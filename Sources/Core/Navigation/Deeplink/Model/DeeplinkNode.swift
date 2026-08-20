//
//  DeeplinkNode.swift
//  Core
//
//  Created by Piotrek Jeremicz on 19/08/2026.
//

public protocol DeeplinkNode: Sendable {
    associatedtype Payload: Core.Payload = Never

    /// Builds this node's payload from the raw identifier carried by an incoming string path
    /// (`"stop:<uuid>"` → identifier `"<uuid>"`). Deliberately has a default implementation
    /// **only** for payload-less nodes — a node that declares a `Payload` type must implement
    /// its own decoding, or it won't compile. That makes "string-addressable" a compile-time
    /// guarantee instead of a runtime timeout.
    func resolvePayload(from identifier: String?) -> Payload?
}

public extension DeeplinkNode where Payload == Never {
    func resolvePayload(from identifier: String?) -> Never? { nil }
}

public struct RootNode: DeeplinkNode {
    /// Top-level nodes of the static deeplink tree, set once by the app's domain layer at
    /// assembly time (e.g. `RootNode.children = [LaunchNode()]`). Required because the typed
    /// accessors (`\.launch`) are grafted on via computed extension properties, which `Mirror`
    /// cannot see — this array is what makes the tree walkable for the engine.
    /// `nonisolated(unsafe)`: written exactly once during assembly, before any navigation runs.
    nonisolated(unsafe) public static var children: [any DeeplinkNode] = []
}
