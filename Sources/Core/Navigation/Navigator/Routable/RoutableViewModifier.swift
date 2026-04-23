//
//  RoutableViewModifier.swift
//  Core
//
//  Created by Piotrek Jeremicz on 19/04/2026.
//

import SwiftUI

struct RoutableViewModifier<Navigator, Destination>: ViewModifier where Navigator: Routable, Destination: View {
    typealias RouteContent = (Navigator.Route) -> Destination

    let onDismiss: VoidClosure?
    let routeContent: RouteContent
    @Binding var navigator: Navigator

    public func body(content: Content) -> some View {
        content.navigationDestination(for: Navigator.Route.self) { item in
            routeContent(item)
        }
    }
}

public extension View {
    func stack<Navigator: Routable, Destination: View>(
        navigator: Binding<Navigator>,
        onDismiss: VoidClosure? = nil,
        @ViewBuilder content: @escaping (Navigator.Route) -> Destination
    ) -> some View {
        modifier(
            RoutableViewModifier(
                onDismiss: onDismiss,
                routeContent: content,
                navigator: navigator
            )
        )
    }
}
