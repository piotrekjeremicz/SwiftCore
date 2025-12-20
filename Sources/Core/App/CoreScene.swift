//
//  CoreScene.swift
//  Core
//
//  Created by Piotrek Jeremicz on 23.10.2025.
//

import SwiftUI

public struct CoreScene<Content, Factor>: Scene where Content: Scene, Factor: Module {
    private let content: Content
    private let container: Container

    public init(assembledWith modules: Factor, @SceneBuilder _ content: @escaping () -> Content) {
        self.content = content()

        container = .init()

        let coreAssembly = CoreAssembly()
        coreAssembly.register(in: container)
        modules.assemblies.assemble(container: container)
        
        Core.DependencyEnvironment.use(container)
    }
    
    public var body: some Scene {
        content
    }
}
