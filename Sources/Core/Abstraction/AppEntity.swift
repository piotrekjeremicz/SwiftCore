//
//  AppEntity.swift
//  Core
//
//  Created by Piotrek Jeremicz on 28.10.2025.
//

public protocol AppEntity: Sendable {
    var version: String { get }

    var bundleId: String { get }
    var groupBundleId: String { get }    
}
