//
//  Dependency.swift
//  Core
//
//  Created by Piotrek Jeremicz on 11.09.2024.
//

import Foundation

@propertyWrapper
public struct Dependency<Dependency> {
    var dependency: Dependency
    
    public init() {
        guard let dependency = DependencyContainer.resolve(Dependency.self) else {
            let dependencyName = String(describing: Dependency.self)
            fatalError("No dependency of type \(dependencyName) registered!")
        }
        
        self.dependency = dependency
    }
    
    public var wrappedValue: Dependency {
        get { self.dependency }
        mutating set { dependency = newValue }
    }
}
