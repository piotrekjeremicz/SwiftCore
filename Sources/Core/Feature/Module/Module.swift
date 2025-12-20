//
//  Module.swift
//  Core
//
//  Created by Piotrek Jeremicz on 21.10.2025.
//

public protocol Module {
    associatedtype Factor: Assembly
    
    @AssemblyBuilder var assemblies: Factor { get }
    
    func resolve(with container: Container, coordinatorRegistrar: CoordinatorRegistrar)
}

public extension Module {
    func resolve(with container: Container, coordinatorRegistrar: CoordinatorRegistrar) {
        assemblies.assemble(container: container)
    }
}
