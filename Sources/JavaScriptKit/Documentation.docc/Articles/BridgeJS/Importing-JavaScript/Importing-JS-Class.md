# Importing a JavaScript class or object into Swift

This guide shows how to bind a JavaScript class (or object shape) so you can construct and use it from Swift with `@JSClass`.

## Steps

### 1. Declare a Swift struct with `@JSClass`

Add a struct that mirrors the JavaScript class. Use `@JSFunction` for the initializer and for methods, and `@JSGetter` / `@JSSetter` for properties. Property setters are exposed as functions (e.g. `setMessage(_:)`) because Swift property setters cannot `throw`.

```swift
import JavaScriptKit

@JSClass struct Greeter {
    @JSFunction init(id: String, name: String) throws(JSException)

    @JSGetter var id: String
    @JSGetter var message: String
    @JSSetter func setMessage(_ newValue: String) throws(JSException)

    @JSFunction func greet() throws(JSException) -> String
}
```

If the class is on `globalThis`, add `from: .global` to `@JSClass` and omit the type from `getImports()` in the next step.

### 2. Wire the JavaScript side

**If you chose injection:** Implement the class in JavaScript and pass it in `getImports()`.

```javascript
// index.js
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";

class Greeter {
    constructor(id, name) { /* ... */ }
    get id() { /* ... */ }
    get message() { /* ... */ }
    set message(value) { /* ... */ }
    greet() { /* ... */ }
}

const { exports } = await init({
  getImports() {
    return { Greeter };
  }
});
```

**If you chose global:** Do not pass the class in `getImports()`; the runtime will resolve it from `globalThis`.

## Macro options

For optional parameters (`jsName`, `from`, etc.), see the API reference: ``JSClass(jsName:from:)``, ``JSFunction(jsName:from:)``, ``JSGetter(jsName:from:)``, and ``JSSetter(jsName:from:)``.
