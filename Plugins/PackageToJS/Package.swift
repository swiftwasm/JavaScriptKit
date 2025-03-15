// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PackageToJS",
    platforms: [.macOS(.v13)],
    targets: [
        .target(name: "PackageToJS"),
        .testTarget(
            name: "PackageToJSTests",
            dependencies: ["PackageToJS"],
            exclude: ["__Snapshots__"]
        ),
    ]
)
