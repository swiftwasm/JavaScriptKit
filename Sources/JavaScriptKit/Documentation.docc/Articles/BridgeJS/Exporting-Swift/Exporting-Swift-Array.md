# Exporting Swift Arrays to JS

Learn how to pass Swift arrays to and from JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS allows you to pass Swift arrays as function parameters and return values.

```swift
import JavaScriptKit

@JS func processNumbers(_ values: [Int]) -> [Int] {
    return values.map { $0 * 2 }
}

@JS func getGreeting() -> [String] {
    return ["Hello", "World", "from", "Swift"]
}
```

In JavaScript:

```javascript
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
const { exports } = await init({});

const doubled = exports.processNumbers([1, 2, 3, 4, 5]);
console.log(doubled); // [2, 4, 6, 8, 10]

const greeting = exports.getGreeting();
console.log(greeting.join(" ")); // "Hello World from Swift"
```

The generated TypeScript declarations:

```typescript
export type Exports = {
    processNumbers(values: number[]): number[];
    getGreeting(): string[];
}
```

## Arrays of Custom Types

Arrays work with `@JS` marked structs, classes, and enums:

```swift
@JS struct Point {
    var x: Double
    var y: Double
}

@JS func scalePoints(_ points: [Point], by factor: Double) -> [Point] {
    return points.map { Point(x: $0.x * factor, y: $0.y * factor) }
}
```

In JavaScript:

```javascript
const points = [{ x: 1.0, y: 2.0 }, { x: 3.0, y: 4.0 }];
const scaled = exports.scalePoints(points, 2.0);
console.log(scaled); // [{ x: 2.0, y: 4.0 }, { x: 6.0, y: 8.0 }]
```

## Optional and Nested Arrays

BridgeJS supports optional arrays (`[T]?`), arrays of optionals (`[T?]`), and nested arrays (`[[T]]`):

```swift
@JS func processOptionalInts(_ values: [Int?]) -> [Int?] {
    return values.map { $0.map { $0 * 2 } }
}

@JS func processMatrix(_ matrix: [[Int]]) -> [[Int]] {
    return matrix.map { row in row.map { $0 * 2 } }
}
```

In JavaScript:

```javascript
const mixed = [1, null, 3];
console.log(exports.processOptionalInts(mixed)); // [2, null, 6]

const matrix = [[1, 2], [3, 4]];
console.log(exports.processMatrix(matrix)); // [[2, 4], [6, 8]]
```

TypeScript definitions:

- `[Int?]` becomes `(number | null)[]`
- `[Int]?` becomes `number[] | null`
- `[[Int]]` becomes `number[][]`

## How It Works

Arrays use **copy semantics** when crossing the Swift/JavaScript boundary:

1. **Data Transfer**: Array elements are pushed to type-specific stacks and reconstructed as JavaScript arrays
2. **No Shared State**: Each side has its own copy - modifications don't affect the original
3. **Element Handling**: Primitive elements are copied by value; class elements copy their references (the objects remain shared)

This differs from classes, which use reference semantics and share state across the boundary.

```javascript
const original = [1, 2, 3];
const result = exports.processNumbers(original);
// original is unchanged - Swift received a copy
```

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
| Primitive arrays: `[Int]`, `[Double]`, `[Bool]`, `[String]` | ✅ |
| Struct arrays: `[MyStruct]` | ✅ |
| Class arrays: `[MyClass]` | ✅ |
| Enum arrays (case, raw value, associated value) | ✅ |
| Nested arrays: `[[Int]]` | ✅ |
| Optional arrays: `[Int]?` | ✅ |
| Arrays of optionals: `[Int?]` | ✅ |
| Protocol arrays: `[MyProtocol]` | ✅ |
| UnsafePointer-family arrays: `[UnsafeRawPointer]`, `[OpaquePointer]`, etc. | ✅ |

> Note: Array element type support matches that of regular `@JS func` parameters and return values.

## See Also

- <doc:Supported-Types>
