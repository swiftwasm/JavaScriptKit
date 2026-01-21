# Default Parameters in Exported Swift Functions

Learn how to use default parameter values in Swift functions and constructors exported to JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS supports default parameter values for Swift functions and class constructors exported to JavaScript. When you specify default values in your Swift code, they are automatically applied in the generated JavaScript bindings.

```swift
import JavaScriptKit

@JS public func greet(name: String = "World", enthusiastic: Bool = false) -> String {
    let greeting = "Hello, \(name)"
    return enthusiastic ? "\(greeting)!" : greeting
}
```

In JavaScript, parameters with defaults become optional:

```javascript
exports.greet();                    // "Hello, World"
exports.greet("Alice");             // "Hello, Alice"
exports.greet("Bob", true);         // "Hello, Bob!"
```

The generated TypeScript definitions show optional parameters with JSDoc comments:

```typescript
export type Exports = {
    /**
     * @param name - Optional parameter (default: "World")
     * @param enthusiastic - Optional parameter (default: false)
     */
    greet(name?: string, enthusiastic?: boolean): string;
}
```

## Skipping Parameters With Default Values

To use a default value for a middle parameter while providing later parameters, pass `undefined`:

```swift
@JS public func configure(title: String = "Default", count: Int = -10, enabled: Bool = false) -> String {
    return "\(title): \(count) (\(enabled))"
}
```

```javascript
// Use all defaults
exports.configure();  // "Default: 10 (false)"
exports.configure("Custom");  // "Custom: -10 (false)"
exports.configure("Custom", undefined, true);  // "Custom: -10 (true)"
exports.configure("Custom", 5, true);  // "Custom: 5 (true)"
```

## Default Parameters in Constructors

Constructor parameters also support default values, making it easy to create instances with flexible initialization options:

```swift
@JS class Config {
    @JS var name: String
    @JS var timeout: Int
    @JS var retries: Int
    
    @JS init(name: String = "default", timeout: Int = 30, retries: Int = 3) {
        self.name = name
        self.timeout = timeout
        self.retries = retries
    }
}
```

In JavaScript, you can omit constructor parameters or use `undefined` to skip them:

```javascript
const c1 = new exports.Config();  // name: "default", timeout: 30, retries: 3
const c2 = new exports.Config("custom");  // name: "custom", timeout: 30, retries: 3
const c3 = new exports.Config("api", 60);  // name: "api", timeout: 60, retries: 3
const c4 = new exports.Config("api", undefined, 5);  // name: "api", timeout: 30, retries: 5
```

The generated TypeScript definitions include JSDoc comments for constructor parameters:

```typescript
/**
 * @param name - Optional parameter (default: "default")
 * @param timeout - Optional parameter (default: 30)
 * @param retries - Optional parameter (default: 3)
 */
new(name?: string, timeout?: number, retries?: number): Config;
```

## Supported Default Value Types

The following default value types are supported for both function and constructor parameters:

| Default Value Type | Swift Example | JavaScript/TypeScript |
|:-------------------|:-------------|:----------------------|
| String literals | `"hello"` | `"hello"` |
| Integer literals | `42` | `42` |
| Float literals | `3.14` | `3.14` |
| Double literals | `2.718` | `2.718` |
| Boolean literals | `true`, `false` | `true`, `false` |
| Nil for optionals | `nil` | `null` |
| Enum cases (shorthand) | `.north` | `Direction.North` |
| Enum cases (qualified) | `Direction.north` | `Direction.North` |
| Class initialization (no args) | `MyClass()` | `new MyClass()` |
| Class initialization (literal args) | `MyClass("value", 42)` | `new MyClass("value", 42)` |
| Struct initialization | `Point(x: 1.0, y: 2.0)` | `{ x: 1.0, y: 2.0 }` |

## Working with Class and Struct Defaults

You can use class or struct initialization expressions as default values:

```swift
@JS struct Point {
    var x: Double
    var y: Double
}

@JS class Config {
    var setting: String
    @JS init(setting: String) { self.setting = setting }
}

@JS public func processPoint(point: Point = Point(x: 0.0, y: 0.0)) -> String
@JS public func processConfig(config: Config = Config(setting: "default")) -> String
```

In JavaScript, structs become object literals while classes use constructor calls:

```javascript
exports.processPoint();                     // uses default { x: 0.0, y: 0.0 }
exports.processPoint({ x: 5.0, y: 10.0 });  // custom struct

exports.processConfig();                    // uses default new Config("default")
const custom = new exports.Config("custom");
exports.processConfig(custom);              // custom instance
custom.release();
```

**Requirements:**

- Constructor/initializer arguments must be literal values (`"text"`, `42`, `true`, `false`, `nil`)
- Struct initializers must use labeled arguments (e.g., `Point(x: 1.0, y: 2.0)`)
- Complex expressions, computed properties, or method calls are not supported

## Unsupported Default Value Types

The following expressions are **not supported** as default parameter values:

| Expression Type | Example | Status |
|:----------------|:--------|:-------|
| Method calls | `Date().description` | ❌ |
| Closures | `{ "computed" }()` | ❌ |
| Array literals | `[1, 2, 3]` | ❌ |
| Dictionary literals | `["key": "value"]` | ❌ |
| Binary operations | `10 + 20` | ❌ |
| Complex member access | `Config.shared.value` | ❌ |
| Ternary operators | `flag ? "a" : "b"` | ❌ |
| Object init with complex args | `Config(setting: getValue())` | ❌ |
