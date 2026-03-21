//
//  CoordinatorView.swift
//  Core
//
//  Created by Piotrek Jeremicz on 26.02.2026.
//

import SwiftUI

public struct CoordinatorView<P>: View where P: Payload {
    @Dependency private var registrar: CoordinatorRegistrar

    private let key: CoordinatorRegistrar.Key
    private let payload: P?

    public init(_ key: CoordinatorRegistrar.Key, payload: P) {
        self.key = key
        self.payload = payload
    }

    public init(_ key: CoordinatorRegistrar.Key) where P == Never {
        self.key = key
        self.payload = nil
    }

    public var body: some View {
        registrar.resolve(key).anyView(payload: payload)
    }
}
