//
//  DeeplinkRouter.swift
//  Core
//
//  Created by Piotrek Jeremicz on 15/08/2026.
//

/// Two entry points, one shared engine. Both resolve down to a chain of static tree nodes plus a
/// payload per node (most `nil` — only segments that actually need one to be presentable carry a
/// value), then hand off to `DeeplinkRegistrar.navigate(path:payloads:)`, which owns the live
/// screen tree and actually walks it.
///
/// Fully domain-agnostic: the tree is discovered from `RootNode.children` (grafted by the app's
/// domain layer at assembly time) and `Mirror` over each node's stored children; payload decoding
/// is delegated to each node's own `resolvePayload(from:)`.
///
/// `@unchecked Sendable` rather than `@MainActor` at the class level, matching `DeeplinkRegistrar`
/// — this type is registered/resolved through the DI container's `Sendable`-constrained
/// `register`/`resolve`, which can't call a `@MainActor`-isolated initializer synchronously.
/// The `navigate` methods themselves are `@MainActor` since they end up driving navigators.
public final class DeeplinkRouter: @unchecked Sendable {
    @Dependency private var registrar: DeeplinkRegistrar

    public init() {}

    @MainActor
    public func navigate<Node: DeeplinkNode>(to keyPath: KeyPath<RootNode, Node>, payload: Node.Payload) async {
        print("[Deeplink] Typed request: \(Node.self), payload: \(payload.id)")
        guard let path = Self.chain(to: Node.self) else {
            print("[Deeplink] ⚠️ No tree path to \(Node.self)")
            return
        }
        var payloads: [(any Payload)?] = Array(repeating: nil, count: max(path.count - 1, 0))
        payloads.append(payload)
        await registrar.navigate(path: path, payloads: payloads)
    }

    @MainActor
    public func navigate<Node: DeeplinkNode>(to keyPath: KeyPath<RootNode, Node>) async where Node.Payload == Never {
        print("[Deeplink] Typed request: \(Node.self)")
        guard let path = Self.chain(to: Node.self) else {
            print("[Deeplink] ⚠️ No tree path to \(Node.self)")
            return
        }
        let payloads: [(any Payload)?] = Array(repeating: nil, count: path.count)
        await registrar.navigate(path: path, payloads: payloads)
    }

    /// Decode boundary for incoming push-notification/universal-link strings, e.g.
    /// "launch/map/dashboard/route:<uuid>". Walks the static tree by `segmentKey`; each segment's
    /// raw identifier is decoded by the matched node itself via `resolvePayload(from:)`.
    @MainActor
    public func navigate(to rawPath: String) async {
        print("[Deeplink] String request: \(rawPath)")
        guard let (path, payloads) = Self.decode(rawPath) else {
            print("[Deeplink] ⚠️ Could not decode path: \(rawPath)")
            return
        }
        let decoded = zip(path, payloads)
            .map { node, payload in payload.map { "\(node.segmentKey) + \(type(of: $0))" } ?? node.segmentKey }
            .joined(separator: " / ")
        print("[Deeplink] Decoded: \(decoded)")
        await registrar.navigate(path: path, payloads: payloads)
    }
}

// MARK: - Static tree walking

private extension DeeplinkRouter {
    /// `Mirror` only reflects stored properties — fine for every node below the top (children are
    /// stored `let`s), while `RootNode`'s grafted accessors are covered by `RootNode.children`.
    static func children(of node: any DeeplinkNode) -> [any DeeplinkNode] {
        Mirror(reflecting: node).children.compactMap { $0.value as? any DeeplinkNode }
    }

    /// Root-first chain of node instances leading to the first node of `targetType`, found by
    /// depth-first search. Node types are unique per tree position, which is what makes a bare
    /// `KeyPath`'s value type sufficient to identify the full path.
    static func chain(to targetType: any DeeplinkNode.Type) -> [any DeeplinkNode]? {
        for top in RootNode.children {
            if let chain = chain(from: top, to: targetType) { return chain }
        }
        return nil
    }

    static func chain(from node: any DeeplinkNode, to targetType: any DeeplinkNode.Type) -> [any DeeplinkNode]? {
        if type(of: node) == targetType { return [node] }
        for child in children(of: node) {
            if let rest = chain(from: child, to: targetType) { return [node] + rest }
        }
        return nil
    }

    static func decode(_ rawPath: String) -> (path: [any DeeplinkNode], payloads: [(any Payload)?])? {
        let segments = rawPath.split(separator: "/").map(String.init)
        guard !segments.isEmpty else { return nil }

        var path: [any DeeplinkNode] = []
        var payloads: [(any Payload)?] = []

        for segment in segments {
            let parts = segment.split(separator: ":", maxSplits: 1).map(String.init)
            let candidates = path.isEmpty ? RootNode.children : children(of: path[path.count - 1])
            guard let match = candidates.first(where: { $0.segmentKey == parts[0] }) else { return nil }
            path.append(match)
            payloads.append(match.resolvePayload(from: parts.count > 1 ? parts[1] : nil))
        }

        return (path, payloads)
    }
}
