# Importing TypeScript Classes into Swift

Learn how TypeScript classes map to Swift when importing APIs.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS reads class declarations in your `bridge-js.d.ts` and generates Swift structs that represent JS objects. Constructors, methods, and properties are bridged via thunks that call into your JavaScript implementations at runtime.

## Example

TypeScript definition (`bridge-js.d.ts`):

```typescript
export class Greeter {
    readonly id: string;
    message: string;
    constructor(id: string, name: string);
    greet(): string;
}
```

Generated Swift API:

```swift
struct Greeter {
    init(id: String, name: String) throws(JSException)

    // Properties
    // Readonly property
    var id: String { get throws(JSException) }
    // Writable property
    var message: String { get throws(JSException) }
    func setMessage(_ newValue: String) throws(JSException)

    // Methods
    func greet() throws(JSException) -> String
}
```

Notes:
- Property setters are emitted as `set<PropertyNameCapitalized>(_:)` functions, not Swift `set` accessors since `set` accessors can't have `throws`
- All thunks throw `JSException` if the underlying JS throws.

JavaScript implementation wiring (provided by your app):

```javascript
// index.js
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";

class Greeter {
    readonly id: string;
    message: string;
    constructor(id: string, name: string) { ... }
    greet(): string { ... }
}

const { exports } = await init({
  getImports() {
    return { Greeter };
  }
});
```
