//
//  Assembly.swift
//  Core
//
//  Created by Piotrek Jeremicz on 11.09.2024.
//

import SwiftUI

public protocol Assembly {
    associatedtype Env: AppEnvironment
    
    var modules: [Module] { get }
    var environment: Env { get }
    
    init()
    
    func assemble(with container: DependencyContainer)
}

public extension Assembly {
    var modules: [Module] {
        [CoreModule()]
    }
    
    func assemble(with container: DependencyContainer) {
        modules.forEach {
            $0.register(container: container, environment: environment)
        }
        
        if let coordinatorRegistrar = container.resolve(CoordinatorRegistrar.self) {
            modules.forEach { $0.register(in: coordinatorRegistrar) }
        }
    }
}
