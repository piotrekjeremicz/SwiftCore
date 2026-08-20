//
//  String+KebabCased.swift
//  Core
//
//  Created by Piotrek Jeremicz on 17/08/2026.
//

import Foundation

extension String {
    var kebabCased: String {
        unicodeScalars.reduce(into: "") { result, scalar in
            if CharacterSet.uppercaseLetters.contains(scalar) {
                if !result.isEmpty { result += "-" }
                result += String(scalar).lowercased()
            } else {
                result += String(scalar)
            }
        }
    }
}
