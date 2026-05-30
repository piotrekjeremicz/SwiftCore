//
//  DeeplinkRegistrarModifier.swift
//  Core
//
//  Created by Piotrek Jeremicz on 29/05/2026.
//

import SwiftUI

struct DeeplinkRegistrarModifier: ViewModifier {
    let key: String
    let identifier: String?

    @Environment(\.deeplinkType) private var deeplinkType
    @Dependency private var registrar: DeeplinkRegistrar

    init(register key: String) {
        self.key = key
        identifier = nil
    }

    init<C: Coordinator>(register coordinator: C) {
        key = DeeplinkRegistrarModifier.createKey(for: coordinator)

        if C.Payload.self != Never.self, let payload = coordinator.payload {
            identifier = payload.id
        } else {
            identifier = nil
        }
    }

    init<V: View>(register view: V) {
        key = DeeplinkRegistrarModifier.createKey(for: view)
        identifier = nil
    }

    func body(content: Content) -> some View {
        let fullKey = identifier.map { "\(key):\($0)" } ?? key
        content
            .onAppear(perform: deeplinkRegistration)
            .onDisappear(perform: deeplinkRemoval)
            .environment(\.deeplinkKey, fullKey)
    }
}

private extension DeeplinkRegistrarModifier {
    func deeplinkRegistration() {
        registrar.registrer(key, identifier: identifier, for: deeplinkType)
    }

    func deeplinkRemoval() {
        registrar.unregister(key, identifier: identifier)
    }
}

private extension DeeplinkRegistrarModifier {
    static func createKey<C: Coordinator>(for coordinator: C) -> String {
        let name = "\(type(of: coordinator))".replacingOccurrences(of: "Coordinator", with: "")
        
        return name.unicodeScalars.reduce(into: "") { result, scalar in
            if CharacterSet.uppercaseLetters.contains(scalar) {
                if !result.isEmpty { result += "-" }
                result += String(scalar).lowercased()
            } else {
                result += String(scalar)
            }
        }
    }

    static func createKey<V: View>(for view: V) -> String {
        let suffixes = ["PageView", "View"]
        let typeName = "\(type(of: view))"
        let name = suffixes.reduce(typeName) { $0.replacingOccurrences(of: $1, with: "") }

        return name.unicodeScalars.reduce(into: "") { result, scalar in
            if CharacterSet.uppercaseLetters.contains(scalar) {
                if !result.isEmpty { result += "-" }
                result += String(scalar).lowercased()
            } else {
                result += String(scalar)
            }
        }
    }
}

extension View {
    func deeplinkRegistrar<C: Coordinator>(register coordinator: C) -> some View {
        modifier(
            DeeplinkRegistrarModifier(register: coordinator)
        )
    }

    func deeplinkRegistrar(register key: String) -> some View {
        modifier(
            DeeplinkRegistrarModifier(register: key)
        )
    }
}
