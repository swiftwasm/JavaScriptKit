// swift-tools-version:5.7

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
                "JavaScriptKit",
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit")
            ]
        )
    ]
)
