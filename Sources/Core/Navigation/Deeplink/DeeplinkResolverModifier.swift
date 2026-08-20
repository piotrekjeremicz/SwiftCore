//
//  DeeplinkResolverModifier.swift
//  Core
//
//  Created by Piotrek Jeremicz on 19/08/2026.
//

import SwiftUI

struct DeeplinkResolverModifier<Node: DeeplinkNode>: ViewModifier {
    let perform: @MainActor (DeeplinkTarget<Node>, (any Payload)?) -> Void

    @Environment(\.deeplinkParentKey) private var deeplinkParentKey
    @Dependency private var registrar: DeeplinkRegistrar

    func body(content: Content) -> some View {
        content
            .onAppear(perform: attachResolver)
            .onDisappear(perform: detachResolver)
    }
}

private extension DeeplinkResolverModifier {
    func attachResolver() {
        registrar.attachResolver(for: deeplinkParentKey) { node, payload in
            perform(DeeplinkTarget(node: node), payload)
        }
    }

    func detachResolver() {
        registrar.detachResolver(for: deeplinkParentKey)
    }
}

public extension View {
    func deeplink<Node: DeeplinkNode>(
        _ path: KeyPath<RootNode, Node>,
        perform: @MainActor @escaping (DeeplinkTarget<Node>, (any Payload)?) -> Void
    ) -> some View {
        modifier(DeeplinkResolverModifier(perform: perform))
    }
}
