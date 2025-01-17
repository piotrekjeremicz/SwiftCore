//
//  Identifiable.swift
//  Core
//
//  Created by Piotrek Jeremicz on 14.01.2025.
//

extension Identifiable where Self: RawRepresentable, Self.RawValue == String {
    var id: String { rawValue }
}

extension Identifiable where Self: RawRepresentable, Self: Hashable {
    var id: Int { self.hashValue }
}
