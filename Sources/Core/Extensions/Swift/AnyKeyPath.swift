//
//  AnyKeyPath.swift
//  Core
//
//  Created by Piotrek Jeremicz on 12.01.2025.
//

import Foundation

extension AnyKeyPath {
    var keyPathString: String {
        String(reflecting: self)
    }
}
