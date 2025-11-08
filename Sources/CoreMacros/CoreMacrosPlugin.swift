//
//  CoreMacrosPlugin.swift
//  Core
//
//  Created by Piotrek Jeremicz on 23.10.2025.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CoreMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        UseCaseMacro.self,
    ]
}
