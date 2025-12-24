//
//  CoordinatorRegistrar.swift
//  Core
//
//  Created by Piotrek Jeremicz on 07.12.2025.
//

import SwiftUI

public final class CoordinatorRegistrar: @unchecked Sendable {
    private var container = [Key: Definition]()

    public func register(_ definition: Definition) {
        container[definition.id] = definition
    }

    public func resolve(_ key: Key) -> Definition {
        container[key] ?? .emptyDefinition
    }

    public func resolve(for location: Location) -> [Definition] {
        container
            .filter {
                $0.value.locations.contains { loc, _ in
                    location == loc
                }
            }
            .sorted { lhs, rhs in
                if let leftOrder = lhs.value.locations.filter { loc, _ in loc == location }.first?.order,
                let rightOrder = rhs.value.locations.filter { loc, _ in loc == location }.first?.order {
                    return leftOrder < rightOrder
                } else { return false }
            }
            .map(\.value)
    }
}

public extension CoordinatorRegistrar {
    struct Definition: Identifiable, @unchecked Sendable {
        typealias Content = @MainActor () -> any View

        public let id: Key
        public let title: String
        public let symbolName: String?

        let content: Content
        let locations: [(Location, order: Int)]

        @MainActor
        public var anyView: AnyView { AnyView(content()) }

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
            self.content = content
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
    static let emptyDefinition = CoordinatorRegistrar.Definition(
        .empty,
        title: "Empty",
        content: { EmptyView() }
    )
}

private extension CoordinatorRegistrar.Key {
    static let empty = Self(rawValue: "empty")
}
