// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ImportTS",
    platforms: [.macOS(.v13)],
    targets: [
        .target(name: "ImportTS"),
        .testTarget(name: "ImportTSTests", dependencies: ["ImportTS"]),
    ]
)
