// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Counter",
    products: [
        .library(
            name: "Counter",
            targets: ["Counter"]
        )
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .target(
            name: "Counter",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ]
        ),
        .testTarget(
            name: "CounterTests",
            dependencies: [
                "Counter",
                // This is needed to run the tests in the JavaScript event loop
                .product(name: "JavaScriptEventLoopTestSupport", package: "JavaScriptKit"),
            ]
        ),
    ]
)
