//
//  Dependency.swift
//  Core
//
//  Created by Piotrek Jeremicz on 28.10.2025.
//

@propertyWrapper
public struct Dependency<T>: Sendable where T: Sendable {
    public private(set) var wrappedValue: T
    
    public init() {
        guard let container = DependencyEnvironment.container else {
            fatalError("❌ InjectContainer not set in DependencyEnvironment")
        }
        self.wrappedValue = container.resolve(T.self)
    }
}

@propertyWrapper
public final class LazyDependency<T>: @unchecked Sendable where T: Sendable {
    private var value: T?
    public init() {}
    
    public var wrappedValue: T {
        if let value = value { return value }
        guard let container = DependencyEnvironment.container else {
            fatalError("❌ InjectContainer not set in DependencyEnvironment")
        }
        let resolved = container.resolve(T.self)
        self.value = resolved
        return resolved
    }
}
