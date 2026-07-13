//
//  FeatureFlagRemoteEntry.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13/07/2026.
//

import Foundation

struct FeatureFlagRemoteEntry<Payload: Decodable>: Decodable {
    let isEnabled: Bool
    let payload: Payload?
}
