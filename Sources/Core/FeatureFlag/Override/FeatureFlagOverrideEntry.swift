//
//  FeatureFlagOverrideEntry.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13/07/2026.
//

struct FeatureFlagOverrideEntry<Payload: Codable>: Codable {
    let isEnabled: Bool
    let payload: Payload
}
