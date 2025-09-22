import _CJavaScriptKit

@available(
    *,
    deprecated,
    renamed: "JSObject",
    message: "Please use JSObject instead. JSFunction is unified with JSObject"
)
public typealias JSFunction = JSObject

extension JSObject {
    @discardableResult
    public func callAsFunction(arguments: [JSValue]) -> JSValue {
        .undefined
    }

    public func new(arguments: [JSValue]) -> JSObject {
        fatalError()
    }

    @available(*, unavailable, message: "Please use JSClosure instead")
    public static func from(_: @escaping ([JSValue]) -> JSValue) -> JSFunction {
        fatalError("unavailable")
    }

    final func invokeNonThrowingJSFunction(arguments: [JSValue]) -> RawJSValue {
        fatalError()
    }

    final func invokeNonThrowingJSFunction(arguments: [JSValue], this: JSObject) -> RawJSValue {
        fatalError()
    }

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
        .undefined
    }

    @discardableResult
    public func callAsFunction(this: JSObject, _ arg0: some ConvertibleToJSValue) -> JSValue {
        .undefined
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue
    ) -> JSValue {
        .undefined
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue
    ) -> JSValue {
        .undefined
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue
    ) -> JSValue {
        .undefined
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
        .undefined
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
        .undefined
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
        .undefined
    }

    @discardableResult
    public func callAsFunction(this: JSObject, arguments: [JSValue]) -> JSValue {
        .undefined
    }

    @discardableResult
    public func callAsFunction() -> JSValue {
        .undefined
    }

    @discardableResult
    public func callAsFunction(_ arg0: some ConvertibleToJSValue) -> JSValue {
        .undefined
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue
    ) -> JSValue {
        .undefined
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue
    ) -> JSValue {
        .undefined
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue
    ) -> JSValue {
        .undefined
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue
    ) -> JSValue {
        .undefined
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
        .undefined
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
        .undefined
    }

    public func new() -> JSObject {
        new(arguments: [])
    }

    public func new(_ arg0: some ConvertibleToJSValue) -> JSObject {
        fatalError()
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue
    ) -> JSObject {
        fatalError()
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue
    ) -> JSObject {
        fatalError()
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue
    ) -> JSObject {
        fatalError()
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue
    ) -> JSObject {
        fatalError()
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue
    ) -> JSObject {
        fatalError()
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
        fatalError()
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
