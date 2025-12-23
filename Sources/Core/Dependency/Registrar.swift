//
//  Registrar.swift
//  Core
//
//  Created by Piotrek Jeremicz on 28.10.2025.
//

public protocol Registrar {
    var container: Container { get }
    
    func register<Service>(_ serviceType: Service.Type, factory: @Sendable @escaping (Resolver) -> Service)
}


public class StoreRegistrar: Registrar {
    public let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    public func register<Service>(_ serviceType: Service.Type, factory: @escaping @Sendable (any Resolver) -> Service) {
        container.register(
            serviceType,
            scope: .singleton,
            factory: factory
        )
    }
}

public class ServiceRegistrar: Registrar {
    public let container: Container

    init(container: Container) {
        self.container = container
    }

    public func register<Service>(_ serviceType: Service.Type, factory: @escaping @Sendable (any Resolver) -> Service) {
        container.register(
            serviceType,
            scope: .singleton,
            factory: factory
        )
    }
}

public class RepositoryRegistrar: Registrar {
    public let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    public func register<Service>(_ serviceType: Service.Type, factory: @escaping @Sendable (any Resolver) -> Service) {
        container.register(
            serviceType,
            scope: .singleton,
            factory: factory
        )
    }
}

public class UseCaseRegistrar: Registrar {
    public let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    public func register<Service>(_ serviceType: Service.Type, factory: @escaping @Sendable (any Resolver) -> Service) {
        container.register(
            serviceType,
            scope: .graph,
            factory: factory
        )
    }
}
