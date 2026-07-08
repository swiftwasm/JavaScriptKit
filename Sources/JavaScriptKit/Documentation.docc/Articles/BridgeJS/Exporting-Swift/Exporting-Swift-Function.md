# Exporting Swift Functions to JS

Learn how to export Swift functions to JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/JavaScript/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

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

### Generic functions

A `@JS` function can be generic over a type parameter constrained to `_BridgedSwiftGenericBridgeable`. The concrete type chosen at the call site crosses the bridge:

```swift
import JavaScriptKit

@JS public func identity<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
    return value
}
```

`T` must be a bridgeable type: a supported primitive (`Bool`, any fixed-width integer such as `Int`/`UInt`/`Int8`…`UInt64`, `Float`, `Double`, `String`, or `JSValue`), or a `@JS` struct, `final @JS class`, or `@JS enum`. You do not write any conformance yourself; marking a type `@JS` makes it usable as `T` (see <doc:Supported-Types>).

Because TypeScript erases generics, the JavaScript caller passes a `BridgeType<T>` token as the last argument so the bridge can select the right type at runtime. The tokens come from a generated `BridgeTypes` map exported at the top level of `bridge-js.js`; import it directly rather than reading it from the `exports` object:

```javascript
import { BridgeTypes } from "./bridge-js.js";

const x = exports.identity(42, BridgeTypes.Int);
const p = exports.identity({ x: 1, y: 2 }, BridgeTypes.MyPoint);
```

Concrete parameters keep their positions; the token is always appended last. The non-generic parameters of a generic `@JS` function may be any supported bridged type, including value types such as `@JS` structs, arrays, dictionaries, and associated-value enums alongside the generic parameter. The generated TypeScript declarations look like:

```typescript
export type BridgeType<T> = string & { readonly __bridgeType?: (value: T) => void };
export const BridgeTypes: { Bool: BridgeType<boolean>; Int: BridgeType<number>; Float: BridgeType<number>; Double: BridgeType<number>; String: BridgeType<string>; MyPoint: BridgeType<MyPoint>; };
export type Exports = {
    identity<T>(value: T, typeT: BridgeType<T>): T;
}
```

A single `T` may be used in more than one parameter, and a function may declare multiple distinct generic parameters. Each distinct generic parameter takes its own `BridgeType` token, appended after the regular arguments in declaration order:

```swift
@JS public func combine<T: _BridgedSwiftGenericBridgeable, U: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: U) -> T {
    a
}
```

```typescript
export type Exports = {
    combine<T, U>(a: T, b: U, typeT: BridgeType<T>, typeU: BridgeType<U>): T;
}
```

The generic parameter may also be wrapped as `[T]`, `T?`, or `[String: T]` in parameters and the result:

```swift
@JS public func firstOrNil<T: _BridgedSwiftGenericBridgeable>(_ values: [T]) -> T? {
    values.first
}
```

The result must be one of the declared generic parameters (such as `T` or `U`), a supported wrapper of one (`[T]`, `T?`, `[String: T]`), or `Void`. A generic parameter that is never used in any parameter is rejected, and returning a concrete non-`Void` type from a generic `@JS` function is not supported. Generic `@JS` functions must be synchronous (see <doc:Unsupported-Features>).

Generics also work on methods. On a `@JS` class or struct they apply to both instance and static methods. A `@JS enum` (including a namespace-style enum) has no instance methods in BridgeJS, so generics there apply to static methods only. The constraint, the trailing `BridgeType` token, and the generic-or-`Void` return rule all carry over unchanged:

```swift
import JavaScriptKit

@JS public class Box {
    @JS public init() {}

    @JS public func wrap<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        return value
    }
}
```

Call an instance method by passing the `BridgeType` token last, just like a top-level function:

```javascript
import { BridgeTypes } from "./bridge-js.js";

const box = new exports.Box();
const wrapped = box.wrap(42, BridgeTypes.Int);
```

```typescript
export interface Box extends SwiftHeapObject {
    wrap<T>(value: T, typeT: BridgeType<T>): T;
}
export type Exports = {
    Box: {
        new(): Box;
    }
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
| Generic parameter/result types (constrained to `_BridgedSwiftGenericBridgeable`) | ✅ |
| Opaque types: `func x() -> some P`, `func y(_: some P)` | ❌ |
| Default parameter values: `func x(_ foo: String = "")` | ✅ (See <doc:Exporting-Swift-Default-Parameters>) |