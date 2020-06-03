// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"])
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"]
        ),
        .target(name: "_CJavaScriptKit"),
        .testTarget(
            name: "JavaScriptKitTests",
            dependencies: ["JavaScriptKit"]
        )
    ]
)
