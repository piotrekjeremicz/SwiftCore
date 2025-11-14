//
//  UseCase.swift
//  Core
//
//  Created by Piotrek Jeremicz on 28.10.2025.
//

@attached(extension, conformances: UseCase)
@attached(member, names: named(callAsFunction))
public macro UseCase() = #externalMacro(module: "CoreMacros", type: "UseCaseMacro")

@attached(member, names: named(callAsFunction))
public macro UseCaseProtocol() = #externalMacro(module: "CoreMacros", type: "UseCaseProtocolMacro")

public protocol UseCase: Sendable { }
