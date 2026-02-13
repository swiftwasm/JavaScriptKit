# Unsupported Features in BridgeJS

Limitations and unsupported patterns when using BridgeJS.

## Overview

BridgeJS generates glue code per Swift target (module). Some patterns that are valid in Swift or TypeScript are not supported across the bridge today. This article summarizes the main limitations so you can design your APIs accordingly.

## Type usage crossing module boundary

BridgeJS does **not** support using a type across module boundaries in the following situations.

### Exporting Swift: types from another Swift module

If you have multiple Swift targets (e.g. a library and an app), you **cannot** use a type defined in one target in an exported API of another target.

**Unsupported example:** Module `App` exports a function that takes or returns a type defined in module `Lib`:

```swift
// In module Lib
@JS public struct LibPoint {
    let x: Double
    let y: Double
}

// In module App (depends on Lib) - unsupported
@JS public func transform(_ p: LibPoint) -> LibPoint { ... }
```
