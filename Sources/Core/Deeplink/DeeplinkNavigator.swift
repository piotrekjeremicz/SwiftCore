//
//  DeeplinkNavigator.swift
//  Core
//
//  Created by Piotrek Jeremicz on 02.01.2025.
//

import SwiftUI

@Observable
public class DeeplinkNavigator {
    private var registeredViews: [AnyKeyPath: (_ destination: AnyKeyPath, _ current: AnyKeyPath) -> AnyKeyPath?] = [:]
    
    public init() { }
    
    func registerView(
        for keyPath: AnyKeyPath,
        resolve: @escaping (AnyKeyPath, AnyKeyPath) -> AnyKeyPath?
    ) {
        registeredViews[keyPath] = resolve
    }
    
    func unregisterView(for keyPath: AnyKeyPath) {
        registeredViews[keyPath] = nil
    }
    
    public func navigate<R: DeeplinkNode>(to path: PartialKeyPath<R>) {
        var currentPath: AnyKeyPath = \R.self
        var nodesCount = path.keyPathString.split(separator: ".").count - 1
        
        repeat {
            guard let similarPath = registeredViews.first(where: { $0.key == currentPath })
            else {
                print("[Deeplink] Can not find similar path for: \(currentPath)")
                return
            }
            
            guard let nextPath = similarPath.value(path, currentPath)
            else {
                print("[Deeplink] Can not resolve nodePath for: \(currentPath)")
                return
            }
            
            currentPath = nextPath
            nodesCount -= 1
        } while path.keyPathString != currentPath.keyPathString || nodesCount > 0
    }
}

public extension EnvironmentValues {
    @Entry public var deeplink: DeeplinkNavigator = DeeplinkNavigator()
}

private extension DeeplinkNavigator {
    struct Registrar {
        let children: [AnyKeyPath]
        let handler: (AnyKeyPath) -> Void
    }
}
