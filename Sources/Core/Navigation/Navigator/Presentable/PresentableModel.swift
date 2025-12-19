//
//  PresentableModel.swift
//  Core
//
//  Created by Piotrek Jeremicz on 18.12.2025.
//


public protocol PresentableModel: Equatable, Sendable {
    var kind: PresentableType { get }
    
    var title: String { get }
    var message: String? { get }
}

public enum PresentableType {
    case alert
}
