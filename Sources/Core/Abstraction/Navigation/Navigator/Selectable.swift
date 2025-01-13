//
//  Selectable.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13.10.2024.
//

public protocol Selectable: AnyObject {
    associatedtype Selection: Identifiable
    
    var selection: Selection { get set }
    
    func select(_ selection: Selection, withAnimation enabled: Bool, completion handler: VoidClosure?)
}

public extension Selectable {
    func select(_ selection: Selection, withAnimation enabled: Bool = true, completion handler: VoidClosure? = nil) {
        withAnimation(enabled, { [weak self] in
            self?.selection = selection
        }, completion: handler)
    }
}
