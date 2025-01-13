//
//  Container.swift
//  Core
//
//  Created by Piotrek Jeremicz on 11.09.2024.
//

import Foundation
import SwiftUI

public struct DependencyContainer {
    private static var repositoryCache: [String: Any] = [:]
    private static var repositoryFactories: [String: () -> Any] = [:]
    
    internal static var serviceFactories: [WritableKeyPath<EnvironmentValues, any Service>: () -> any Service] = [:]
    
    public init() {}
    
    public func register<Dependency>(type: Dependency.Type, _ factory: @autoclosure @escaping () -> Dependency) {
        Self.repositoryFactories[String(describing: type.self)] = factory
    }
    
    public func register(keyPath: WritableKeyPath<EnvironmentValues, any Service>, factory: @autoclosure @escaping () -> any Service) {
        Self.serviceFactories[keyPath] = factory
    }
    
    public func resolve<Dependency>(_ type: Dependency.Type) -> Dependency? {
        Self.resolve(type)
    }
    
    public static func resolve<Dependency>(_ type: Dependency.Type) -> Dependency? {
        let serviceName = String(describing: type.self)
        
        if let service = repositoryCache[serviceName] as? Dependency {
            return service
        } else {
            let service = repositoryFactories[serviceName]?() as? Dependency
            
            if let service = service {
                repositoryCache[serviceName] = service
            }
            
            return service
        }
    }
}
