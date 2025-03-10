// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BridgeJS",
    platforms: [.macOS(.v13)],
    targets: [
        .target(name: "BridgeJS"),
        .testTarget(name: "BridgeJSTests", dependencies: ["BridgeJS"]),
    ]
)
