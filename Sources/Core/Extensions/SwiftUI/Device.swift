//
//  Device.swift
//  Core
//
//  Created by Piotrek Jeremicz on 27.09.2024.
//

#if canImport(SwiftUI)
import SwiftUI

public extension EnvironmentValues {
    @Entry var device = Device()
}
#endif

public struct Device {
    public enum Kind {
        case phone, pad, tv, carPlay, mac, vision
        case unknown
    }
    
    public var kind: Kind {
#if canImport(UIKit)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        .phone
        case .pad:          .pad
        case .tv:           .tv
        case .carPlay:      .carPlay
        case .mac:          .mac
        case .vision:       .vision
        case .unspecified:  .unknown
        @unknown default:   .unknown
        }
#elseif canImport(AppKit)
        .mac
#else
        .unknown
#endif
    }
}
