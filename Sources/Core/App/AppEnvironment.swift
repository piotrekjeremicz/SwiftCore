//
//  AppEnvironment.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13.07.2026.
//

public struct AppEnvironment: RawRepresentable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let undefined = Self(rawValue: "undefined")
}
