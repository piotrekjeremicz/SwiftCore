//
//  Builder.swift
//  Core
//
//  Created by Piotrek Jeremicz on 21.12.2024.
//

import SwiftUI

public protocol Builder: Service {
    associatedtype Item: BuilderItem
    
    var container: [Item] { get set }
    var resolved: [Item] { get }
    func register(_ item: @autoclosure @escaping () -> Item)
}

public extension Builder {
    var resolved: [Item] {
        container.sorted { $0.order < $1.order }
    }
}

public protocol BuilderItem: Identifiable {
    var id: ID { get }
    var order: Int { get }
    var title: String { get }
    var symbol: String { get }
    var content: () -> any View { get }
}
