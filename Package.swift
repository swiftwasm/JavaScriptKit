// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "JavaScriptKit",
    products: [
        .library(name: "JavaScriptKit", targets: ["JavaScriptKit"]),
        .library(name: "JavaScriptEventLoop", targets: ["JavaScriptEventLoop"]),
    ],
    targets: [
        .target(
            name: "JavaScriptKit",
            dependencies: ["_CJavaScriptKit"]
        ),
        .target(
            name: "JavaScriptEventLoop",
            dependencies: ["JavaScriptKit", "_CJavaScriptEventLoop"],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
            ]
        ),
        .target(name: "_CJavaScriptKit"),
        .target(
            name: "_CJavaScriptEventLoop",
            dependencies: ["_CJavaScriptKit"],
            exclude: [
                "README", "LICENSE-llvm", "LICENSE-swift",
                "include/swift/ABI/MetadataKind.def",
                "include/swift/ABI/ValueWitness.def",
                "include/swift/AST/ReferenceStorage.def",
                "include/swift/Demangling/DemangleNodes.def",
                "include/swift/Demangling/ValueWitnessMangling.def",
            ],
            linkerSettings: [
                .linkedLibrary("swift_Concurrency", .when(platforms: [.wasi])),
            ]
        ),
    ],
    cxxLanguageStandard: .cxx14
)
