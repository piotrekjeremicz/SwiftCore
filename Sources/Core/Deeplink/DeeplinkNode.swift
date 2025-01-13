//
//  DeeplinkRoot.swift
//  Core
//
//  Created by Piotrek Jeremicz on 05.01.2025.
//

public protocol DeeplinkNode {
    static var children: [PartialKeyPath<Self>] { get }
}

extension DeeplinkNode {
    public static var children: [PartialKeyPath<Self>] { [] }
}

public struct Root: DeeplinkNode {}
