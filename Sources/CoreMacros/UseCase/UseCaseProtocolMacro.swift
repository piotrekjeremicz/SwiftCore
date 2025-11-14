//
//  UseCaseProtocolMacro.swift
//  Core
//
//  Created by Piotrek Jeremicz on 09/11/2025.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum UseCaseProtocolMacroError: CustomStringConvertible, Error {
    case canNotFindExecuteFunction
    
    var description: String {
        switch self {
        case .canNotFindExecuteFunction: "Can not find an `execute` function"
        }
    }
}

public struct UseCaseProtocolMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let functionDeclarations = declaration.memberBlock.members.compactMap { $0.decl.as(FunctionDeclSyntax.self) }
        
        guard var executeFunctionDeclaration = functionDeclarations.first(where: { $0.name.text == "execute" })
        else { throw UseCaseMacroError.canNotFindExecuteFunction }
        
        executeFunctionDeclaration.name = "callAsFunction"
        
        var bodyLiteral = ""
        bodyLiteral += executeFunctionDeclaration.description.contains("throws") ? "try " : ""
        bodyLiteral += executeFunctionDeclaration.description.contains("async") ? "await " : ""
        
        return [
            "\(raw: executeFunctionDeclaration)"
        ]
    }
}

extension UseCaseProtocolMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let requestExtension = try ExtensionDeclSyntax("extension \(type.trimmed): UseCase {}")
        return [requestExtension]
    }
}
