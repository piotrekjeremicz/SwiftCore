//
//  View.swift
//  Core
//
//  Created by Piotrek Jeremicz on 12.10.2024.
//

import SwiftUI

public extension View {
    @inlinable func frame(size: CGSize? = nil, alignment: Alignment = .center) -> some View {
        frame(width: size?.width, height: size?.height, alignment: alignment)
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<C1: View, C2: View>(_ condition: Bool, true transformOnTrue: (Self) -> C1, else transformOnFalse: (Self) -> C2) -> some View {
        if condition {
            transformOnTrue(self)
        } else {
            transformOnFalse(self)
        }
    }
    
    @ViewBuilder
    func unwrap<Value: Any, Content: View>(_ value: Value?, transform: (Self, Value) -> Content) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
}
