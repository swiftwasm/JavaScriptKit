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

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
| Closure Parameters with Supported Types `(String, Int) -> Person` | ✅ |
| Closure Return Value with Supported Types `() -> Person` | ✅ |
| `@escaping` closures | ✅ |
| Optional types in closures |  ✅ |
| Closure-typed `@JS` properties | ❌ |
| Async closures | ❌ |
| Throwing closures | ❌ |

## See Also

- <doc:Bringing-Swift-Closures-to-JavaScript> - passing or returning closures with ``JSTypedClosure`` and explicit `release()`
- <doc:Supported-Types>
