// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "TestSuites",
    platforms: [
        // This package doesn't work on macOS host, but should be able to be built for it
        // for developing on Xcode. This minimum version requirement is to prevent availability
        // errors for Concurrency API, whose runtime support is shipped from macOS 12.0
        .macOS("12.0")
    ],
    products: [
        .executable(
            name: "BenchmarkTests",
            targets: ["BenchmarkTests"]
        )
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .target(name: "CHelpers"),
        .executableTarget(name: "BenchmarkTests", dependencies: ["JavaScriptKit", "CHelpers"]),
    ]
)
