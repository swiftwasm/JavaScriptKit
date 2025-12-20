# Exporting Swift to JavaScript

Learn how to make your Swift code callable from JavaScript.

## Overview

> Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS allows you to expose Swift functions, classes, and methods to JavaScript by using the `@JS` attribute. This enables JavaScript code to call into Swift code running in WebAssembly.

## Configuring the BridgeJS plugin

To use the BridgeJS feature, you need to enable the experimental `Extern` feature and add the BridgeJS plugin to your package. Here's an example of a `Package.swift` file:

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
                // This is required because the generated code depends on @_extern(wasm)
                .enableExperimentalFeature("Extern")
            ],
            plugins: [
                // Add build plugin for processing @JS and generate Swift glue code
                .plugin(name: "BridgeJS", package: "JavaScriptKit")
            ]
        )
    ]
)
```

The `BridgeJS` plugin will process your Swift code to find declarations marked with `@JS` and generate the necessary bridge code to make them accessible from JavaScript.

### Building your package for JavaScript

After configuring your `Package.swift`, you can build your package for JavaScript using the following command:

```bash
swift package --swift-sdk $SWIFT_SDK_ID js
```

This command will:

1. Process all Swift files with `@JS` annotations
2. Generate JavaScript bindings and TypeScript type definitions (`.d.ts`) for your exported Swift code
3. Output everything to the `.build/plugins/PackageToJS/outputs/` directory

> Note: For larger projects, you may want to generate the BridgeJS code ahead of time to improve build performance. See <doc:Ahead-of-Time-Code-Generation> for more information.



## Topics

- <doc:Exporting-Swift-Function>
- <doc:Exporting-Swift-Class>
- <doc:Exporting-Swift-Struct>
- <doc:Exporting-Swift-Enum>
- <doc:Exporting-Swift-Closure>
- <doc:Exporting-Swift-Protocols>
- <doc:Exporting-Swift-Optional>
- <doc:Exporting-Swift-Default-Parameters>
- <doc:Exporting-Swift-Static-Functions>
- <doc:Exporting-Swift-Static-Properties>
- <doc:Using-Namespace>
