import _CJavaScriptKit

@available(
    *,
    deprecated,
    renamed: "JSObject",
    message: "Please use JSObject instead. JSFunction is unified with JSObject"
)
public typealias JSFunction = JSObject

extension JSObject {
    #if !hasFeature(Embedded)
    /// Call this function with given `arguments` and binding given `this` as context.
    /// - Parameters:
    ///   - this: The value to be passed as the `this` parameter to this function.
    ///   - arguments: Arguments to be passed to this function.
    /// - Returns: The result of this call.
    @discardableResult
    public func callAsFunction(this: JSObject, arguments: [ConvertibleToJSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments, this: this).jsValue
    }

    /// Call this function with given `arguments`.
    /// - Parameters:
    ///   - arguments: Arguments to be passed to this function.
    /// - Returns: The result of this call.
    @discardableResult
    public func callAsFunction(arguments: [ConvertibleToJSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments).jsValue
    }

    /// A variadic arguments version of `callAsFunction`.
    @discardableResult
    public func callAsFunction(this: JSObject, _ arguments: ConvertibleToJSValue...) -> JSValue {
        self(this: this, arguments: arguments)
    }

    /// A variadic arguments version of `callAsFunction`.
    @discardableResult
    public func callAsFunction(_ arguments: ConvertibleToJSValue...) -> JSValue {
        self(arguments: arguments)
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
                JSObject(id: swjs_call_new(self.id, bufferPointer.baseAddress!, Int32(bufferPointer.count)))
            }
        }
    }

    /// A variadic arguments version of `new`.
    public func new(_ arguments: ConvertibleToJSValue...) -> JSObject {
        new(arguments: arguments)
    }

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
    /// let validateAge = JSObject.global.validateAge.object!
    /// try validateAge.throws(20)
    /// ```
    public var `throws`: JSThrowingFunction {
        JSThrowingFunction(self)
    }
    #endif

    @discardableResult
    public func callAsFunction(arguments: [JSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments).jsValue
    }

    public func new(arguments: [JSValue]) -> JSObject {
        arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                JSObject(id: swjs_call_new(self.id, bufferPointer.baseAddress!, Int32(bufferPointer.count)))
            }
        }
    }

    @available(*, unavailable, message: "Please use JSClosure instead")
    public static func from(_: @escaping ([JSValue]) -> JSValue) -> JSFunction {
        fatalError("unavailable")
    }

    final func invokeNonThrowingJSFunction(arguments: [JSValue]) -> RawJSValue {
        arguments.withRawJSValues { invokeNonThrowingJSFunction(rawValues: $0) }
    }

    final func invokeNonThrowingJSFunction(arguments: [JSValue], this: JSObject) -> RawJSValue {
        arguments.withRawJSValues { invokeNonThrowingJSFunction(rawValues: $0, this: this) }
    }

    #if !hasFeature(Embedded)
    final func invokeNonThrowingJSFunction(arguments: [ConvertibleToJSValue]) -> RawJSValue {
        arguments.withRawJSValues { invokeNonThrowingJSFunction(rawValues: $0) }
    }

    final func invokeNonThrowingJSFunction(arguments: [ConvertibleToJSValue], this: JSObject) -> RawJSValue {
        arguments.withRawJSValues { invokeNonThrowingJSFunction(rawValues: $0, this: this) }
    }
    #endif

    final private func invokeNonThrowingJSFunction(rawValues: [RawJSValue]) -> RawJSValue {
        rawValues.withUnsafeBufferPointer { [id] bufferPointer in
            let argv = bufferPointer.baseAddress
            let argc = bufferPointer.count
            var payload1 = JavaScriptPayload1()
            var payload2 = JavaScriptPayload2()
            let resultBitPattern = swjs_call_function_no_catch(
                id,
                argv,
                Int32(argc),
                &payload1,
                &payload2
            )
            let kindAndFlags = JavaScriptValueKindAndFlags(bitPattern: resultBitPattern)
            assert(!kindAndFlags.isException)
            let result = RawJSValue(kind: kindAndFlags.kind, payload1: payload1, payload2: payload2)
            return result
        }
    }

    final private func invokeNonThrowingJSFunction(rawValues: [RawJSValue], this: JSObject) -> RawJSValue {
        rawValues.withUnsafeBufferPointer { [id] bufferPointer in
            let argv = bufferPointer.baseAddress
            let argc = bufferPointer.count
            var payload1 = JavaScriptPayload1()
            var payload2 = JavaScriptPayload2()
            let resultBitPattern = swjs_call_function_with_this_no_catch(
                this.id,
                id,
                argv,
                Int32(argc),
                &payload1,
                &payload2
            )
            let kindAndFlags = JavaScriptValueKindAndFlags(bitPattern: resultBitPattern)
            #if !hasFeature(Embedded)
            assert(!kindAndFlags.isException)
            #endif
            let result = RawJSValue(kind: kindAndFlags.kind, payload1: payload1, payload2: payload2)
            return result
        }
    }
}

#if hasFeature(Embedded)
// Overloads of `callAsFunction(ConvertibleToJSValue...) -> JSValue`
// for 0 through 7 arguments for Embedded Swift.
//
// These are required because the `ConvertibleToJSValue...` version is not
// available in Embedded Swift due to lack of support for existentials.
//
// Once Embedded Swift supports parameter packs/variadic generics, we can
// replace all variants with a single method each that takes a generic pack.
extension JSFunction {

    @discardableResult
    public func callAsFunction(this: JSObject) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [], this: this).jsValue
    }

    @discardableResult
    public func callAsFunction(this: JSObject, _ arg0: some ConvertibleToJSValue) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue], this: this).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue], this: this).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue], this: this).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue], this: this)
            .jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(
            arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue],
            this: this
        ).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(
            arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue],
            this: this
        ).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue,
        _ arg6: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(
            arguments: [
                arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue, arg6.jsValue,
            ],
            this: this
        ).jsValue
    }

    @discardableResult
    public func callAsFunction(this: JSObject, arguments: [JSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments, this: this).jsValue
    }

    @discardableResult
    public func callAsFunction() -> JSValue {
        invokeNonThrowingJSFunction(arguments: []).jsValue
    }

    @discardableResult
    public func callAsFunction(_ arg0: some ConvertibleToJSValue) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue])
            .jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [
            arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue,
        ]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue,
        _ arg6: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [
            arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue, arg6.jsValue,
        ]).jsValue
    }

    public func new() -> JSObject {
        new(arguments: [])
    }

    public func new(_ arg0: some ConvertibleToJSValue) -> JSObject {
        new(arguments: [arg0.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue,
        _ arg6: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [
            arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue, arg6.jsValue,
        ])
    }
}
#endif

internal struct JavaScriptValueKindAndFlags {
    static var errorBit: UInt32 { 1 << 31 }
    let kind: JavaScriptValueKind
    let isException: Bool

    init(bitPattern: UInt32) {
        self.kind = JavaScriptValueKind(rawValue: bitPattern & ~Self.errorBit)!
        self.isException = (bitPattern & Self.errorBit) != 0
    }
}
