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
    #if hasFeature(Embedded)
    @discardableResult
    public func callAsFunction(this: JSObject, arguments: [JSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments, this: this).jsValue
    }
    #else
    @discardableResult
    public func callAsFunction(this: JSObject, arguments: [ConvertibleToJSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments, this: this).jsValue
    }
    #endif

    /// Call this function with given `arguments`.
    /// - Parameters:
    ///   - arguments: Arguments to be passed to this function.
    /// - Returns: The result of this call.
    #if hasFeature(Embedded)
    @discardableResult
    public func callAsFunction(arguments: [JSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments).jsValue
    }
    #else
    @discardableResult
    public func callAsFunction(arguments: [ConvertibleToJSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments).jsValue
    }
    #endif

    /// A variadic arguments version of `callAsFunction`.
    #if hasFeature(Embedded)
    @discardableResult
    public func callAsFunction(this: JSObject, _ arguments: JSValue...) -> JSValue {
       self(this: this, arguments: arguments)
    }
    #else
    @discardableResult
    public func callAsFunction(this: JSObject, _ arguments: ConvertibleToJSValue...) -> JSValue {
        self(this: this, arguments: arguments)
    }
    #endif

    /// A variadic arguments version of `callAsFunction`.
    #if hasFeature(Embedded)
    @discardableResult
    public func callAsFunction(_ arguments: JSValue...) -> JSValue {
       self(arguments: arguments)
    }
    #else
    @discardableResult
    public func callAsFunction(_ arguments: ConvertibleToJSValue...) -> JSValue {
        self(arguments: arguments)
    }
    #endif

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
    #if hasFeature(Embedded)
    public func new(arguments: [JSValue]) -> JSObject {
        arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                JSObject(id: _call_new(self.id, bufferPointer.baseAddress!, Int32(bufferPointer.count)))
            }
        }
    }
    #else
    public func new(arguments: [ConvertibleToJSValue]) -> JSObject {
        arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                JSObject(id: _call_new(self.id, bufferPointer.baseAddress!, Int32(bufferPointer.count)))
            }
        }
    }
    #endif

    /// A modifier to call this function as a throwing function
    ///
    ///
    /// ```javascript
    /// function validateAge(age) {
    ///   if (age < 0) {
    ///     throw new Error("Invalid age");
    ///   }
    /// }
    /// ```
    ///
    /// ```swift
    /// let validateAge = JSObject.global.validateAge.function!
    /// try validateAge.throws(20)
    /// ```
    public var `throws`: JSThrowingFunction {
        JSThrowingFunction(self)
    }

    /// A variadic arguments version of `new`.
    #if hasFeature(Embedded)
    public func new(_ arguments: JSValue...) -> JSObject {
        new(arguments: arguments)
    }
    #else
    public func new(_ arguments: ConvertibleToJSValue...) -> JSObject {
        new(arguments: arguments)
    }
    #endif

    override public var jsValue: JSValue {
        .function(self)
    }

    #if hasFeature(Embedded)
    final func invokeNonThrowingJSFunction(arguments: [JSValue]) -> RawJSValue {
        let id = self.id
        return arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var payload1 = JavaScriptPayload1()
                var payload2 = JavaScriptPayload2()
                let resultBitPattern = _call_function_no_catch(
                    id, argv, Int32(argc),
                    &payload1, &payload2
                )
                let kindAndFlags = JSValueKindAndFlags.decode(resultBitPattern)
                assert(!kindAndFlags.isException)
                return RawJSValue(kind: kindAndFlags.kind, payload1: payload1, payload2: payload2)
            }
        }
    }
    #else
    final func invokeNonThrowingJSFunction(arguments: [ConvertibleToJSValue]) -> RawJSValue {
        let id = self.id
        return arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var payload1 = JavaScriptPayload1()
                var payload2 = JavaScriptPayload2()
                let resultBitPattern = _call_function_no_catch(
                    id, argv, Int32(argc),
                    &payload1, &payload2
                )
                let kindAndFlags = unsafeBitCast(resultBitPattern, to: JavaScriptValueKindAndFlags.self)
                assert(!kindAndFlags.isException)
                let result = RawJSValue(kind: kindAndFlags.kind, payload1: payload1, payload2: payload2)
                return result
            }
        }
    }
    #endif

    #if hasFeature(Embedded)
    final func invokeNonThrowingJSFunction(arguments: [JSValue], this: JSObject) -> RawJSValue {
        let id = self.id
        return arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var payload1 = JavaScriptPayload1()
                var payload2 = JavaScriptPayload2()
                let resultBitPattern = _call_function_with_this_no_catch(this.id,
                    id, argv, Int32(argc),
                    &payload1, &payload2
                )
                let kindAndFlags = JSValueKindAndFlags.decode(resultBitPattern)
                assert(!kindAndFlags.isException)
                return RawJSValue(kind: kindAndFlags.kind, payload1: payload1, payload2: payload2)
            }
        }
    }
    #else
    final func invokeNonThrowingJSFunction(arguments: [ConvertibleToJSValue], this: JSObject) -> RawJSValue {
        let id = self.id
        return arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var payload1 = JavaScriptPayload1()
                var payload2 = JavaScriptPayload2()
                let resultBitPattern = _call_function_with_this_no_catch(this.id,
                    id, argv, Int32(argc),
                    &payload1, &payload2
                )
                let kindAndFlags = unsafeBitCast(resultBitPattern, to: JavaScriptValueKindAndFlags.self)
                assert(!kindAndFlags.isException)
                let result = RawJSValue(kind: kindAndFlags.kind, payload1: payload1, payload2: payload2)
                return result
            }
        }
    }
    #endif
}

#if hasFeature(Embedded)
struct JSValueKindAndFlags {
    let kind: UInt
    let isException: Bool

    static func decode(_ resultBitPattern: UInt32) -> JSValueKindAndFlags {
        .init(
            // Extract the kind (first 4 bits)
            kind: UInt(UInt8(resultBitPattern & 0b00000000000000000000000000001111)),
            // Extract the isException (5th bit)
            isException: (resultBitPattern & 0b00000000000000000000000000010000) != 0
        )
    }
}
#endif
