//
//  DeeplinkRegistrarModifier.swift
//  Core
//
//  Created by Piotrek Jeremicz on 29/05/2026.
//

import SwiftUI

struct DeeplinkRegistrarModifier: ViewModifier {
    let deeplinkKey: DeeplinkKey

    // TODO: - Maybe it could be better if Destinable and Routable track dismissal on their own but for now it could be
    private let dismiss: ((_ continuation: @escaping VoidClosure) -> Void)?
    private let popToRoot: ((_ continuation: @escaping VoidClosure) -> Void)?

    @Environment(\.deeplinkType) private var deeplinkType
    @Dependency private var registrar: DeeplinkRegistrar

    init<C: Coordinator>(register coordinator: C) {
        deeplinkKey = DeeplinkKey(
            key: coordinator.key,
            identifier: coordinator.identifier
        )

        if C.Navigator.self != Never.self {
            if let destinable = coordinator.navigator as? any Destinable {
                dismiss = { continuation in destinable.dismiss(completion: continuation) }
            } else {
                dismiss = nil
            }

            if let routable = coordinator.navigator as? any Routable {
                popToRoot = { continuation in routable.popToRoot(completion: continuation) }
            } else {
                popToRoot = nil
            }
        } else {
            dismiss = nil
            popToRoot = nil
        }
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
        registrar.registrer(deeplinkKey, for: deeplinkType, dismiss: dismiss, popToRoot: popToRoot)
    }

    func deeplinkRemoval() {
        registrar.unregister(deeplinkKey)
    }
}

extension View {
    func deeplinkRegistrar<C: Coordinator>(register coordinator: C) -> some View {
        modifier(
            DeeplinkRegistrarModifier(register: coordinator)
        )
    }
}
