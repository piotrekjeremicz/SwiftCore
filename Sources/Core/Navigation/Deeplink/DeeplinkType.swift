//
//  DeeplinkType.swift
//  Core
//
//  Created by Piotrek Jeremicz on 29/05/2026.
//

import SwiftUI

enum DeeplinkType {
    case root
    case stack
    case attached(to: String)
    case stale
}

extension EnvironmentValues {
    @Entry var deeplinkType: DeeplinkType = .root
}
