// swift-tools-version:6.1

import PackageDescription

// NOTE: needed for embedded customizations, ideally this will not be necessary at all in the future, or can be replaced with traits
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
    traits: [
        "Embedded"
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"],
            exclude: useLegacyResourceBundling ? [] : ["Runtime"],
            resources: useLegacyResourceBundling ? [.copy("Runtime")] : [],
            cSettings: [
                .unsafeFlags(["-fdeclspec"], .when(traits: ["Embedded"]))
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded", .when(traits: ["Embedded"])),
                .enableExperimentalFeature("Extern", .when(traits: ["Embedded"])),
                .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"], .when(traits: ["Embedded"])),
            ]
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
            swiftSettings: [
                .enableExperimentalFeature("Embedded", .when(traits: ["Embedded"])),
                .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"], .when(traits: ["Embedded"])),
            ]
        ),
        .target(name: "_CJavaScriptBigIntSupport", dependencies: ["_CJavaScriptKit"]),
        .testTarget(
            name: "JavaScriptBigIntSupportTests",
            dependencies: ["JavaScriptBigIntSupport", "JavaScriptKit"]
        ),

        .target(
            name: "JavaScriptEventLoop",
            dependencies: ["JavaScriptKit", "_CJavaScriptEventLoop"],
            swiftSettings: [
                .enableExperimentalFeature("Embedded", .when(traits: ["Embedded"])),
                .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"], .when(traits: ["Embedded"])),
            ]
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
