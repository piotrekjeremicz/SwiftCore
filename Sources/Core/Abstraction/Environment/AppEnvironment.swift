//
//  Environment.swift
//  Core
//
//  Created by Piotrek Jeremicz on 06.09.2024.
//

import Foundation

public enum EnvironmentType {
    case dev
    case prod
}

public protocol AppEnvironment {
    var baseUrl: URL { get }
    var current: EnvironmentType { get }
    
    var appName: String { get }
    var appVersion: String { get }
    var appBuildVersion: Int { get }
    var appBundleIdentifier: String { get }
        
    init()
}

public extension AppEnvironment {
    var appName: String {
        Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    var appBuildVersion: Int {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? Int ?? 0
    }
    
    var appBundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? ""
    }
}
