//
//  DeeplinkRegistrar.swift
//  Core
//
//  Created by Piotrek Jeremicz on 18.11.2025.
//

public final class DeeplinkRegistrar: @unchecked Sendable {
    private var root: DeeplinkNode?

    var activePaths: [String] {
        guard let root else { return [] }
        return leafNodes(of: root).map(\.path)
    }

    func registrer(_ key: String, identifier: String? = nil, for type: DeeplinkType) {
        let fullKey = identifier.map { "\(key):\($0)" } ?? key
        let node = DeeplinkNode(key: fullKey, type: type)

        switch type {
        case .root:
            root = node
        case .attached(let parentKey), .stack(let parentKey):
            guard let parent = findNode(key: parentKey) else {
                print("[Deeplink] ⚠️ Parent not found: \(parentKey)")
                return
            }
            node.parent = parent
            parent.children.append(node)
        case .stale:
            break
        }

        print("[Deeplink] Registering: \(fullKey), type: \(type)")
        activePaths.forEach { print("[Deeplink] Active path: \($0)") }
    }

    func unregister(_ key: String, identifier: String? = nil) {
        let fullKey = identifier.map { "\(key):\($0)" } ?? key
        guard let node = findNode(key: fullKey) else { return }
        node.parent?.children.removeAll { $0 === node }
        if node === root { root = nil }
        print("[Deeplink] Removing: \(fullKey)")
        activePaths.forEach { print("[Deeplink] Active path: \($0)") }
    }

    private func findNode(key: String) -> DeeplinkNode? {
        findNode(key: key, in: root)
    }

    private func findNode(key: String, in node: DeeplinkNode?) -> DeeplinkNode? {
        guard let node else { return nil }
        if node.key == key { return node }
        for child in node.children {
            if let found = findNode(key: key, in: child) { return found }
        }
        return nil
    }

    private func leafNodes(of node: DeeplinkNode) -> [DeeplinkNode] {
        node.isLeaf ? [node] : node.children.flatMap { leafNodes(of: $0) }
    }
}
