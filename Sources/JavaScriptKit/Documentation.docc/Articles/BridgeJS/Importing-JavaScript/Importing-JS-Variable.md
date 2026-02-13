# Importing a global JavaScript variable into Swift

This guide shows how to bind a JavaScript global variable (or any property you provide at initialization) so you can read and optionally write it from Swift using `@JSGetter` and `@JSSetter`.

## Steps

### 1. Declare the variable in Swift with `@JSGetter`

Use a type that bridges to the JavaScript value (see <doc:Supported-Types>). For object-shaped values, use a struct conforming to the bridged type (e.g. a `@JSClass` struct).

```swift
import JavaScriptKit

@JSGetter(from: .global) var document: Document
@JSGetter(from: .global) var myConfig: String
```

To bind a variable that is not on `globalThis`, omit `from: .global` and supply the value in `getImports()` in the next step. Use `jsName` when the Swift name differs from the JavaScript property name - see the ``JSGetter(jsName:from:)`` API reference.

### 2. Add a setter for writable variables (optional)

If the JavaScript property is writable and you need to set it from Swift, add a corresponding `@JSSetter` function. Property setters are exposed as functions (e.g. `setMyConfig(_:)`) because Swift property setters cannot `throw`.

```swift
@JSGetter(from: .global) var myConfig: String
@JSSetter(from: .global) func setMyConfig(_ newValue: String) throws(JSException)
```

### 3. Provide the value at initialization (injected only)

If you did **not** use `from: .global`, pass the value in the object returned by `getImports()` when initializing the WebAssembly module.

```javascript
// index.js
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";

const { exports } = await init({
  getImports() {
    return {
      myConfig: "production",
    };
  }
});
```

If you used `from: .global`, do not pass the variable in `getImports()`; the runtime reads it from `globalThis`.

## Supported features

| Feature | Status |
|:--|:--|
| Read-only global (e.g. `document`, `console`) | ✅ |
| Writable global | ✅ (`@JSSetter`) |
| Injected variable (via `getImports()`) | ✅ |

## See also

- ``JSGetter(jsName:from:)``
- ``JSSetter(jsName:from:)``
