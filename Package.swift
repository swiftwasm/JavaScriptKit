// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"]),
        .library(name: "JavaScriptEventLoop", targets: ["JavaScriptEventLoop"]),
        .library(name: "JavaScriptBigIntSupport", targets: ["JavaScriptBigIntSupport"]),
        .library(name: "JavaScriptEventLoopTestSupport", targets: ["JavaScriptEventLoopTestSupport"]),
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"],
            resources: [.copy("Runtime")]
        ),
        .target(name: "_CJavaScriptKit"),
        .target(
            name: "JavaScriptBigIntSupport",
            dependencies: ["_CJavaScriptBigIntSupport", "JavaScriptKit"]
        ),
        .target(name: "_CJavaScriptBigIntSupport", dependencies: ["_CJavaScriptKit"]),
        .target(
            name: "JavaScriptEventLoop",
            dependencies: ["JavaScriptKit", "_CJavaScriptEventLoop"]
        ),
        .target(name: "_CJavaScriptEventLoop"),
        .target(
            name: "JavaScriptEventLoopTestSupport",
            dependencies: [
                "_CJavaScriptEventLoopTestSupport",
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ]
        ),
        .target(name: "_CJavaScriptEventLoopTestSupport"),
    ]
)
