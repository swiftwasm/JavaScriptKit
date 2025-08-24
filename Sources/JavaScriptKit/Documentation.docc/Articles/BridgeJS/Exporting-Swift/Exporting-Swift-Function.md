# Exporting Swift Functions to JS

Learn how to export Swift functions to JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

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

### Throwing functions

Swift functions can throw JavaScript errors using `throws(JSException)`.

```swift
import JavaScriptKit

@JS public func findUser(id: Int) throws(JSException) -> String {
    if id <= 0 {
        throw JSException(JSError(message: "Invalid ID").jsValue)
    }
    return "User_\(id)"
}
```

From JavaScript, call with `try/catch`:

```javascript
try {
  const name = exports.findUser(42);
  console.log(name);
} catch (e) {
  console.error("findUser failed:", e);
}
```

Generated TypeScript type:

```typescript
export type Exports = {
    findUser(id: number): string; // throws at runtime
}
```

Notes:
- Only `throws(JSException)` is supported. Plain `throws` is not supported.
- Thrown values are surfaced to JS as normal JS exceptions.

### Async functions

Async Swift functions are exposed as Promise-returning JS functions.

```swift
import JavaScriptKit

@JS public func fetchCount(endpoint: String) async -> Int {
    // Simulate async work
    try? await Task.sleep(nanoseconds: 50_000_000)
    return endpoint.count
}
```

Usage from JavaScript:

```javascript
const count = await exports.fetchCount("/items");
```

Generated TypeScript type:

```typescript
export type Exports = {
    fetchCount(endpoint: string): Promise<number>;
}
```

### Async + throws

Async throwing functions become Promise-returning JS functions that reject on error.

```swift
import JavaScriptKit

@JS public func loadProfile(userId: Int) async throws(JSException) -> String {
    if userId <= 0 { throw JSException(JSError(message: "Bad userId").jsValue) }
    try? await Task.sleep(nanoseconds: 50_000_000)
    return "Profile_\(userId)"
}
```

JavaScript usage:

```javascript
try {
  const profile = await exports.loadProfile(1);
  console.log(profile);
} catch (e) {
  console.error("loadProfile failed:", e);
}
```

TypeScript:

```typescript
export type Exports = {
    loadProfile(userId: number): Promise<string>;
}
```

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
| Primitive parameter/result types: (e.g. `Bool`, `Int`, `Double`) | ✅ |
| `String` parameter/result type | ✅ |
| `@JS class` parameter/result type | ✅ |
| `@JS enum` parameter/result type | ✅ |
| `JSObject` parameter/result type | ✅ |
| Throwing JS exception: `func x() throws(JSException)` | ✅ |
| Throwing any exception: `func x() throws` | ❌ |
| Async methods: `func x() async` | ✅ |
| Generics | ❌ |
| Opaque types: `func x() -> some P`, `func y(_: some P)` | ❌ |
| Default parameter values: `func x(_ foo: String = "")` | ❌ |