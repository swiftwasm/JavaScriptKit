# Exporting Swift Static Properties to JS

Learn how to export Swift static and class properties as JavaScript static properties using BridgeJS.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS supports exporting Swift `static var`, `static let`, and `class var` properties to JavaScript static properties. Both stored and computed properties are supported.

## Class Static Properties

Classes can export both stored and computed static properties:

```swift
@JS class Configuration {
    @JS init() {}
    
    @JS static let version = "1.0.0"
    @JS static var debugMode = false
    @JS class var defaultTimeout = 30
    
    @JS static var timestamp: Double {
        get { return Date().timeIntervalSince1970 }
        set { /* custom setter logic */ }
    }
    
    @JS static var buildNumber: Int {
        return 12345
    }
}
```

Generated TypeScript definitions:

```typescript
export type Exports = {
    Configuration: {
        new(): Configuration;
        readonly version: string;
        debugMode: boolean;
        defaultTimeout: number;
        timestamp: number;
        readonly buildNumber: number;
    }
}

export interface Configuration extends SwiftHeapObject {
    // instance methods here
}
```

Usage:

```typescript
console.log(Configuration.version);      // "1.0.0"
console.log(Configuration.debugMode);    // false
console.log(Configuration.timestamp);    // current timestamp

Configuration.debugMode = true;
Configuration.timestamp = Date.now() / 1000;
```


## Values/Tag/Object Pattern

For enums with static properties, BridgeJS generates a structured pattern:

- **Values**: Constants for enum cases (`PropertyEnumValues: { readonly Value1: 0; readonly Value2: 1; }`)
- **Tag**: Type alias for enum values (`PropertyEnumTag = typeof PropertyEnumValues[keyof typeof PropertyEnumValues]`)
- **Object**: Intersection type combining Values + properties (`PropertyEnumObject = typeof PropertyEnumValues & { properties }`)
- **Exports**: Uses Object type for unified access (`PropertyEnum: PropertyEnumObject`)

This allows accessing both enum constants and static properties through a single interface: `exports.PropertyEnum.Value1` and `exports.PropertyEnum.enumProperty`.

## Enum Static Properties

Enums can contain static properties that are exported alongside enum cases:

```swift
@JS enum PropertyEnum {
    case value1
    case value2
    
    @JS static var enumProperty = "mutable"
    @JS static let enumConstant = 42
    @JS static var computedEnum: String {
        return "computed value"
    }
}
```

Generated TypeScript definitions:

```typescript
export const PropertyEnumValues: {
    readonly Value1: 0;
    readonly Value2: 1;
};
export type PropertyEnumTag = typeof PropertyEnumValues[keyof typeof PropertyEnumValues];

export type PropertyEnumObject = typeof PropertyEnumValues & {
    enumProperty: string;
    readonly enumConstant: number;
    computedEnum: string;
};

export type Exports = {
    PropertyEnum: PropertyEnumObject
}
```

Usage:

```typescript
const status: PropertyEnumTag = exports.PropertyEnum.Value1;  // 0
const otherStatus: PropertyEnumTag = PropertyEnumValues.Value2;  // 1

// Access static properties
console.log(exports.PropertyEnum.enumProperty);  // "mutable"
console.log(exports.PropertyEnum.enumConstant);  // 42
console.log(exports.PropertyEnum.computedEnum);  // "computed value"

// Modify mutable properties
exports.PropertyEnum.enumProperty = "updated";

```

## Namespace Enum Static Properties

Namespace enums organize related static properties and are assigned to `globalThis`:

```swift
@JS enum PropertyNamespace {
    @JS enum Nested {
        @JS static var nestedConstant = "constant"
        @JS static var nestedDouble = 3.14
        @JS static var nestedProperty = 100
    }
}
```

Generated TypeScript definitions:

```typescript
declare global {
    namespace PropertyNamespace {
        namespace Nested {
            var nestedConstant: string;
            let nestedDouble: number;
            let nestedProperty: number;
        }
    }
}
```

JavaScript usage:

```typescript
// Direct access via global namespace (no exports needed)
console.log(PropertyNamespace.Nested.nestedConstant);  // "constant"
console.log(PropertyNamespace.Nested.nestedDouble);    // 3.14
console.log(PropertyNamespace.Nested.nestedProperty);  // 100

// Modify mutable properties
PropertyNamespace.Nested.nestedConstant = "updated";
PropertyNamespace.Nested.nestedProperty = 200;

// Type-safe access
const constant: string = PropertyNamespace.Nested.nestedConstant;
const value: number = PropertyNamespace.Nested.nestedProperty;
```

## Supported Features

| Swift Static Property Feature | Status |
|:------------------------------|:-------|
| Class `static let` | ✅ |
| Class `static var` | ✅ |
| Class `class var` | ✅ |
| Enum static properties | ✅ |
| Namespace enum static properties | ✅ |
| Computed properties (get/set) | ✅ |
| Read-only computed properties | ✅ |
| All property types (primitives, objects, optionals) | ✅ |
| Property observers (`willSet`/`didSet`) | ❌ |
| Generic static properties | ❌ |
| Protocol static property requirements | ❌ |
