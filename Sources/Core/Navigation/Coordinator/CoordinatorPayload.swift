//
//  CoordinatorPayload.swift
//  Core
//
//  Created by Piotrek Jeremicz on 26.02.2026.
//

public protocol Payload: Hashable, Equatable, Sendable {}

public typealias AnyPayload = any Payload

extension Never: Payload {}
