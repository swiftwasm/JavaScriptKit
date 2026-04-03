# Exporting Swift Classes to JS

Learn how to export Swift classes to JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/JavaScript/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

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
cart.release(); // Call release() when done; don't rely on FinalizationRegistry as much as possible
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

## Adding Members via Extensions

You can add exported methods, computed properties, and static members to a `@JS` class using extensions. The extension block itself does not need `@JS` - only the individual members do:

```swift
@JS class Greeter {
    @JS var name: String

    @JS init(name: String) {
        self.name = name
    }

    @JS func greet() -> String {
        return "Hello, " + self.name + "!"
    }
}

extension Greeter {
    @JS func greetEnthusiastically() -> String {
        return "Hey, " + self.name + "!!!"
    }

    @JS var nameCount: Int { name.count }

    @JS static func greetAnonymously() -> String {
        return "Hello."
    }

    @JS static var defaultGreeting: String { "Hello, world!" }
}
```

This also works across files within the same module:

```swift
// GreeterExtension.swift
extension Greeter {
    @JS func greetFormally() -> String {
        return "Good day, " + self.name + "."
    }
}
```

All `@JS`-annotated members in extensions are merged into the same generated TypeScript interface as the original class declaration.

> Note: Extensions must target `@JS`-annotated types from the same module.

## How It Works

Classes use **reference semantics** when crossing the Swift/JavaScript boundary:

1. **Object Creation**: When you create a class instance (via `new` in JS), the object lives on the Swift heap
2. **Reference Passing**: JavaScript receives a reference (handle) to the Swift object, not a copy
3. **Shared State**: Changes made through either Swift or JavaScript affect the same object
4. **Memory Management**: `FinalizationRegistry` can release Swift objects when they're garbage collected in JavaScript, but you should **not rely on it** for cleanup. Call `release()` when an instance is no longer needed so that Swift memory is reclaimed deterministically. This is especially important for **short-lived instances**: GC may run late or not at all for objects that become unreachable quickly, so relying on `FinalizationRegistry` can delay or leak Swift-side resources.

This differs from structs, which use copy semantics and transfer data by value.

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
| Initializers: `init()` | ✅ |
| Initializers that throw JSException: `init() throws(JSException)` | ✅ |
| Initializers that throw typed error conforming to `ConvertibleToJSException` | ✅ |
| Untyped throws initializers: `init() throws` | ❌  |
| Async initializers: `init() async` | ❌ |
| Deinitializers: `deinit` | ✅ |
| Stored properties: `var`, `let` (with `willSet`, `didSet`) | ✅ |
| Computed properties: `var x: X { get set }` | ✅ |
| Computed properties with effects: `var x: X { get async throws }` | 🚧  |
| Static / class properties: `static var`, `class let` | ✅ (See <doc:Exporting-Swift-Static-Properties> )|
| Methods: `func` | ✅ (See <doc:Exporting-Swift-Function> ) |
| Static/class methods: `static func`, `class func` | ✅ (See <doc:Exporting-Swift-Static-Functions> ) |
| Extension methods/properties | ✅ |
| Subscripts: `subscript()` | ❌ |
| Generics | ❌ |
