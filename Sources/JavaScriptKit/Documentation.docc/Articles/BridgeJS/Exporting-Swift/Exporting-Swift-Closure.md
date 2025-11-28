# Exporting Swift Closures

Learn how to use closure/function types as parameters and return values in BridgeJS.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS supports typed closure parameters and return values, allowing you to pass functions between Swift and JavaScript with full type safety. This enables functional programming patterns like callbacks, higher-order functions, and function composition across the language boundary.

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

## Memory Management

When JavaScript passes a function to Swift, it's automatically stored in `swift.memory` with reference counting. When Swift's closure wrapper is deallocated by ARC, the JavaScript function is released.

When Swift returns a closure to JavaScript, the Swift closure is boxed and automatically released when the JavaScript function is garbage collected.

Both directions use automatic memory management - no manual cleanup required.

## Supported Features

| Feature | Status |
|:--------|:-------|
| Closure Parameters with Supported Types `(String, Int) -> Person` | ✅ |
| Closure Return Value with Supported Types `() -> Person` | ✅ |
| `@escaping` closures | ✅ |
| Optional types in closures |  ✅ |
| Closure-typed `@JS` properties | ❌ |
| Async closures | ❌ |
| Throwing closures | ❌ |

## See Also

- <doc:Supported-Types>
