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
