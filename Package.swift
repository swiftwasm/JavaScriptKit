// swift-tools-version:5.8

import PackageDescription

// NOTE: needed for embedded customizations, ideally this will not be necessary at all in the future, or can be replaced with traits
let shouldBuildForEmbedded = Context.environment["JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM"].flatMap(Bool.init) ?? false

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
            resources: shouldBuildForEmbedded ? [] : [.copy("Runtime")],
            cSettings: shouldBuildForEmbedded ? [
                    .unsafeFlags(["-fdeclspec"])
                ] : nil,
            swiftSettings: shouldBuildForEmbedded 
                ? [
                    .enableExperimentalFeature("Embedded"),
                    .enableExperimentalFeature("Extern"),
                    .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"])
                ] : nil
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
        .testTarget(
            name: "JavaScriptEventLoopTests",
            dependencies: [
                "JavaScriptEventLoop",
                "JavaScriptKit",
                "JavaScriptEventLoopTestSupport",
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ]
        ),
        .target(name: "_CJavaScriptEventLoop"),
        .target(
            name: "JavaScriptEventLoopTestSupport",
            dependencies: [
                "_CJavaScriptEventLoopTestSupport",
                "JavaScriptEventLoop",
            ]
        ),
        .target(name: "_CJavaScriptEventLoopTestSupport"),
        .testTarget(
          name: "JavaScriptEventLoopTestSupportTests",
          dependencies: [
            "JavaScriptKit",
            "JavaScriptEventLoopTestSupport"
          ]
        ),
    ]
)
