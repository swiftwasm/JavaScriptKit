import JavaScriptKit

extension UInt64: ConvertibleToJSValue, TypedArrayElement {
    public static var typedArrayClass = JSObject.global.BigUint64Array.function!

    public var jsValue: JSValue { .bigInt(JSBigInt(unsigned: self)) }
}

extension Int64: ConvertibleToJSValue, TypedArrayElement {
    public static var typedArrayClass = JSObject.global.BigInt64Array.function!

    public var jsValue: JSValue { .bigInt(JSBigInt(self)) }
}
