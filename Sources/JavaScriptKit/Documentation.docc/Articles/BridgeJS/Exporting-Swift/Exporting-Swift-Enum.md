# Exporting Swift Enums to JS

Learn how to export Swift enums to JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS supports two output styles for enums, controlled by the `enumStyle` parameter:

- **`.const` (default)**: Generates const objects with union types
- **`.tsEnum`**: Generates native TypeScript enum declarations - **only available for case enums and raw value enums with String or numeric raw types**

Examples output of both styles can be found below.

#### Case Enums

**Swift Definition:**

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

**Generated TypeScript Declaration:**

```typescript
// Const object style (default)
const Direction: {
    readonly North: 0;
    readonly South: 1;
    readonly East: 2;
    readonly West: 3;
};
type Direction = typeof Direction[keyof typeof Direction];

// Native TypeScript enum style
enum TSDirection {
    North = 0,
    South = 1,
    East = 2,
    West = 3,
}

const Status: {
    readonly Loading: 0;
    readonly Success: 1;
    readonly Error: 2;
};
type Status = typeof Status[keyof typeof Status];
```

**Usage in TypeScript:**

```typescript
const direction: Direction = exports.Direction.North;
const tsDirection: TSDirection = exports.TSDirection.North;
const status: Status = exports.Status.Loading;

exports.setDirection(exports.Direction.South);
exports.setTSDirection(exports.TSDirection.East);
const currentDirection: Direction = exports.getDirection();
const currentTSDirection: TSDirection = exports.getTSDirection();

const result: Status = exports.processDirection(exports.Direction.East);

function handleDirection(direction: Direction) {
    switch (direction) {
        case exports.Direction.North:
            console.log("Going north");
            break;
        case exports.Direction.South:
            console.log("Going south");
            break;
        // TypeScript will warn about missing cases
    }
}
```

BridgeJS also generates convenience initializers and computed properties for each case-style enum, allowing the rest of the Swift glue code to remain minimal and consistent. This avoids repetitive switch statements in every function that passes enum values between JavaScript and Swift.

```swift
extension Direction {
    init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .north
        case 1:
            self = .south
        case 2:
            self = .east
        case 3:
            self = .west
        default:
            return nil
        }
    }

    var bridgeJSRawValue: Int32 {
        switch self {
        case .north:
            return 0
        case .south:
            return 1
        case .east:
            return 2
        case .west:
            return 3
        }
    }
}
...
@_expose(wasm, "bjs_setDirection")
@_cdecl("bjs_setDirection")
public func _bjs_setDirection(direction: Int32) -> Void {
    #if arch(wasm32)
    setDirection(_: Direction(bridgeJSRawValue: direction)!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getDirection")
@_cdecl("bjs_getDirection")
public func _bjs_getDirection() -> Int32 {
    #if arch(wasm32)
    let ret = getDirection()
    return ret.bridgeJSRawValue
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
```

#### Raw Value Enums

##### String Raw Values

**Swift Definition:**

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

**Generated TypeScript Declaration:**

```typescript
// Const object style (default)
const Theme: {
    readonly Light: "light";
    readonly Dark: "dark";
    readonly Auto: "auto";
};
type Theme = typeof Theme[keyof typeof Theme];

// Native TypeScript enum style
enum TSTheme {
    Light = "light",
    Dark = "dark",
    Auto = "auto",
}
```

**Usage in TypeScript:**

```typescript
// Both styles work similarly in usage
const theme: Theme = exports.Theme.Dark;
const tsTheme: TSTheme = exports.TSTheme.Dark;

exports.setTheme(exports.Theme.Light);
const currentTheme: Theme = exports.getTheme();

const status: HttpStatus = exports.processTheme(exports.Theme.Auto);
```

##### Integer Raw Values

**Swift Definition:**

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

**Generated TypeScript Declaration:**

```typescript
// Const object style (default)
const HttpStatus: {
    readonly Ok: 200;
    readonly NotFound: 404;
    readonly ServerError: 500;
};
type HttpStatus = typeof HttpStatus[keyof typeof HttpStatus];

// Native TypeScript enum style
enum TSHttpStatus {
    Ok = 200,
    NotFound = 404,
    ServerError = 500,
}

const Priority: {
    readonly Lowest: 1;
    readonly Low: 2;
    readonly Medium: 3;
    readonly High: 4;
    readonly Highest: 5;
};
type Priority = typeof Priority[keyof typeof Priority];
```

**Usage in TypeScript:**

```typescript
const status: HttpStatus = exports.HttpStatus.Ok;
const tsStatus: TSHttpStatus = exports.TSHttpStatus.Ok;
const priority: Priority = exports.Priority.High;

exports.setHttpStatus(exports.HttpStatus.NotFound);
exports.setPriority(exports.Priority.Medium);

const convertedPriority: Priority = exports.convertPriority(exports.HttpStatus.Ok);
```

### Namespace Enums

Namespace enums are empty enums (containing no cases) used for organizing related types and functions into hierarchical namespaces.

**Swift Definition:**

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

**Generated TypeScript Declaration:**

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
                call(method: Networking.API.Method): void;
            }
            const Method: {
                readonly Get: 0;
                readonly Post: 1;
            };
            type Method = typeof Method[keyof typeof Method];
        }
        namespace APIV2 {
            namespace Internal {
                class TestServer {
                    constructor();
                    call(method: Internal.SupportedMethod): void;
                }
                const SupportedMethod: {
                    readonly Get: 0;
                    readonly Post: 1;
                };
                type SupportedMethod = typeof SupportedMethod[keyof typeof SupportedMethod];
            }
        }
    }
}
```

**Usage in TypeScript:**

```typescript
// Access nested classes through namespaces
const converter = new globalThis.Utils.Converter();
const result: string = converter.toString(42)

const server = new globalThis.Networking.API.HTTPServer();
const method: Networking.API.Method = globalThis.Networking.API.Method.Get;
server.call(method)

const testServer = new globalThis.Networking.APIV2.Internal.TestServer();
const supportedMethod: Internal.SupportedMethod = globalThis.Networking.APIV2.Internal.SupportedMethod.Post;
testServer.call(supportedMethod);
```

Things to remember when using enums for namespacing:

1. Only enums with no cases will be used for namespaces
2. Top-level enums can use `@JS(namespace: "Custom.Path")` to place themselves in custom namespaces, which will be used as "base namespace" for all nested elements as well
3. Classes and enums nested within namespace enums **cannot** use `@JS(namespace:)` - this would create conflicting namespace declarations

**Invalid Usage:**

```swift
@JS enum Utils {
    // Invalid - nested items cannot specify their own namespace
    @JS(namespace: "Custom") class Helper {
        @JS init() {}
    }
}
```

**Valid Usage:**

```swift
// Valid - top-level enum with explicit namespace
@JS(namespace: "Custom.Utils")
enum Helper {
    @JS class Converter {
        @JS init() {}
    }
}
```

#### Associated Value Enums

Associated value enums are not currently supported, but are planned for future releases.
