//
//  CoreScene.swift
//  Core
//
//  Created by Piotrek Jeremicz on 25.09.2024.
//

import SwiftUI

public struct CoreScene<Assembler, Content>: Scene where Assembler: Assembly, Content: Scene {
    private let content: () -> Content
    
    private let assembler: Assembler
    private let container: DependencyContainer
    
    public init(
        _ assembly: Assembler.Type,
        content: @escaping () -> Content
    ) {
        self.content = content
        
        container = .init()
        assembler = assembly.init()
        assembler.assemble(with: container)
    }
    
    public var body: some Scene {
        content()
    }
}
