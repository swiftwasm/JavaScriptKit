# Exporting Swift Protocols

Learn how to expose Swift protocols to JavaScript as TypeScript interfaces.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS allows you to export Swift protocols as TypeScript interfaces. JavaScript objects implementing these interfaces can be passed to Swift code, enabling protocol-oriented design across the Swift-JavaScript boundary.

When you mark a protocol with `@JS`, BridgeJS generates:

- A TypeScript interface with the protocol's method signatures
- A Swift wrapper struct (`Any{ProtocolName}`) that conforms to the protocol and bridges calls to JavaScript objects

## Example: Counter Protocol

Mark a Swift protocol with `@JS` to expose it:

```swift
import JavaScriptKit

@JS protocol Counter {
    func increment(by amount: Int)
    func reset()
    func getValue() -> Int
}

@JS class CounterManager {
    var delegate: Counter
    
    @JS init(delegate: Counter) {
        self.delegate = delegate
    }
    
    @JS func incrementTwice() {
        delegate.increment(by: 1)
        delegate.increment(by: 1)
    }
    
    @JS func getCurrentValue() -> Int {
        return delegate.getValue()
    }
}
```

In JavaScript:

```javascript
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
const { exports } = await init({});

// Implement the Counter protocol
const counterImpl = {
    count: 0,
    increment(amount) {
        this.count += amount;
    },
    reset() {
        this.count = 0;
    },
    getValue() {
        return this.count;
    }
};

// Pass the implementation to Swift
const manager = new exports.CounterManager(counterImpl);
manager.incrementTwice();
console.log(manager.getCurrentValue()); // 2
```

The generated TypeScript interface:

```typescript
export interface Counter {
    increment(amount: number): void;
    reset(): void;
    getValue(): number;
}

export type Exports = {
    CounterManager: {
        new(delegate: Counter): CounterManager;
    }
}
```

## Generated Wrapper

BridgeJS generates a Swift wrapper struct for each `@JS` protocol. This wrapper holds a `JSObject` reference and forwards protocol method calls to the JavaScript implementation:

```swift
struct AnyCounter: Counter, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    func increment(by amount: Int) {
        @_extern(wasm, module: "TestModule", name: "bjs_Counter_increment")
        func _extern_increment(this: Int32, amount: Int32)
        _extern_increment(
            this: Int32(bitPattern: jsObject.id), 
            amount: amount.bridgeJSLowerParameter()
        )
    }

    func reset() {
        @_extern(wasm, module: "TestModule", name: "bjs_Counter_reset")
        func _extern_reset(this: Int32)
        _extern_reset(this: Int32(bitPattern: jsObject.id))
    }

    func getValue() -> Int {
        @_extern(wasm, module: "TestModule", name: "bjs_Counter_getValue")
        func _extern_getValue(this: Int32) -> Int32
        let ret = _extern_getValue(this: Int32(bitPattern: jsObject.id))
        return Int.bridgeJSLiftReturn(ret)
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyCounter(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}
```

## Swift Implementation

You can also implement protocols in Swift and use them from JavaScript:

```swift
@JS protocol Counter {
    func increment(by amount: Int)
    func reset()
    func getValue() -> Int
}

final class SwiftCounter: Counter {
    private var count = 0
    
    func increment(by amount: Int) {
        count += amount
    }
    
    func reset() {
        count = 0
    }
    
    func getValue() -> Int {
        return count
    }
}

@JS func createCounter() -> Counter {
    return SwiftCounter()
}
```

From JavaScript:

```javascript
const counter = exports.createCounter();
counter.increment(5);
counter.increment(3);
console.log(counter.getValue()); // 8
counter.reset();
console.log(counter.getValue()); // 0
```

## How It Works

When you pass a JavaScript object implementing a protocol to Swift:

1. **JavaScript Side**: The object is stored in JavaScriptKit's memory heap and its ID is passed as an `Int32` to Swift
2. **Swift Side**: BridgeJS creates an `Any{ProtocolName}` wrapper that holds a `JSObject` reference
3. **Method Calls**: Protocol method calls are forwarded through WASM to the JavaScript implementation
4. **Memory Management**: The `JSObject` reference keeps the JavaScript object alive using JavaScriptKit's retain/release system. When the Swift wrapper is deallocated, the JavaScript object is automatically released.

## Supported Features

| Swift Feature | Status |
|:--------------|:-------|
| Method requirements: `func method()` | ✅ |
| Method requirements with parameters | ✅ |
| Method requirements with return values | ✅ |
| Throwing method requirements: `func method() throws(JSException)` | ✅ |
| Async method requirements: `func method() async` | ✅ |
| Optional protocol methods | ❌ |
| Property requirements: `var property: Type { get }` | ❌ |
| Property requirements: `var property: Type { get set }` | ❌ |
| Associated types | ❌ |
| Protocol inheritance | ❌ |
| Protocol composition: `Protocol1 & Protocol2` | ❌ |
| Generics | ❌ |
