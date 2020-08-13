// swift-tools-version:5.3

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
            linkerSettings: [
                .unsafeFlags(
                    [
                        "-Xlinker",
                        "--export=swjs_call_host_function",
                        "-Xlinker",
                        "--export=swjs_prepare_host_function_call",
                        "-Xlinker",
                        "--export=swjs_cleanup_host_function_call",
                        "-Xlinker",
                        "--export=swjs_library_version",
                    ],
                    .when(platforms: [.wasi])
                ),
            ]
        ),
        .target(
            name: "_CJavaScriptKit",
            linkerSettings: [
                .unsafeFlags(
                    [
                        "-Xlinker",
                        "--allow-undefined",
                    ],
                    .when(platforms: [.wasi])
                ),
            ]
        )
    ]
)
