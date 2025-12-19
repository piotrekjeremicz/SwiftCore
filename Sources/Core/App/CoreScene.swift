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
    private let coordinatorRegistrar: CoordinatorRegistrar

    public init(assembledWith modules: Factor, @SceneBuilder _ content: @escaping () -> Content) {
        self.content = content()

        container = .init()
        coordinatorRegistrar = .init()

        modules.assemblies.assemble(
            container: container,
            coordinatorRegistrar: coordinatorRegistrar
        )
        
        Core.DependencyEnvironment.use(container)
    }
    
    public var body: some Scene {
        content
    }
}
