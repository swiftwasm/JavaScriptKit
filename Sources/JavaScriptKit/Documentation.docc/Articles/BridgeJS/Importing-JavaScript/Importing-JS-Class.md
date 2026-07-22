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

For a class shipped as an ECMAScript module, put the origin on `@JSClass`:

```javascript
// JavaScript/greeter.js
export class Greeter {
    constructor(name) { this.name = name; }
    static named(name) { return new Greeter(name); }
    greet() { return `Hello, ${this.name}!`; }
}
```

```swift
@JSClass(from: .module("JavaScript/greeter.js"))
struct Greeter {
    @JSFunction init(_ name: String) throws(JSException)
    @JSFunction static func named(_ name: String) throws(JSException) -> Greeter
    @JSFunction func greet() throws(JSException) -> String
}
```

The module's named class export is the root for construction and static methods. Instance methods, getters, and setters operate on the wrapped object and must not specify their own `from:` argument. Use `jsName` on `@JSClass` to select a differently named class export. JavaScript inheritance may be implemented normally in the module; the Swift declaration describes the API visible on the exported class and its instances.

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

**If you chose global or module-backed lookup:** Do not pass the class in `getImports()`; the runtime resolves it from `globalThis` or the copied module.

## Macro options

For optional parameters (`jsName`, `from`, etc.), see the API reference: ``JSClass(jsName:from:)``, ``JSFunction(jsName:from:)``, ``JSGetter(jsName:from:)``, and ``JSSetter(jsName:from:)``.
