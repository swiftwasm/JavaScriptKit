// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Basic",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .executableTarget(
            name: "Basic",
            dependencies: [
                "JavaScriptKit",
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
