# JavaScript Interop Cheat Sheet

Practical recipes for manipulating JavaScript values from Swift with JavaScriptKit. Each section shows the shortest path to access, call, or convert the APIs you interact with the most.

## Access JavaScript Values

### Global entry points

```swift
let global: JSObject = JSObject.global
let document: JSObject = global.document.object!
let math: JSObject = global.Math.object!
```

- Use ``JSObject/global`` for `globalThis` and drill into properties.
- Accessing through [dynamic member lookup](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0195-dynamic-member-lookup.md) returns ``JSValue``; call `.object`, `.number`, `.string`, etc. to unwrap a concrete type (callable values are represented as ``JSObject`` as well).
- Prefer storing ``JSObject`` references (`document` above) when you call multiple members to avoid repeated conversions (for performance).

### Properties, subscripts, and symbols

```swift
extension JSObject {
    public subscript(_ name: String) -> JSValue { get set }
    public subscript(_ index: Int) -> JSValue { get set }
    public subscript(_ name: JSSymbol) -> JSValue { get set }
    /// Use this API when you want to avoid repeated String serialization overhead
    public subscript(_ name: JSString) -> JSValue { get set }
    /// A convenience method of `subscript(_ name: String) -> JSValue`
    /// to access the member through Dynamic Member Lookup.
    /// ```swift
    /// let document: JSObject = JSObject.global.document.object!
    /// ```
    public subscript(dynamicMember name: String) -> JSValue { get set }
}
extension JSValue {
    /// An unsafe convenience method of `JSObject.subscript(_ index: Int) -> JSValue`
    /// - Precondition: `self` must be a JavaScript Object.
    public subscript(dynamicMember name: String) -> JSValue
    public subscript(_ index: Int) -> JSValue
}
```

**Example**

```swift
document.title = .string("Swift <3 Web")
let obj = JSObject.global.myObject.object!
let value = obj["key"].string  // Access object property with String
let propName = JSString("key")
let value2 = obj[propName].string  // Access object property with JSString

let array = JSObject.global.Array.object!.new(1, 2, 3)
array[0] = .number(10)  // Assign to array index

let symbol = JSSymbol("secret")
let data = obj[symbol].object
```

## Call Functions and Methods

```swift
extension JSObject {
    /// Call this function with given `arguments` using [Callable values of user-defined nominal types](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0253-callable.md)
    /// ```swift
    /// let alert = JSObject.global.alert.object!
    /// alert("Hello from Swift")
    /// ```
    public func callAsFunction(_ arguments: ConvertibleToJSValue...) -> JSValue
    public func callAsFunction(this: JSObject, _ arguments: ConvertibleToJSValue...) -> JSValue

    /// Returns the `name` member method binding this object as `this` context.
    public subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)? { get }
    public subscript(_ name: JSString) -> ((ConvertibleToJSValue...) -> JSValue)? { get }
    /// A convenience method of `subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)?` to access the member through Dynamic Member Lookup.
    /// ```swift
    /// let document = JSObject.global.document.object!
    /// let divElement = document.createElement!("div")
    /// ```
    public subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) -> JSValue)? { get }
}
extension JSValue {
    /// An unsafe convenience method of `JSObject.subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)?`
    /// - Precondition: `self` must be a JavaScript Object and specified member should be a callable object.
    public subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) -> JSValue)
}
```

**Example**

```swift
let alert = JSObject.global.alert.object!
alert("Hello from Swift")

let console = JSObject.global.console.object!
_ = console.log!("Cheat sheet ready", 1, true)

let document = JSObject.global.document.object!
let button = document.createElement!("button").object!
_ = button.classList.add("primary")
```

- **Dynamic Member Lookup and `!`**: When calling a method on ``JSObject`` (like `createElement!`), it returns an optional closure, so `!` is used to unwrap and call it. In contrast, calling on ``JSValue`` (like `button.classList.add`) returns a non-optional closure that traps on failure for convenience.

Need to bind manually? Grab the function object and supply `this`:

```swift
let appendChild = document.body.appendChild.object!
appendChild(this: document.body.object!, document.createElement!("div"))
```

### Passing options objects

When JavaScript APIs require an options object, create one using ``JSObject``:

```swift
public class JSObject: ExpressibleByDictionaryLiteral {
    /// Creates an empty JavaScript object (equivalent to {} or new Object())
    public init()
    
    /// Creates a new object with the key-value pairs in the dictionary literal
    public init(dictionaryLiteral elements: (String, JSValue)...)
}
```

**Example**

```swift
// Create options object with dictionary literal
let listeningOptions: JSObject = ["once": .boolean(true), "passive": .boolean(true)]
button.addEventListener!("click", handler, listeningOptions)

// Create empty object and add properties
let fetchOptions = JSObject()
fetchOptions["method"] = .string("POST")
let headers: JSObject = ["Content-Type": .string("application/json")]
fetchOptions["headers"] = headers.jsValue
fetchOptions["body"] = "{}".jsValue

let fetch = JSObject.global.fetch.object!
let response = fetch("https://api.example.com", fetchOptions)
```

### Throwing JavaScript

JavaScript exceptions surface as ``JSException``. Wrap the function (or object) in a throwing helper.

```swift
// Method
let JSON = JSObject.global.JSON.object!
do {
    let value = try JSON.throwing.parse!("{\"flag\":true}")
} catch let error as JSException {
    print("Invalid JSON", error)
}

// Function
let validateAge: JSObject = JSObject.global.validateAge.object!
do {
    try validateAge.throws(-3)
} catch let error as JSException {
    print("Validation failed:", error)
}
```

- Use ``JSObject/throwing`` to access object methods that may throw JavaScript exceptions.
- Use ``JSObject/throws`` to call the callable object itself that may throw JavaScript exceptions.

### Constructors and `new`

```swift
let url = JSObject.global.URL.object!.new("https://example.com", "https://example.com")
let searchParams = url.searchParams.object!
```

Use ``JSThrowingFunction/new(_:)`` (via `throws.new`) when the constructor can throw.

## Convert Between Swift and JavaScript

### Swift -> JavaScript

Types conforming to ``ConvertibleToJSValue`` can be converted via the `.jsValue` property. Conversion behavior depends on the context:

| Swift type | JavaScript result | Notes |
|------------|------------------|-------|
| `Bool` | `JSValue.boolean(Bool)` | |
| `String` | `JSValue.string(JSString)` | Wrapped in ``JSString`` to avoid extra copies |
| `Int`, `UInt`, `Int8-32`, `UInt8-32`, `Float`, `Double` | `JSValue.number(Double)` | All numeric types convert to `Double` |
| `Int64`, `UInt64` | `JSValue.bigInt(JSBigInt)` | Converted to `BigInt` (requires `import JavaScriptBigIntSupport`) |
| `Data` | `Uint8Array` | Converted to `Uint8Array` (requires `import JavaScriptFoundationCompat`) |
| `Array<Element>` where `Element: ConvertibleToJSValue` | JavaScript Array | Each element converted via `.jsValue` |
| `Dictionary<String, Value>` where `Value: ConvertibleToJSValue` | Plain JavaScript object | Keys must be `String` |
| `Optional.none` | `JSValue.null` | Use ``JSValue/undefined`` when you specifically need `undefined` |
| `Optional.some(wrapped)` | `wrapped.jsValue` | |
| ``JSValue``, ``JSObject``, ``JSString`` | Passed through | No conversion needed |

**Function arguments**: Automatic conversion when passing to JavaScript functions:

```swift
let alert = JSObject.global.alert.object!
alert("Hello")  // String automatically converts via .jsValue

let console = JSObject.global.console.object!
console.log!("Count", 42, true)  // All arguments auto-convert
```

**Property assignment**: Explicit conversion required:

```swift
let obj = JSObject.global.myObject.object!
let count: Int = 42
let message = "Hello"

obj["count"] = count.jsValue
obj["message"] = message.jsValue

obj.count = count.jsValue
obj.message = message.jsValue

// Alternative: use JSValue static methods
obj["count"] = .number(Double(count))
obj.message = .string(message)
divElement.innerText = .string("Count \(count)")
canvasElement.width = .number(Double(size))
```

### JavaScript -> Swift

Access JavaScript values through ``JSValue`` accessors:

```swift
let jsValue: JSValue = // ... some JavaScript value

// Primitive types via direct accessors (most common pattern)
let message: String? = jsValue.string
let n: Double? = jsValue.number
let flag: Bool? = jsValue.boolean
let obj: JSObject? = jsValue.object

// Access nested properties through JSObject subscripts
if let obj = jsValue.object {
    let nested = obj.key.string
    let arrayItem = obj.items[0].string
    let count = obj.count.number
}

// Arrays (if elements conform to ConstructibleFromJSValue)
if let items = [String].construct(from: jsValue) {
    // Use items
}

// Dictionaries (if values conform to ConstructibleFromJSValue)
if let data = [String: Int].construct(from: jsValue) {
    // Use data
}

// For complex Decodable types, use JSValueDecoder
struct User: Decodable {
    let name: String
    let age: Int
}
let user = try JSValueDecoder().decode(User.self, from: jsValue)
```

## Pass Swift Closures back to JavaScript

```swift
public class JSClosure: JSObject, JSClosureProtocol {
    public init(_ body: @escaping (sending [JSValue]) -> JSValue)
    public static func async(
        priority: TaskPriority? = nil,
        _ body: @escaping (sending [JSValue]) async throws(JSException) -> JSValue
    ) -> JSClosure
    public func release()
}

public class JSOneshotClosure: JSObject, JSClosureProtocol {
    public init(_ body: @escaping (sending [JSValue]) -> JSValue)
    public static func async(
        priority: TaskPriority? = nil,
        _ body: @escaping (sending [JSValue]) async throws(JSException) -> JSValue
    ) -> JSOneshotClosure
    public func release()
}
```

**Example**

```swift
let document = JSObject.global.document.object!
let console = JSObject.global.console.object!

// Persistent closure - keep reference while JavaScript can call it
let button = document.createElement!("button").object!
let handler = JSClosure { args in
    console.log!("Clicked", args[0])
    return .undefined
}
button.addEventListener!("click", handler)

// One-shot closure - automatically released after first call
button.addEventListener!(
    "click",
    JSOneshotClosure { _ in
        console.log!("One-off click")
        return .undefined
    },
    ["once": true]
)

// Async closure - bridges Swift async to JavaScript Promise
let asyncHandler = JSClosure.async { _ async throws(JSException) -> JSValue in
    try! await Task.sleep(nanoseconds: 1_000_000)
    console.log!("Async closure finished")
    return .undefined
}
button.addEventListener!("async", asyncHandler)
```

## Promises and `async/await`

```swift
public final class JSPromise: JSBridgedClass {
    public init(unsafelyWrapping object: JSObject)
    public init(resolver: @escaping (@escaping (Result) -> Void) -> Void)
    public static func async(
        body: @escaping () async throws(JSException) -> Void
    ) -> JSPromise
    public static func async(
        body: @escaping () async throws(JSException) -> JSValue
    ) -> JSPromise
    
    public enum Result {
        case success(JSValue)
        case failure(JSValue)
    }
    
    // Available when JavaScriptEventLoop is linked
    public var value: JSValue { get async throws(JSException) }
    public var result: Result { get async }
}
```

**Example**

```swift
import JavaScriptEventLoop

JavaScriptEventLoop.installGlobalExecutor()

let console = JSObject.global.console.object!
let fetch = JSObject.global.fetch.object!

// Wrap existing JavaScript Promise and await from Swift
Task {
    do {
        let response = try await JSPromise(
            unsafelyWrapping: fetch("https://example.com").object!
        ).value
        console.log!("Fetched data", response)
    } catch let error as JSException {
        console.error!("Fetch failed", error.thrownValue)
    }
}

// Expose Swift async work to JavaScript
let swiftPromise = JSPromise.async {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    return .string("Swift async complete")
}
```

- Wrap existing promise-returning APIs with ``JSPromise/init(unsafelyWrapping:)``.
- Use `JSPromise.async(body:)` (with `Void` or `JSValue` return type) to expose Swift `async/await` work to JavaScript callers.
- To await JavaScript `Promise` from Swift, import `JavaScriptEventLoop`, call `JavaScriptEventLoop.installGlobalExecutor()` early, and use the `value` property.
- The `value` property suspends until the promise resolves or rejects, rethrowing rejections as ``JSException``.

