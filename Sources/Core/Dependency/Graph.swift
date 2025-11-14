//
//  Graph.swift
//  Core
//
//  Created by Piotrek Jeremicz on 25.10.2025.
//


internal final class Graph: Resolver, @unchecked Sendable {
    var definitions: [ObjectIdentifier: any Definition]
    
    init(container: Container) {
        self.definitions = container.definitions
    }
    
    public func resolve<Service: Sendable>() -> Service {
        resolve(Service.self)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type) -> Service where Service: Sendable {
        let id = ObjectIdentifier(serviceType)
        
        guard let definition = definitions[id] as? LazyDefinition<Service> else {
            fatalError("No definition for \(serviceType)")
        }
        
        switch definition.scope {
        case .singleton, .graph:
            if let cached = definition.cache { return cached }
            
            let instance = definition.factory(self)
            definition.cache = instance
            definitions[id] = definition
            
            return instance
        case .transient:
            return definition.factory(self)
        }
    }
}
