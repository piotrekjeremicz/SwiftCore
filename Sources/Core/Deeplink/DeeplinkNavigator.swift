//
//  DeeplinkNavigator.swift
//  Core
//
//  Created by Piotrek Jeremicz on 02.01.2025.
//

import SwiftUI

@Observable
public class DeeplinkNavigator {
    private typealias RegistrarValue = (_ destination: AnyKeyPath, _ current: AnyKeyPath, _ withAnimation: Bool) -> AnyKeyPath?
    
    private var registeredViews: [AnyKeyPath: RegistrarValue] = [:]
    
    public init() { }
    
    func registerView(
        for keyPath: AnyKeyPath,
        resolve: @escaping (AnyKeyPath, AnyKeyPath, Bool) -> AnyKeyPath?
    ) {
        registeredViews[keyPath] = resolve
    }
    
    func unregisterView(for keyPath: AnyKeyPath) {
        registeredViews[keyPath] = nil
    }
    
    public func navigate<R: DeeplinkNode>(to path: PartialKeyPath<R>, withAnimation animation: Bool = true, completion: VoidClosure? = nil) {
        Task {
            await resolve(path, withAnimation: animation)
            completion?()
        }
    }
    
    public func navigate<R: DeeplinkNode>(to path: PartialKeyPath<R>, withAnimation animation: Bool = true) async {
        await resolve(path, withAnimation: animation)
    }
}

extension DeeplinkNavigator {
    private func resolve<R: DeeplinkNode>(_ path: PartialKeyPath<R>, withAnimation animation: Bool = true) async {
        var currentPath: AnyKeyPath = \R.self
        var nodesCount = path.keyPathString.split(separator: ".").count - 1
        
        repeat {
            guard let similarRegistrar = await findSimilarPath(for: currentPath, withAnimation: animation)
            else {
                print("[Deeplink] Can not find similar path for: \(currentPath)")
                return
            }
            
            guard let nextPath = similarRegistrar(path, currentPath, animation)
            else {
                print("[Deeplink] Can not resolve nodePath for: \(currentPath)")
                return
            }
            
            currentPath = nextPath
            nodesCount -= 1
        } while path.keyPathString != currentPath.keyPathString || nodesCount > 0
    }
    
    private func findSimilarPath(for currentPath: AnyKeyPath, withAnimation animation: Bool) async -> RegistrarValue? {
        var repeatCount: Int = 0
        
        repeat {
            if let element = registeredViews.first(where: { $0.key == currentPath }) {
                return element.value
            } else {
                try? await Task.sleep(for: .seconds(animation ? 0.3 : 0.1))
                repeatCount += 1
            }
        } while repeatCount < 10
        
        return nil
    }
}

public extension EnvironmentValues {
    @Entry public var deeplink: DeeplinkNavigator = DeeplinkNavigator()
}
