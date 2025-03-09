// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "UseJSPackage",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .executableTarget(
            name: "UseJSPackage",
            dependencies: [
                "JavaScriptKit"
            ],
            exclude: ["bridge.d.ts"],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ],
            plugins: [
                .plugin(name: "BridgeJS", package: "JavaScriptKit")
            ]
        )
    ],
    swiftLanguageModes: [.v5]
)
