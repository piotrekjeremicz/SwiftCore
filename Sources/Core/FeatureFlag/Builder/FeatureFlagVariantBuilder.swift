//
//  FeatureFlagVariantBuilder.swift
//  Core
//
//  Created by Piotrek Jeremicz on 13/07/2026.
//

@resultBuilder
public struct FeatureFlagVariantBuilder<Flag: FeatureFlag> {
    public static func buildExpression(_ variant: FeatureFlagVariant<Flag>) -> FeatureFlagVariant<Flag> {
        variant
    }

    public static func buildBlock(_ variants: FeatureFlagVariant<Flag>...) -> [FeatureFlagVariant<Flag>] {
        variants
    }
}
