//
//  Environment.swift
//  Core
//
//  Created by Piotrek Jeremicz on 28.10.2025.
//

public enum DependencyEnvironment {
    nonisolated(unsafe) public internal(set) static var container: Container?
    
    public static func use(_ container: Container) {
        self.container = container
    }
}
