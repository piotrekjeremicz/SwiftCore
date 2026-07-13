//
//  FeatureFlagRemoteSource.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13.07.2026.
//

import Foundation

public protocol FeatureFlagRemoteSource: Sendable {
    func fetch() async throws -> [String: Data]
}

public struct EmptyFeatureFlagRemoteSource: FeatureFlagRemoteSource {
    public init() {}

    public func fetch() async throws -> [String: Data] { [:] }
}
