// swift-tools-version:6.1

import CompilerPluginSupport
import PackageDescription

// NOTE: needed for embedded customizations, ideally this will not be necessary at all in the future, or can be replaced with traits
let shouldBuildForEmbedded = Context.environment["JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM"].flatMap(Bool.init) ?? false
let useLegacyResourceBundling =
    Context.environment["JAVASCRIPTKIT_USE_LEGACY_RESOURCE_BUNDLING"].flatMap(Bool.init) ?? false

let tracingTrait = Trait(
    name: "JavaScriptKitTracing",
    description: "Enable opt-in Swift <-> JavaScript bridge tracing hooks.",
    enabledTraits: []
)

let testingLinkerFlags: [LinkerSetting] = [
    .unsafeFlags([
        "-Xlinker", "--stack-first",
        "-Xlinker", "--global-base=524288",
        "-Xlinker", "-z",
        "-Xlinker", "stack-size=524288",
    ])
]

let package = Package(
    name: "JavaScriptKit",
    platforms: [
        .macOS(.v13),
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
    traits: [tracingTrait],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", "600.0.0"..<"603.0.0")
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit", "BridgeJSMacros"],
            exclude: useLegacyResourceBundling ? [] : ["Runtime"],
            resources: useLegacyResourceBundling ? [.copy("Runtime")] : [],
            cSettings: shouldBuildForEmbedded
                ? [
                    .unsafeFlags(["-fdeclspec"])
                ] : nil,
            swiftSettings: [
                .enableExperimentalFeature("Extern"),
                .define("JAVASCRIPTKIT_ENABLE_TRACING", .when(traits: ["JavaScriptKitTracing"])),
            ]
                + (shouldBuildForEmbedded
                    ? [
                        .enableExperimentalFeature("Embedded"),
                        .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"]),
                    ] : [])
        ),
        .target(name: "_CJavaScriptKit"),
        .macro(
            name: "BridgeJSMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        .testTarget(
            name: "JavaScriptKitTests",
            dependencies: ["JavaScriptKit"],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ],
            linkerSettings: testingLinkerFlags
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
            dependencies: ["JavaScriptBigIntSupport", "JavaScriptKit"],
            linkerSettings: testingLinkerFlags
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
            ],
            linkerSettings: testingLinkerFlags
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
            ],
            linkerSettings: testingLinkerFlags
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
            ],
            linkerSettings: testingLinkerFlags
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
            exclude: ["TS2Swift/JavaScript", "README.md"]
        ),
        .testTarget(
            name: "BridgeJSRuntimeTests",
            dependencies: ["JavaScriptKit", "JavaScriptEventLoop"],
            exclude: [
                "bridge-js.config.json",
                "bridge-js.d.ts",
                "bridge-js.global.d.ts",
                "Generated/JavaScript",
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ],
            linkerSettings: testingLinkerFlags
        ),
        .testTarget(
            name: "BridgeJSGlobalTests",
            dependencies: ["JavaScriptKit", "JavaScriptEventLoop"],
            exclude: [
                "bridge-js.config.json",
                "bridge-js.d.ts",
                "Generated/JavaScript",
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ],
            linkerSettings: testingLinkerFlags
        ),
    ]
)
