//
//  OverridableFeatureFlag.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13/07/2026.
//

import Foundation

public protocol OverridableFeatureFlag: FeatureFlag where Payload: Codable {
    static var id: String { get }
}

extension OverridableFeatureFlag {
    static func decodeOverride(from data: Data) -> Self? {
        guard let entry = try? JSONDecoder().decode(FeatureFlagOverrideEntry<Payload>.self, from: data) else {
            return nil
        }

        return Self(isEnabled: entry.isEnabled, payload: entry.payload)
    }

    static func encodeOverride(isEnabled: Bool, payload: Payload) -> Data? {
        try? JSONEncoder().encode(FeatureFlagOverrideEntry(isEnabled: isEnabled, payload: payload))
    }
}
