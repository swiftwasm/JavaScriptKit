// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PackageToJS",
    targets: [
        .target(name: "PackageToJS"),
        .testTarget(name: "PackageToJSTests", dependencies: ["PackageToJS"]),
    ]
)
