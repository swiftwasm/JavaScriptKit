# JavaScriptKit

[![Run unit tests](https://github.com/swiftwasm/JavaScriptKit/actions/workflows/test.yml/badge.svg)](https://github.com/swiftwasm/JavaScriptKit/actions/workflows/test.yml)
[![Documentation](https://img.shields.io/badge/docc-read_documentation-blue)](https://swiftpackageindex.com/swiftwasm/JavaScriptKit/documentation)

Swift framework to interact with JavaScript through WebAssembly.

## Quick Start

Check out the [Hello World](https://swiftpackageindex.com/swiftwasm/JavaScriptKit/tutorials/javascriptkit/hello-world) tutorial for a step-by-step guide to getting started.

## Overview

JavaScriptKit provides a seamless way to interact with JavaScript from Swift code when compiled to WebAssembly. It allows Swift developers to:

- Access JavaScript objects and functions
- Create closures that can be called from JavaScript
- Convert between Swift and JavaScript data types
- Use JavaScript promises with Swift's `async/await`
- Work with multi-threading

```swift
import JavaScriptKit

// Access global JavaScript objects
let document = JSObject.global.document

// Create and manipulate DOM elements
var div = document.createElement("div")
div.innerText = "Hello from Swift!"
_ = document.body.appendChild(div)

// Handle events with Swift closures
var button = document.createElement("button")
button.innerText = "Click me"
button.onclick = .object(JSClosure { _ in
    JSObject.global.alert!("Button clicked!")
    return .undefined
})
_ = document.body.appendChild(button)
```

**Learn more:** [JavaScript Interop Cheat Sheet](https://swiftpackageindex.com/swiftwasm/JavaScriptKit/documentation/javascriptkit/javascript-interop-cheat-sheet)

## BridgeJS Plugin

> **Note:** BridgeJS is experimental. APIs may change in future releases.

BridgeJS provides easy interoperability between Swift and JavaScript/TypeScript. It enables:

- **Exporting Swift APIs to JavaScript**: Make your Swift code callable from JavaScript
- **Importing TypeScript APIs into Swift**: Use JavaScript APIs with type safety in Swift

For architecture details, see the [BridgeJS Plugin README](Plugins/BridgeJS/README.md).

### Exporting Swift to JavaScript

Mark Swift code with `@JS` to make it callable from JavaScript:

```swift
import JavaScriptKit

@JS class Greeter {
    @JS var name: String

    @JS init(name: String) {
        self.name = name
    }

    @JS func greet() -> String {
        return "Hello, \(name)!"
    }
}
```

**JavaScript usage:**
```javascript
const greeter = new exports.Greeter("World");
console.log(greeter.greet()); // "Hello, World!"
```

**Learn more:** [Exporting Swift to JavaScript](https://swiftpackageindex.com/swiftwasm/JavaScriptKit/documentation/javascriptkit/exporting-swift-to-javascript)

### Importing TypeScript into Swift

Define TypeScript interfaces and BridgeJS generates type-safe Swift bindings:

```typescript
// bridge-js.d.ts
interface Document {
    title: string;
    getElementById(id: string): HTMLElement;
    createElement(tagName: string): HTMLElement;
}

export function getDocument(): Document;
```

**Swift usage:**
```swift
@JS func run() throws(JSException) {
    let document = try getDocument()
    try document.setTitle("My Swift App")
    let button = try document.createElement("button")
    try button.setInnerText("Click Me")
}
```

**Learn more:** [Importing TypeScript into Swift](https://swiftpackageindex.com/swiftwasm/JavaScriptKit/documentation/javascriptkit/importing-typescript-into-swift)

### Try It Online

Use the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/) to preview what interfaces will be exposed on the Swift/TypeScript sides.

## Examples

Check out the [examples](https://github.com/swiftwasm/JavaScriptKit/tree/main/Examples) for more detailed usage patterns.

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to the project.

## Sponsoring

[Become a gold or platinum sponsor](https://github.com/sponsors/swiftwasm/) and contact maintainers to add your logo on our README on Github with a link to your site.
