# Importing TypeScript Functions into Swift

Learn how functions declared in TypeScript become callable Swift functions.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS reads your `bridge-js.d.ts` and generates Swift thunks that call into JavaScript implementations provided at runtime. Each imported function becomes a top-level Swift function with the same name and a throwing signature.

### Example

TypeScript definition (`bridge-js.d.ts`):

```typescript
export function add(a: number, b: number): number;
export function setTitle(title: string): void;
export function fetchUser(id: string): Promise<User>;
```

Generated Swift signatures:

```swift
func add(a: Double, b: Double) throws(JSException) -> Double
func setTitle(title: String) throws(JSException)
func fetchUser(id: String) throws(JSException) -> JSPromise
```

JavaScript implementation wiring (provided by your app):

```javascript
// index.js
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";

const { exports } = await init({
  getImports() {
    return {
      add: (a, b) => a + b,
      setTitle: (title) => { document.title = title },
      fetchUser: (id) => fetch(`/api/users/${id}`).then(r => r.json()),
    };
  }
});
```

### Error handling

- All imported Swift functions are generated as `throws(JSException)` and will throw if the underlying JS implementation throws.

## Supported features

| Feature | Status |
|:--|:--|
| Primitive parameter/result types: (e.g. `boolean`, `number`) | ✅ |
| `string` parameter/result type | ✅ |
| Enums in signatures | ❌ |
| Async function | ✅ |
| Generics | ❌ |


