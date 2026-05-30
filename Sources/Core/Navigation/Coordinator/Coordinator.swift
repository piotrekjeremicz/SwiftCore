//
//  Coordinator.swift
//  Core
//
//  Created by Piotrek Jeremicz on 01.11.2025.
//

import SwiftUI

@MainActor
public protocol Coordinator: View {
    associatedtype Root: View
    associatedtype Navigator = Never
    associatedtype Payload: Core.Payload = Never

    var payload: Payload? { get }
    var navigator: Navigator { get }
    @ViewBuilder @MainActor var root: Root { get }

    init(payload: Payload?)
}

public extension Coordinator where Navigator == Never {
    var navigator: Never { fatalError("Navigator is Never") }
}

public extension Coordinator where Payload == Never {
    var payload: Payload? { fatalError("Payload is Never") }
    
    init(payload: Payload?) { fatalError("Payload is Never") }
}

public extension Coordinator {
    @MainActor
    @ViewBuilder
    var body: some View {
        if Navigator.self == Never.self {
            root.deeplinkRegistrar(register: self)
        } else if let routable = navigator as? any (Routable & Observable) {
            makeRoutableStack(navigator: routable) {
                root
            }
            .deeplinkRegistrar(register: self)
        } else {
            NavigationStack {
                root
            }
            .deeplinkRegistrar(register: self)
        }
    }
}

@MainActor
private func makeRoutableStack<N: Routable & Observable, Content: View>(
    navigator: N,
    @ViewBuilder content: @escaping () -> Content
) -> AnyView {
    AnyView(RoutableStack(navigator: navigator, content: content))
}

@MainActor
private struct RoutableStack<N: Routable & Observable, Content: View>: View {
    @Bindable var navigator: N
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationStack(path: $navigator.route) {
            content()
        }
    }
}
