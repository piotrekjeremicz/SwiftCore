//
//  Store.swift
//  Core
//
//  Created by Piotrek Jeremicz on 28.10.2025.
//

public protocol Store: Sendable {
    func get<Value>(_ key: String) -> Value?

    func insert<Value>(_ value: Value, at key: String)
    
    func remove(_ key: String)
}
