// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "TestSuites",
    products: [
        .executable(
            name: "TestSuites", targets: ["TestSuites"]
        ),
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [.target(name: "TestSuites", dependencies: ["JavaScriptKit"])]
)
