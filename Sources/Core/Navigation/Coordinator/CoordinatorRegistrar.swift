//
//  CoordinatorRegistrar.swift
//  Core
//
//  Created by Piotrek Jeremicz on 07.12.2025.
//

public final class CoordinatorRegistrar: @unchecked Sendable {
    private var container = [Key: Definition]()

    public func register(_ definition: Definition) {
        container[definition.id] = definition
    }

    public func resolve(_ key: Key) -> Definition {
        container[key] ?? .missingDefinition(for: key)
    }

    public func resolve(for location: Location) -> [Definition] {
        container
            .filter {
                $0.value.locations.contains { loc, _ in
                    location == loc
                }
            }
            .sorted { lhs, rhs in
                if let leftOrder = lhs.value.locations.filter({ loc, _ in loc == location }).first?.order,
                   let rightOrder = rhs.value.locations.filter({ loc, _ in loc == location }).first?.order {
                    return leftOrder < rightOrder
                } else { return false }
            }
            .map(\.value)
    }
}
