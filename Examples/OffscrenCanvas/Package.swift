// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Example",
    platforms: [.macOS("15"), .iOS("18"), .watchOS("11"), .tvOS("18"), .visionOS("2")],
    dependencies: [
        .package(path: "../../")
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern"),
            ],
            plugins: [
                .plugin(name: "BridgeJS", package: "JavaScriptKit"),
            ]
        )
    ]
)
