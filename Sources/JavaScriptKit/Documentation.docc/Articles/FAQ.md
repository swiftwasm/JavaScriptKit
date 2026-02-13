# FAQ

Common questions about JavaScriptKit and BridgeJS.

## Why does the initialization need to be async? Why must I await it?

Initialization is asynchronous because the runtime must **fetch and instantiate the WebAssembly module** before your Swift code can run. That means:

1. **Fetching** the `.wasm` binary (e.g. over the network or from disk).
2. **Instantiating** it with `WebAssembly.instantiate()` (or `instantiateStreaming()`), which compiles the module and allocates the linear memory and table.

Until that completes, there is no WebAssembly instance to call into, so the entry point that sets up the Swift-JavaScript bridge has to be `async` and must be `await`ed from the JavaScript host (e.g. in your `index.js` or HTML script). This matches the standard WebAssembly JavaScript API, which is promise-based.

## Why does every imported JavaScript interface via BridgeJS declare `throws(JSException)`?

This is a conservative, safety-oriented design. Calling into JavaScript can throw at any time. If the Swift call site does not expect errors (i.e. the call is not in a `throws` context and the compiler does not force handling), then when JavaScript throws:

- Control leaves the WebAssembly call frames **without running function epilogues**.
- Even a `do { } catch { }` in Swift does not run its `catch` block in the way you might expect, because unwinding crosses the WASM/JS boundary.
- **`defer` blocks are not executed** in those frames.

That can lead to **inconsistent memory state** and **resource leaks**. To avoid that, every call that might invoke JavaScript is modeled as throwing: all imported JS functions, property accessors, and related operations are marked with `throws(JSException)`. That way:

- The compiler requires you to handle or propagate errors.
- You explicitly decide how to react to JavaScript exceptions (e.g. `try`/`catch`, or propagating `throws`).
- Epilogues and cleanup run in a well-defined way when you handle the error in Swift.

So the “everything throws” rule is there to keep behavior predictable and safe when crossing the Swift-JavaScript boundary.
