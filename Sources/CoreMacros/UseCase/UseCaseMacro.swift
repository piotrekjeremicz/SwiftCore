//
//  UseCaseMacro.swift
//  Core
//
//  Created by Piotrek Jeremicz on 28.10.2025.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum UseCaseMacroError: CustomStringConvertible, Error {
    case canNotFindExecuteFunction
    
    var description: String {
        switch self {
        case .canNotFindExecuteFunction: "Can not find an `execute` function"
        }
    }
}

public struct UseCaseMacro: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        let functionDeclarations = declaration.memberBlock.members.compactMap { $0.decl.as(FunctionDeclSyntax.self) }
        
        guard var executeFunctionDeclaration = functionDeclarations.first(where: { $0.name.text == "execute" })
        else { throw UseCaseMacroError.canNotFindExecuteFunction }
        
        executeFunctionDeclaration.name = "callAsFunction"
        
        var bodyLiteral = ""
        bodyLiteral += executeFunctionDeclaration.description.contains("throws") ? "try " : ""
        bodyLiteral += executeFunctionDeclaration.description.contains("async") ? "await " : ""
        bodyLiteral += "execute("
        
        var parametersLiteral = [String]()
        executeFunctionDeclaration.signature.parameterClause.parameters.forEach { parameter in
            let firstName = parameter.firstName
            let secondName = parameter.secondName
            
            if firstName.text == "_", let secondName {
                parametersLiteral.append(secondName.text)
            } else if let secondName {
                parametersLiteral.append("\(firstName.text): \(secondName.text)")
            } else {
                parametersLiteral.append("\(firstName.text): \(firstName.text)")
            }
        }
        
        bodyLiteral += parametersLiteral.joined(separator: ", ") + ")"
        
        executeFunctionDeclaration.body = nil
        let stringLiteral = executeFunctionDeclaration.description + "{\n\(bodyLiteral)\n}"
        return [
            "\(raw: stringLiteral)"
        ]
    }
}

extension UseCaseMacro: ExtensionMacro {
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
