//
//  DeeplinkRegistrar.swift
//  Core
//
//  Created by Piotrek Jeremicz on 18.11.2025.
//

public final class DeeplinkRegistrar: @unchecked Sendable {
    var path: [String] = []

    var relativePath: String {
        path.joined(separator: "/")
    }

    func registrer(_ key: String, for type: DeeplinkType) {
        print("[Deeplink] Registering: \(key), type: \(type)")
        path.append(key)
        print("[Deeplink] Current path: \(relativePath)")
    }

    func unregister(_ key: String) {
        print("[Deeplink] Removing: \(key)")
        if path.last == key {
            path.removeLast()
        }
        print("[Deeplink] Current path: \(relativePath)")
    }
}
