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
        modules.assemblies.assemble(container: container)
        Core.Environment.use(container)
    }
    
    public var body: some Scene {
        content
    }
}
