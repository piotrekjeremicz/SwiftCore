//
//  FeatureFlagValues.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13.07.2026.
//

public struct FeatureFlagValues: Sendable {
    public let environment: AppEnvironment

    public init(environment: AppEnvironment) {
        self.environment = environment
    }

    public func flag<Flag: FeatureFlag>(_ variants: FeatureFlagVariant<Flag>...) -> Flag {
        if let match = variants.first(where: { $0.environment == environment }) {
            return match.flag
        }

        if let fallback = variants.first(where: { $0.environment == nil }) {
            return fallback.flag
        }

        fatalError("❌ No FeatureFlag variant of \(Flag.self) for environment '\(environment.rawValue)' and no .default provided")
    }
}
