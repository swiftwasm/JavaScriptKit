// swift-tools-version: 6.0
import PackageDescription

// PackageToJS adds these itself, except for Embedded builds.
let reactorLinkerSettings: [LinkerSetting] = [
    .unsafeFlags(
        ["-Xclang-linker", "-mexec-model=reactor", "-Xlinker", "--export-if-defined=__main_argc_argv"],
        .when(platforms: [.wasi])
    )
]

let package = Package(
    name: "WASIShimCheck",
    dependencies: [.package(name: "JavaScriptKit", path: "../../../../")],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                "JavaScriptKit",
                .product(name: "JavaScriptWASIShim", package: "JavaScriptKit"),
            ],
            linkerSettings: reactorLinkerSettings
        ),
        .executableTarget(
            name: "ReturnsApp",
            dependencies: [
                .product(name: "JavaScriptWASIShim", package: "JavaScriptKit")
            ],
            linkerSettings: reactorLinkerSettings
        ),
    ]
)
