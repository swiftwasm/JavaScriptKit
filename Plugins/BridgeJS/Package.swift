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
        .target(name: "BridgeJSLink"),
        .executableTarget(
            name: "BridgeJSTool",
            dependencies: [
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftBasicFormat", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "BridgeJSToolTests",
            dependencies: ["BridgeJSTool", "BridgeJSLink"],
            exclude: ["__Snapshots__", "Inputs"]
        ),
    ]
)
