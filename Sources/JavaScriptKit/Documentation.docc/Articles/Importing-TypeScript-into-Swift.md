# Importing TypeScript into Swift

Learn how to leverage TypeScript definitions to create type-safe bindings for JavaScript APIs in your Swift code.

## Overview

> Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.

BridgeJS enables seamless integration between Swift and JavaScript by automatically generating Swift bindings from TypeScript declaration files (`.d.ts`). This provides type-safe access to JavaScript APIs directly from your Swift code.

The key benefits of this approach over `@dynamicMemberLookup`-based APIs include:

- **Type Safety**: Catch errors at compile-time rather than runtime
- **IDE Support**: Get autocompletion and documentation in your Swift editor
- **Performance**: Eliminating dynamism allows us to optimize the glue code

If you prefer keeping your project simple, you can continue using `@dynamicMemberLookup`-based APIs.

## Getting Started

### Step 1: Configure Your Package

First, add the BridgeJS plugin to your Swift package by modifying your `Package.swift` file:

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

### Step 2: Create TypeScript Definitions

Create a file named `bridge-js.d.ts` in your target source directory (e.g. `Sources/<target-name>/bridge-js.d.ts`). This file defines the JavaScript APIs you want to use in Swift:

```typescript
// Simple function
export function consoleLog(message: string): void;

// Define a subset of DOM API you want to use
interface Document {
    // Properties
    title: string;
    readonly body: HTMLElement;
 
    // Methods
    getElementById(id: string): HTMLElement;
    createElement(tagName: string): HTMLElement;
}

// You can use type-level operations like `Pick` to reuse
// type definitions provided by `lib.dom.d.ts`.
interface HTMLElement extends Pick<globalThis.HTMLElement, "innerText" | "className"> {
    appendChild(child: HTMLElement): void;
    // TODO: Function types on function signatures are not supported yet.
    // addEventListener(event: string, handler: (event: any) => void): void;
}

// Provide access to `document`
export function getDocument(): Document;
```

BridgeJS will generate Swift code that matches these TypeScript declarations. For example:

```swift
func consoleLog(message: String)

struct Document {
    var title: String { get set }
    var body: HTMLElement { get }

    func getElementById(_ id: String) -> HTMLElement
    func createElement(_ tagName: String) -> HTMLElement
}

struct HTMLElement {
    var innerText: String { get set }
    var className: String { get set }
    
    func appendChild(_ child: HTMLElement)
}

func getDocument() -> Document
```

### Step 3: Build Your Package

Build your package with the following command:

```bash
swift package --swift-sdk $SWIFT_SDK_ID js
```

This command:
1. Processes your TypeScript definition files
2. Generates corresponding Swift bindings
3. Compiles your Swift code to WebAssembly
4. Produces JavaScript glue code in `.build/plugins/PackageToJS/outputs/`

> Note: For larger projects, you may want to generate the BridgeJS code ahead of time to improve build performance. See <doc:Ahead-of-Time-Code-Generation> for more information.

### Step 4: Use the Generated Swift Bindings

The BridgeJS plugin automatically generates Swift bindings that match your TypeScript definitions. You can now use these APIs directly in your Swift code:

```swift
import JavaScriptKit

@JS func run() {
    // Simple function call
    consoleLog("Hello from Swift!")

    // Get `document`
    let document = getDocument()

    // Property access
    document.title = "My Swift App"

    // Method calls
    let button = document.createElement("button")
    button.innerText = "Click Me"

    // TODO: Function types on function signatures are not supported yet.
    // buttion.addEventListener("click") { _ in
    //     print("On click!")
    // }

    // DOM manipulation
    let container = document.getElementById("app")
    container.appendChild(button)
}
```

### Step 5: Inject JavaScript Implementations

The final step is to provide the actual JavaScript implementations for the TypeScript declarations you defined. You need to create a JavaScript file that initializes your WebAssembly module with the appropriate implementations:

```javascript
// index.js
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";

// Initialize the WebAssembly module with JavaScript implementations
const { exports } = await init({
    imports: {
        consoleLog: (message) => {
            console.log(message);
        },
        getDocument: () => document,
    }
});

// Call the entry point of your Swift application
exports.run();
```
