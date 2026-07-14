//
//  FeatureFlagVariant.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13.07.2026.
//

public struct FeatureFlagVariant<Flag: FeatureFlag>: Sendable {
    let environment: AppEnvironment?
    let flag: Flag

    public init(_ environment: AppEnvironment?, isEnabled: Bool, payload: Flag.Payload) {
        self.environment = environment
        self.flag = Flag(isEnabled: isEnabled, payload: payload)
    }
}

public extension FeatureFlagVariant {
    static func `default`(_ isEnabled: Bool, _ payload: Flag.Payload) -> Self {
        .init(nil, isEnabled: isEnabled, payload: payload)
    }
}

public extension FeatureFlagVariant where Flag: ToggleFeatureFlag {
    static func `default`(_ isEnabled: Bool) -> Self {
        .init(nil, isEnabled: isEnabled, payload: isEnabled)
    }
}
