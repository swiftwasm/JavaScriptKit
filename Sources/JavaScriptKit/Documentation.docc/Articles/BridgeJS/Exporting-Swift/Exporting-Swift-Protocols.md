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
    var count: Int { get set }
    var name: String { get }
    var label: String? { get set }
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
    
    @JS func getCounterName() -> String {
        return delegate.name
    }
    
    @JS func setCountValue(_ value: Int) {
        delegate.count = value
    }
    
    @JS func updateLabel(_ newLabel: String?) {
        delegate.label = newLabel
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
    name: "JSCounter",
    label: "Default Label",
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
console.log(manager.getCounterName()); // "JSCounter"
manager.setCountValue(10);
console.log(counterImpl.count); // 10

manager.updateLabel("Custom Label");
console.log(counterImpl.label); // "Custom Label"
manager.updateLabel(null);
console.log(counterImpl.label); // null
```

The generated TypeScript interface:

```typescript
export interface Counter {
    count: number;
    readonly name: string;
    label: string | null;
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

    var count: Int {
        get {
            @_extern(wasm, module: "TestModule", name: "bjs_Counter_count_get")
            func _extern_get(this: Int32) -> Int32
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
            return Int.bridgeJSLiftReturn(ret)
        }
        set {
            @_extern(wasm, module: "TestModule", name: "bjs_Counter_count_set")
            func _extern_set(this: Int32, value: Int32)
            _extern_set(this: Int32(bitPattern: jsObject.id), value: newValue.bridgeJSLowerParameter())
        }
    }

    var name: String {
        @_extern(wasm, module: "TestModule", name: "bjs_Counter_name_get")
        func _extern_get(this: Int32)
        _extern_get(this: Int32(bitPattern: jsObject.id))
        return String.bridgeJSLiftReturn()
    }

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
    var count: Int { get set }
    var name: String { get }
    func increment(by amount: Int)
    func reset()
    func getValue() -> Int
}

final class SwiftCounter: Counter {
    var count = 0
    let name = "SwiftCounter"
    
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
console.log(counter.name); // "SwiftCounter"
counter.increment(5);
counter.increment(3);
console.log(counter.getValue()); // 8
console.log(counter.count); // 8
counter.count = 100;
console.log(counter.getValue()); // 100
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
| Method requirements: `func foo(_ param: String?) -> FooClass?` | ✅ |
| Property requirements: `var property: Type { get }` / `var property: Type { get set }` | ✅ |
| Optional parameters / return values in methods | ✅ |
| Optional properties | ✅ |
| Optional protocol methods | ❌ |
| Associated types | ❌ |
| Protocol inheritance | ❌ |
| Protocol composition: `Protocol1 & Protocol2` | ❌ |
| Generics | ❌ |

**Type Limitations:**
- `@JS enum` types are not supported in protocol signatures (use raw values or separate parameters instead)

> Note: Protocol type support matches that of regular `@JS func` and `@JS class` exports. See <doc:Exporting-Swift-Function> and <doc:Exporting-Swift-Optional> for more information.
