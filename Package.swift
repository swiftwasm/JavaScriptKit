// swift-tools-version:5.10

import PackageDescription

let embeddedSwiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("Embedded"),
    .interoperabilityMode(.Cxx),
    .unsafeFlags([
        "-wmo", "-disable-cmo",
        "-Xfrontend", "-gnone",
        "-Xfrontend", "-disable-stack-protector",
        "-Xfrontend", "-emit-empty-object-file"
    ])
]

let embeddedCSettings: [CSetting] = [
    .unsafeFlags(["-fdeclspec"])
]

let linkerSettings: [LinkerSetting] = [
    .unsafeFlags([
        "-Xclang-linker", "-nostdlib",
        "-Xlinker", "--no-entry"
    ])
]

let libcSettings: [CSetting] = [
    .define("LACKS_TIME_H"),
    .define("LACKS_SYS_TYPES_H"),
    .define("LACKS_STDLIB_H"),
    .define("LACKS_STRING_H"),
    .define("LACKS_SYS_MMAN_H"),
    .define("LACKS_FCNTL_H"),
    .define("NO_MALLOC_STATS", to: "1"),
    .define("__wasilibc_unmodified_upstream"),
]

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"]),
        .library(name: "JavaScriptEventLoop", targets: ["JavaScriptEventLoop"]),
        .library(name: "JavaScriptBigIntSupport", targets: ["JavaScriptBigIntSupport"]),
        .library(name: "JavaScriptEventLoopTestSupport", targets: ["JavaScriptEventLoopTestSupport"]),
        // Embedded
        .library(name: "JavaScriptKitEmbedded", targets: ["JavaScriptKitEmbedded"]),
        .library(name: "JavaScriptEventLoopEmbedded", targets: ["JavaScriptEventLoopEmbedded"]),
        .library(name: "JavaScriptBigIntSupportEmbedded", targets: ["JavaScriptBigIntSupportEmbedded"]),
        .library(name: "JavaScriptEventLoopTestSupportEmbedded", targets: ["JavaScriptEventLoopTestSupportEmbedded"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swifweb/String16", branch: "0.1.0")
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"],
            resources: [.copy("Runtime")]
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
        // Embedded
        .target(
            name: "JavaScriptKitEmbedded",
            dependencies: [
                "_CJavaScriptKitEmbedded",
                .product(name: "String16", package: "String16")
            ],
//            resources: [.copy("Runtime")], // FIXME: doesn't work with embedded because trying to import Foundation
            cSettings: embeddedCSettings,
            swiftSettings: embeddedSwiftSettings,
            linkerSettings: linkerSettings
        ),
        .target(
            name: "_CJavaScriptKitEmbedded",
            cSettings: libcSettings
        ),
        .target(
            name: "JavaScriptBigIntSupportEmbedded",
            dependencies: ["_CJavaScriptBigIntSupportEmbedded", "JavaScriptKitEmbedded"],
            cSettings: embeddedCSettings,
            swiftSettings: embeddedSwiftSettings,
            linkerSettings: linkerSettings
        ),
        .target(
            name: "_CJavaScriptBigIntSupportEmbedded",
            dependencies: ["_CJavaScriptKitEmbedded"],
            cSettings: libcSettings
        ),
        .target(
            name: "JavaScriptEventLoopEmbedded",
            dependencies: ["JavaScriptKitEmbedded", "_CJavaScriptEventLoopEmbedded"],
            cSettings: embeddedCSettings,
            swiftSettings: embeddedSwiftSettings,
            linkerSettings: linkerSettings
        ),
        .target(
            name: "_CJavaScriptEventLoopEmbedded",
            cSettings: libcSettings
        ),
        .target(
            name: "JavaScriptEventLoopTestSupportEmbedded",
            dependencies: [
                "_CJavaScriptEventLoopTestSupportEmbedded",
                "JavaScriptEventLoopEmbedded",
            ],
            cSettings: embeddedCSettings,
            swiftSettings: embeddedSwiftSettings,
            linkerSettings: linkerSettings
        ),
        .target(
            name: "_CJavaScriptEventLoopTestSupportEmbedded",
            cSettings: libcSettings
        ),
    ]
)
