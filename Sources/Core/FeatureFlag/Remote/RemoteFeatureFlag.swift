//
//  FeatureFlagIdentity.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13.07.2026.
//

import Foundation

public protocol RemoteFeatureFlag: FeatureFlag where Payload: Decodable {
    static var id: String { get }
}

extension RemoteFeatureFlag {
    static func decode(from data: Data) -> Self? {
        guard let entry = try? JSONDecoder().decode(FeatureFlagRemoteEntry<Payload>.self, from: data),
              let payload = entry.payload ?? (entry.isEnabled as? Payload) else {
            return nil
        }

        return Self(isEnabled: entry.isEnabled, payload: payload)
    }
}


