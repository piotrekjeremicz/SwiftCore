//
//  Navigation.swift
//  Core
//
//  Created by Piotrek Jeremicz on 04.09.2024.
//

public protocol Navigation: Hashable, Identifiable, Sendable { }

public extension Navigation {
    var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
