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
3. Output everything to the `.build/plugins/PackageToJS/outputs/` directory

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

const cart = new exports.ShoppingCart();
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
        new(): ShoppingCart;
    }
}
```


### Enum Support

BridgeJS supports two output styles for enums, controlled by the `enumStyle` parameter:

- **`.const` (default)**: Generates const objects with union types
- **`.tsEnum`**: Generates native TypeScript enum declarations - **only available for case enums and raw value enums with String or numeric raw types**

Examples output of both styles can be found below.

#### Case Enums

**Swift Definition:**

```swift
@JS enum Direction {
    case north
    case south
    case east
    case west
}

@JS(enumStyle: .tsEnum) enum TSDirection {
    case north
    case south
    case east
    case west
}

@JS enum Status {
    case loading
    case success
    case error
}
```

**Generated TypeScript Declaration:**

```typescript
// Const object style (default)
const Direction: {
    readonly North: 0;
    readonly South: 1;
    readonly East: 2;
    readonly West: 3;
};
type Direction = typeof Direction[keyof typeof Direction];

// Native TypeScript enum style
enum TSDirection {
    North = 0,
    South = 1,
    East = 2,
    West = 3,
}

const Status: {
    readonly Loading: 0;
    readonly Success: 1;
    readonly Error: 2;
};
type Status = typeof Status[keyof typeof Status];
```

**Usage in TypeScript:**

```typescript
const direction: Direction = exports.Direction.North;
const tsDirection: TSDirection = exports.TSDirection.North;
const status: Status = exports.Status.Loading;

exports.setDirection(exports.Direction.South);
exports.setTSDirection(exports.TSDirection.East);
const currentDirection: Direction = exports.getDirection();
const currentTSDirection: TSDirection = exports.getTSDirection();

const result: Status = exports.processDirection(exports.Direction.East);

function handleDirection(direction: Direction) {
    switch (direction) {
        case exports.Direction.North:
            console.log("Going north");
            break;
        case exports.Direction.South:
            console.log("Going south");
            break;
        // TypeScript will warn about missing cases
    }
}
```

BridgeJS also generates convenience initializers and computed properties for each case-style enum, allowing the rest of the Swift glue code to remain minimal and consistent. This avoids repetitive switch statements in every function that passes enum values between JavaScript and Swift.

```swift
extension Direction {
    init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .north
        case 1:
            self = .south
        case 2:
            self = .east
        case 3:
            self = .west
        default:
            return nil
        }
    }

    var bridgeJSRawValue: Int32 {
        switch self {
        case .north:
            return 0
        case .south:
            return 1
        case .east:
            return 2
        case .west:
            return 3
        }
    }
}
...
@_expose(wasm, "bjs_setDirection")
@_cdecl("bjs_setDirection")
public func _bjs_setDirection(direction: Int32) -> Void {
    #if arch(wasm32)
    setDirection(_: Direction(bridgeJSRawValue: direction)!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getDirection")
@_cdecl("bjs_getDirection")
public func _bjs_getDirection() -> Int32 {
    #if arch(wasm32)
    let ret = getDirection()
    return ret.bridgeJSRawValue
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
```

#### Raw Value Enums

##### String Raw Values

**Swift Definition:**

```swift
// Default const object style
@JS enum Theme: String {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}

// Native TypeScript enum style
@JS(enumStyle: .tsEnum) enum TSTheme: String {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}
```

**Generated TypeScript Declaration:**

```typescript
// Const object style (default)
const Theme: {
    readonly Light: "light";
    readonly Dark: "dark";
    readonly Auto: "auto";
};
type Theme = typeof Theme[keyof typeof Theme];

// Native TypeScript enum style
enum TSTheme {
    Light = "light",
    Dark = "dark",
    Auto = "auto",
}
```

**Usage in TypeScript:**

```typescript
// Both styles work similarly in usage
const theme: Theme = exports.Theme.Dark;
const tsTheme: TSTheme = exports.TSTheme.Dark;

exports.setTheme(exports.Theme.Light);
const currentTheme: Theme = exports.getTheme();

const status: HttpStatus = exports.processTheme(exports.Theme.Auto);
```

##### Integer Raw Values

**Swift Definition:**

```swift
// Default const object style
@JS enum HttpStatus: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
}

// Native TypeScript enum style
@JS(enumStyle: .tsEnum) enum TSHttpStatus: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
}

@JS enum Priority: Int32 {
    case lowest = 1
    case low = 2
    case medium = 3
    case high = 4
    case highest = 5
}
```

**Generated TypeScript Declaration:**

```typescript
// Const object style (default)
const HttpStatus: {
    readonly Ok: 200;
    readonly NotFound: 404;
    readonly ServerError: 500;
};
type HttpStatus = typeof HttpStatus[keyof typeof HttpStatus];

// Native TypeScript enum style
enum TSHttpStatus {
    Ok = 200,
    NotFound = 404,
    ServerError = 500,
}

const Priority: {
    readonly Lowest: 1;
    readonly Low: 2;
    readonly Medium: 3;
    readonly High: 4;
    readonly Highest: 5;
};
type Priority = typeof Priority[keyof typeof Priority];
```

**Usage in TypeScript:**

```typescript
const status: HttpStatus = exports.HttpStatus.Ok;
const tsStatus: TSHttpStatus = exports.TSHttpStatus.Ok;
const priority: Priority = exports.Priority.High;

exports.setHttpStatus(exports.HttpStatus.NotFound);
exports.setPriority(exports.Priority.Medium);

const convertedPriority: Priority = exports.convertPriority(exports.HttpStatus.Ok);
```

### Namespace Enums

Namespace enums are empty enums (containing no cases) used for organizing related types and functions into hierarchical namespaces.

**Swift Definition:**

```swift
@JS enum Utils {
    @JS class Converter {
        @JS init() {}
        
        @JS func toString(value: Int) -> String {
            return String(value)
        }
    }
}

// Nested namespace enums with no @JS(namespace:) macro used
@JS enum Networking {
    @JS enum API {
        @JS enum Method {
            case get
            case post
        }
        
        @JS class HTTPServer {
            @JS init() {}
            @JS func call(_ method: Method)
        }
    }
}

// Top level enum can still use explicit namespace via @JS(namespace:)
@JS(namespace: "Networking.APIV2")
enum Internal {
    @JS enum SupportedMethod {
        case get
        case post
    }
    
    @JS class TestServer {
        @JS init() {}
        @JS func call(_ method: SupportedMethod)
    }
}
```

**Generated TypeScript Declaration:**

```typescript
declare global {
    namespace Utils {
        class Converter {
            constructor();
            toString(value: number): string;
        }
    }
    namespace Networking {
        namespace API {
            class HTTPServer {
                constructor();
                call(method: Networking.API.Method): void;
            }
            const Method: {
                readonly Get: 0;
                readonly Post: 1;
            };
            type Method = typeof Method[keyof typeof Method];
        }
        namespace APIV2 {
            namespace Internal {
                class TestServer {
                    constructor();
                    call(method: Internal.SupportedMethod): void;
                }
                const SupportedMethod: {
                    readonly Get: 0;
                    readonly Post: 1;
                };
                type SupportedMethod = typeof SupportedMethod[keyof typeof SupportedMethod];
            }
        }
    }
}
```

**Usage in TypeScript:**

```typescript
// Access nested classes through namespaces
const converter = new globalThis.Utils.Converter();
const result: string = converter.toString(42)

const server = new globalThis.Networking.API.HTTPServer();
const method: Networking.API.Method = globalThis.Networking.API.Method.Get;
server.call(method)

const testServer = new globalThis.Networking.APIV2.Internal.TestServer();
const supportedMethod: Internal.SupportedMethod = globalThis.Networking.APIV2.Internal.SupportedMethod.Post;
testServer.call(supportedMethod);
```

Things to remember when using enums for namespacing: 

1. Only enums with no cases will be used for namespaces
2. Top-level enums can use `@JS(namespace: "Custom.Path")` to place themselves in custom namespaces, which will be used as "base namespace" for all nested elements as well
3. Classes and enums nested within namespace enums **cannot** use `@JS(namespace:)` - this would create conflicting namespace declarations

**Invalid Usage:**

```swift
@JS enum Utils {
    // Invalid - nested items cannot specify their own namespace
    @JS(namespace: "Custom") class Helper {
        @JS init() {}
    }
}
```

**Valid Usage:**

```swift
// Valid - top-level enum with explicit namespace
@JS(namespace: "Custom.Utils") 
enum Helper {
    @JS class Converter {
        @JS init() {}
    }
}
```

#### Associated Value Enums

Associated value enums are not currently supported, but are planned for future releases.

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
