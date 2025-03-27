// swift-tools-version:6.0

import PackageDescription

// NOTE: needed for embedded customizations, ideally this will not be necessary at all in the future, or can be replaced with traits
let shouldBuildForEmbedded = Context.environment["JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM"].flatMap(Bool.init) ?? false
let useLegacyResourceBundling =
    Context.environment["JAVASCRIPTKIT_USE_LEGACY_RESOURCE_BUNDLING"].flatMap(Bool.init) ?? false

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"]),
        .library(name: "JavaScriptEventLoop", targets: ["JavaScriptEventLoop"]),
        .library(name: "JavaScriptBigIntSupport", targets: ["JavaScriptBigIntSupport"]),
        .library(name: "JavaScriptEventLoopTestSupport", targets: ["JavaScriptEventLoopTestSupport"]),
        .plugin(name: "PackageToJS", targets: ["PackageToJS"]),
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"],
            exclude: useLegacyResourceBundling ? [] : ["Runtime"],
            resources: useLegacyResourceBundling ? [.copy("Runtime")] : [],
            cSettings: shouldBuildForEmbedded
                ? [
                    .unsafeFlags(["-fdeclspec"])
                ] : nil,
            swiftSettings: shouldBuildForEmbedded
                ? [
                    .enableExperimentalFeature("Embedded"),
                    .enableExperimentalFeature("Extern"),
                    .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"]),
                ] : nil
        ),
        .target(name: "_CJavaScriptKit"),
        .testTarget(
            name: "JavaScriptKitTests",
            dependencies: ["JavaScriptKit"],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ]
        ),

        .target(
            name: "JavaScriptBigIntSupport",
            dependencies: ["_CJavaScriptBigIntSupport", "JavaScriptKit"],
            swiftSettings: shouldBuildForEmbedded
                ? [
                    .enableExperimentalFeature("Embedded"),
                    .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"]),
                ] : []
        ),
        .target(name: "_CJavaScriptBigIntSupport", dependencies: ["_CJavaScriptKit"]),
        .testTarget(
            name: "JavaScriptBigIntSupportTests",
            dependencies: ["JavaScriptBigIntSupport", "JavaScriptKit"]
        ),

        .target(
            name: "JavaScriptEventLoop",
            dependencies: ["JavaScriptKit", "_CJavaScriptEventLoop"],
            swiftSettings: shouldBuildForEmbedded
                ? [
                    .enableExperimentalFeature("Embedded"),
                    .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"]),
                ] : []
        ),
        .target(name: "_CJavaScriptEventLoop"),
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
                "JavaScriptEventLoopTestSupport",
            ]
        ),
        .plugin(
            name: "PackageToJS",
            capability: .command(
                intent: .custom(verb: "js", description: "Convert a Swift package to a JavaScript package")
            ),
            sources: ["Sources"]
        ),
    ]
)
