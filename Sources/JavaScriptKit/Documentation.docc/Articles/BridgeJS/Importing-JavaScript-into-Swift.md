# Importing JavaScript into Swift

Learn how to make JavaScript APIs callable from your Swift code using macro-annotated bindings.

## Overview

> Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.

> Tip: You can quickly preview what interfaces will be exposed on the Swift/JavaScript/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

You can import JavaScript APIs into Swift in two ways:

1. **Annotate Swift with macros** - Use `@JSFunction`, `@JSClass`, `@JSGetter`, and `@JSSetter` to declare bindings directly in Swift. No TypeScript required. Prefer this to get started.
2. **Generate bindings from TypeScript** - Use a `bridge-js.d.ts` file; the BridgeJS plugin generates the same macro-annotated Swift. See <doc:Generating-from-TypeScript> when you have existing `.d.ts` definitions or many APIs to bind.

This guide covers the macro-based path.

## How to import JavaScript APIs (macro path)

### Step 1: Configure your package

Add the BridgeJS plugin and enable the Extern feature as described in <doc:Setting-up-BridgeJS>.

### Step 2: Declare bindings in Swift with macros

Create Swift declarations that mirror the JavaScript API you want to call.

You can bring JavaScript into Swift in two ways:

- **Inject at initialization**: Declare in Swift and supply the implementation in `getImports()` (e.g. a `today()` function).
- **Import from `globalThis`**: For APIs on the JavaScript global object (e.g. `console`, `document`), use `@JSGetter(from: .global)` so they are read from `globalThis` and you don't pass them in `getImports()`.

```swift
import JavaScriptKit

@JSFunction func today() -> String

@JSClass struct JSConsole {
    @JSFunction func log(_ message: String) throws(JSException)
}
@JSGetter(from: .global) var console: JSConsole

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
```

For full details, see <doc:Importing-JS-Function>, <doc:Importing-JS-Class>, and <doc:Importing-JS-Variable>.

### Step 3: Use the bindings in Swift

Call the bound APIs from Swift:

```swift
import JavaScriptKit

@JS func run() {
    try console.log("Hello from Swift! (\(today()))")

    let button = document.createElement("button")!
    try button.setInnerText("Click Me")
    let container = document.getElementById("app")!
    container.appendChild(button)
}
```

### Step 5: Inject JavaScript implementations (if needed)

Bindings imported from globalThis (e.g. `console`, `document`) are read at runtime and do not go in `getImports()`. Only APIs you inject at initialization must be supplied there:

```javascript
// index.js
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";

const { exports } = await init({
    getImports() {
        return {
            today: () => new Date().toString()
        };
    }
});

exports.run();
```

## Topics

- <doc:Importing-JS-Function>
- <doc:Importing-JS-Class>
- <doc:Importing-JS-Variable>