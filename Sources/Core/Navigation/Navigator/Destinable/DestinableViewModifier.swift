//
//  DestinableViewModifier.swift
//  Core
//
//  Created by Piotrek Jeremicz on 15.12.2025.
//

import SwiftUI

struct DestinableViewModifier<Navigator, Destination>: ViewModifier where Navigator: Destinable, Destination: View {
    typealias DestinationContent = (Navigator.Destination) -> Destination

    let onDismiss: VoidClosure?
    let destinationContent: DestinationContent

    @Binding var navigator: Navigator

    public func body(content: Content) -> some View {
        content.fullScreenCover(
            item: $navigator.destination,
            onDismiss: onDismiss,
            content: destinationContent
        )
    }
}

public extension View {
    func destination<Navigator: Destinable, Destination: View>(
        navigator: Binding<Navigator>,
        onDismiss: VoidClosure? = nil,
        @ViewBuilder content: @escaping (Navigator.Destination) -> Destination
    ) -> some View {
        modifier(
            DestinableViewModifier(
                onDismiss: onDismiss,
                destinationContent: content,
                navigator: navigator
            )
        )
    }
}
