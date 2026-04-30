// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "MultiModule",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "JavaScriptKit"
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ],
            plugins: [
                .plugin(name: "BridgeJS", package: "JavaScriptKit")
            ]
        ),
        .executableTarget(
            name: "MultiModule",
            dependencies: [
                "Core",
                "JavaScriptKit",
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ],
            plugins: [
                .plugin(name: "BridgeJS", package: "JavaScriptKit")
            ]
        ),
    ]
)
