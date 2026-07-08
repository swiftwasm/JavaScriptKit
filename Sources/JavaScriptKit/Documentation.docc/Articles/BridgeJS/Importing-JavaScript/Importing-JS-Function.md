# Importing a JavaScript function into Swift

This guide shows how to bind a JavaScript function so it is callable from Swift using `@JSFunction`.

## Steps

### 1. Declare the function in Swift with `@JSFunction`

Match the JavaScript name and signature. Use Swift types that bridge to the JS types you need (see <doc:Supported-Types>).

```swift
import JavaScriptKit

@JSFunction func add(_ a: Double, _ b: Double) throws(JSException) -> Double
@JSFunction func setTitle(_ title: String) throws(JSException)
```

To bind a function that lives on the JavaScript global object (e.g. `parseInt`, `setTimeout`), add `from: .global`. Use `jsName` when the Swift name differs from the JavaScript name - see the ``JSFunction(jsName:from:)`` API reference for options.

### 2. Provide the implementation at initialization

Return the corresponding function(s) in the object passed to `getImports()` when initializing the WebAssembly module.

```javascript
// index.js
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";

const { exports } = await init({
  getImports() {
    return {
      add: (a, b) => a + b,
      setTitle: (title) => { document.title = title },
    };
  }
});
```

If you used `from: .global`, do not pass the function in `getImports()`; the runtime resolves it from `globalThis`.

### 3. Handle errors

Bound functions are `throws(JSException)`. Call them with `try` or `try?`; they throw when the JavaScript implementation throws.

## Generic functions

A `@JSFunction` can be generic over a type parameter constrained to `_BridgedSwiftGenericBridgeable`. The concrete type chosen at the call site then crosses the bridge:

```swift
@JSFunction func parse<T: _BridgedSwiftGenericBridgeable>(_ json: String) throws(JSException) -> T

let user: User = try parse(jsonString)
```

`T` must be a bridgeable type: a supported primitive (`Bool`, any fixed-width integer such as `Int`/`UInt`/`Int8`…`UInt64`, `Float`, `Double`, `String`, or `JSValue`), or a `@JS` struct, `final @JS class`, or `@JS enum`. You do not write any conformance yourself; marking a type `@JS` makes it usable as `T` (see <doc:Supported-Types>). Generics are not supported for `async` functions or `where` clauses (see <doc:Unsupported-Features>).

A generic type parameter may be used in more than one parameter, an imported function may declare more than one distinct generic parameter, and a generic result type may be used on a function that takes no generic parameters (the JavaScript implementation produces the value):

```swift
@JSFunction func pickFirst<T: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: T) throws(JSException) -> T

@JSFunction func makeValue<T: _BridgedSwiftGenericBridgeable>() throws(JSException) -> T

@JSFunction func combine<T: _BridgedSwiftGenericBridgeable, U: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: U) throws(JSException) -> U
```

The generic parameter may also be wrapped as `[T]`, `T?`, or `[String: T]` in parameters and the result:

```swift
@JSFunction func roundTrip<T: _BridgedSwiftGenericBridgeable>(_ values: [T]) throws(JSException) -> [T]

@JSFunction func lookup<T: _BridgedSwiftGenericBridgeable>(_ values: [String: T]) throws(JSException) -> T?
```

### Generic methods on imported classes

An imported `@JSClass` type can also have generic methods, both instance and static. The same constraint applies. The Swift to JavaScript bridge resolves the concrete type through an internal type id, and the JavaScript implementation is called with only the method's declared arguments:

```swift
@JSClass struct Store {
    @JSFunction func identity<T: _BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
    @JSFunction static func box<T: _BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
}
```

## Supported features

| Feature | Status |
|:--|:--|
| Primitive parameter/result types (e.g. `Double`, `Bool`) | ✅ |
| `String` parameter/result type | ✅ |
| Generic parameter/result types (constrained to `_BridgedSwiftGenericBridgeable`) | ✅ |
| Async function | ❌ |
