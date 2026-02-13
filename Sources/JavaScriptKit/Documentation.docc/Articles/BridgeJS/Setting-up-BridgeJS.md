# Setting up BridgeJS

Package and build setup required for all BridgeJS workflows

## Overview

BridgeJS requires the JavaScriptKit package dependency, the experimental `Extern` Swift feature, and the BridgeJS build plugin. The same configuration applies whether you are exporting Swift to JavaScript, importing JavaScript into Swift with macros, and generating bindings from a TypeScript file.

## Package.swift

Add the JavaScriptKit dependency, enable the Extern feature on the target that uses BridgeJS, and register the BridgeJS plugin:

```swift
// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: ["JavaScriptKit"],
            swiftSettings: [
                .enableExperimentalFeature("Extern")
            ],
            plugins: [
                .plugin(name: "BridgeJS", package: "JavaScriptKit")
            ]
        )
    ]
)
```

- **Dependency**: The target must depend on `"JavaScriptKit"`.
- **Extern feature**: Required because the generated bridge code uses `@_extern(wasm)`.
- **BridgeJS plugin**: Processes macro annotations to generate glue code and, [when present, `bridge-js.d.ts`; generates JS binding Swift code](<doc:Generating-from-TypeScript>).

## Build command

Build the package for the JavaScript/WebAssembly SDK:

```bash
swift package --swift-sdk $SWIFT_SDK_ID js
```

This command:

1. Runs the BridgeJS plugin
2. Compiles Swift to WebAssembly and generates JavaScript glue and TypeScript type definitions.
3. Writes output to `.build/plugins/PackageToJS/outputs/Package/`.

For package layout and how to consume the output from JavaScript, see <doc:Package-Output-Structure>.

## Larger projects

The build plugin runs on every build. For larger projects, generating bridge code ahead of time can improve build performance. See <doc:Ahead-of-Time-Code-Generation>.
