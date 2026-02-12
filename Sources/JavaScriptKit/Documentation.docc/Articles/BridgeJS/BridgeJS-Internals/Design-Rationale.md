# BridgeJS Design Rationale

Why BridgeJS is faster than dynamic `JSObject`/`JSValue` APIs and how engine optimizations influence the design.

## Overview

BridgeJS generates **specialized** bridge code per exported or imported interface. That specialization, combined with stable call and property access patterns, allows JavaScript engines to optimize the boundary crossing much better than with generic dynamic code. This page explains the main performance rationale.

## Why generated code is faster

1. **Specialized code per interface** - Each bridged function or property gets its own glue path with known types. The engine does not need to handle arbitrary shapes or types at the call site.

2. **Use of static type information** - The generator knows parameter and return types at compile time. It can avoid dynamic type checks and boxing where the dynamic API would require them.

3. **IC-friendly access patterns** - Property and method accesses use stable, predictable shapes instead of a single generic subscript path. That keeps engine **inline caches (ICs)** effective instead of turning them **megamorphic**.

## Inline caches (ICs) and megamorphic penalty

JavaScript engines (and many other dynamic-language VMs) use **inline caches** at property and method access sites: they remember the object shape (e.g. “this property is at offset X”) so the next access with the same shape can take a fast path.

- **Monomorphic** - One shape seen at a site → very fast, offset cached.
- **Polymorphic** - A few shapes → still fast, small dispatch in the IC.
- **Megamorphic** - Too many different shapes at the same site → the IC gives up and falls back to a generic property lookup, which is much slower.

Engines typically allow only a small number of shapes per IC (e.g. on the order of a few) before marking the site megamorphic.

## Why `JSObject` subscript is problematic

`JSObject.subscript` (and similar dynamic property access) shares **one** code path for all property names and all object shapes. Every access goes through the same call site with varying keys and receiver shapes. That site therefore sees many different shapes and quickly becomes **megamorphic**, so the engine cannot cache property offsets and must do a generic lookup every time.

So even if you cache the property name (e.g. with `CachedJSStrings`), you are still using the same generic subscript path; the call site stays megamorphic and pays the slow-path cost.

BridgeJS avoids this by generating **separate** access paths per property or method. Each generated getter/setter or function call has a stable shape at the engine level, so the IC can stay monomorphic or polymorphic and the fast path is used.

## What to read next

- ABI and binary interface details will be documented in this section as they stabilize.
- For using BridgeJS in your app, see <doc:Introducing-BridgeJS>, <doc:Importing-JavaScript-into-Swift>, and <doc:Exporting-Swift-to-JavaScript>.
