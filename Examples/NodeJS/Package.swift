// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "NodeJS",
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [
        .executableTarget(
            name: "NodeJS",
            dependencies: ["JavaScriptKit"]
        )
    ],
    swiftLanguageModes: [.v6]
)
