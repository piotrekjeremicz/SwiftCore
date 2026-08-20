//
//  DeeplinkRegistrarModifier.swift
//  Core
//
//  Created by Piotrek Jeremicz on 29/05/2026.
//

import SwiftUI

struct DeeplinkRegistrarModifier: ViewModifier {
    let deeplinkKey: DeeplinkKey

/////// CHECK
    var resolve: ((_ key: String, _ payload: (any Payload)?, _ continuation: @escaping VoidClosure) -> DeeplinkCommand?)?
    var unwind: ((_ continuation: @escaping VoidClosure) -> Void)?
///////

    @Environment(\.deeplinkType) private var deeplinkType
    @Dependency private var registrar: DeeplinkRegistrar

    init(register key: String, identifier: String? = nil) {
        deeplinkKey = .init(key: key, identifier: identifier)
    }

    init<C: Coordinator>(register coordinator: C) {
        deeplinkKey = DeeplinkKey(
            key: coordinator.key,
            identifier: coordinator.identifier
        )

///////// CHECK
        unwind = DeeplinkRegistrarModifier.unwindClosure(for: coordinator)

        if let resolving = coordinator as? any DeeplinkResolving {
            resolve = { key, payload, continuation in
                resolving.deeplinkCommand(for: key, payload: payload, then: continuation)
            }
        }
/////////
    }

    func body(content: Content) -> some View {
        content
            .onAppear(perform: deeplinkRegistration)
            .onDisappear(perform: deeplinkRemoval)
            .environment(\.deeplinkParentKey, deeplinkKey.description)
    }
}

private extension DeeplinkRegistrarModifier {
    func deeplinkRegistration() {
        registrar.registrer(deeplinkKey, for: deeplinkType, resolve: resolve, unwind: unwind)
    }

    func deeplinkRemoval() {
        registrar.unregister(deeplinkKey)
    }
}

private extension DeeplinkRegistrarModifier {
    /// `nil` when `C.Navigator == Never` (no navigator to unwind) or when the navigator is
    /// neither `Destinable` nor `Routable`.
    static func unwindClosure<C: Coordinator>(for coordinator: C) -> ((@escaping VoidClosure) -> Void)? {
        guard C.Navigator.self != Never.self else { return nil }

        if let destinable = coordinator.navigator as? any Destinable {
            return { continuation in destinable.dismiss(completion: continuation) }
        }
        if let routable = coordinator.navigator as? any Routable {
            return { continuation in routable.popToRoot(completion: continuation) }
        }
        return nil
    }
}

private extension DeeplinkRegistrarModifier {
    ////// CHEKC BOTH
    static func createKey<C: Coordinator>(for coordinator: C) -> String {
        "\(type(of: coordinator))"
            .replacingOccurrences(of: "Coordinator", with: "")
            .kebabCased
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
