// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/PureSwift/SwiftFoundation.git", .branch("feature/swift5"))
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: [
                "_CJavaScriptKit",
                "SwiftFoundation"
            ],
            linkerSettings: [
                .unsafeFlags(
                    [
                        "-Xlinker",
                        "--export=swjs_call_host_function",
                        "-Xlinker",
                        "--export=swjs_prepare_host_function_call",
                        "-Xlinker",
                        "--export=swjs_cleanup_host_function_call"
                    ],
                    .when(platforms: [.wasi])
                )
            ]),
        .target(
            name: "_CJavaScriptKit",
            linkerSettings: [
                .unsafeFlags(
                    [
                        "-Xlinker",
                        "--allow-undefined",
                    ],
                    .when(platforms: [.wasi])
                )
            ]),
        .testTarget(
            name: "JavaScriptKitTests",
            dependencies: ["JavaScriptKit"]),
    ]
)
