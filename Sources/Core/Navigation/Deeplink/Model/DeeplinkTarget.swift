//
//  DeeplinkTarget.swift
//  Core
//
//  Created by Piotrek Jeremicz on 19/08/2026.
//

public struct DeeplinkTarget<Parent: DeeplinkNode> {
    public let node: any DeeplinkNode
}

public func ~= <Parent: DeeplinkNode, Child: DeeplinkNode>(
    pattern: KeyPath<Parent, Child>,
    target: DeeplinkTarget<Parent>
) -> Bool {
    type(of: target.node) == Child.self
}
