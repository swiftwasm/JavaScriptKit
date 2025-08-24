// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BridgeJS",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.1")
    ],
    targets: [
        .target(name: "BridgeJSBuildPlugin"),
        .executableTarget(
            name: "BridgeJSTool",
            dependencies: [
                "BridgeJSCore",
                "TS2Skeleton",
            ]
        ),
        .target(
            name: "TS2Skeleton",
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
                "TS2Skeleton",
            ],
            exclude: ["__Snapshots__", "Inputs"]
        ),
    ]
)
