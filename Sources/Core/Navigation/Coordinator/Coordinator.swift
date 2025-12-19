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
    var root: Root { get }
}

public extension Coordinator {
    var body: some View {
        NavigationStack {
            root
        }
    }
}

public extension Coordinator {
    var root: some View { EmptyView() }
}
