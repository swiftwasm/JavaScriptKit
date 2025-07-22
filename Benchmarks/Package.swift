// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Benchmarks",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13),
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "Benchmarks",
            dependencies: [
                "JavaScriptKit",
                .product(name: "JavaScriptFoundationCompat", package: "JavaScriptKit"),
            ],
            exclude: ["Generated/JavaScript", "bridge-js.d.ts"],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ]
        )
    ]
)
