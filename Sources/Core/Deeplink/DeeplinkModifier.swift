//
//  DeeplinkModifier.swift
//  Core
//
//  Created by Piotrek Jeremicz on 05.01.2025.
//

import SwiftUI

public struct DeeplinkModifier<Node: DeeplinkNode>: ViewModifier {
    let keyPath: KeyPath<Root, Node>
    let nodeType: Node.Type
    let handler: (PartialKeyPath<Node>) -> Void
    
    @Environment(\.deeplink) private var deeplink
    
    public func body(content: Content) -> some View {
        content
            .onAppear(perform: viewRegistration)
            .onDisappear(perform: viewRemoval)
    }
}

extension DeeplinkModifier {
    func viewRegistration() {        
        deeplink.registerView(for: keyPath) { destinationPath, currentPath in
            let matchedPath = nodeType.children.first { item in
                if let nextNode = currentPath.appending (path: item),
                   destinationPath.keyPathString.starts(with: nextNode.keyPathString)
                { return true } else { return false }
            }
            
            guard let matchedPath, let newPath = currentPath.appending(path: matchedPath)
            else { return nil }
            
            return newPath
        }
    }
    
    func viewRemoval() {
        deeplink.unregisterView(for: keyPath)
    }
}

public extension View {
    func deeplink<Node: DeeplinkNode>(
        _ keyPath: KeyPath<Root, Node>,
        node: Node.Type,
        handler: @escaping (PartialKeyPath<Node>) -> Void
    ) -> some View {
        modifier(
            DeeplinkModifier(
                keyPath: keyPath,
                nodeType: node,
                handler: handler
            )
        )
    }
}

extension AnyKeyPath {
    var keyPathString: String {
        String(reflecting: self)
    }
}
