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

JavaScript usage:

```javascript
// Static methods - no instance needed
const sum = MathUtils.add(5, 3);
const difference = MathUtils.subtract(10, 4);

// Instance method - requires instance
const utils = new MathUtils();
const product = utils.multiply(4, 7);
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

Generated JavaScript:

```javascript
export const Calculator = {
    Scientific: 0,
    Basic: 1,
    square: null,
    cube: null,
};

// Later assigned:
Calculator.square = function(value) {
    const ret = instance.exports.bjs_Calculator_static_square(value);
    return ret;
}
Calculator.cube = function(value) {
    const ret = instance.exports.bjs_Calculator_static_cube(value);
    return ret;
}
```

JavaScript usage:

```javascript
const squared = Calculator.square(5);
const cubed = Calculator.cube(3);
```

Generated TypeScript definitions:

```typescript
export const Calculator: {
    readonly Scientific: 0;
    readonly Basic: 1;
    square(value: number): number;
    cube(value: number): number;
};
export type Calculator = typeof Calculator[keyof typeof Calculator];
```

## Namespace Enum Static Functions

Namespace enums organize related utility functions and are assigned to `globalThis`:

```swift
@JS enum Utils {
    @JS enum String {
        @JS static func uppercase(_ text: String) -> String {
            return text.uppercased()
        }
    }
}
```

Generated JavaScript:

```javascript
// Function exported in exports object
const exports = {
    uppercase: function bjs_Utils_String_uppercase(text) {
        const textBytes = textEncoder.encode(text);
        const textId = swift.memory.retain(textBytes);
        instance.exports.bjs_Utils_String_uppercase(textId, textBytes.length);
        const ret = tmpRetString;
        tmpRetString = undefined;
        swift.memory.release(textId);
        return ret;
    },
};

// Then assigned to globalThis
if (typeof globalThis.Utils === 'undefined') {
    globalThis.Utils = {};
}
if (typeof globalThis.Utils.String === 'undefined') {
    globalThis.Utils.String = {};
}
globalThis.Utils.String.uppercase = exports.uppercase;
```

JavaScript usage:

```javascript
const upper = Utils.String.uppercase("hello");
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

## Supported Features

| Swift Static Function Feature | Status |
|:------------------------------|:-------|
| Class `static func` | ✅ |
| Class `class func` | ✅ |
| Enum `static func` | ✅ |
| Namespace enum `static func` | ✅ |
| Generic static functions | ❌ |
| Protocol static requirements | ❌ |
