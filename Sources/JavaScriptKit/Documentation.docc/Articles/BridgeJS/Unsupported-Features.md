# Unsupported Features in BridgeJS

Limitations and unsupported patterns when using BridgeJS.

## Overview

BridgeJS generates glue code per Swift target (module). Some patterns that are valid in Swift or TypeScript are not supported across the bridge today. This article summarizes the main limitations so you can design your APIs accordingly.

## JavaScript modules

`JSImportFrom.module` accepts two forms, distinguished by a leading `/`.

A **target-local file** is a `/`-prefixed `.js` or `.mjs` path, such as `.module("/Modules/utils.mjs")`. The leading slash denotes the Swift target root, not the filesystem root, and the file must remain within that Swift target. Only explicitly referenced files are copied into the generated package. BridgeJS does not discover or rewrite an imported module's dependency graph, so referenced files should currently be self-contained.

An **external module** is any other value, passed to the JavaScript module resolver verbatim — for example `.module("node:path")`, `.module("lodash/fp")`, or `.module("@scope/package")`. Because resolution is host-defined, BridgeJS deliberately performs no build-time validation of these specifiers beyond rejecting the empty string and relative specifiers (`./x`, `../x`); use the `/`-prefixed form to reference your own files. This has several consequences you are responsible for:

- Importing a `node:`-prefixed builtin makes the generated package Node-only. It will fail to load in a browser.
- An npm package must be resolvable at load time — either from the generated output directory (Node walks up to the nearest `node_modules`), or through your bundler's aliasing or an import map.
- BridgeJS does not add anything to the generated `package.json`. Installing the dependency is up to you, and no version is inferred.
- A specifier is not verified to exist until the JavaScript host loads the generated module, so a typo surfaces as a resolution error from your JavaScript toolchain rather than a Swift compile error.

Generated packages use static ECMAScript module imports. This works with the existing PackageToJS browser and Node ESM entry points. CommonJS and classic non-module script output are not generated or translated. Note that named exports of a CommonJS package are only importable when Node can statically detect them; when in doubt, use `jsName: .default` and reach members through the default export.

Module origins apply to top-level `@JSFunction`, top-level `@JSGetter`, and an entire `@JSClass`. Per-member origins, top-level setters, inline JavaScript source, package-root-relative paths, and per-member module overrides are not supported. `jsName: .default` is likewise only valid on those three declaration forms and only together with `from: .module(...)`; it cannot be used on `@JSSetter`, because ECMAScript module bindings are read-only.

The TypeScript-definition workflow (`bridge-js.d.ts`) always imports from `globalThis` and cannot yet target a module origin. To import from a module, declare the API with the macros instead.

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
