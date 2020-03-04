// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    targets: [
        .target(
            name: "JavaScriptKitExample",
            dependencies: ["JavaScriptKit"]),
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"]),
        .target(
            name: "_CJavaScriptKit"),
        .testTarget(
            name: "JavaScriptKitTests",
            dependencies: ["JavaScriptKit"]),
    ]
)
