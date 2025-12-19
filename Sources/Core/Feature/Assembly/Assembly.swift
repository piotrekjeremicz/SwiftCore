//
//  Assembly.swift
//  Core
//
//  Created by Piotrek Jeremicz on 22.10.2025.
//

public protocol Assembly {
    func assemble(container: Container, coordinatorRegistrar: CoordinatorRegistrar)

    func register(in container: Container)
    func registerStores(in registrar: StoreRegistrar)
    func registerRepositories(in registrar: RepositoryRegistrar)
    func registerUseCases(in registrar: UseCaseRegistrar)
    func registerCoordinator(in registrar: CoordinatorRegistrar)
}

public extension Assembly {
    func assemble(container: Container, coordinatorRegistrar: CoordinatorRegistrar) {
        register(in: container)
        registerStores(in: .init(container: container))
        registerRepositories(in: .init(container: container))
        registerUseCases(in: .init(container: container))
        registerCoordinator(in: coordinatorRegistrar)
    }
    
    func register(in container: Container) { }
    func registerStores(in registrar: StoreRegistrar) { }
    func registerRepositories(in registrar: RepositoryRegistrar) { }
    func registerUseCases(in registrar: UseCaseRegistrar) { }
    func registerCoordinator(in registrar: CoordinatorRegistrar) { }
}
