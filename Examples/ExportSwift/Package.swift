// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: [
                "JavaScriptKit"
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ],
            plugins: [
                .plugin(name: "BridgeJS", package: "JavaScriptKit")
            ]
        )
    ]
)
