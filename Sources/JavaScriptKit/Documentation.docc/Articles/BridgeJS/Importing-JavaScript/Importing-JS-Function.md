# Importing a JavaScript function into Swift

This guide shows how to bind a JavaScript function so it is callable from Swift using `@JSFunction`.

## Steps

### 1. Declare the function in Swift with `@JSFunction`

Match the JavaScript name and signature. Use Swift types that bridge to the JS types you need (see <doc:Supported-Types>).

```swift
import JavaScriptKit

@JSFunction func add(_ a: Double, _ b: Double) throws(JSException) -> Double
@JSFunction func setTitle(_ title: String) throws(JSException)
```

To bind a function that lives on the JavaScript global object (e.g. `parseInt`, `setTimeout`), add `from: .global`. Use `jsName` when the Swift name differs from the JavaScript name - see the ``JSFunction(jsName:from:)`` API reference for options.

### 2. Provide the implementation at initialization

Return the corresponding function(s) in the object passed to `getImports()` when initializing the WebAssembly module.

```javascript
// index.js
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";

const { exports } = await init({
  getImports() {
    return {
      add: (a, b) => a + b,
      setTitle: (title) => { document.title = title },
    };
  }
});
```

If you used `from: .global`, do not pass the function in `getImports()`; the runtime resolves it from `globalThis`.

### 3. Handle errors

Bound functions are `throws(JSException)`. Call them with `try` or `try?`; they throw when the JavaScript implementation throws.

## Supported features

| Feature | Status |
|:--|:--|
| Primitive parameter/result types (e.g. `Double`, `Bool`) | ✅ |
| `String` parameter/result type | ✅ |
| Async function | ❌ |
| Generics | ❌ |
