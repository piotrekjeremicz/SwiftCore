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
        assemblies.assemble(container: container, coordinatorRegistrar: coordinatorRegistrar)
    }
}

//public extension Module {
//    func runAssemble(container: InjectContainer) {
//        assemblies.forEach { $0.assemble(container: container) }
//    }
//    
//    func runLoad(resolver: InjectResolver) {
//        assemblies.forEach { $0.load(resolver: resolver) }
//    }
//}
