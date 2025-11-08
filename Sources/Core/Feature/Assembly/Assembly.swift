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
    func registerRepositories(in registrar: RepositoryRegistrar)
    func registerUseCases(in registrar: UseCaseRegistrar)
}

public extension Assembly {
    func assemble(container: Container) {
        register(in: container)
        registerStores(in: .init(container: container))
        registerRepositories(in: .init(container: container))
        registerUseCases(in: .init(container: container))
    }
    
    func register(in container: Container) { }
    func registerStores(in registrar: StoreRegistrar) { }
    func registerRepositories(in registrar: RepositoryRegistrar) { }
    func registerUseCases(in registrar: UseCaseRegistrar) { }
}
