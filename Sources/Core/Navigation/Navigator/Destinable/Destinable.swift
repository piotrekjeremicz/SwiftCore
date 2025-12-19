//
//  Destinable.swift
//  Core
//
//  Created by Piotrek Jeremicz on 04.09.2024.
//

@MainActor
public protocol Destinable: AnyObject, Sendable {
    associatedtype Destination: Identifiable, Sendable
    
    var destination: Destination? { get set }
    
    func present(_ destination: Destination, withAnimation enabled: Bool, completion handler: VoidClosure?)
    func dismiss(withAnimation enabled: Bool, completion handler: VoidClosure?)
}

public extension Destinable {
    func present(_ destination: Destination, withAnimation enabled: Bool = true, completion handler: VoidClosure? = nil) {
        withAnimation(enabled, { [weak self] in
            self?.destination = destination
        }, completion: handler)
    }
    
    func dismiss(withAnimation enabled: Bool = true, completion handler: VoidClosure? = nil) {
        withAnimation(enabled, { [weak self] in
            self?.destination = nil
        }, completion: handler)
    }
}
