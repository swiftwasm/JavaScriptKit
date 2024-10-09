// swift-tools-version:5.7

import PackageDescription

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
        .testTarget(
            name: "JavaScriptEventLoopTests",
            dependencies: [
                "JavaScriptEventLoop",
                "JavaScriptKit",
                "JavaScriptEventLoopTestSupport",
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

// `resources` implicitly forces the package to link `Foundation` but
// we don't actually need it at runtime since the `resources` declaration
// is just for teaching carton how to bundle .js files into the package.
// For those who really want to avoid linking `Foundation` at all, you can
// set the `JAVASCRIPTKIT_NO_FOUNDATION` environment variable to any value
// before running `swift test` or `swift build` to skip the `resources` declaration.
import Foundation

if ProcessInfo.processInfo.environment["JAVASCRIPTKIT_NO_FOUNDATION"] != nil {
    for target in package.targets {
        target.resources = nil
    }
}
