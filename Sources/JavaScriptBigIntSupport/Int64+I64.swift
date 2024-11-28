import JavaScriptKit

extension UInt64: JavaScriptKit.ConvertibleToJSValue, JavaScriptKit.TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.BigUint64Array.function! }

    public var jsValue: JSValue { .bigInt(JSBigInt(unsigned: self)) }
}

extension Int64: JavaScriptKit.ConvertibleToJSValue, JavaScriptKit.TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.BigInt64Array.function! }

    public var jsValue: JSValue { .bigInt(JSBigInt(self)) }
}
