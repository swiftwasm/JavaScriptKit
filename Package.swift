// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"]),
        .library(name: "JavaScriptEventLoop", targets: ["JavaScriptEventLoop"]),
        .library(name: "JavaScriptKit_I64", targets: ["JavaScriptKit_I64"]),
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"]
        ),
        .target(name: "_CJavaScriptKit"),
        .target(
            name: "JavaScriptKit_I64",
            dependencies: ["_CJavaScriptKit_I64", "JavaScriptKit"]
        ),
        .target(name: "_CJavaScriptKit_I64", dependencies: ["_CJavaScriptKit"]),
        .target(
            name: "JavaScriptEventLoop",
            dependencies: ["JavaScriptKit", "_CJavaScriptEventLoop"]
        ),
        .target(name: "_CJavaScriptEventLoop"),
    ]
)
