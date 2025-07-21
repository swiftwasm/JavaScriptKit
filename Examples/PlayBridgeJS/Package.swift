// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "PlayBridgeJS",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .executableTarget(
            name: "PlayBridgeJS",
            dependencies: [
                "JavaScriptKit",
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ]
        )
    ]
)
