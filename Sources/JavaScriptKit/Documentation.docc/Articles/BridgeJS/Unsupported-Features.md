# Unsupported Features in BridgeJS

Limitations and unsupported patterns when using BridgeJS.

## Overview

BridgeJS generates glue code per Swift target (module). Some patterns that are valid in Swift or TypeScript are not supported across the bridge today. This article summarizes the main limitations so you can design your APIs accordingly.

## Type usage crossing module boundary

### Exporting Swift: extending types from another Swift module

If you have multiple Swift targets (e.g. a library and an app), you **cannot** extend a type defined in one target with a `@JS` exported API in another target.

**Unsupported example:** Module `App` extends a type defined in module `Lib`:

```swift
// In module Lib
@JS public struct LibPoint {
    let x: Double
    let y: Double
}

// In module App (depends on Lib) - unsupported
extension LibPoint {
    @JS public func transformed() -> LibPoint { ... }
}
```

### Exporting Swift: non-`@JS` types from another Swift module

While using `@JS` types from another Swift module is supported, it is not possible to use non-`@JS` types defined in other modules: this will fail at type lookup.

### Exporting Swift: types from another Swift package

Types defined in a separate Swift package cannot yet be referenced from `@JS` declarations in your package.

## Generics

Generic functions are supported in both directions, through a type parameter constrained to `_BridgedSwiftGenericBridgeable`: an imported `@JSFunction` (see <doc:Importing-JS-Function>) and an exported `@JS` function (see <doc:Exporting-Swift-Function>). Generics also work on methods of an exported `@JS` class or struct (both instance and static), on static methods of an exported `@JS` enum or namespace enum, and on imported `@JSClass` methods. A function may declare one or more distinct generic parameters, such as `combine<T, U>(_ a: T, _ b: U) -> T`. The following forms are not supported and produce build-time diagnostics:

- `async` generic functions.
- `where` clauses on a generic declaration.
- An exported `@JS` generic function that is `throws`. (Imported `@JSFunction` generics may still use `throws(JSException)`.)
- A declared generic parameter on an exported `@JS` function that is not used in any parameter. A return-only generic (such as `make<T>() -> T`) is supported for imported `@JSFunction`s, where the JavaScript implementation produces the value.
- An exported generic function that returns a concrete, non-`Void` type. The result of an exported generic function must be one of the declared generic parameters (optionally wrapped in `[T]`, `T?`, or `[String: T]`) or `Void`.

The generic parameter may be used bare (`T`) or wrapped in `[T]`, `T?`, or `[String: T]`. Nested or other wrappings, such as `[T?]`, `[[T]]`, `T??`, or `[Int: T]`, are not supported and produce build-time diagnostics. `JSObject` cannot be used as the generic argument (it is a non-final class); use `JSValue` instead.

The generic argument must be a primitive or a type defined in the same module as the generic function. Using a `@JS` type from another module as the generic argument is not supported yet: at an imported `@JSFunction` call site this surfaces as a Swift conformance error, and an exported `@JS` function traps at runtime when passed such a type's token.

Exported generic functions additionally require runtime existential support, so they are not available under Embedded Swift. Imported generics remain available there.
