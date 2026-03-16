// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "EmbeddedConcurrency",
    dependencies: [
        .package(name: "JavaScriptKit", path: "../../")
    ],
    targets: [
        .executableTarget(
            name: "EmbeddedConcurrencyApp",
            dependencies: [
                "JavaScriptKit",
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern"),
                .swiftLanguageMode(.v5),
            ]
        )
    ]
)
