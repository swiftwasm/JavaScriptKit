import _CJavaScriptKit

/// `JSFunction` represents a function in JavaScript and supports new object instantiation.
/// This type can be callable as a function using `callAsFunction`.
///
/// e.g.
/// ```swift
/// let alert: JSFunction = JSObject.global.alert.function!
/// // Call `JSFunction` as a function
/// alert("Hello, world")
/// ```
///
public class JSFunction: JSObject {

    /// Call this function with given `arguments` and binding given `this` as context.
    /// - Parameters:
    ///   - this: The value to be passed as the `this` parameter to this function.
    ///   - arguments: Arguments to be passed to this function.
    /// - Returns: The result of this call.
    @discardableResult
    public func callAsFunction(this: JSObject? = nil, arguments: [ConvertibleToJSValue]) -> JSValue {
        let result = arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer -> RawJSValue in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var result = RawJSValue()
                if let thisId = this?.id {
                    _call_function_with_this(thisId,
                                             self.id, argv, Int32(argc),
                                             &result.kind, &result.payload1, &result.payload2)
                } else {
                    _call_function(
                        self.id, argv, Int32(argc),
                        &result.kind, &result.payload1, &result.payload2
                    )
                }
                return result
            }
        }
        return result.jsValue()
    }

    /// A variadic arguments version of `callAsFunction`.
    @discardableResult
    public func callAsFunction(this: JSObject? = nil, _ arguments: ConvertibleToJSValue...) -> JSValue {
        self(this: this, arguments: arguments)
    }

    /// Instantiate an object from this function as a constructor.
    ///
    /// Guaranteed to return an object because either:
    ///
    /// - a. the constructor explicitly returns an object, or
    /// - b. the constructor returns nothing, which causes JS to return the `this` value, or
    /// - c. the constructor returns undefined, null or a non-object, in which case JS also returns `this`.
    ///
    /// - Parameter arguments: Arguments to be passed to this constructor function.
    /// - Returns: A new instance of this constructor.
    public func new(arguments: [ConvertibleToJSValue]) -> JSObject {
        arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var resultObj = JavaScriptObjectRef()
                _call_new(self.id, argv, Int32(argc), &resultObj)
                return JSObject(id: resultObj)
            }
        }
    }

    /// A variadic arguments version of `new`.
    public func new(_ arguments: ConvertibleToJSValue...) -> JSObject {
        new(arguments: arguments)
    }

    @available(*, unavailable, message: "Please use JSClosure instead")
    public static func from(_: @escaping ([JSValue]) -> JSValue) -> JSFunction {
        fatalError("unavailable")
    }

    public override class func construct(from value: JSValue) -> Self? {
        return value.function as? Self
    }

    override public func jsValue() -> JSValue {
        .function(self)
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
public class JSClosure: JSFunction {
    static var sharedFunctions: [JavaScriptHostFuncRef: ([JSValue]) -> JSValue] = [:]

    private var hostFuncRef: JavaScriptHostFuncRef = 0

    private var isReleased = false
    
    /// Instantiate a new `JSClosure` with given function body.
    /// - Parameter body: The body of this function.
    public init(_ body: @escaping ([JSValue]) -> JSValue) {
        // 1. Fill `id` as zero at first to access `self` to get `ObjectIdentifier`.
        super.init(id: 0)
        let objectId = ObjectIdentifier(self)
        let funcRef = JavaScriptHostFuncRef(bitPattern: Int32(objectId.hashValue))
        // 2. Retain the given body in static storage by `funcRef`.
        Self.sharedFunctions[funcRef] = body
        // 3. Create a new JavaScript function which calls the given Swift function.
        var objectRef: JavaScriptObjectRef = 0
        _create_function(funcRef, &objectRef)

        hostFuncRef = funcRef
        id = objectRef
    }
    
    /// A convenience initializer which assumes that the given body function returns `JSValue.undefined`
    convenience public init(_ body: @escaping ([JSValue]) -> ()) {
        self.init { (arguments: [JSValue]) -> JSValue in
            body(arguments)
            return .undefined
        }
    }
    
    /// Release this function resource.
    /// After calling `release`, calling this function from JavaScript will fail.
    public func release() {
        Self.sharedFunctions[hostFuncRef] = nil
        isReleased = true
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
    guard let hostFunc = JSClosure.sharedFunctions[hostFuncRef] else {
        fatalError("The function was already released")
    }
    let arguments = UnsafeBufferPointer(start: argv, count: Int(argc)).map {
        $0.jsValue()
    }
    let result = hostFunc(arguments)
    let callbackFuncRef = JSFunction(id: callbackFuncRef)
    _ = callbackFuncRef(result)
}
