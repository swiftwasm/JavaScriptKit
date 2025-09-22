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
        .plugin(name: "PackageToJS", targets: ["PackageToJS"]),
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: [],
            exclude: useLegacyResourceBundling ? [] : ["Runtime"],
            resources: useLegacyResourceBundling ? [.copy("Runtime")] : [],
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
        .plugin(
            name: "PackageToJS",
            capability: .command(
                intent: .custom(verb: "js", description: "Convert a Swift package to a JavaScript package")
            ),
            path: "Plugins/PackageToJS/Sources"
        ),
    ]
)
