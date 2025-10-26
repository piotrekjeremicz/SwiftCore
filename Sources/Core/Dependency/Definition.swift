//
//  Definition.swift
//  Core
//
//  Created by Piotrek Jeremicz on 24.10.2025.
//

public protocol Definition {
    associatedtype Service
    
    var scope: Scope { get }
    var factory: (Resolver) -> Service { get }
}

public final class LazyDefinition<Service>: Definition {
    public let scope: Scope
    public let factory: (Resolver) -> Service
    var cache: Service?

    init(
        scope: Scope,
        factory: @escaping (Resolver) -> Service
    ) {
        self.scope = scope
        self.factory = factory
    }
}
