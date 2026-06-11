# Bringing Swift Closures to JavaScript

Use ``JSTypedClosure`` to pass or return Swift closures to the JavaScript world with BridgeJS-with type safety and explicit lifetime management.

## Overview

``JSTypedClosure`` wraps a **Swift closure** so you can **pass it or return it to JavaScript** through BridgeJS. The closure lives in Swift; JavaScript receives a function that calls back into that closure when invoked. Use it when:

- You **pass** a Swift closure as an argument to a JavaScript API (e.g. an ``JSFunction(jsName:from:)`` that takes a callback parameter).
- You **return** a Swift closure from Swift exported by ``JS(namespace:enumStyle:)`` so JavaScript can call it later.

Unlike ``JSClosure``, which uses untyped ``JSValue`` arguments and return values, ``JSTypedClosure`` has a concrete **signature** (e.g. `(Int) -> Int` or `(String) -> Void`). BridgeJS generates the glue code for that signature, so you get compile-time type safety when crossing into the JS world.

You **must call** ``JSTypedClosure/release()`` when the closure is no longer needed by JavaScript. After release, any attempt to invoke the closure from JavaScript throws an explicit JS exception.

## Creating a JSTypedClosure

BridgeJS generates an initializer for each closure signature used in your module. Wrap your Swift closure and pass or return it to JavaScript:

```swift
import JavaScriptKit

// Pass a Swift closure to a JS function that expects a callback (Int) -> Int
@JSFunction static func applyTransform(_ value: Int, _ transform: JSTypedClosure<(Int) -> Int>) throws(JSException) -> Int

let double = JSTypedClosure<(Int) -> Int> { $0 * 2 }
defer { double.release() }
let result = try applyTransform(10, double)  // 20 - JS calls back into Swift
```

You can pass or return typed closures with other signatures the same way:

```swift
let sum = JSTypedClosure<(Int, Int) -> Int> { $0 + $1 }
defer { sum.release() }

let log = JSTypedClosure<(String) -> Void> { print($0) }
defer { log.release() }
```

## Throwing typed closures

A ``JSTypedClosure`` signature can be `throws(JSException)`. Exceptions propagate across the boundary: a Swift closure that throws surfaces as a thrown JS error (caught with `try/catch` in JavaScript), and a throwing JS callback surfaces back into Swift as a `JSException`.

```swift
import JavaScriptKit

let parse = JSTypedClosure<(String) throws(JSException) -> Int> { text in
    guard let value = Int(text) else {
        throw JSException(JSError(message: "Not a number: \(text)").jsValue)
    }
    return value
}
defer { parse.release() }
```

Only `throws(JSException)` is supported. Plain `throws` is rejected at build time with a diagnostic, consistent with the rest of BridgeJS (see <doc:Exporting-Swift-Function>).

## Async typed closures

A ``JSTypedClosure`` signature can be `async`. JavaScript receives a function that returns a `Promise`, so the TypeScript shape is `(args) => Promise<R>`. Supported return types mirror `async` functions: `ConvertibleToJSValue` types, `@JS struct`, raw-value / case-only enums, `Void`, and their `Optional` / `Array` / `Dictionary` compositions. Unsupported async return types (associated-value enums, protocols, namespace enums) are diagnosed at build time.

```swift
import JavaScriptKit

let fetchCount = JSTypedClosure<(String) async -> Int> { endpoint in
    try? await Task.sleep(nanoseconds: 10_000_000)
    return endpoint.count
}
defer { fetchCount.release() }
```

```javascript
const count = await fetchCount("/items"); // Promise<number>
```

> Important: Async closures require the JavaScript event loop executor, exactly like `async` functions. Call `JavaScriptEventLoop.installGlobalExecutor()` once during startup before invoking them. There is no special handling for closures.

**Cancellation is a non-goal.** There is no propagation between a Swift `Task` and a JavaScript `Promise` in either direction.

> Note: The reject path of async throwing typed closures is affected by a Swift compiler bug ([swiftlang/swift#89320](https://github.com/swiftlang/swift/issues/89320)); BridgeJS emits a build-time warning for this signature. See <doc:Exporting-Swift-Closure> for details.

## Lifetime and release()

A ``JSTypedClosure`` keeps the Swift closure alive and exposes a JavaScript function that calls into it. To avoid leaks and use-after-free:

1. **Call `release()` exactly once** when the closure is no longer needed by JavaScript (e.g. when the callback is unregistered or the object that held it is released).
2. Prefer **`defer { closure.release() }`** right after creating the closure so cleanup runs when the current scope exits.
3. After `release()`, calling the closure from JavaScript throws an exception with a message that includes the file and line where the ``JSTypedClosure`` was created.

A **FinalizationRegistry** on the JavaScript side may eventually release the Swift storage if you never call `release()`, but that is non-deterministic. Do not rely on it for timely cleanup.

## Getting the underlying JavaScript function

When you need to store or pass the function on the JavaScript side (e.g. to compare identity or attach to a DOM node), use the ``JSTypedClosure/jsObject`` property to get the ``JSObject`` that represents the JavaScript function.

## JSTypedClosure vs JSClosure

Both let you pass or return a Swift closure to the JavaScript world. The difference is how they are typed and which API you use:

| | JSTypedClosure | JSClosure |
|:--|:--|:--|
| **API** | BridgeJS (macros, generated code) | Dynamic ``JSObject`` / ``JSValue`` |
| **Types** | Typed signature, e.g. `(Int) -> Int` | Untyped `([JSValue]) -> JSValue` |
| **Lifetime** | Explicit `release()` required | Explicit `release()` required |
| **Use case** | Passing/returning closures at the BridgeJS boundary with a fixed signature | Passing Swift functions to JS via dynamic APIs (e.g. DOM events) |

Use ``JSTypedClosure`` when you pass or return closures through BridgeJS-declared APIs. Use ``JSClosure`` when you pass a Swift function to JavaScript using the dynamic APIs (e.g. ``JSObject``, ``JSValue``) without generated glue.

## JSTypedClosure vs auto-managed closures

BridgeJS can also expose **plain** Swift closure types (e.g. `(String) -> String`) as parameters and return values; lifetime is then managed automatically via ``FinalizationRegistry`` and no `release()` is required. See <doc:Exporting-Swift-Closure>.

**When returning** a closure from Swift to JavaScript, we **recommend** using ``JSTypedClosure`` and managing lifetime explicitly with `release()`, rather than returning a plain closure type. Explicit release makes cleanup predictable and avoids relying solely on JavaScript GC.

## See also

- ``JSTypedClosure``
- ``JSClosure``
- <doc:Exporting-Swift-Closure>
- <doc:Importing-JavaScript-into-Swift>
- <doc:Supported-Types>
