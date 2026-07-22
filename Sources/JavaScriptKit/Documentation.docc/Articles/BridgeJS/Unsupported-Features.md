# Unsupported Features in BridgeJS

Limitations and unsupported patterns when using BridgeJS.

## Overview

BridgeJS generates glue code per Swift target (module). Some patterns that are valid in Swift or TypeScript are not supported across the bridge today. This article summarizes the main limitations so you can design your APIs accordingly.

## File-backed JavaScript modules

Files referenced by `JSImportFrom.module` must be nonempty, target-relative `.js` or `.mjs` paths and must remain within that Swift target. Only explicitly referenced files are copied. BridgeJS does not discover or rewrite an imported module's dependency graph, so referenced files should currently be self-contained.

Generated packages use static ECMAScript module imports. This works with the existing PackageToJS browser and Node ESM entry points. CommonJS and classic non-module script output are not generated or translated.

Module origins apply to top-level `@JSFunction`, top-level `@JSGetter`, and an entire `@JSClass`. Per-member origins, top-level setters, inline JavaScript source, package-root-relative paths, and per-member module overrides are not supported.

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
