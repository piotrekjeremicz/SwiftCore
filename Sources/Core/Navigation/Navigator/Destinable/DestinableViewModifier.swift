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

    @State private var isSheetPresented = false
    @State private var isFullScreenCoverPresented = false

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(
                isPresented: $isFullScreenCoverPresented,
                onDismiss: performDismiss,
                content: {
                    if let destination = navigator.destination {
                        destinationContent(destination)
                    } else {
                        EmptyView()
                    }
                }
            )
            .sheet(
                isPresented: $isSheetPresented,
                onDismiss: performDismiss,
                content: {
                    if let destination = navigator.destination {
                        destinationContent(destination)
                    } else {
                        EmptyView()
                    }
                }
            )
            .onChange(of: navigator.destination) { _, newValue in
                guard let presentationStyle = newValue?.prefferedPresentationStyle else {
                    isSheetPresented = false
                    isFullScreenCoverPresented = false
                    return
                }

                switch presentationStyle {
                case .automatic, .fullScreen:
                    isSheetPresented = false
                    isFullScreenCoverPresented = true
                case .sheet:
                    isSheetPresented = true
                    isFullScreenCoverPresented = false
                }
            }
    }

    func performDismiss() {
        navigator.destination = nil
        onDismiss?()
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
