# JavaScriptKit

[![Run unit tests](https://github.com/swiftwasm/JavaScriptKit/actions/workflows/test.yml/badge.svg)](https://github.com/swiftwasm/JavaScriptKit/actions/workflows/test.yml)

Swift framework to interact with JavaScript through WebAssembly.

## Quick Start

Check out the [Hello World](https://swiftpackageindex.com/swiftwasm/JavaScriptKit/main/tutorials/javascriptkit/hello-world) tutorial for a step-by-step guide to getting started.

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

Check out the [examples](https://github.com/swiftwasm/JavaScriptKit/tree/main/Examples) for more detailed usage.

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to the project.

## Sponsoring

[Become a gold or platinum sponsor](https://github.com/sponsors/swiftwasm/) and contact maintainers to add your logo on our README on Github with a link to your site.

<a href="https://www.emergetools.com/">
  <img src="https://github.com/swiftwasm/swift/raw/swiftwasm-distribution/assets/sponsors/emergetools.png" width="30%">
</a>
