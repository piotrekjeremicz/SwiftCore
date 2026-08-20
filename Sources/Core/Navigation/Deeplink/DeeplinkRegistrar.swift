//
//  DeeplinkRegistrar.swift
//  Core
//
//  Created by Piotrek Jeremicz on 18.11.2025.
//

/// One mounted screen in the live deeplink tree. `@unchecked Sendable`: only ever touched from
/// `@MainActor`-isolated code, but instances cross `withCheckedContinuation` boundaries in
/// `DeeplinkRegistrar.step(from:to:payload:)`, which Swift 6 strict concurrency treats as a real
/// concurrency boundary regardless.
final class DeeplinkTreeNode: @unchecked Sendable {
    let key: String
    let type: DeeplinkType
    var children: [DeeplinkTreeNode] = []
    weak var parent: DeeplinkTreeNode?

    /// Dismisses this node's presented destination, captured from its `Destinable` navigator.
    var dismiss: ((_ continuation: @escaping VoidClosure) -> Void)?
    /// Pops this node's stack to root, captured from its `Routable` navigator. Kept separately
    /// from `dismiss` so unwinding can pick the right teardown for the kind of children that
    /// are actually mounted (`.attached` → dismiss, `.stack` → popToRoot).
    var popToRoot: ((_ continuation: @escaping VoidClosure) -> Void)?

    init(key: String, type: DeeplinkType) {
        self.key = key
        self.type = type
    }

    var path: String {
        guard let parent else { return key }
        return "\(parent.path)/\(key)"
    }

    var isLeaf: Bool { children.isEmpty }
}

public extension DeeplinkNode {
    /// Wire-format segment key derived from the type name: the "Node" suffix dropped, the rest
    /// kebab-cased — `ReportFeedbackNode` → `report-feedback`. The static tree in Domain never
    /// declares string keys; renaming a node type is the only way to change the wire format.
    var segmentKey: String {
        let name = "\(type(of: self))"
        let trimmed = name.hasSuffix("Node") ? String(name.dropLast(4)) : name
        return trimmed.kebabCased
    }
}

public final class DeeplinkRegistrar: @unchecked Sendable {
    private var root: DeeplinkTreeNode?

    private var pendingForwardWait: (parentObjectID: ObjectIdentifier, key: String, generation: Int, resume: (DeeplinkTreeNode?) -> Void)?
    /// Same idea for unwinding: wait for the anchor's children to actually empty out, driven by
    /// `unregister`, not by `dismiss`/`popToRoot`'s completion callback.
    private var pendingEmptyWait: (parentObjectID: ObjectIdentifier, generation: Int, resume: (Bool) -> Void)?
    private var waitGeneration = 0

    /// Handlers declared by `.deeplink(_:perform:)`, keyed by the owning coordinator's full key.
    /// Kept outside the live node tree on purpose: a resolver can be attached before its node
    /// registers (inner `onAppear` usually fires first) and survives the node's re-registration.
    private var resolvers: [String: @MainActor (any DeeplinkNode, (any Payload)?) -> Void] = [:]

    /// Navigations are serialized — the single pending-wait slots can't track two walks at once.
    private var isNavigating = false

    private static let waitTimeout: UInt64 = 3_000_000_000

    var activePaths: [String] {
        guard let root else { return [] }
        return leafNodes(of: root).map(\.path)
    }

    // MARK: Resolvers

    func attachResolver(
        for key: String,
        _ resolver: @escaping @MainActor (any DeeplinkNode, (any Payload)?) -> Void
    ) {
        resolvers[key] = resolver
        print("[Deeplink] Resolver attached for: \(key)")
    }

    func detachResolver(for key: String) {
        resolvers[key] = nil
        print("[Deeplink] Resolver detached for: \(key)")
    }

    func resolver(for key: String) -> (@MainActor (any DeeplinkNode, (any Payload)?) -> Void)? {
        resolvers[key]
    }

    // MARK: Registration

    func registrer(
        _ key: DeeplinkKey,
        for type: DeeplinkType,
        dismiss: ((_ continuation: @escaping VoidClosure) -> Void)? = nil,
        popToRoot: ((_ continuation: @escaping VoidClosure) -> Void)? = nil
    ) {
        register(fullKey: key.description, type: type, dismiss: dismiss, popToRoot: popToRoot)
    }

    /// Stack items registered by `RoutableViewModifier` — plain keys, no teardown closures of
    /// their own (their stack's owner holds the `popToRoot`).
    func registrer(_ key: String, for type: DeeplinkType) {
        register(fullKey: key, type: type, dismiss: nil, popToRoot: nil)
    }

    func unregister(_ key: DeeplinkKey) {
        unregister(fullKey: key.description)
    }

    func unregister(_ key: String) {
        unregister(fullKey: key)
    }

    private func register(
        fullKey: String,
        type: DeeplinkType,
        dismiss: ((_ continuation: @escaping VoidClosure) -> Void)?,
        popToRoot: ((_ continuation: @escaping VoidClosure) -> Void)?
    ) {
        let node = DeeplinkTreeNode(key: fullKey, type: type)
        node.dismiss = dismiss
        node.popToRoot = popToRoot

        switch type {
        case .root:
            root = node
        case .attached(let parentKey), .stack(let parentKey):
            guard let parent = findNode(key: parentKey) else {
                print("[Deeplink] ⚠️ Parent not found: \(parentKey)")
                // A walk waiting for this exact key would otherwise only learn about the
                // failure from its timeout — fail it fast instead.
                if let pending = pendingForwardWait, pending.key == fullKey {
                    print("[Deeplink] ✗ '\(fullKey)' failed to register — failing the walk early")
                    pendingForwardWait = nil
                    pending.resume(nil)
                }
                return
            }
            node.parent = parent
            parent.children.append(node)

            if let pending = pendingForwardWait, pending.parentObjectID == ObjectIdentifier(parent), pending.key == fullKey {
                print("[Deeplink] ▶ '\(fullKey)' appeared — walk continues")
                pendingForwardWait = nil
                pending.resume(node)
            }
        case .stale:
            break
        }

        print("[Deeplink] Registering: \(fullKey), type: \(type)")
        activePaths.forEach { print("[Deeplink] Active path: \($0)") }
    }

    private func unregister(fullKey: String) {
        guard let node = findNode(key: fullKey) else { return }
        let parent = node.parent
        node.parent?.children.removeAll { $0 === node }
        if node === root { root = nil }

        print("[Deeplink] Removing: \(fullKey)")
        activePaths.forEach { print("[Deeplink] Active path: \($0)") }

        if let parent, let pending = pendingEmptyWait, pending.parentObjectID == ObjectIdentifier(parent), parent.children.isEmpty {
            print("[Deeplink] ▶ '\(parent.key)' has no children left — unwind complete, walk continues")
            pendingEmptyWait = nil
            pending.resume(true)
        }
    }

    private func findNode(key: String) -> DeeplinkTreeNode? {
        findNode(key: key, in: root)
    }

    private func findNode(key: String, in node: DeeplinkTreeNode?) -> DeeplinkTreeNode? {
        guard let node else { return nil }
        if node.key == key { return node }
        for child in node.children {
            if let found = findNode(key: key, in: child) { return found }
        }
        return nil
    }

    private func leafNodes(of node: DeeplinkTreeNode) -> [DeeplinkTreeNode] {
        node.isLeaf ? [node] : node.children.flatMap { leafNodes(of: $0) }
    }
}

// MARK: - Navigation

extension DeeplinkRegistrar {
    /// Walks the live tree towards `path` (a chain of static tree nodes, root-first — e.g.
    /// `[LaunchNode, MapNode, DashboardNode, StopNode]`), reusing whatever's already on screen
    /// and only presenting/pushing the remainder through the `.deeplink` resolvers. `payloads`
    /// is aligned index-for-index with `path` (`nil` where a segment carries none) — a payload
    /// isn't only relevant to the *final* segment: e.g. "stop" needs its own `StopPayload` to
    /// be presentable even when it's just a waypoint on the way to "timetable".
    ///
    /// Called by `DeeplinkRouter` (Domain) after it's turned either a typed
    /// `KeyPath<RootNode, _>` call or a decoded string path into this `(path, payloads)` pair —
    /// this method doesn't know or care which.
    @MainActor
    public func navigate(path: [any DeeplinkNode], payloads: [(any Payload)?]) async {
        guard !path.isEmpty else { return }
        guard payloads.count == path.count else {
            print("[Deeplink] ⚠️ \(payloads.count) payloads for \(path.count) nodes — mismatch")
            return
        }
        guard !isNavigating else {
            print("[Deeplink] ⚠️ Navigation already in progress — ignoring")
            return
        }
        isNavigating = true
        defer { isNavigating = false }

        let target = zip(path, payloads).map { Self.key(for: $0, payload: $1) }.joined(separator: "/")
        print("[Deeplink] ── Navigate to: \(target)")

        // `root` itself is the match for path[0] (e.g. "launch") — walking only starts
        // through `children` from path[1] onward.
        guard let root, root.key == Self.key(for: path[0], payload: payloads[0]) else {
            print("[Deeplink] ⚠️ No matching root registered — can't navigate")
            return
        }

        var current = root
        var index = 1

        while index < path.count {
            let expectedKey = Self.key(for: path[index], payload: payloads[index])
            guard let match = current.children.first(where: { $0.key == expectedKey }) else { break }
            current = match
            index += 1
        }

        print("[Deeplink] Already on screen: \(current.path)")

        guard index < path.count else {
            print("[Deeplink] ── Target already visible — nothing to do")
            return
        }

        if !current.children.isEmpty {
            print("[Deeplink] Unwinding children of '\(current.key)': \(current.children.map(\.key))")
            guard await unwind(current) else {
                print("[Deeplink] ⚠️ Could not unwind \(current.path) — stopping")
                return
            }
        }

        while index < path.count {
            let expectedKey = Self.key(for: path[index], payload: payloads[index])
            print("[Deeplink] Step: '\(current.key)' resolves '\(expectedKey)'…")
            guard let next = await step(from: current, to: path[index], payload: payloads[index]) else {
                print("[Deeplink] ⚠️ \(current.key) could not resolve '\(path[index].segmentKey)' — stopping at \(current.path)")
                return
            }
            current = next
            index += 1
        }

        print("[Deeplink] ── Arrived at: \(current.path)")
    }

    /// Tears down the anchor's children before the walk diverges from what's on screen.
    /// Two phases, each picked by what's actually mounted: `.attached` children go through the
    /// navigator's `dismiss`, remaining `.stack` children through `popToRoot`. Completion is
    /// detected by the children actually unregistering, with a timeout as the failure path.
    @MainActor
    private func unwind(_ node: DeeplinkTreeNode) async -> Bool {
        let hasAttachedChild = node.children.contains { child in
            if case .attached = child.type { return true } else { return false }
        }

        if hasAttachedChild, let dismiss = node.dismiss {
            print("[Deeplink] Unwind: dismissing what '\(node.key)' presents…")
            guard await awaitChildrenEmpty(of: node, trigger: dismiss) else { return false }
        }

        if !node.children.isEmpty, let popToRoot = node.popToRoot {
            print("[Deeplink] Unwind: popping '\(node.key)' stack to root…")
            guard await awaitChildrenEmpty(of: node, trigger: popToRoot) else { return false }
        }

        return node.children.isEmpty
    }

    @MainActor
    private func awaitChildrenEmpty(
        of node: DeeplinkTreeNode,
        trigger: (@escaping VoidClosure) -> Void
    ) async -> Bool {
        if node.children.isEmpty { return true }

        return await withCheckedContinuation { continuation in
            let objectID = ObjectIdentifier(node)
            waitGeneration += 1
            let generation = waitGeneration

            pendingEmptyWait = (objectID, generation, { continuation.resume(returning: $0) })
            trigger {}

            Task { @MainActor [weak self] in
                try? await Task.sleep(nanoseconds: Self.waitTimeout)
                guard let self, let pending = self.pendingEmptyWait, pending.generation == generation else { return }
                self.pendingEmptyWait = nil
                print("[Deeplink] ⚠️ Unwind of \(node.key) timed out")
                pending.resume(false)
            }
        }
    }

    /// One hop: hands `(child, payload)` to the resolver declared at the current node and waits
    /// for the child's registration to confirm the screen actually appeared. The timeout is the
    /// only failure signal — a resolver that doesn't handle the request looks exactly like one
    /// whose presentation never landed.
    @MainActor
    private func step(from node: DeeplinkTreeNode, to child: any DeeplinkNode, payload: (any Payload)?) async -> DeeplinkTreeNode? {
        guard let resolver = resolver(for: node.key) else {
            print("[Deeplink] ⚠️ No resolver attached for \(node.key)")
            return nil
        }
        let expectedKey = Self.key(for: child, payload: payload)

        return await withCheckedContinuation { continuation in
            let objectID = ObjectIdentifier(node)
            waitGeneration += 1
            let generation = waitGeneration

            pendingForwardWait = (objectID, expectedKey, generation, { continuation.resume(returning: $0) })
            resolver(child, payload)

            Task { @MainActor [weak self] in
                try? await Task.sleep(nanoseconds: Self.waitTimeout)
                guard let self, let pending = self.pendingForwardWait, pending.generation == generation else { return }
                self.pendingForwardWait = nil
                print("[Deeplink] ⚠️ Waiting for '\(expectedKey)' timed out")
                pending.resume(nil)
            }
        }
    }

    private static func key(for node: any DeeplinkNode, payload: (any Payload)?) -> String {
        payload.map { "\(node.segmentKey):\($0.id)" } ?? node.segmentKey
    }
}
