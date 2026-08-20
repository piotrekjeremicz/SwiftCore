//
//  CoordinatorPayload.swift
//  Core
//
//  Created by Piotrek Jeremicz on 26.02.2026.
//

public protocol Payload: Hashable, Sendable, Identifiable {
    var id: ID { get }
}

public typealias AnyPayload = any Payload

extension Never: Payload {
    public var id: Never { fatalError("Never has no id") }
}
