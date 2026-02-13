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

- **Export Swift to JavaScript** - Expose Swift functions, classes, and types to JavaScript; the plugin also generates TypeScript definitions (`.d.ts`) for the exported API.
- **Import JavaScript into Swift** - Make JavaScript/TypeScript APIs (functions, classes, globals like `document` or `console`) callable from Swift with type-safe bindings. You can declare bindings with macros in Swift or generate them from a TypeScript declaration file (`bridge-js.d.ts`).

For architecture details, see the [BridgeJS Plugin README](Plugins/BridgeJS/README.md). For package and build setup, see [Setting up BridgeJS](https://swiftpackageindex.com/swiftwasm/JavaScriptKit/documentation/javascriptkit/setting-up-bridgejs) in the documentation.

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

### Importing JavaScript into Swift

Declare bindings in Swift with macros such as `@JSFunction`, `@JSClass`, `@JSGetter`, and `@JSSetter`:

```swift
import JavaScriptKit

@JSClass struct Document {
    @JSFunction func getElementById(_ id: String) throws(JSException) -> HTMLElement
    @JSFunction func createElement(_ tagName: String) throws(JSException) -> HTMLElement
}
@JSGetter(from: .global) var document: Document

@JSClass struct HTMLElement {
    @JSGetter var innerText: String
    @JSSetter func setInnerText(_ newValue: String) throws(JSException)
    @JSFunction func appendChild(_ child: HTMLElement) throws(JSException)
}

@JS func run() throws(JSException) {
    let button = document.createElement("button")!
    try button.setInnerText("Click Me")
    let container = document.getElementById("app")!
    container.appendChild(button)
}
```

You can also generate the same macro-annotated Swift from a TypeScript file (`bridge-js.d.ts`). See [Generating bindings from TypeScript](https://swiftpackageindex.com/swiftwasm/JavaScriptKit/documentation/javascriptkit/generating-from-typescript) in the documentation.

**Learn more:** [Importing JavaScript into Swift](https://swiftpackageindex.com/swiftwasm/JavaScriptKit/documentation/javascriptkit/importing-javascript-into-swift)

### Try It Online

Use the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/) to preview what interfaces will be exposed on the Swift/TypeScript sides.

## Examples

Check out the [examples](https://github.com/swiftwasm/JavaScriptKit/tree/main/Examples) for more detailed usage patterns.

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to the project.

## Sponsoring

[Become a gold or platinum sponsor](https://github.com/sponsors/swiftwasm/) and contact maintainers to add your logo on our README on Github with a link to your site.
