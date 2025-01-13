//
//  Task.swift
//  Core
//
//  Created by Piotrek Jeremicz on 19.09.2024.
//

import Foundation

public extension Task where Success == Never, Failure == Never {
    static var name: String? {
        get { Thread.current.name }
        set { Thread.current.name = newValue }
    }
}
