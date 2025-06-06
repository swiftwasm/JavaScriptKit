// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Check",
    dependencies: [.package(name: "JavaScriptKit", path: "../../../../../")],
    targets: [
        .testTarget(
            name: "CheckTests",
            dependencies: [
                "JavaScriptKit",
                .product(name: "JavaScriptEventLoopTestSupport", package: "JavaScriptKit"),
            ],
            path: "Tests"
        )
    ]
)
