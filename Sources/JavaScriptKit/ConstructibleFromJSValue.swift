/// Types conforming to this protocol can be constructed from `JSValue`.
public protocol ConstructibleFromJSValue {
    /// Construct an instance of `Self`, if possible, from the given `JSValue`.
    /// Return `nil` if the value is not compatible with the conforming Swift type.
    ///
    /// - Parameter value: The `JSValue` to decode
    /// - Returns: An instance of `Self`, if one was successfully constructed from the value.
    static func construct(from value: JSValue) -> Self?
}

extension Bool: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Bool? {
        value.boolean
    }
}

extension String: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> String? {
        value.string
    }
}

extension JSString: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> JSString? {
        value.jsString
    }
}

extension BinaryFloatingPoint where Self: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}
extension Double: ConstructibleFromJSValue {}
extension Float: ConstructibleFromJSValue {}

extension SignedInteger where Self: ConstructibleFromJSValue {
    public init(_ bigInt: JSBigInt) {
        self.init(bigInt.int64Value)
    }
    public static func construct(from value: JSValue) -> Self? {
        value.bigInt.map(Self.init) ?? value.number.map(Self.init)
    }
}
extension Int: ConstructibleFromJSValue {}
extension Int8: ConstructibleFromJSValue {}
extension Int16: ConstructibleFromJSValue {}
extension Int32: ConstructibleFromJSValue {}
extension Int64: ConstructibleFromJSValue {}

extension UnsignedInteger where Self: ConstructibleFromJSValue {
    public init(_ bigInt: JSBigInt) {
        self.init(bigInt.uInt64Value)
    }
    public static func construct(from value: JSValue) -> Self? {
        value.bigInt.map(Self.init) ?? value.number.map(Self.init)
    }
}
extension UInt: ConstructibleFromJSValue {}
extension UInt8: ConstructibleFromJSValue {}
extension UInt16: ConstructibleFromJSValue {}
extension UInt32: ConstructibleFromJSValue {}
extension UInt64: ConstructibleFromJSValue {}
