//
//  Resolver.swift
//  Core
//
//  Created by Piotrek Jeremicz on 24.10.2025.
//


public protocol Resolver: Sendable {
    func resolve<Service: Sendable>() -> Service
    
    func resolve<Service: Sendable>(
        _ serviceType: Service.Type
    ) -> Service
}
