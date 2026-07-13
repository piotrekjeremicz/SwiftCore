//
//  FeatureFlag.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13.07.2026.
//

public protocol FeatureFlag: Sendable {
    associatedtype Payload: Sendable

    var isEnabled: Bool { get }
    var payload: Payload { get }

    init(isEnabled: Bool, payload: Payload)
}

public extension FeatureFlag where Payload == Bool {
    var payload: Bool { isEnabled }
}

public protocol ToggleFeatureFlag: FeatureFlag where Payload == Bool {
    init(isEnabled: Bool)
}

public extension ToggleFeatureFlag {
    init(isEnabled: Bool, payload: Bool) {
        self.init(isEnabled: isEnabled)
    }
}
