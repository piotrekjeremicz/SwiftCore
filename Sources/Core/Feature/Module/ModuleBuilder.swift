//
//  ModuleBuilder.swift
//  Core
//
//  Created by Piotrek Jeremicz on 21.10.2025.
//

import Foundation

@resultBuilder
public struct ModuleBuilder {
    public static func buildBlock() -> EmptyModule {
        EmptyModule()
    }
    
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: Module {
        content
    }
    
    public static func buildExpression<Content>(_ content: Content) -> Content where Content: Module {
        content
    }
    
    public static func buildBlock<each Content>(_ content: repeat each Content) -> TupleModule<(repeat each Content)> where repeat each Content: Module {
        TupleModule((repeat each content))
    }
}
