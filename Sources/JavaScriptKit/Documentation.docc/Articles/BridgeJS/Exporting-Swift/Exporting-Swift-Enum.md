# Exporting Swift Enums to JS

Learn how to export Swift enums to JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS supports two output styles for enums, controlled by the `enumStyle` parameter:

- **`.const` (default)**: Generates const objects with union types
- **`.tsEnum`**: Generates native TypeScript enum declarations - **only available for case enums and raw value enums with String or numeric raw types**

Examples output of both styles can be found below.

BridgeJS generates separate objects with descriptive naming for `.const` enums:

- **`EnumNameValues`**: Contains the enum case constants for all enums
- **`EnumNameTag`**: Represents the union type for enums
- **`EnumNameObject`**: Object type for all const-style enums, contains static members for enums with methods/properties or references the values type for simple enums

### Case Enums

```swift
@JS enum Direction {
    case north
    case south
    case east
    case west
}

@JS(enumStyle: .tsEnum) enum TSDirection {
    case north
    case south
    case east
    case west
}

@JS enum Status {
    case loading
    case success
    case error
}
```

Generated TypeScript declarations:

```typescript
// Const object style (default)
export const DirectionValues: {
    readonly North: 0;
    readonly South: 1;
    readonly East: 2;
    readonly West: 3;
};
export type DirectionTag = typeof DirectionValues[keyof typeof DirectionValues];

// Native TypeScript enum style
export enum TSDirection {
    North = 0,
    South = 1,
    East = 2,
    West = 3,
}

export const StatusValues: {
    readonly Loading: 0;
    readonly Success: 1;
    readonly Error: 2;
};
export type StatusTag = typeof StatusValues[keyof typeof StatusValues];
```

In TypeScript:

```typescript
const direction: DirectionTag = DirectionValues.North;
const tsDirection: TSDirection = TSDirection.North;
const status: StatusTag = StatusValues.Loading;

exports.setDirection(DirectionValues.South);
exports.setTSDirection(TSDirection.East);
const currentDirection: DirectionTag = exports.getDirection();
const currentTSDirection: TSDirection = exports.getTSDirection();

const result: StatusTag = exports.processDirection(DirectionValues.East);

function handleDirection(direction: DirectionTag) {
    switch (direction) {
        case DirectionValues.North:
            console.log("Going north");
            break;
        case DirectionValues.South:
            console.log("Going south");
            break;
        // TypeScript will warn about missing cases
    }
}
```

### Raw Value Enums

#### String Raw Values

```swift
// Default const object style
@JS enum Theme: String {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}

// Native TypeScript enum style
@JS(enumStyle: .tsEnum) enum TSTheme: String {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}
```

Generated TypeScript declarations:

```typescript
// Const object style (default)
export const ThemeValues: {
    readonly Light: "light";
    readonly Dark: "dark";
    readonly Auto: "auto";
};
export type ThemeTag = typeof ThemeValues[keyof typeof ThemeValues];

// Native TypeScript enum style
export enum TSTheme {
    Light = "light",
    Dark = "dark",
    Auto = "auto",
}
```

In TypeScript:

```typescript
// Raw value enums work similarly to case enums
const theme: ThemeTag = ThemeValues.Dark;
const tsTheme: TSTheme = TSTheme.Dark;

exports.setTheme(ThemeValues.Light);
const currentTheme: ThemeTag = exports.getTheme();

const status: HttpStatusTag = exports.processTheme(ThemeValues.Auto);
```

#### Integer Raw Values

```swift
// Default const object style
@JS enum HttpStatus: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
}

// Native TypeScript enum style
@JS(enumStyle: .tsEnum) enum TSHttpStatus: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
}

@JS enum Priority: Int32 {
    case lowest = 1
    case low = 2
    case medium = 3
    case high = 4
    case highest = 5
}
```

Generated TypeScript declarations:

```typescript
// Const object style (default)
export const HttpStatusValues: {
    readonly Ok: 200;
    readonly NotFound: 404;
    readonly ServerError: 500;
};
export type HttpStatusTag = typeof HttpStatusValues[keyof typeof HttpStatusValues];

// Native TypeScript enum style
export enum TSHttpStatus {
    Ok = 200,
    NotFound = 404,
    ServerError = 500,
}

export const PriorityValues: {
    readonly Lowest: 1;
    readonly Low: 2;
    readonly Medium: 3;
    readonly High: 4;
    readonly Highest: 5;
};
export type PriorityTag = typeof PriorityValues[keyof typeof PriorityValues];
```

In TypeScript:

```typescript
const status: HttpStatusTag = HttpStatusValues.Ok;
const tsStatus: TSHttpStatus = TSHttpStatus.Ok;
const priority: PriorityTag = PriorityValues.High;

exports.setHttpStatus(HttpStatusValues.NotFound);
exports.setPriority(PriorityValues.Medium);

const convertedPriority: PriorityTag = exports.convertPriority(HttpStatusValues.Ok);
```

### Namespace Enums

Namespace enums are empty enums (containing no cases) used for organizing related types and functions into hierarchical namespaces. See <doc:Using-Namespace> for more details on namespace organization.

```swift
@JS enum Utils {
    @JS class Converter {
        @JS init() {}

        @JS func toString(value: Int) -> String {
            return String(value)
        }
    }
}

// Nested namespace enums with no @JS(namespace:) macro used
@JS enum Networking {
    @JS enum API {
        @JS enum Method {
            case get
            case post
        }

        @JS class HTTPServer {
            @JS init() {}
            @JS func call(_ method: Method)
        }
    }
}

// Top level enum can still use explicit namespace via @JS(namespace:)
@JS(namespace: "Networking.APIV2")
enum Internal {
    @JS enum SupportedMethod {
        case get
        case post
    }

    @JS class TestServer {
        @JS init() {}
        @JS func call(_ method: SupportedMethod)
    }
}
```

Generated TypeScript declarations:

```typescript
declare global {
    namespace Utils {
        class Converter {
            constructor();
            toString(value: number): string;
        }
    }
    namespace Networking {
        namespace API {
            class HTTPServer {
                constructor();
                call(method: Networking.API.MethodTag): void;
            }
            const MethodValues: {
                readonly Get: 0;
                readonly Post: 1;
            };
            type MethodTag = typeof MethodValues[keyof typeof MethodValues];
        }
        namespace APIV2 {
            namespace Internal {
                class TestServer {
                    constructor();
                    call(method: Internal.SupportedMethodTag): void;
                }
                const SupportedMethodValues: {
                    readonly Get: 0;
                    readonly Post: 1;
                };
                type SupportedMethodTag = typeof SupportedMethodValues[keyof typeof SupportedMethodValues];
            }
        }
    }
}
```

In TypeScript:

```typescript
// Access nested classes through namespaces (no globalThis prefix needed)
const converter = new Utils.Converter();
const result: string = converter.toString(42)

const server = new Networking.API.HTTPServer();
const method: Networking.API.MethodTag = Networking.API.MethodValues.Get;
server.call(method)

const testServer = new Networking.APIV2.Internal.TestServer();
const supportedMethod: Internal.SupportedMethodTag = Networking.APIV2.Internal.SupportedMethodValues.Post;
testServer.call(supportedMethod);
```

Things to remember when using enums for namespacing:

1. Only enums with no cases will be used for namespaces
2. Top-level enums can use `@JS(namespace: "Custom.Path")` to place themselves in custom namespaces, which will be used as "base namespace" for all nested elements as well
3. Classes and enums nested within namespace enums **cannot** use `@JS(namespace:)` - this would create conflicting namespace declarations

Invalid usage:

```swift
@JS enum Utils {
    // Invalid - nested items cannot specify their own namespace
    @JS(namespace: "Custom") class Helper {
        @JS init() {}
    }
}
```

Valid usage:

```swift
// Valid - top-level enum with explicit namespace
@JS(namespace: "Custom.Utils")
enum Helper {
    @JS class Converter {
        @JS init() {}
    }
}
```

### Associated Value Enums

Associated value enums are supported and allow you to pass data along with each enum case. BridgeJS generates TypeScript discriminated union types. Associated values are encoded into a binary format for efficient transfer between JavaScript and WebAssembly

```swift
@JS
enum APIResult {
    case success(String)
    case failure(Int)
    case flag(Bool)
    case rate(Float)
    case precise(Double)
    case info
}

@JS
enum ComplexResult {
    case success(String)
    case error(String, Int)
    case status(Bool, Int, String)
    case coordinates(Double, Double, Double)
    case comprehensive(Bool, Bool, Int, Int, Double, Double, String, String, String)
    case info
}

@JS func handle(result: APIResult)
@JS func getResult() -> APIResult
```

Generated TypeScript declarations:

```typescript
export const APIResultValues: {
    readonly Tag: {
        readonly Success: 0;
        readonly Failure: 1;
        readonly Flag: 2;
        readonly Rate: 3;
        readonly Precise: 4;
        readonly Info: 5;
    };
};

export type APIResultTag =
  { tag: typeof APIResultValues.Tag.Success; param0: string } |
  { tag: typeof APIResultValues.Tag.Failure; param0: number } |
  { tag: typeof APIResultValues.Tag.Flag; param0: boolean } |
  { tag: typeof APIResultValues.Tag.Rate; param0: number } |
  { tag: typeof APIResultValues.Tag.Precise; param0: number } |
  { tag: typeof APIResultValues.Tag.Info }

export const ComplexResultValues: {
    readonly Tag: {
        readonly Success: 0;
        readonly Error: 1;
        readonly Status: 2;
        readonly Coordinates: 3;
        readonly Comprehensive: 4;
        readonly Info: 5;
    };
};

export type ComplexResultTag =
  { tag: typeof ComplexResultValues.Tag.Success; param0: string } |
  { tag: typeof ComplexResultValues.Tag.Error; param0: string; param1: number } |
  { tag: typeof ComplexResultValues.Tag.Status; param0: boolean; param1: number; param2: string } |
  { tag: typeof ComplexResultValues.Tag.Coordinates; param0: number; param1: number; param2: number } |
  { tag: typeof ComplexResultValues.Tag.Comprehensive; param0: boolean; param1: boolean; param2: number; param3: number; param4: number; param5: number; param6: string; param7: string; param8: string } |
  { tag: typeof ComplexResultValues.Tag.Info }
```

In TypeScript:

```typescript
const successResult: APIResultTag = {
    tag: APIResultValues.Tag.Success,
    param0: "Operation completed successfully"
};

const errorResult: ComplexResultTag = {
    tag: ComplexResultValues.Tag.Error,
    param0: "Network timeout",
    param1: 503
};

const statusResult: ComplexResultTag = {
    tag: ComplexResultValues.Tag.Status,
    param0: true,
    param1: 200,
    param2: "OK"
};

exports.handle(successResult);
exports.handle(errorResult);

const result: APIResultTag = exports.getResult();

// Pattern matching with discriminated unions
function processResult(result: APIResultTag) {
    switch (result.tag) {
        case APIResultValues.Tag.Success:
            console.log("Success:", result.param0); // TypeScript knows param0 is string
            break;
        case APIResultValues.Tag.Failure:
            console.log("Failure code:", result.param0); // TypeScript knows param0 is number
            break;
        case APIResultValues.Tag.Flag:
            console.log("Flag value:", result.param0); // TypeScript knows param0 is boolean
            break;
        case APIResultValues.Tag.Info:
            console.log("Info case has no associated data");
            break;
        // TypeScript will warn about missing cases
    }
}
```

## How It Works

Enums use **copy semantics** when crossing the Swift/JavaScript boundary:

1. **Case Enums**: Passed as integer tag values (0, 1, 2, ...) representing each case
2. **Raw Value Enums**: Passed using their raw value type (string or integer)
3. **Associated Value Enums**: Tag value passed directly, associated data pushed to type-specific stacks and reconstructed on the receiving side

BridgeJS generates convenience initializers and computed properties for each enum, keeping the glue code minimal and consistent:

```swift
extension Direction {
    init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0: self = .north
        case 1: self = .south
        // ...
        default: return nil
        }
    }

    var bridgeJSRawValue: Int32 {
        switch self {
        case .north: return 0
        case .south: return 1
        // ...
        }
    }
}
```

This differs from classes, which use reference semantics and share state across the boundary.

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
| Case enums | ✅ |
| Raw value enums (`String`) | ✅ |
| Raw value enums (`Int`, `Int32`, etc.) | ✅ |
| Namespace enums (empty enums) | ✅ |
| Associated value enums | ✅ |
| `.tsEnum` style option | ✅ |
| Static functions | ✅ |
| Static properties | ✅ |
| Associated values: `String`, `Int`, `Bool`, `Float`, `Double` | ✅ |
| Associated values: Custom classes/structs | ❌ |
| Associated values: Other enums (case and raw value) | ✅ |
| Associated values: Arrays/Collections | ❌ |
| Associated values: Optionals | ❌ |
| Generics | ❌ |
