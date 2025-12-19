//
//  WithAnimation.swift
//  Extensions
//
//  Created by Piotrek Jeremicz on 04.09.2024.
//

import SwiftUI

func withAnimation(_ enabled: Bool = true, _ body: VoidClosure, completion: (VoidClosure)? = nil) {
    if enabled {
        withAnimation {
            body()
        } completion: {
            completion?()
        }
    } else {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        
        withTransaction(transaction) {
            body()
        }
        
        completion?()
    }
}
