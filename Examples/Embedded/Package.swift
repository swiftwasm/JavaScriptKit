// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "Embedded",
    dependencies: [
        .package(name: "JavaScriptKit", path: "../../"),
        .package(url: "https://github.com/swifweb/EmbeddedFoundation", branch: "0.1.0")
    ],
    targets: [
        .executableTarget(
            name: "EmbeddedApp",
            dependencies: [
                "JavaScriptKit",
                .product(name: "Foundation", package: "EmbeddedFoundation")
            ]
        )
    ]
)
