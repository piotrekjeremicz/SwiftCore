//
//  DeeplinkRoot.swift
//  Core
//
//  Created by Piotrek Jeremicz on 05.01.2025.
//

public protocol DeeplinkNode {
    static var children: [PartialKeyPath<Self>] { get }
}
