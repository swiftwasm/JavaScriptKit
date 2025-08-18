// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [
        .macOS(.v11),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13),
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
