// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Counter",
    products: [
        .library(
            name: "Counter",
            targets: ["Counter"]),
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .target(
            name: "Counter",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ]),
        .testTarget(
            name: "CounterTests",
            dependencies: ["Counter"]
        ),
    ]
)
