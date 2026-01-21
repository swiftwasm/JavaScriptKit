# Exporting Swift Static Functions to JS

Learn how to export Swift static and class functions as JavaScript static methods using BridgeJS.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS supports exporting Swift `static func` and `class func` to JavaScript static methods. Both generate identical JavaScript output but differ in Swift inheritance behavior.

> Important: Static function support is **Swift → JavaScript only**. JavaScript → Swift static function imports are not currently supported.

## Class Static Functions

Classes can export both `static` and `class` functions:

```swift
@JS class MathUtils {
    @JS init() {}
    
    @JS static func add(a: Int, b: Int) -> Int {
        return a + b
    }
    
    @JS class func subtract(a: Int, b: Int) -> Int {
        return a - b
    }
    
    @JS func multiply(x: Int, y: Int) -> Int {
        return x * y
    }
}
```

Generated TypeScript definitions:

```typescript
export type Exports = {
    MathUtils: {
        new(): MathUtils;
        subtract(a: number, b: number): number;
        add(a: number, b: number): number;
    }
}

export interface MathUtils extends SwiftHeapObject {
    multiply(x: number, y: number): number;
}
```

Usage:

```typescript
// Static methods
const sum = MathUtils.add(5, 3);
const difference = MathUtils.subtract(10, 4);

// Instance methods
const utils = new MathUtils();
const product = utils.multiply(4, 7);
```

## Values/Tag/Object Pattern

For enums with static functions, BridgeJS generates a structured pattern:

- **Values**: Constants for enum cases (`CalculatorValues: { readonly Scientific: 0; readonly Basic: 1; }`)
- **Tag**: Type alias for enum values (`CalculatorTag = typeof CalculatorValues[keyof typeof CalculatorValues]`)
- **Object**: Intersection type combining Values + methods (`CalculatorObject = typeof CalculatorValues & { methods }`)
- **Exports**: Uses Object type for unified access (`Calculator: CalculatorObject`)

This allows accessing both enum constants and static functions through a single interface: `exports.Calculator.Scientific` and `exports.Calculator.square(5)`.

## Enum Static Functions

Enums can contain static functions that are exported as properties:

```swift
@JS enum Calculator {
    case scientific
    case basic
    
    @JS static func square(value: Int) -> Int {
        return value * value
    }
    
    @JS static func cube(value: Int) -> Int {
        return value * value * value
    }
}
```

Generated TypeScript definitions:

```typescript
export const CalculatorValues: {
    readonly Scientific: 0;
    readonly Basic: 1;
};
export type CalculatorTag = typeof CalculatorValues[keyof typeof CalculatorValues];

export type CalculatorObject = typeof CalculatorValues & {
    square(value: number): number;
    cube(value: number): number;
};

export type Exports = {
    Calculator: CalculatorObject
}
```

This enables unified access to both enum constants and static functions:

```typescript
// Access enum constants
const mode: CalculatorTag = exports.Calculator.Scientific;  // 0
const otherMode: CalculatorTag = CalculatorValues.Basic;  // 1

// Call static functions
const result: number = exports.Calculator.square(5);  // 25
```

## Namespace Enum Static Functions

Namespace enums organize related utility functions and are assigned to `globalThis`. See <doc:Using-Namespace> for more details on namespace organization.

```swift
@JS enum Utils {
    @JS enum String {
        @JS static func uppercase(_ text: String) -> String {
            return text.uppercased()
        }
    }
}
```

Generated TypeScript definitions:

```typescript
declare global {
    namespace Utils {
        namespace String {
            uppercase(text: string): string;
        }
    }
}
```

Usage:

```typescript
// Direct access via global namespace (no exports needed)
const upper: string = Utils.String.uppercase("hello");
const result: string = Utils.String.uppercase("world");
```

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
| Class `static func` | ✅ |
| Class `class func` | ✅ |
| Enum `static func` | ✅ |
| Namespace enum `static func` | ✅ |
| Generic static functions | ❌ |
| Protocol static requirements | ❌ |
