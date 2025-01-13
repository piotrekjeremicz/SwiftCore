//
//  Module.swift
//  Core
//
//  Created by Piotrek Jeremicz on 11.09.2024.
//

import SwiftUI

public protocol Module {
    init()
    
    func register(in registrar: CoordinatorRegistrar)
    func register(container: DependencyContainer, environment: AppEnvironment)
}

public extension Module {    
    func register(container: DependencyContainer, environment: AppEnvironment) { }
    func register(in registrar: CoordinatorRegistrar) { }
}
