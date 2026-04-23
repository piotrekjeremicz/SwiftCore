//
//  Coordinator.swift
//  Core
//
//  Created by Piotrek Jeremicz on 01.11.2025.
//

import SwiftUI

@MainActor
public protocol Coordinator: View {
    associatedtype Navigator = Never
    associatedtype Root: View

    var navigator: Navigator { get }
    @ViewBuilder @MainActor var root: Root { get }
}

public extension Coordinator where Navigator == Never {
    var navigator: Never { fatalError("Navigator is Never") }
}

public extension Coordinator {
    @MainActor
    @ViewBuilder
    var body: some View {
        if Navigator.self == Never.self {
            root
        } else if let routable = navigator as? any (Routable & Observable) {
            makeRoutableStack(navigator: routable) {
                root
            }
        } else {
            NavigationStack {
                root
            }
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
