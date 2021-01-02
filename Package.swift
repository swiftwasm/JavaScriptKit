// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"]),
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
            ]
        ),
        .target(
            name: "JavaScriptEventLoop",
            dependencies: ["JavaScriptKit", "_CJavaScriptEventLoop"]
        ),
        .target(name: "_CJavaScriptKit"),
        .target(
            name: "_CJavaScriptEventLoop",
            dependencies: ["_CJavaScriptKit"],
            linkerSettings: [
                .linkedLibrary("swift_Concurrency"),
            ]
        ),
        .target(
            name: "_CJavaScriptEventLoopPrototype",
            linkerSettings: [
                .linkedLibrary("swift_Concurrency"),
            ]
        ),
    ]
)
