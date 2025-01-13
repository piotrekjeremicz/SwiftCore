//
//  KeychainRepository.swift
//  Core
//
//  Created by Piotrek Jeremicz on 25.09.2024.
//

import Foundation
import KeychainAccess
import Networking

public protocol KeychainRepository: Repository, AuthorizationStore {
    func get(valueFor key: String) throws -> String
    func set(_ value: String, for key: String) throws
    func remove(valueFor key: String) throws
}

final class KeychainRepositoryImpl: KeychainRepository {
    var environment: any AppEnvironment
    lazy var keychain = Keychain(service: "group." + environment.appBundleIdentifier)
    
    public init(environment: any AppEnvironment) {
        self.environment = environment
    }
    
    public func get(valueFor key: String) throws -> String {
        try keychain.get(key) ?? ""
    }
    
    public func set(_ value: String, for key: String) throws {
        try keychain.set(value, key: key)
    }
    
    public func remove(valueFor key: String) throws {
        try keychain.remove(key)
    }
}

extension KeychainRepositoryImpl {
    static let tokenKey: String = Bundle.main.bundleIdentifier! + ".token"
    static let refreshTokenKey: String = Bundle.main.bundleIdentifier! + ".refresh-token"
    static let usernameKey: String = Bundle.main.bundleIdentifier! + ".username"
    static let passwordKey: String = Bundle.main.bundleIdentifier! + ".password"
    
    func store(key: AuthorizationKey, value: String) {
        try? set(value, for: key.representant(for: Self.self))
    }
    
    func get(key: AuthorizationKey) -> String? {
        try? get(valueFor: key.representant(for: Self.self))
    }
    
    func remove(key: AuthorizationKey) {
        try? remove(valueFor: key.representant(for: Self.self))
    }
}
