//
//  DeeplinkNode.swift
//  Core
//
//  Created by Piotrek Jeremicz on 30/05/2026.
//

final class DeeplinkNode {
    let key: String
    let type: DeeplinkType
    var children: [DeeplinkNode] = []
    weak var parent: DeeplinkNode?

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
