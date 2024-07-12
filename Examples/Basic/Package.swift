// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "Basic",
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .executableTarget(
            name: "Basic",
            dependencies: [
                "JavaScriptKit",
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit")
            ]
        )
    ]
)
