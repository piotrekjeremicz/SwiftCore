//
//  DeeplinkNode.swift
//  Core
//
//  Created by Piotrek Jeremicz on 19/08/2026.
//

public protocol DeeplinkNode: Sendable {
    associatedtype Payload: Core.Payload = Never
}

public struct RootNode: DeeplinkNode { }
