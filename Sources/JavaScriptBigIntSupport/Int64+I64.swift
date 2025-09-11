import JavaScriptKit

extension UInt64: JavaScriptKit.ConvertibleToJSValue, JavaScriptKit.TypedArrayElement {
    public static var typedArrayClass: JSObject { JSObject.global.BigUint64Array.object! }

    public var jsValue: JSValue { .bigInt(JSBigInt(unsigned: self)) }
}

extension Int64: JavaScriptKit.ConvertibleToJSValue, JavaScriptKit.TypedArrayElement {
    public static var typedArrayClass: JSObject { JSObject.global.BigInt64Array.object! }

    public var jsValue: JSValue { .bigInt(JSBigInt(self)) }
}
