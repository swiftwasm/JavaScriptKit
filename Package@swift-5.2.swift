// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/PureSwift/SwiftFoundation.git", .branch("develop"))
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: [
                "_CJavaScriptKit",
                "SwiftFoundation"
            ]
        ),
        .target(name: "_CJavaScriptKit"),
        .testTarget(
            name: "JavaScriptKitTests",
            dependencies: ["JavaScriptKit"]
        )
    ]
)
