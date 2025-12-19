//
//  PresentableViewModifier.swift
//  Core
//
//  Created by Piotrek Jeremicz on 16.12.2025.
//

import SwiftUI

struct PresentableAlertViewModifier<Navigator>: ViewModifier where Navigator: Presentable {
    let defaultTitle: String

    @State private var item: PresentableItem?
    @Binding var navigator: Navigator

    init(navigator: Binding<Navigator>, defaultTitle: String = "") {
        _navigator = navigator
        self.defaultTitle = defaultTitle
    }

    public func body(content: Content) -> some View {
        content
            .onChange(of: navigator.presentableItem?.model.kind == .alert) { _, isAlert in
                if isAlert {
                    item = navigator.presentableItem
                } else {
                    item = nil
                }
            }
            .alert(
                item?.model.title ?? defaultTitle,
                isPresented: $navigator.isPresentableVisible,
                presenting: item?.model,
                actions: { _ in
                    item?.actions
                }, message: { model in
                    Text(verbatim: model.message ?? "")
                }
            )
    }
}

public extension View {
    func alert<Navigator: Presentable>(
        navigator: Binding<Navigator>,
        defaultTitle: String? = nil
    ) -> some View {
        modifier(
            PresentableAlertViewModifier(
                navigator: navigator,
                defaultTitle: defaultTitle ?? ""
            )
        )
    }
}
