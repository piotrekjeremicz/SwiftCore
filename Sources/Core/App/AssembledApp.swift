//
//  AssembledApp.swift
//  Core
//
//  Created by Piotrek Jeremicz on 21.10.2025.
//

import SwiftUI

public protocol AssembledApp: App {
    associatedtype Factor: Module
    associatedtype AppScene: Scene
    
    @SceneBuilder @MainActor @preconcurrency var scenes: AppScene { get }
    
    @ModuleBuilder var modules: Factor { get }    
}

public extension AssembledApp {
    var body: some Scene {
        CoreScene(assembledWith: modules) { scenes }
    }
    
    var modules: some Module { EmptyModule() }
}
