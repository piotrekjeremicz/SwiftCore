//
//  AssemblyBuilder.swift
//  Core
//
//  Created by Piotrek Jeremicz on 23.10.2025.
//

import Foundation

@resultBuilder
public struct AssemblyBuilder {
    public static func buildBlock() -> EmptyAssembly {
        EmptyAssembly()
    }
    
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: Assembly {
        content
    }
    
    public static func buildExpression<Content>(_ content: Content) -> Content where Content: Assembly {
        content
    }
    
    public static func buildBlock<each Content>(_ content: repeat each Content) -> TupleAssembly<(repeat each Content)> where repeat each Content: Assembly {
        TupleAssembly((repeat each content))
    }
}
