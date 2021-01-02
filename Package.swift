// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"]),
        .library(name: "JavaScriptEventLoop", targets: ["JavaScriptEventLoop"]),
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"]
        ),
        .target(
            name: "JavaScriptEventLoop",
            dependencies: ["JavaScriptKit", "_CJavaScriptEventLoop"],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
            ]
        ),
        .target(name: "_CJavaScriptKit"),
        .target(
            name: "_CJavaScriptEventLoop",
            dependencies: ["_CJavaScriptKit"],
            linkerSettings: [
                .linkedLibrary("swift_Concurrency", .when(platforms: [.wasi])),
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
