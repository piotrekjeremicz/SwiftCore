//
//  String.swift
//  Core
//
//  Created by Piotrek Jeremicz on 12.10.2024.
//

import CommonCrypto
import Foundation

public extension String {
    func sha256(salt: String) -> Data {
        return (self + salt).data(using: .utf8)!.sha256
    }
}
