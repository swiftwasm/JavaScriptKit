# Ahead-of-Time Code Generation with BridgeJS

Learn how to improve build times by generating BridgeJS code ahead of time.

## Overview

> Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.

The BridgeJS build plugin automatically processes macro annotations and TypeScript definitions during each build. While convenient, this can significantly increase build times for larger projects. To address this, JavaScriptKit provides a command plugin that lets you generate the bridge code ahead of time.

## Using the Command Plugin

The `swift package plugin bridge-js` command provides an alternative to the build plugin approach. By generating code once and committing it to your repository, you can:

1. **Reduce build times**: Skip code generation during normal builds
2. **Inspect generated code**: Review and version control the generated Swift code
3. **Create reproducible builds**: Ensure consistent builds across different environments

### Step 1: Configure Your Package

Configure your package to use JavaScriptKit, but without including the BridgeJS build plugin:

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
                // Still required for the generated code
                .enableExperimentalFeature("Extern")
            ]
            // Notice we DON'T include the BridgeJS build plugin here
        )
    ]
)
```

### Step 2: Create BridgeJS Configuration

Create a `bridge-js.config.json` file in your SwiftPM target directory you want to use BridgeJS.

```console
$ echo "{}" > Sources/MyApp/bridge-js.config.json
```

### Step 3: Create Your Swift Code with @JS Annotations

Write your Swift code with macro annotations as usual:

```swift
import JavaScriptKit

@JS public func calculateTotal(price: Double, quantity: Int) -> Double {
    return price * Double(quantity)
}

@JS class Counter {
    private var count = 0

    @JS init() {}

    @JS func increment() {
        count += 1
    }

    @JS func getValue() -> Int {
        return count
    }
}
```

### Step 4: Create Your TypeScript Definitions

If you're importing JavaScript APIs, create your `bridge-js.d.ts` file as usual:

```typescript
// Sources/MyApp/bridge-js.d.ts
export function consoleLog(message: string): void;

export interface Document {
    title: string;
    getElementById(id: string): HTMLElement;
}

export function getDocument(): Document;
```

### Step 5: Generate the Bridge Code

Run the command plugin to generate the bridge code:

```bash
swift package plugin bridge-js
```

This command will:

1. Process all Swift files with macro annotations
2. Process any TypeScript definition files
3. Generate Swift binding code in a `Generated` directory within your source folder

For example, with a target named "MyApp", it will create:

```
Sources/MyApp/Generated/BridgeJS.swift            # Glue code for both exports and imports
Sources/MyApp/Generated/BridgeJS.Macros.swift     # Bridging interface generated from bridge-js.d.ts
Sources/MyApp/Generated/JavaScript/BridgeJS.json  # Unified skeleton JSON
```

### Step 6: Add Generated Files to Version Control

Add these generated files to your version control system:

```bash
git add Sources/MyApp/Generated
git commit -m "Add generated BridgeJS code"
```

### Step 7: Build Your Package

Now you can build your package as usual:

```bash
swift package --swift-sdk $SWIFT_SDK_ID js
```

Since the bridge code is already generated, the build will be faster.

## Options for Selective Code Generation

The command plugin supports targeting specific modules in your package:

```bash
# Generate bridge code only for the specified target
swift package plugin bridge-js --target MyApp
```

## Updating Generated Code

When you change your Swift code or TypeScript definitions, you'll need to regenerate the bridge code:

```bash
# Regenerate bridge code
swift package plugin bridge-js
git add Sources/MyApp/Generated
git commit -m "Update generated BridgeJS code"
```

## When to Use Each Approach

**Use the build plugin** when:
- You're developing a small project or prototype
- You frequently change your API boundaries
- You want the simplest setup

**Use the command plugin** when:
- You're developing a larger project
- Build time is a concern
- You want to inspect and version control the generated code
- You're working in a team and want to ensure consistent builds

## Best Practices

1. **Consistency**: Choose either the build plugin or the command plugin approach for your project
2. **Version Control**: Always commit the generated files if using the command plugin
3. **API Boundaries**: Try to stabilize your API boundaries to minimize regeneration
4. **Documentation**: Document your approach in your project README
5. **CI/CD**: If using the command plugin, consider verifying that generated code is up-to-date in CI
