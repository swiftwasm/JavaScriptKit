// swift-tools-version: 6.0

import PackageDescription

let coreDependencies: [Target.Dependency] = [
    .product(name: "SwiftParser", package: "swift-syntax"),
    .product(name: "SwiftSyntax", package: "swift-syntax"),
    .product(name: "SwiftBasicFormat", package: "swift-syntax"),
    .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
]

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
            dependencies: coreDependencies
        ),
        .testTarget(
            name: "BridgeJSToolTests",
            dependencies: coreDependencies,
            exclude: ["__Snapshots__", "Inputs"]
        ),
    ]
)
