//
//  EmptyModule.swift
//  Core
//
//  Created by Piotrek Jeremicz on 23.10.2025.
//

public class EmptyModule: Module {
    public var assemblies: some Assembly {
        EmptyAssembly()
    }
}
