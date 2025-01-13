//
//  PreviewScene.swift
//  Core
//
//  Created by Piotrek Jeremicz on 16.11.2024.
//

import SwiftUI

public struct PreviewScene<Assembler, Content>: View where Assembler: Assembly, Content: View {
    private let content: () -> Content
    
    private let assembler: Assembler
    private let container: DependencyContainer
    
    public init(
        _ assembler: Assembler,
        container: DependencyContainer,
        content: @escaping () -> Content
    ) {
        self.content = content
        self.container = container
        self.assembler = assembler
    }
    
    public var body: some View {
        content()
    }
}

public struct PreviewSceneModifier<Assembler>: PreviewModifier where Assembler: Assembly {
    public init() {}
    
    public static func makeSharedContext() async throws -> (assembler: Assembler, container: DependencyContainer) {
        let container = DependencyContainer()
        let assembler = Assembler.init()
        assembler.assemble(with: container)
        
        return (assembler, container)
    }
    
    public func body(content: Content, context: (assembler: Assembler, container: DependencyContainer)) -> some View {
        PreviewScene(context.assembler, container: context.container) {
            content
        }
    }
}
