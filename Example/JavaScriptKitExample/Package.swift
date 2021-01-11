// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JavaScriptKitExample",
    products: [
        .executable(
            name: "JavaScriptKitExample", targets: ["JavaScriptKitExample"]
        ),
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .target(
            name: "JavaScriptKitExample",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
            ]
        ),
    ]
)
