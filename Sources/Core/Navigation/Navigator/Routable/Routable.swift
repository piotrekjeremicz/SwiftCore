//
//  Routable.swift
//  Core
//
//  Created by Piotrek Jeremicz on 05.09.2024.
//

public protocol Routable: AnyObject, Sendable {
    associatedtype Route: Identifiable, Sendable
    
    var route: [Route] { get set }
    
    func push(_ route: Route, withAnimation enabled: Bool, completion handler: VoidClosure?)
    func pop(withAnimation enabled: Bool, completion handler: VoidClosure?)
    func popToRoot(withAnimation enabled: Bool, completion handler: VoidClosure?)
}

public extension Routable {
    func push(_ route: Route, withAnimation enabled: Bool = true, completion handler: VoidClosure? = nil) {
        withAnimation(enabled) { [weak self] in
            self?.route.append(route)
        }
    }
    
    func pop(withAnimation enabled: Bool = true, completion handler: VoidClosure? = nil) {
        withAnimation(enabled) { [weak self] in
            let _ = self?.route.popLast()
        }
    }
    
    func popToRoot(withAnimation enabled: Bool = true, completion handler: VoidClosure? = nil) {
        withAnimation(enabled) { [weak self] in
            self?.route = []
        }
    }
}
