//
//  DeeplinkKey.swift
//  Core
//
//  Created by Piotrek Jeremicz on 18/08/2026.
//

struct DeeplinkKey: CustomStringConvertible, Equatable {
    let key: String
    let identifier: String?

    init(key: String, identifier: String? = nil) {
        self.key = key
        self.identifier = identifier
    }

    var description: String {
        identifier.map { "\(key):\($0)" } ?? key
    }
}
