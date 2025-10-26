//
//  TupleModule.swift
//  Core
//
//  Created by Piotrek Jeremicz on 23.10.2025.
//

public class TupleModule<T>: Module {
    let value: T

    public init(_ value: T) {
        self.value = value
    }
}

public extension TupleModule {
    var assemblies: some Assembly {
        CompactAssembly(assemblies: modules.compactMap { $0.assemblies })
    }
}

private extension TupleModule {
    var modules: [any Module] {
        Mirror(reflecting: value).children.compactMap { $0.value as? any Module }
    }
}
