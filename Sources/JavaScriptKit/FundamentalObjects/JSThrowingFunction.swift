import _CJavaScriptKit


/// A `JSFunction` wrapper that enables throwing function calls.
/// Exceptions produced by JavaScript functions will be thrown as `JSValue`.
public class JSThrowingFunction {
    private let base: JSFunction
    public init(_ base: JSFunction) {
        self.base = base
    }

    /// Call this function with given `arguments` and binding given `this` as context.
    /// - Parameters:
    ///   - this: The value to be passed as the `this` parameter to this function.
    ///   - arguments: Arguments to be passed to this function.
    /// - Returns: The result of this call.
    @discardableResult
    public func callAsFunction(this: JSObject? = nil, arguments: [ConvertibleToJSValue]) throws -> JSValue {
        try invokeJSFunction(base, arguments: arguments, this: this)
    }

    /// A variadic arguments version of `callAsFunction`.
    @discardableResult
    public func callAsFunction(this: JSObject? = nil, _ arguments: ConvertibleToJSValue...) throws -> JSValue {
        try self(this: this, arguments: arguments)
    }

    /// Instantiate an object from this function as a throwing constructor.
    ///
    /// Guaranteed to return an object because either:
    ///
    /// - a. the constructor explicitly returns an object, or
    /// - b. the constructor returns nothing, which causes JS to return the `this` value, or
    /// - c. the constructor returns undefined, null or a non-object, in which case JS also returns `this`.
    ///
    /// - Parameter arguments: Arguments to be passed to this constructor function.
    /// - Returns: A new instance of this constructor.
    public func new(arguments: [ConvertibleToJSValue]) throws -> JSObject {
        try arguments.withRawJSValues { rawValues -> Result<JSObject, JSValue> in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count

                var exceptionKind = JavaScriptValueKindAndFlags()
                var exceptionPayload1 = JavaScriptPayload1()
                var exceptionPayload2 = JavaScriptPayload2()
                let resultObj = _call_throwing_new(
                    self.base.id, argv, Int32(argc),
                    &exceptionKind, &exceptionPayload1, &exceptionPayload2
                )
                if exceptionKind.isException {
                    let exception = RawJSValue(kind: exceptionKind.kind, payload1: exceptionPayload1, payload2: exceptionPayload2)
                    return .failure(exception.jsValue)
                }
                return .success(JSObject(id: resultObj))
            }
        }.get()
    }

    /// A variadic arguments version of `new`.
    public func new(_ arguments: ConvertibleToJSValue...) throws -> JSObject {
        try new(arguments: arguments)
    }
}

private func invokeJSFunction(_ jsFunc: JSFunction, arguments: [ConvertibleToJSValue], this: JSObject?) throws -> JSValue {
    let id = jsFunc.id
    let (result, isException) = arguments.withRawJSValues { rawValues in
        rawValues.withUnsafeBufferPointer { bufferPointer -> (JSValue, Bool) in
            let argv = bufferPointer.baseAddress
            let argc = bufferPointer.count
            var kindAndFlags = JavaScriptValueKindAndFlags()
            var payload1 = JavaScriptPayload1()
            var payload2 = JavaScriptPayload2()
            if let thisId = this?.id {
                let resultBitPattern = _call_function_with_this(
                    thisId, id, argv, Int32(argc),
                    &payload1, &payload2
                )
                kindAndFlags = unsafeBitCast(resultBitPattern, to: JavaScriptValueKindAndFlags.self)
            } else {
                let resultBitPattern = _call_function(
                    id, argv, Int32(argc),
                    &payload1, &payload2
                )
                kindAndFlags = unsafeBitCast(resultBitPattern, to: JavaScriptValueKindAndFlags.self)
            }
            let result = RawJSValue(kind: kindAndFlags.kind, payload1: payload1, payload2: payload2)
            return (result.jsValue, kindAndFlags.isException)
        }
    }
    if isException {
        throw result
    }
    return result
}
