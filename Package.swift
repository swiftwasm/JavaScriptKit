// swift-tools-version:6.0

import CompilerPluginSupport
import PackageDescription

// NOTE: needed for embedded customizations, ideally this will not be necessary at all in the future, or can be replaced with traits
let shouldBuildForEmbedded = Context.environment["JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM"].flatMap(Bool.init) ?? false
let useLegacyResourceBundling =
    Context.environment["JAVASCRIPTKIT_USE_LEGACY_RESOURCE_BUNDLING"].flatMap(Bool.init) ?? false

let package = Package(
    name: "JavaScriptKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13),
    ],
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"]),
        .library(name: "JavaScriptEventLoop", targets: ["JavaScriptEventLoop"]),
        .library(name: "JavaScriptBigIntSupport", targets: ["JavaScriptBigIntSupport"]),
        .library(name: "JavaScriptFoundationCompat", targets: ["JavaScriptFoundationCompat"]),
        .library(name: "JavaScriptEventLoopTestSupport", targets: ["JavaScriptEventLoopTestSupport"]),
        .plugin(name: "PackageToJS", targets: ["PackageToJS"]),
        .plugin(name: "BridgeJS", targets: ["BridgeJS"]),
        .plugin(name: "BridgeJSCommandPlugin", targets: ["BridgeJSCommandPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", "600.0.0"..<"601.0.0")
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
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ]
                + (shouldBuildForEmbedded
                    ? [
                        .enableExperimentalFeature("Embedded"),
                        .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"]),
                    ] : [])
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
        .target(
            name: "JavaScriptFoundationCompat",
            dependencies: [
                "JavaScriptKit"
            ]
        ),
        .testTarget(
            name: "JavaScriptFoundationCompatTests",
            dependencies: [
                "JavaScriptFoundationCompat"
            ]
        ),
        .plugin(
            name: "PackageToJS",
            capability: .command(
                intent: .custom(verb: "js", description: "Convert a Swift package to a JavaScript package")
            ),
            path: "Plugins/PackageToJS/Sources"
        ),
        .plugin(
            name: "BridgeJS",
            capability: .buildTool(),
            dependencies: ["BridgeJSTool"],
            path: "Plugins/BridgeJS/Sources/BridgeJSBuildPlugin"
        ),
        .plugin(
            name: "BridgeJSCommandPlugin",
            capability: .command(
                intent: .custom(verb: "bridge-js", description: "Generate bridging code"),
                permissions: [.writeToPackageDirectory(reason: "Generate bridging code")]
            ),
            dependencies: ["BridgeJSTool"],
            path: "Plugins/BridgeJS/Sources/BridgeJSCommandPlugin"
        ),
        .executableTarget(
            name: "BridgeJSTool",
            dependencies: [
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftBasicFormat", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ],
            exclude: ["TS2Skeleton/JavaScript"]
        ),
        .testTarget(
            name: "BridgeJSRuntimeTests",
            dependencies: ["JavaScriptKit"],
            exclude: [
                "bridge-js.config.json",
                "bridge-js.d.ts",
                "Generated/JavaScript",
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ]
        ),
    ]
)
