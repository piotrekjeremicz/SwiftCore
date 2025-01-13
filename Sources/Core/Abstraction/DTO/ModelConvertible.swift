//
//  ModelConvertible.swift
//  Core
//
//  Created by Piotrek Jeremicz on 08.09.2024.
//

public protocol ModelConvertible {
    associatedtype Model
    
    var model: Model { get }
}

