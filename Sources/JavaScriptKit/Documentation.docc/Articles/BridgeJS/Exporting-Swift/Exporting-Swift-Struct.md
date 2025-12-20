# Exporting Swift Structs to JS

Learn how to export Swift structs to JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

To export a Swift struct, mark it with `@JS`:

```swift
import JavaScriptKit

@JS struct Point {
    var x: Double
    var y: Double
    var label: String
}

@JS struct Address {
    var street: String
    var city: String
    var zipCode: Int?
}

@JS struct Person {
    var name: String
    var age: Int
    var address: Address
    var email: String?
}

@JS func createPerson(name: String, age: Int, street: String, city: String) -> Person
@JS func updateEmail(person: Person, email: String?) -> Person
```

In JavaScript:

```javascript
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
const { exports } = await init({});

const person = exports.createPerson("Alice", 30, "123 Main St", "NYC");
console.log(person.name);           // "Alice"
console.log(person.address.street); // "123 Main St"
console.log(person.email);          // null

const updated = exports.updateEmail(person, "alice@example.com");
console.log(updated.email);         // "alice@example.com"
```

The generated TypeScript declarations:

```typescript
export interface Point {
    x: number;
    y: number;
    label: string;
}

export interface Address {
    street: string;
    city: string;
    zipCode: number | null;
}

export interface Person {
    name: string;
    age: number;
    address: Address;
    email: string | null;
}

export type Exports = {
    createPerson(name: string, age: number, street: string, city: string): Person;
    updateEmail(person: Person, email: string | null): Person;
}
```

## Instance Fields vs Static Properties

**Instance fields** (part of the struct value) are automatically exported - no `@JS` needed:
```swift
@JS struct Point {
    var x: Double        // Auto-exported
    var y: Double        // Auto-exported
}
```

**Static properties** (not part of instance) require `@JS`:
```swift
@JS struct Config {
    var name: String
    
    @JS nonisolated(unsafe) static var defaultTimeout: Double = 30.0
    @JS static let maxRetries: Int = 3
}
```

In JavaScript:
```javascript
console.log(exports.Config.defaultTimeout);  // 30.0
exports.Config.defaultTimeout = 60.0;
console.log(exports.Config.maxRetries);      // 3 (readonly)
```

## Struct Methods

Structs can have instance and static methods, both require @JS annotation:

```swift
@JS struct Calculator {
    @JS func add(a: Double, b: Double) -> Double {
        return a + b
    }
    
    @JS static func multiply(x: Double, y: Double) -> Double {
        return x * y
    }
}
```

In JavaScript:

```javascript
const calc = {};
console.log(exports.useMathOperations(calc, 5.0, 3.0)); // Uses instance methods
console.log(exports.Calculator.multiply(4.0, 5.0));      // Static method
```

## Struct Initializers

Struct initializers are exported as static `init` methods, not constructors:

```swift
@JS struct Point {
    var x: Double
    var y: Double

    @JS init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
```

In JavaScript:

```javascript
const point = exports.Point.init(10.0, 20.0);
console.log(point.x); // 10.0
```

This differs from classes, where `@JS init` maps to a JavaScript constructor using `new`:

```javascript
// Class: uses `new`
const cart = new exports.ShoppingCart();

// Struct: uses static `init` method
const point = exports.Point.init(10.0, 20.0);
```

## Supported Features

| Feature | Status |
|:--------|:-------|
| Stored fields with supported types | ✅ |
| Optional fields | ✅ |
| Nested structs | ✅ |
| Instance methods | ✅ |
| Static methods | ✅ |
| Static properties | ✅ |
| Property observers (`willSet`, `didSet`) | ❌ |
| Generics | ❌ |
| Conformances | ❌ |

## See Also

- <doc:Supported-Types>
