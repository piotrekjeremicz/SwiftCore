//
//  CoordinatorDefinition.swift
//  Core
//
//  Created by Piotrek Jeremicz on 26.02.2026.
//

import SwiftUI

public extension CoordinatorRegistrar {
    struct Definition: Identifiable, @unchecked Sendable {
        typealias Content = @MainActor (AnyPayload?) -> any View

        public let id: Key
        public let title: String
        public let symbolName: String?

        let content: Content
        let locations: [(Location, order: Int)]

        public init(
            _ key: Key,
            title: String,
            symbolName: String? = nil,
            locations: [(Location, order: Int)] = [],
            content: @escaping @MainActor (AnyPayload?) -> any View
        ) {
            id = key
            self.title = title
            self.symbolName = symbolName
            self.locations = locations
            self.content = content
        }

        public init(
            _ key: Key,
            title: String,
            symbolName: String? = nil,
            locations: [(Location, order: Int)] = [],
            content: @escaping @MainActor () -> any View
        ) {
            id = key
            self.title = title
            self.symbolName = symbolName
            self.locations = locations
            self.content = { _ in content() }
        }

        @MainActor
        public func anyView(payload: AnyPayload?) -> some View {
            AnyView(content(payload))
        }
    }

    struct Key: Hashable, Sendable {
        let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    struct Location: Equatable, Sendable {
        let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension CoordinatorRegistrar.Definition {
    static func missingDefinition(for key: CoordinatorRegistrar.Key) -> CoordinatorRegistrar.Definition {
        CoordinatorRegistrar.Definition(
            .empty,
            title: "Missing Definition",
            content: { Text("⚠️ Can't find \(key.rawValue) coordinator") }
        )
    }
}

private extension CoordinatorRegistrar.Key {
    static let empty = Self(rawValue: "empty")
}
