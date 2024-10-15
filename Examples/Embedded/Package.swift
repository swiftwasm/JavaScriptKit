// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "Embedded",
    dependencies: [
        .package(name: "JavaScriptKit", path: "../../"),
        .package(url: "https://github.com/swiftwasm/swift-dlmalloc", branch: "0.1.0")
    ],
    targets: [
        .executableTarget(
            name: "EmbeddedApp",
            dependencies: [
                "JavaScriptKit",
                .product(name: "dlmalloc", package: "swift-dlmalloc")
            ],
            cSettings: [
                .unsafeFlags(["-fdeclspec"])
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .enableExperimentalFeature("Extern"),
                .unsafeFlags([
                    "-Xfrontend", "-gnone",
                    "-Xfrontend", "-disable-stack-protector",
                ]),
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-Xclang-linker", "-nostdlib",
                    "-Xlinker", "--no-entry"
                ])
            ]
        )
    ]
)