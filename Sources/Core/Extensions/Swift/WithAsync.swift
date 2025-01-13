//
//  WithAsync.swift
//  Core
//
//  Created by Piotrek Jeremicz on 24.09.2024.
//

import Foundation

public func withAsync(_ closure: @escaping () async -> Void) -> () -> Void {
    { Task { @MainActor in await closure() } }
}

public func withAsync<T>(_ closure: @escaping (T) async -> Void) -> (T) -> Void {
    { item in Task { @MainActor in await closure(item) } }
}
