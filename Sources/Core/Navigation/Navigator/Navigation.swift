//
//  Navigation.swift
//  Core
//
//  Created by Piotrek Jeremicz on 04.09.2024.
//

public protocol Navigation: Hashable, Identifiable, Sendable {
    var preferredPresentationStyle: PresentationStyle { get }
}

public extension Navigation {
    var id: Self { self }

    var preferredPresentationStyle: PresentationStyle { .automatic }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public enum PresentationStyle {
    case automatic
    case fullScreen, sheet

    func isOneOf(_ styles: PresentationStyle...) -> Bool {
        styles.contains(self)
    }
}
