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
@JSClass(from: .snippet("/JavaScript/greeter.js"))
struct Greeter {
    @JSFunction init(_ name: String) throws(JSException)
    @JSFunction static func named(_ name: String) throws(JSException) -> Greeter
    @JSFunction func greet() throws(JSException) -> String
}
```

To wrap a class exported by an installed npm package, use `from: .module(...)`. Pass `jsName: .default` when the class is the module's default export:

```swift
@JSClass(jsName: "File", from: .module("@bjorn3/browser_wasi_shim"))
struct WasiFile {
    @JSFunction init(_ data: JSObject) throws(JSException)
    @JSGetter var size: Int64
}
```

Nothing is copied for these, and you are responsible for making them resolvable at load time; see <doc:Unsupported-Features>.

The path's leading `/` denotes the Swift target root, not the filesystem root. The module's named class export is the root for construction and static methods. Instance methods, getters, and setters operate on the wrapped object and must not specify their own `from:` argument. Use `jsName` on `@JSClass` to select a differently named class export. JavaScript inheritance may be implemented normally in the module; the Swift declaration describes the API visible on the exported class and its instances.

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

## Noncopyable wrappers

A `@JSClass` struct declared `~Copyable` is a noncopyable wrapper. Each value holds its own reference to the JavaScript object, with no `JSObject` instance behind it, and releases the reference when the value is destroyed.

```swift
@JSClass struct Element: ~Copyable {
    @JSFunction func appendChild(_ child: borrowing Element) throws(JSException)
    @JSFunction func removeChild(_ child: consuming Element) throws(JSException)
    @JSGetterFunction func firstElementChild() throws(JSException) -> Element?
}
```

- A parameter of a wrapper type is `borrowing` or `consuming`. A `borrowing` parameter lends the reference for the call; a `consuming` one releases it when the call returns.
- Read a property of a wrapper type with `@JSGetterFunction func name() throws(JSException) -> T`. Swift rejects a throwing getter of a noncopyable type, so BridgeJS reports an error for `@JSGetter var` of a wrapper type.
- An array of wrappers is a `UniqueArray`, which Swift 6.4's standard library adds; `[T]` of a wrapper type is an error. If the package also builds with older Swift versions, put the declarations that name `UniqueArray` inside `#if compiler(>=6.4)`. BridgeJS wraps the code it generates for a declaration in the same `#if` only when the declaration's signature names `UniqueArray`, so keep other `@JS` and `@JSFunction` declarations outside it.
- Dictionaries of wrappers are not supported, and neither are wrapper-typed `@JS struct` fields or `@JS enum` associated values.
- A wrapper is not `Sendable`: its reference is valid only on the thread that created it.
- `init(unsafelyWrapping:)` converts a `JSObject` into a wrapper. It takes over the `JSObject`'s reference when no other Swift reference to that `JSObject` exists, and otherwise takes a reference of its own. `withView(as:_:)` lends the object to a closure as another wrapper type without taking a reference.
- `UniqueArray` is available from version 27 of Apple's operating systems. BridgeJS marks the declarations it generates that name `UniqueArray` with `@available(anyAppleOS 27.0, *)`, so a native build for an older version needs the same attribute on your declarations that name `UniqueArray`. A stored `UniqueArray` property of a `@JS class` cannot take the attribute, so such a class builds natively only for version 27 and later. WebAssembly builds are not affected.

## Macro options

For optional parameters (`jsName`, `from`, etc.), see the API reference: ``JSClass(jsName:from:)``, ``JSFunction(jsName:from:)``, ``JSGetter(jsName:from:)``, and ``JSSetter(jsName:from:)``.
