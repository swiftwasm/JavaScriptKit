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
            dependencies: ["_CJavaScriptKit"],
            linkerSettings: [
              .unsafeFlags([
                "-Xlinker",
                "--export=swjs_call_host_function",
                "-Xlinker",
                "--export=swjs_prepare_host_function_call"
              ])
            ]),
        .target(
            name: "_CJavaScriptKit",
            linkerSettings: [
              .unsafeFlags([
                "-Xlinker",
                "--allow-undefined",
              ])
            ]),
        .testTarget(
            name: "JavaScriptKitTests",
            dependencies: ["JavaScriptKit"]),
    ]
)
