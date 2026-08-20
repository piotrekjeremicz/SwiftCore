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
    @Environment(\.deeplinkParentKey) private var deeplinkParentKey
    @Dependency private var registrar: DeeplinkRegistrar

    public func body(content: Content) -> some View {
        content
            .navigationDestination(for: Navigator.Route.self) { item in
                routeContent(item)
                    .environment(\.deeplinkParentKey, DeeplinkSegment.key(for: item))
                    .environment(\.deeplinkType, .stack(in: deeplinkParentKey))
            }
            .onChange(of: navigator.route) { oldValue, newValue in
                syncDeeplinkTree(from: oldValue, to: newValue)
            }
    }

    private func syncDeeplinkTree(from oldRoute: [Navigator.Route], to newRoute: [Navigator.Route]) {
        let commonCount = zip(oldRoute, newRoute).prefix(while: { $0.0 == $0.1 }).count

        for item in oldRoute[commonCount...].reversed() {
//            registrar.unregister(DeeplinkSegment.key(for: item))
        }

        for index in commonCount..<newRoute.count {
            let parentKey = index == 0 ? deeplinkParentKey : DeeplinkSegment.key(for: newRoute[index - 1])
//            registrar.registrer(DeeplinkSegment.key(for: newRoute[index]), for: .stack(in: parentKey))
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

/// Stable segment key for a stack route item: the bare enum case name kebab-cased, with the
/// associated value dropped via reflection — `feedbackDetail(FeedbackItem(...))` → `feedback-detail`.
/// Values without a case label (plain enums, non-enums) fall back to their description.
enum DeeplinkSegment {
    static func key(for item: some Hashable) -> String {
        let caseName = Mirror(reflecting: item).children.first?.label ?? "\(item)"
        return caseName.kebabCased
    }
}
