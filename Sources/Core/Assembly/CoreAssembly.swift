//
//  CoreAssembly.swift
//  Core
//
//  Created by Piotrek Jeremicz on 20/12/2025.
//

final class CoreAssembly {
    public func register(in container: Container) {
        container.register(CoordinatorRegistrar.self, scope: .singleton) { _ in
            CoordinatorRegistrar()
        }
    }
}
