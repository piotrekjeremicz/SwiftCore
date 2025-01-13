//
//  UseCase.swift
//  Core
//
//  Created by Piotrek Jeremicz on 10.09.2024.
//

@attached(extension, conformances: UseCase)
@attached(member, names: named(callAsFunction))
public macro UseCase() = #externalMacro(module: "CoreMacros", type: "UseCaseMacro")

public protocol UseCase {}
