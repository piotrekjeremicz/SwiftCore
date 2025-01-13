//
//  Data.swift
//  Core
//
//  Created by Piotrek Jeremicz on 12.10.2024.
//

import CommonCrypto
import Foundation

public extension Data {
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    var sha256: Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes({
            _ = CC_SHA256($0, CC_LONG(self.count), &digest)
        })
        return Data(digest)
    }
}
