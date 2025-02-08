// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/piotrekjeremicz/SwiftyNetworking",
            .upToNextMinor(from: "0.8.0")
        ),
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "509.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-algorithms",
            .upToNextMinor(from: "1.2.0")
        ),
        .package(
            url: "https://github.com/kishikawakatsumi/KeychainAccess.git",
            .upToNextMinor(from: "4.2.0")
        ),
        .package(
            url: "https://github.com/apple/swift-async-algorithms",
            from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "CoreMacros",
                "KeychainAccess",
                .product(name: "Networking", package: "swiftynetworking"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
            ]
        ),
        .macro(
            name: "CoreMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        )
    ]
)
