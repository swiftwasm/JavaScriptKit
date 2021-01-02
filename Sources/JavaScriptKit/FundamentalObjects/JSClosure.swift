import _CJavaScriptKit

fileprivate var sharedFunctions: [JavaScriptHostFuncRef: ([JSValue]) -> JSValue] = [:]

/// `JSOneshotClosure` is a JavaScript function that can be called only once.
public class JSOneshotClosure: JSFunction {
    private var hostFuncRef: JavaScriptHostFuncRef = 0

    public init(_ body: @escaping ([JSValue]) -> JSValue) {
        // 1. Fill `id` as zero at first to access `self` to get `ObjectIdentifier`.
        super.init(id: 0)
        let objectId = ObjectIdentifier(self)
        let funcRef = JavaScriptHostFuncRef(bitPattern: Int32(objectId.hashValue))
        // 2. Retain the given body in static storage by `funcRef`.
        sharedFunctions[funcRef] = body
        // 3. Create a new JavaScript function which calls the given Swift function.
        var objectRef: JavaScriptObjectRef = 0
        _create_function(funcRef, &objectRef)

        hostFuncRef = funcRef
        id = objectRef
    }

    public override func callAsFunction(this: JSObject? = nil, arguments: [ConvertibleToJSValue]) -> JSValue {
        defer { release() }
        return super.callAsFunction(this: this, arguments: arguments)
    }

    /// Release this function resource.
    /// After calling `release`, calling this function from JavaScript will fail.
    public func release() {
        sharedFunctions[hostFuncRef] = nil
    }
}

/// `JSClosure` represents a JavaScript function the body of which is written in Swift.
/// This type can be passed as a callback handler to JavaScript functions.
/// Note that the lifetime of `JSClosure` should be managed by users manually
/// due to GC boundary between Swift and JavaScript.
/// For further discussion, see also [swiftwasm/JavaScriptKit #33](https://github.com/swiftwasm/JavaScriptKit/pull/33)
///
/// e.g.
/// ```swift
/// let eventListenter = JSClosure { _ in
///     ...
///     return JSValue.undefined
/// }
///
/// button.addEventListener!("click", JSValue.function(eventListenter))
/// ...
/// button.removeEventListener!("click", JSValue.function(eventListenter))
/// eventListenter.release()
/// ```
///
public class JSClosure: JSOneshotClosure {
    
    var isReleased: Bool = false

    @available(*, deprecated, message: "This initializer will be removed in the next minor version update. Please use `init(_ body: @escaping ([JSValue]) -> JSValue)`")
    @_disfavoredOverload
    public init(_ body: @escaping ([JSValue]) -> ()) {
        super.init({
            body($0)
            return .undefined
        })
    }

    public override init(_ body: @escaping ([JSValue]) -> JSValue) {
        super.init(body)
    }

    public override func callAsFunction(this: JSObject? = nil, arguments: [ConvertibleToJSValue]) -> JSValue {
        try! invokeJSFunction(self, arguments: arguments, this: this)
    }
    
    public override func release() {
        isReleased = true
        super.release()
    }

    deinit {
        guard isReleased else {
            fatalError("""
            release() must be called on closures manually before deallocating.
            This is caused by the lack of support for the `FinalizationRegistry` API in Safari.
            """)
        }
    }
}

// MARK: - `JSClosure` mechanism note
//
// 1. Create thunk function in JavaScript world, that has a reference
//    to Swift Closure.
// ┌─────────────────────┬──────────────────────────┐
// │     Swift side      │   JavaScript side        │
// │                     │                          │
// │                     │                          │
// │                     │   ┌──[Thunk function]──┐ │
// │          ┌ ─ ─ ─ ─ ─│─ ─│─ ─ ─ ─ ─ ┐         │ │
// │          ↓          │   │          │         │ │
// │  [Swift Closure]    │   │  Host Function ID  │ │
// │                     │   │                    │ │
// │                     │   └────────────────────┘ │
// └─────────────────────┴──────────────────────────┘
//
// 2. When thunk function is invoked, it calls Swift Closure via
//    `_call_host_function` and callback the result through callback func
// ┌─────────────────────┬──────────────────────────┐
// │     Swift side      │   JavaScript side        │
// │                     │                          │
// │                     │                          │
// │                   Apply ┌──[Thunk function]──┐ │
// │          ┌ ─ ─ ─ ─ ─│─ ─│─ ─ ─ ─ ─ ┐         │ │
// │          ↓          │   │          │         │ │
// │  [Swift Closure]    │   │  Host Function ID  │ │
// │          │          │   │                    │ │
// │          │          │   └────────────────────┘ │
// │          │          │                    ↑     │
// │          │        Apply                  │     │
// │          └─[Result]─┼───>[Callback func]─┘     │
// │                     │                          │
// └─────────────────────┴──────────────────────────┘

@_cdecl("_call_host_function_impl")
func _call_host_function_impl(
    _ hostFuncRef: JavaScriptHostFuncRef,
    _ argv: UnsafePointer<RawJSValue>, _ argc: Int32,
    _ callbackFuncRef: JavaScriptObjectRef
) {
    guard let hostFunc = sharedFunctions[hostFuncRef] else {
        fatalError("The function was already released")
    }
    let arguments = UnsafeBufferPointer(start: argv, count: Int(argc)).map {
        $0.jsValue()
    }
    let result = hostFunc(arguments)
    let callbackFuncRef = JSFunction(id: callbackFuncRef)
    _ = callbackFuncRef(result)
}
