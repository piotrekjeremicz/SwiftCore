//
//  CompactAssembly.swift
//  Core
//
//  Created by Piotrek Jeremicz on 23.10.2025.
//

public class CompactAssembly: Assembly {
    let assemblies: [any Assembly]
    
    init(assemblies: [any Assembly]) {
        self.assemblies = assemblies
    }
    
    public func assemble(container: Container) {
        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }
}
