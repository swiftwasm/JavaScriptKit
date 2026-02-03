# Modeling JavaScript Interfaces with `@JSClass`

`@JS protocol` support has been removed. Use `@JSClass` structs to describe JavaScript objects you consume from Swift instead of exporting Swift protocols.

With `@JSClass`, you declare the shape of a JavaScript object (methods, getters, setters) and BridgeJS generates a lightweight wrapper to call into JS.

```swift
import JavaScriptKit

@JSClass struct Counter {
    @JSGetter var count: Int
    @JSGetter var name: String
    @JSGetter var label: String?

    @JSFunction func increment(by amount: Int)
    @JSFunction func reset()
    @JSFunction func getValue() -> Int
}

@JS class CounterManager {
    @JS var counter: Counter

    @JS init(counter: Counter) {
        self.counter = counter
    }

    @JS func incrementTwice() {
        counter.increment(by: 1)
        counter.increment(by: 1)
    }

    @JS func getCurrentValue() -> Int {
        counter.getValue()
    }

    @JS func setCountValue(_ value: Int) {
        counter.count = value
    }

    @JS func updateLabel(_ newLabel: String?) {
        counter.label = newLabel
    }
}
```

JavaScript can pass any compatible object into `CounterManager`:

```javascript
import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
const { exports } = await init({});

const counterImpl = {
  count: 0,
  name: "JSCounter",
  label: "Default Label",
  increment(amount) { this.count += amount; },
  reset() { this.count = 0; },
  getValue() { return this.count; }
};

const manager = new exports.CounterManager(counterImpl);
manager.incrementTwice();
console.log(manager.getCurrentValue()); // 2
manager.setCountValue(10);
console.log(counterImpl.count); // 10
manager.updateLabel("Custom Label");
console.log(counterImpl.label); // "Custom Label"
```

## Migration notes

- Replace `@JS protocol` declarations with `@JSClass struct` wrappers that mirror the JavaScript interface.
- Swift types implementing protocols can no longer be exported; expose concrete `@JS class` or `@JS struct` types instead.
- Methods and properties from the old protocol should be mapped to `@JSFunction`, `@JSGetter`, and `@JSSetter` members on the `@JSClass` struct.
