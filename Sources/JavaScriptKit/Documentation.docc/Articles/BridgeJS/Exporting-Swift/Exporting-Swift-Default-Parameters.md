# Default Parameters in Exported Swift Functions

Learn how to use default parameter values in Swift functions exported to JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS supports default parameter values for Swift functions exported to JavaScript. When you specify default values in your Swift code, they are automatically applied in the generated JavaScript bindings.

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
@JS public func configure(title: String = "Default", count: Int = 10, enabled: Bool = false) -> String {
    return "\(title): \(count) (\(enabled))"
}
```

```javascript
// Use all defaults
exports.configure();  // "Default: 10 (false)"

// Provide first parameter only
exports.configure("Custom");  // "Custom: 10 (false)"

// Skip middle parameter with undefined
exports.configure("Custom", undefined, true);  // "Custom: 10 (true)"

// Provide all parameters
exports.configure("Custom", 5, true);  // "Custom: 5 (true)"
```

## Supported Default Value Types

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
| Object initialization (no args) | `MyClass()` | `new MyClass()` |
| Object initialization (literal args) | `MyClass("value", 42)` | `new MyClass("value", 42)` |

## Working with Class Instances as Default Parameters

You can use class initialization expressions as default values:

```swift
@JS class Config {
    var setting: String
    
    @JS init(setting: String) {
        self.setting = setting
    }
}

@JS public func process(config: Config = Config(setting: "default")) -> String {
    return "Using: \(config.setting)"
}
```

In JavaScript:

```javascript
// Uses default Config instance
exports.process();  // "Using: default"

// Provides custom Config instance
const custom = new exports.Config("custom");
exports.process(custom);  // "Using: custom"
custom.release();
```

**Limitations for object initialization:**
- Constructor arguments must be literal values (`"text"`, `42`, `true`, `false`, `nil`)
- Complex expressions in constructor arguments are not supported
- Computed properties or method calls as arguments are not supported

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

When a complex default value is needed, make the parameter optional and handle the default in the function body:

```swift
@JS public func process(config: Config? = nil) -> String {
    let actualConfig = config ?? createDefaultConfig()
    return actualConfig.process()
}
```
