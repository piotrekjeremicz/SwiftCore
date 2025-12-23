//
//  Assembly.swift
//  Core
//
//  Created by Piotrek Jeremicz on 22.10.2025.
//

public protocol Assembly {
    func assemble(container: Container)

    func register(in container: Container)
    func registerStores(in registrar: StoreRegistrar)
    func registerServices(in registrar: ServiceRegistrar)
    func registerRepositories(in registrar: RepositoryRegistrar)
    func registerUseCases(in registrar: UseCaseRegistrar)
    func registerCoordinator(in registrar: CoordinatorRegistrar)
}

public extension Assembly {
    func assemble(container: Container) {
        register(in: container)
        registerStores(in: .init(container: container))
        registerServices(in: .init(container: container))
        registerRepositories(in: .init(container: container))
        registerUseCases(in: .init(container: container))
        registerCoordinator(in: container.resolve())
    }
    
    func register(in container: Container) { }
    func registerStores(in registrar: StoreRegistrar) { }
    func registerServices(in registrar: ServiceRegistrar) { }
    func registerRepositories(in registrar: RepositoryRegistrar) { }
    func registerUseCases(in registrar: UseCaseRegistrar) { }
    func registerCoordinator(in registrar: CoordinatorRegistrar) { }
}
