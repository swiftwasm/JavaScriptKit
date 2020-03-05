// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JavaScriptKitExec",
    products: [
        .executable(
            name: "JavaScriptKitExec", targets: ["JavaScriptKitExec"]
        ),
    ],
    dependencies: [.package(name: "JavaScriptKit", path: "../../")],
    targets: [.target(name: "JavaScriptKitExec", dependencies: ["JavaScriptKit"])]
)
