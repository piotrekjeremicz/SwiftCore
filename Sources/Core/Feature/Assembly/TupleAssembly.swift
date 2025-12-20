//
//  TupleAssembly.swift
//  Core
//
//  Created by Piotrek Jeremicz on 23.10.2025.
//

public class TupleAssembly<T>: Assembly {
    let value: T
    
    public init(_ value: T) {
        self.value = value
    }
}

public extension TupleAssembly {
    func assemble(container: Container) {
        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }
}

private extension TupleAssembly {
    var assemblies: [any Assembly] {
        Mirror(reflecting: value).children.compactMap { $0.value as? any Assembly }
    }
}
