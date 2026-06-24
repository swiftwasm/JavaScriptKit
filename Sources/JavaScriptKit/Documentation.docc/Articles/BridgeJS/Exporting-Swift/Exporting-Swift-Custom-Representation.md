# Exporting a Type With a Custom JS Representation

Learn how to give a Swift type a different representation on the JavaScript side using `@JS(as:)`.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/JavaScript/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS picks a sensible default representation for each exported type - structs cross by copy, classes by reference, and so on. Sometimes that default is a poor fit:

- A struct copied at the boundary is expensive when it holds a large payload (for example a polygon with thousands of vertices).
- A type uses a feature BridgeJS does not export directly (for example a dictionary with integer keys).

`@JS(as:)` is the escape hatch. It lets a Swift type keep its idiomatic shape while being bridged to JavaScript through a different `@JS` type that you control, without duplicating the surrounding API.

Mark the type with `@JS(as: OtherType.self)` and provide two conversions:

```swift
import JavaScriptKit

@JS(as: JSPolygon.self) struct Polygon {
    var vertices: [Point]

    consuming func bridgeToJS() -> JSPolygon {
        JSPolygon(underlying: self)
    }

    static func bridgeFromJS(_ value: consuming JSPolygon) -> Polygon {
        value.underlying
    }
}

@JS final class JSPolygon {
    var underlying: Polygon

    @JS init(underlying: Polygon) {
        self.underlying = underlying
    }

    @JS var vertexCount: Int { underlying.vertices.count }
}

@JS func merge(_ a: Polygon, _ b: Polygon) -> Polygon
```

Existing Swift code keeps using the idiomatic `Polygon`. Anywhere `Polygon` crosses the boundary - parameters, return values, optionals, arrays - BridgeJS substitutes `JSPolygon`, so JavaScript sees the reference type and avoids copying.

The generated TypeScript declarations refer to the representation type:

```typescript
export interface JSPolygon extends SwiftHeapObject {
    readonly vertexCount: number;
}

export type Exports = {
    JSPolygon: {
        new(underlying: JSPolygon): JSPolygon;
    }
    merge(a: JSPolygon, b: JSPolygon): JSPolygon;
}
```

## The Bridging Contract

A type marked `@JS(as: R.self)` must provide both halves of the conversion to and from its representation `R`:

```swift
consuming func bridgeToJS() -> R
static func bridgeFromJS(_ value: consuming R) -> Self
```

BridgeJS inserts a call to `bridgeToJS()` at the first opportunity when a value leaves Swift, and `bridgeFromJS(_:)` at the last opportunity when one enters. The rest of the generated glue just uses `R`'s ABI, so the conversions are the only code you write.

## Wrapping a Primitive

The representation does not have to be a class. A small wrapper over a primitive is a common case - for example exposing a strongly-typed identifier as a plain string:

```swift
@JS(as: String.self) struct UUID {
    var rawValue: String

    consuming func bridgeToJS() -> String { rawValue }
    static func bridgeFromJS(_ value: consuming String) -> UUID { UUID(rawValue: value) }
}

@JS func currentUser() -> UUID
```

JavaScript sees a `string`, while Swift keeps the distinct `UUID` type.

## Supported Representations

The representation type (the `as:` target) must itself be a type BridgeJS can export by value or reference:

| Representation | Status |
|:---------------|:-------|
| `@JS class` | ✅ |
| `@JSClass` (imported) | ✅ |
| `@JS struct` | ✅ |
| Primitives (`Int`, `Double`, `Float`, `Bool`, `String`) | ✅ |
| `JSValue` | ✅ |
| Case enums and associated-value enums | ✅ |
| Raw-value enums | ❌ |
| `@JS protocol` | ❌ |
| Another `@JS(as:)` type (chained aliases) | ❌ |
| Closures, arrays, dictionaries, optionals as the direct target | ❌ |

`@JS(as:)` cannot be combined with `namespace:` - an aliased type adopts its representation's placement.

## See Also

- <doc:Exporting-Swift-Struct>
- <doc:Exporting-Swift-Class>
- <doc:Supported-Types>
