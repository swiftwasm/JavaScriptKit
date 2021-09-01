// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "TestSuites",
    products: [
        .executable(
            name: "PrimaryTests", targets: ["PrimaryTests"]
        ),
        .executable(
            name: "BenchmarkTests", targets: ["BenchmarkTests"]
        ),
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .target(name: "PrimaryTests", dependencies: ["JavaScriptKit"]),
        .target(
            name: "ConcurrencyTests",
            dependencies: [
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ]
        ),
        .target(name: "BenchmarkTests", dependencies: ["JavaScriptKit"]),
    ]
)
