# Exporting Swift to JavaScript

Learn how to make your Swift code callable from JavaScript.

## Overview

> Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.

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
4. Output everything to the `.build/plugins/PackageToJS/outputs/` directory

> Note: For larger projects, you may want to generate the BridgeJS code ahead of time to improve build performance. See <doc:Ahead-of-Time-Code-Generation> for more information.

## Marking Swift Code for Export

### Functions

To export a Swift function to JavaScript, mark it with the `@JS` attribute and make it `public`:

```swift
import JavaScriptKit

@JS public func calculateTotal(price: Double, quantity: Int) -> Double {
    return price * Double(quantity)
}

@JS public func formatCurrency(amount: Double) -> String {
    return "$\(String(format: "%.2f", amount))"
}
```

These functions will be accessible from JavaScript:

```javascript
const total = exports.calculateTotal(19.99, 3);
const formattedTotal = exports.formatCurrency(total);
console.log(formattedTotal); // "$59.97"
```

The generated TypeScript declarations for these functions would look like:

```typescript
export type Exports = {
    calculateTotal(price: number, quantity: number): number;
    formatCurrency(amount: number): string;
}
```

### Classes

To export a Swift class, mark both the class and any members you want to expose:

```swift
import JavaScriptKit

@JS class ShoppingCart {
    private var items: [(name: String, price: Double, quantity: Int)] = []

    @JS init() {}

    @JS public func addItem(name: String, price: Double, quantity: Int) {
        items.append((name, price, quantity))
    }

    @JS public func removeItem(atIndex index: Int) {
        guard index >= 0 && index < items.count else { return }
        items.remove(at: index)
    }

    @JS public func getTotal() -> Double {
        return items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }

    @JS public func getItemCount() -> Int {
        return items.count
    }

    // This method won't be accessible from JavaScript (no @JS)
    var debugDescription: String {
        return "Cart with \(items.count) items, total: \(getTotal())"
    }
}
```

In JavaScript:

```javascript
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
const { exports } = await init({});

const cart = exports.ShoppingCart.init();
cart.addItem("Laptop", 999.99, 1);
cart.addItem("Mouse", 24.99, 2);
console.log(`Items in cart: ${cart.getItemCount()}`);
console.log(`Total: $${cart.getTotal().toFixed(2)}`);
```

The generated TypeScript declarations for this class would look like:

```typescript
// Base interface for Swift reference types
export interface SwiftHeapObject {
    release(): void;
}

// ShoppingCart interface with all exported methods
export interface ShoppingCart extends SwiftHeapObject {
    addItem(name: string, price: number, quantity: number): void;
    removeItem(atIndex: number): void;
    getTotal(): number;
    getItemCount(): number;
}

export type Exports = {
    ShoppingCart: {
        init(): ShoppingCart;
    }
}
```

## Using Namespaces

The `@JS` macro supports organizing your exported Swift code into namespaces using dot-separated strings. This allows you to create hierarchical structures in JavaScript that mirror your Swift code organization.

### Functions with Namespaces

You can export functions to specific namespaces by providing a namespace parameter:

```swift
import JavaScriptKit

// Export a function to a custom namespace
@JS(namespace: "MyModule.Utils") func namespacedFunction() -> String {
    return "namespaced"
}
```

This function will be accessible in JavaScript through its namespace hierarchy:

```javascript
// Access the function through its namespace
const result = globalThis.MyModule.Utils.namespacedFunction();
console.log(result); // "namespaced"
```

The generated TypeScript declaration will reflect the namespace structure:

```typescript
declare global {
    namespace MyModule {
        namespace Utils {
            function namespacedFunction(): string;
        }
    }
}
```

### Classes with Namespaces

For classes, you only need to specify the namespace on the top-level class declaration. All exported methods within the class will be part of that namespace:

```swift
import JavaScriptKit

@JS(namespace: "__Swift.Foundation") class Greeter {
    var name: String

    @JS init(name: String) {
        self.name = name
    }

    @JS func greet() -> String {
        return "Hello, " + self.name + "!"
    }

    func changeName(name: String) {
        self.name = name
    }
}
```

In JavaScript, this class is accessible through its namespace:

```javascript
// Create instances through namespaced constructors
const greeter = new globalThis.__Swift.Foundation.Greeter("World");
console.log(greeter.greet()); // "Hello, World!"
```

The generated TypeScript declaration will organize the class within its namespace:

```typescript
declare global {
    namespace __Swift {
        namespace Foundation {
            class Greeter {
                constructor(name: string);
                greet(): string;
            }
        }
    }
}

export interface Greeter extends SwiftHeapObject {
    greet(): string;
}
```

Using namespaces can be preferable for projects with many global functions, as they help prevent naming collisions. Namespaces also provide intuitive hierarchies for organizing your exported Swift code, and they do not affect the code generated by `@JS` declarations without namespaces.
