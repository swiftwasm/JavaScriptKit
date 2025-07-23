// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "PlayBridgeJS",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(name: "JavaScriptKit", path: "../../"),
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.1"),
    ],
    targets: [
        .executableTarget(
            name: "PlayBridgeJS",
            dependencies: [
                "JavaScriptKit",
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftBasicFormat", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ],
            exclude: [
                "bridge-js.d.ts",
                "bridge-js.config.json",
                "Generated/JavaScript",
            ],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ],
            linkerSettings: [
                .unsafeFlags(
                    [
                        "-Xlinker", "--stack-first",
                        "-Xlinker", "--global-base=524288",
                        "-Xlinker", "-z", "-Xlinker", "stack-size=524288",
                    ],
                    .when(platforms: [.wasi])
                )
            ]
        )
    ]
)
