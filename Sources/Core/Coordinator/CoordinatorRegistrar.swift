//
//  CoordinatorRegistrar.swift
//  Core
//
//  Created by Piotrek Jeremicz on 22.12.2024.
//

import SwiftUI

public class CoordinatorRegistrar {
    private var container = [Key: Item]()
    
    public func register(_ item: Item) {
        container[item.id] = item
    }
    
    public func resolve(_ key: Key) -> AnyView? {
        guard let content = container[key]?.content() else { return nil }
        return AnyView(content)
    }
    
    public func resolve(for location: Location) -> [Item] {
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
    public struct Item: Identifiable {
        public let id: Key
        public let title: String
        public let symbolName: String?
        public let content: () -> any View
        let locations: [(Location, order: Int)]
        
        public var anyView: AnyView { AnyView(content()) }
        
        public init(
            _ key: Key,
            title: String,
            symbolName: String? = nil,
            locations: [(Location, order: Int)] = [],
            content: @escaping () -> any View
        ) {
            id = key
            self.title = title
            self.symbolName = symbolName
            self.locations = locations
            self.content = content
        }
    }
    
    public struct Key: Hashable {
        let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    public struct Location: Equatable {
        let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

