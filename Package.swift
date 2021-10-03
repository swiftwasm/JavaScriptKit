// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    platforms: [
        // This package doesn't work on macOS host, but should be able to be built for it
        // for developing on Xcode. This minimum version requirement is to prevent availability
        // errors for Concurrency API, whose runtime support is shipped from macOS 12.0
        .macOS("12.0")
    ],
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"]),
        .library(name: "JavaScriptEventLoop", targets: ["JavaScriptEventLoop"]),
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"]
        ),
        .target(name: "_CJavaScriptKit"),
        .target(
            name: "JavaScriptEventLoop",
            dependencies: ["JavaScriptKit", "_CJavaScriptEventLoop"]
        ),
        .target(name: "_CJavaScriptEventLoop"),
    ]
)
