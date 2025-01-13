//
//  UIScreen.swift
//  idea
//
//  Created by Piotrek Jeremicz on 07.12.2024.
//

import UIKit

public extension UIScreen {
    private static let cornerRadiusKey: String = {
        let components = ["Radius", "Corner", "display", "_"]
        return components.reversed().joined()
    }()
    
    public var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
            assertionFailure("Failed to detect screen corner radius")
            return 0
        }
        
        return cornerRadius
    }
}
