# Exporting Swift Optionals to JS

Learn how to use Swift optionals in functions, classes, and enums exported to JavaScript.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/JavaScript/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS provides comprehensive support for Swift optionals across all bridged types. When you use `Optional<T>` or `T?` in Swift, it automatically maps to `T | null` in TypeScript/JavaScript.

Swift optionals are translated to union types with `null` (not `undefined`) because `null` represents an explicit "no value" state that aligns semantically with Swift's `nil`. This design choice ensures consistent null handling across the Swift-JavaScript bridge and avoids the ambiguity that comes with JavaScript's `undefined`.

## Supported Optional Syntax

BridgeJS recognizes all Swift optional syntax variants:

```swift
// All of these work identically
@JS func test(name: String?) -> String? { return name }
@JS func test(name: Optional<String>) -> Optional<String> { return name }
@JS func test(name: Swift.Optional<String>) -> Swift.Optional<String> { return name }
@JS func test(name: Swift.Optional<  String >) -> Swift.Optional< String. > { return name }

// Type aliases work too
typealias OptionalName = String?
@JS func test(name: OptionalName) -> OptionalName { return name }
```

## Optional Parameters

All parameter types can be made optional, including primitives, objects, and enums:

```swift
@JS public func processOptionalData(
    text: String?,          // Optional string
    count: Int?,            // Optional integer
    flag: Bool?,            // Optional boolean
    rate: Double?,          // Optional double
    user: User?             // Optional Swift class
) -> String
```

Generated TypeScript type:

```typescript
export type Exports = {
    processOptionalData(
        text: string | null,
        count: number | null,
        flag: boolean | null,
        rate: number | null,
        user: User | null
    ): string;
}
```

## Optional Return Values

Functions can return optional values of any supported type:

```swift
@JS public func processText(input: String?) -> String?
```

Generated TypeScript type:

```typescript
export type Exports = {
    processText(
        input: string | null
    ): string | null;
}
```

## Optionals in classes

Class properties can be optional with proper getter/setter support.
Constructors can accept optional parameters.

```swift
@JS public class UserProfile {
    @JS public var name: String?
    @JS public var email: String?
    @JS public var age: Int?
    @JS public var avatar: User?

    @JS public init(name: String?)
    @JS public func updateProfile(email: String?, age: Int?)
}

```

Generated TypeScript definition:

```typescript
export interface UserProfile extends SwiftHeapObject {
    name: string | null;
    email: string | null;
    age: number | null;
    avatar: User | null;

    updateProfile(email: string | null, age: number | null): void;
}
export type UserProfile = {
    UserProfile: {
        new(name: string | null): UserProfile;
    }
}
```

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
| Optional primitive parameters: `Int?`, `String?`, etc. | ✅ |
| Optional primitive return values | ✅ |
| Optional object parameters: `MyClass?`, `JSObject?` | ✅ |
| Optional object return values | ✅ |
| Optional enum type parameters and returns | ✅ |
| Optional properties within associated value enum cases | ✅ |
| Optional properties in classes | ✅ |
| Optional constructor parameters | ✅ |
| Type aliases for optionals | ✅ |
| All optional syntax: `T?`, `Optional<T>`, `Swift.Optional<T>` | ✅ |
| Nested optionals: `T??` | ❌ |