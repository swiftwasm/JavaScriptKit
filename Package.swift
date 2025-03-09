// swift-tools-version:6.1

import CompilerPluginSupport
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
        .plugin(name: "BridgeJS", targets: ["BridgeJS"]),
        .plugin(name: "BridgeJSCommandPlugin", targets: ["BridgeJSCommandPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", "600.0.0"..<"601.0.0")
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
            path: "Plugins/BridgeJS/Sources/BridgeJSTool"
        ),
        .testTarget(
            name: "BridgeJSRuntimeTests",
            dependencies: ["JavaScriptKit"],
            exclude: ["Generated/JavaScript"],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ]
        ),
        .macro(
            name: "JavaScriptKitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
    ]
)
