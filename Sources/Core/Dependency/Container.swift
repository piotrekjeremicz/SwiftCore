//
//  Container.swift
//  Core
//
//  Created by Piotrek Jeremicz on 24.10.2025.
//

import Foundation

public final class Container: @unchecked Sendable {
    private let lock = NSRecursiveLock()
    internal var definitions: [ObjectIdentifier: any Definition] = [:]
    
    public init() {}
    
    public func register<Service>(
        _ serviceType: Service.Type,
        scope: Scope = .transient,
        factory: @Sendable @escaping (Resolver) -> Service
    ) {
        let id = ObjectIdentifier(serviceType)
        lock.lock(); defer { lock.unlock() }
        
        definitions[id] = LazyDefinition(scope: scope, factory: factory)
    }
}


extension Container: Resolver {
    public func resolve<Service>(_ serviceType: Service.Type) -> Service where Service: Sendable {
        let id = ObjectIdentifier(serviceType)
        lock.lock(); defer { lock.unlock() }
        
        guard let definition = definitions[id] as? LazyDefinition<Service> else {
            fatalError("No definition for \(serviceType)")
        }
        
        switch definition.scope {
        case .singleton:
            if let cached = definition.cache { return cached }
            
            let instance = definition.factory(self)
            definition.cache = instance
            definitions[id] = definition
            
            return instance
        case .graph:
            let graph = Graph(container: self)
            return graph.resolve(serviceType)
        case .transient:
            return definition.factory(self)
        }
    }
}
