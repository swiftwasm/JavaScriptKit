# Exporting Swift Closures to JS

Learn how to use closure/function types as parameters and return values in BridgeJS.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/JavaScript/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS supports typed closure parameters and return values, allowing you to pass or return Swift closures to JavaScript with full type safety. **Lifetime is automatic**: you use plain Swift closure types (e.g. `(String) -> String`); the runtime releases them when no longer needed-no manual `release()` required. This enables callbacks, higher-order functions, and function composition across the boundary.

**Recommendation:** When **returning** a closure from Swift to JavaScript, prefer returning a ``JSTypedClosure`` and managing its lifetime explicitly (see <doc:Bringing-Swift-Closures-to-JavaScript>). Explicit `release()` makes cleanup predictable and avoids relying solely on JavaScript garbage collection. Use plain closure types (this article) when you want fully automatic lifetime or when passing closures only as parameters into your exported API.

## Example

```swift
import JavaScriptKit

@JS class TextProcessor {
    private var transform: (String) -> String

    @JS init(transform: @escaping (String) -> String) {
        self.transform = transform
    }

    @JS func processWithPerson(_ person: Person, formatter: (Person) -> String) -> String {
        return formatter(person)
    }

    @JS func makePersonCreator(defaultName: String) -> (String) -> Person {
        return { name in
            let fullName = name.isEmpty ? defaultName : name
            return Person(name: fullName)
        }
    }

    @JS func getTransform() -> (String) -> String {
        return transform
    }
}
```

In JavaScript:

```javascript
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
const { exports } = await init({});

// Pass closure to initializer
const processor = new exports.TextProcessor((text) => text.toUpperCase());
console.log(processor.getTransform()("hello")); // "HELLO"

// Pass closure with Swift class parameter
const person = new exports.Person("Alice");
const result = processor.processWithPerson(person, (p) => {
    return `${p.name}: ${p.greet()}`;
});
console.log(result); // "Alice: Hello, Alice!"

// Call returned closure
const creator = processor.makePersonCreator("Default");
const p1 = creator("Bob");
console.log(p1.greet()); // "Hello, Bob!"
p1.release();

const p2 = creator(""); // Empty uses default
console.log(p2.greet()); // "Hello, Default!"
p2.release();

person.release();
processor.release();
```

The generated TypeScript declarations:

```typescript
export interface TextProcessor extends SwiftHeapObject {
    processWithPerson(
        person: Person,
        formatter: (arg0: Person) => string
    ): string;
    makePersonCreator(
        defaultName: string
    ): (arg0: string) => Person;
    getTransform(): (arg0: string) => string;
}

export type Exports = {
    TextProcessor: {
        new(transform: (arg0: string) => string): TextProcessor
    };
}
```

## How It Works

Closures use **reference semantics** when crossing the Swift/JavaScript boundary:

1. **JavaScript → Swift**: When JavaScript passes a function to Swift, it's stored in `swift.memory` with reference counting. When Swift's closure wrapper is deallocated by ARC, the JavaScript function is released.
2. **Swift → JavaScript**: When Swift returns a closure to JavaScript, the Swift closure is boxed and automatically released when the JavaScript function is garbage collected.
3. **Memory Management**: Both directions use automatic memory management via `FinalizationRegistry` - no manual cleanup required.

This differs from structs and arrays, which use copy semantics and transfer data by value.

When you **return** a closure to JavaScript, we recommend using ``JSTypedClosure`` and calling `release()` when the closure is no longer needed, instead of returning a plain closure type. See <doc:Bringing-Swift-Closures-to-JavaScript>.

## Throwing closures

Closures can throw JavaScript errors across the boundary using `throws(JSException)`, in both directions. Exceptions propagate just like they do for throwing functions (see <doc:Exporting-Swift-Function>).

A Swift closure handed to JavaScript that throws surfaces as a thrown JS error, so JavaScript catches it with `try/catch`:

```swift
import JavaScriptKit

@JS func makeParser() -> (String) throws(JSException) -> Int {
    return { text in
        guard let value = Int(text) else {
            throw JSException(JSError(message: "Not a number: \(text)").jsValue)
        }
        return value
    }
}
```

```javascript
const parse = exports.makeParser();
try {
    console.log(parse("42")); // 42
    parse("oops");            // throws
} catch (e) {
    console.error("parse failed:", e);
}
```

A throwing JavaScript callback passed into Swift surfaces back into Swift as a `JSException`, which the Swift call site rethrows:

```swift
import JavaScriptKit

@JS func runValidator(_ input: String, validate: (String) throws(JSException) -> Bool) throws(JSException) -> Bool {
    return try validate(input)
}
```

```javascript
exports.runValidator("ok", (value) => {
    if (value.length === 0) {
        throw new Error("empty input");
    }
    return true;
});
```

Notes:
- Only `throws(JSException)` is supported. Plain `throws` is rejected at build time with a diagnostic.
- Thrown values are surfaced to JS as normal JS exceptions, and JS exceptions thrown by callbacks are surfaced into Swift as a `JSException`.

## Async closures

Closures can be `async` in both directions, just like `async` functions (see <doc:Exporting-Swift-Function>). An async closure is exposed to JavaScript as a function that returns a `Promise`, so its TypeScript shape is `(args) => Promise<R>`.

> Important: Async closures require the JavaScript event loop executor to be installed, exactly like `async` functions. Call `JavaScriptEventLoop.installGlobalExecutor()` once during startup before invoking async closures.

### Direction A - Swift awaits a JavaScript async callback

A Swift `@JS func` can take a JavaScript async callback typed as `(A) async throws(JSException) -> R`. Swift `await`s the `Promise` the callback returns. Both resolution and rejection work: a rejected `Promise` surfaces into Swift as a `JSException`.

```swift
import JavaScriptKit

@JS func loadAll(_ keys: [String], fetch: (String) async throws(JSException) -> String) async throws(JSException) -> [String] {
    var results: [String] = []
    for key in keys {
        results.append(try await fetch(key))
    }
    return results
}
```

```javascript
const values = await exports.loadAll(["a", "b"], async (key) => {
    const response = await fetch(`/items/${key}`);
    if (!response.ok) throw new Error(`failed: ${key}`); // rejects → JSException in Swift
    return response.text();
});
```

### Direction B - a Swift async closure handed to JavaScript

A Swift async closure returned to JavaScript (as a plain async closure type or a ``JSTypedClosure``) becomes a function JavaScript `await`s. Supported return types mirror async functions: `ConvertibleToJSValue` types, `@JS struct`, raw-value / case-only enums, `Void`, and their `Optional` / `Array` / `Dictionary` compositions. Unsupported async return types (associated-value enums, protocols, namespace enums) are diagnosed at build time.

```swift
import JavaScriptKit

@JS struct Point {
    let x: Double
    let y: Double
}

// Async closure returning a @JS struct
@JS func makePointLoader() -> JSTypedClosure<(Double, Double) async -> Point> {
    let loader = JSTypedClosure<(Double, Double) async -> Point> { x, y in
        try? await Task.sleep(nanoseconds: 10_000_000)
        return Point(x: x, y: y)
    }
    return loader
}

// Async closure returning Void
@JS func makeLogger() -> JSTypedClosure<(String) async -> Void> {
    return JSTypedClosure<(String) async -> Void> { message in
        try? await Task.sleep(nanoseconds: 10_000_000)
        print(message)
    }
}
```

```javascript
const loadPoint = exports.makePointLoader();
const point = await loadPoint(1, 2); // Promise<Point>
console.log(point.x, point.y);       // 1 2
loadPoint.release();

const log = exports.makeLogger();
await log("hello"); // Promise<void>
log.release();
```

The generated TypeScript declarations:

```typescript
export type Exports = {
    makePointLoader(): (arg0: number, arg1: number) => Promise<Point>;
    makeLogger(): (arg0: string) => Promise<void>;
}
```

Notes:
- The same `JavaScriptEventLoop.installGlobalExecutor()` requirement applies as for async functions; there is no special handling for closures.
- **Cancellation is a non-goal.** There is no propagation between a Swift `Task` and a JavaScript `Promise` in either direction; cancelling one side does not cancel the other.

> Warning: When an async throwing closure handed to JavaScript throws, the error is currently lost instead of rejecting the `Promise` with it, due to a Swift compiler bug on `wasm32` ([swiftlang/swift#89320](https://github.com/swiftlang/swift/issues/89320), fix in progress in [swiftlang/swift#89715](https://github.com/swiftlang/swift/pull/89715)). Closures that capture state are unaffected, as are throwing JavaScript callbacks passed into Swift. BridgeJS emits a build-time warning for this signature.

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
| Closure Parameters with Supported Types `(String, Int) -> Person` | ✅ |
| Closure Return Value with Supported Types `() -> Person` | ✅ |
| `@escaping` closures | ✅ |
| Optional types in closures |  ✅ |
| Closure-typed `@JS` properties | ❌ |
| Async closures `(A) async -> B` | ✅ |
| Async throwing closures `(A) async throws(JSException) -> B` | ✅ (reject path of closures handed to JS pending [swiftlang/swift#89320](https://github.com/swiftlang/swift/issues/89320)) |
| Throwing closures `(A) throws(JSException) -> B` | ✅ |

## See Also

- <doc:Bringing-Swift-Closures-to-JavaScript> - passing or returning closures with ``JSTypedClosure`` and explicit `release()`
- <doc:Supported-Types>
