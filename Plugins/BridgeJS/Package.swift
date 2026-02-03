// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

let swiftSyntaxVersion = Context.environment["BRIDGEJS_OVERRIDE_SWIFT_SYNTAX_VERSION"] ?? "600.0.1"

let package = Package(
    name: "BridgeJS",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: Version(swiftSyntaxVersion)!),
        // Development dependencies
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.7.0"),
    ],
    targets: [
        .target(name: "BridgeJSBuildPlugin"),
        .executableTarget(
            name: "BridgeJSTool",
            dependencies: [
                "BridgeJSCore",
                "TS2Swift",
            ]
        ),
        .target(
            name: "TS2Swift",
            dependencies: [
                "BridgeJSCore",
                "BridgeJSSkeleton",
            ],
            exclude: ["JavaScript"]
        ),
        .target(
            name: "BridgeJSCore",
            dependencies: [
                "BridgeJSSkeleton",
                "BridgeJSUtilities",
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftBasicFormat", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),
        .target(name: "BridgeJSSkeleton"),
        .target(name: "BridgeJSUtilities"),

        .target(
            name: "BridgeJSLink",
            dependencies: [
                "BridgeJSSkeleton",
                "BridgeJSUtilities",
            ]
        ),

        .testTarget(
            name: "BridgeJSToolTests",
            dependencies: [
                "BridgeJSCore",
                "BridgeJSLink",
                "TS2Swift",
            ],
            exclude: ["__Snapshots__", "Inputs", "MultifileInputs", "ImportMacroInputs"]
        ),
        .macro(
            name: "BridgeJSMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "BridgeJSMacrosTests",
            dependencies: [
                "BridgeJSMacros",
                .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
            ]
        ),

        .executableTarget(
            name: "BridgeJSToolInternal",
            dependencies: [
                "BridgeJSCore",
                "BridgeJSLink",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
