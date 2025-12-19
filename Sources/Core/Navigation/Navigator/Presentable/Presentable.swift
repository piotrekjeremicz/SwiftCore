//
//  Presentable.swift
//  Core
//
//  Created by Piotrek Jeremicz on 12.12.2025.
//

import SwiftUI

@MainActor
public protocol Presentable: AnyObject, Sendable {
    var presentableItem: PresentableItem? { get set }
    var isPresentableVisible: Bool { get set }

    func present<Model, Actions>(_ model: Model, withAnimation enabled: Bool, @ViewBuilder actions: (Model) -> Actions) where Model: PresentableModel, Actions: View
    func present<Model>(_ model: Model, withAnimation enabled: Bool) where Model: PresentableModel
    func dismissPresenter(withAnimation enabled: Bool)
}

public extension Presentable {
    func present<Model, Actions>(_ model: Model, withAnimation enabled: Bool = true, @ViewBuilder actions: (Model) -> Actions) where Model: PresentableModel, Actions: View {
        withAnimation(enabled) { [weak self] in
            self?.presentableItem = PresentableItem(model: model, actions: AnyView(actions(model)))
            self?.isPresentableVisible = true
        }
    }

    func present<Model>(_ model: Model, withAnimation enabled: Bool) where Model: PresentableModel {
        withAnimation(enabled) { [weak self] in
            self?.presentableItem = PresentableItem(model: model, actions: nil)
            self?.isPresentableVisible = true
        }
    }

    func dismissPresenter(withAnimation enabled: Bool) {
        withAnimation(enabled) { [weak self] in
            self?.presentableItem = nil
            self?.isPresentableVisible = false
        }
    }
}
