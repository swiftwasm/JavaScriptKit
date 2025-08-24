# Importing TypeScript Type Aliases into Swift

Understand how TypeScript type aliases are handled when generating Swift bindings.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS resolves TypeScript aliases while importing. If an alias names an anonymous object type, Swift will generate a corresponding bridged struct using that name.

> Note: When a type alias names an anonymous object type, its bridging behavior (constructors not applicable, but methods/properties if referenced) mirrors class/interface importing. See <doc:Importing-TS-Class> for more details.

### Examples

```typescript
// Primitive alias → maps to the underlying primitive
export type Price = number;

// Object-shaped alias with a name → becomes a named bridged type when referenced
export type User = {
  readonly id: string;
  name: string;
  age: Price;
}

export function getUser(): User;
```

Generated Swift (simplified):

```swift
// Price → Double

struct User {
    // Readonly property
    var id: String { get throws(JSException) }

    // Writable properties
    var name: String { get throws(JSException) }
    func setName(_ newValue: String) throws(JSException)

    var age: Double { get throws(JSException) }
    func setAge(_ newValue: Double) throws(JSException)
}

func getUser() throws(JSException) -> User
```
