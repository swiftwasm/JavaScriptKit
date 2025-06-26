// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Benchmarks",
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
