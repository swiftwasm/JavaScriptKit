# Importing TypeScript Interfaces into Swift

Learn how TypeScript interfaces become Swift value types with methods and properties.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS converts TS interfaces to Swift structs conforming to an internal bridging protocol and provides thunks for methods and properties that call into your JavaScript implementations.

> Note: Interfaces are bridged very similarly to classes. Methods and properties map the same way. See <doc:Importing-TS-Class> for more details.

### Example

TypeScript definition (`bridge-js.d.ts`):

```typescript
export interface HTMLElement {
  readonly innerText: string;
  className: string;
  appendChild(child: HTMLElement): void;
}
```

Generated Swift API:

```swift
struct HTMLElement {
    var innerText: String { get throws(JSException) }
    var className: String { get throws(JSException) }
    func setClassName(_ newValue: String) throws(JSException)
    func appendChild(_ child: HTMLElement) throws(JSException)
}
```
