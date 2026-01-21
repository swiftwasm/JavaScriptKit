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

## Struct Methods and Initializers

Structs can have instance methods, static methods, and initializers. All require `@JS` annotation:

```swift
@JS struct Point {
    var x: Double
    var y: Double

    @JS init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    @JS func distanceFromOrigin() -> Double {
        return (x * x + y * y).squareRoot()
    }

    @JS static func origin() -> Point {
        return Point(x: 0, y: 0)
    }
}
```

In JavaScript:

```javascript
// Create via static init method (not constructor)
const point = exports.Point.init(3.0, 4.0);
console.log(point.distanceFromOrigin()); // 5.0

// Static method
const origin = exports.Point.origin();
console.log(origin.x); // 0.0
```

Note: Struct initializers are exported as static `init` methods. This differs from classes, where `@JS init` maps to a JavaScript constructor using `new`.

## How It Works

Structs use **copy semantics** when crossing the Swift/JavaScript boundary:

1. **Data Transfer**: Struct fields are pushed to type-specific stacks and reconstructed as plain JavaScript objects
2. **No Shared State**: Each side has its own copy - modifications don't affect the other
3. **No Memory Management**: No `release()` needed since there's no shared reference
4. **Plain Objects**: In JavaScript, structs become plain objects matching the TypeScript interface

This differs from classes, which use reference semantics and share state across the boundary.

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
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
