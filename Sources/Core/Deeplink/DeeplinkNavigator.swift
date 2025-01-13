//
//  DeeplinkNavigator.swift
//  Core
//
//  Created by Piotrek Jeremicz on 02.01.2025.
//

import SwiftUI

@Observable
public class DeeplinkNavigator {
    private var registeredViews: [PartialKeyPath<Root>: (_ destination: PartialKeyPath<Root>, _ current: AnyKeyPath) -> AnyKeyPath?] = [:]
    
    public init() { }
    
    func registerView(
        for keyPath: PartialKeyPath<Root>,
        resolve: @escaping (PartialKeyPath<Root>, AnyKeyPath) -> AnyKeyPath?
    ) {
        registeredViews[keyPath] = resolve
    }
    
    func unregisterView(for keyPath: PartialKeyPath<Root>) {
        registeredViews[keyPath] = nil
    }
    
    public func navigate(to path: PartialKeyPath<Root>) {
        var currentPath: AnyKeyPath = \Root.self
        var nodesCount = path.keyPathString.split(separator: ".").count
        
        repeat {
            guard let similarPath = registeredViews.first(where: { $0.key == currentPath })
            else {
                print("Can not find similar path for: \(currentPath)")
                return
            }
            
            guard let nextPath = similarPath.value(path, currentPath)
            else {
                print("Can not resolve nodePath for: \(currentPath)")
                return
            }
            
            currentPath = nextPath
            nodesCount -= 1
        } while path.keyPathString == currentPath.keyPathString
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
