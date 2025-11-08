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

extension Coordinator {
    public var body: some View {
        NavigationStack {
            root
        }
    }
}
