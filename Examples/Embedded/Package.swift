// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Embedded",
    dependencies: [
        .package(name: "JavaScriptKit", path: "../../")
    ],
    targets: [
        .executableTarget(
            name: "EmbeddedApp",
            dependencies: [
                "JavaScriptKit"
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern"),
            ],
        )
    ],
    swiftLanguageModes: [.v5]
)
