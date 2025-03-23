// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Example",
    platforms: [.macOS("15"), .iOS("18"), .watchOS("11"), .tvOS("18"), .visionOS("2")],
    dependencies: [
        .package(path: "../../"),
        .package(
            url: "https://github.com/kateinoigakukun/chibi-ray",
            revision: "c8cab621a3338dd2f8e817d3785362409d3b8cf1"
        ),
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
                .product(name: "ChibiRay", package: "chibi-ray"),
            ]
        )
    ]
)
