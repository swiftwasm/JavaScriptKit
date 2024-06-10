#if hasFeature(Embedded)
import String16
#endif

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

#if hasFeature(Embedded)
extension String16: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> String16? {
        value.string
    }
}
#else
extension String: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> String? {
        value.string
    }
}
#endif

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
    #if !hasFeature(Embedded)
    public init(_ bigInt: JSBigIntExtended) {
        self.init(bigInt.int64Value)
    }
    #endif

    public static func construct(from value: JSValue) -> Self? {
        if let number = value.number {
            return Self(number)
        }
        #if !hasFeature(Embedded)
        if let bigInt = value.bigInt as? JSBigIntExtended {
            return Self(bigInt)
        }
        #endif
        return nil
    }
}
extension Int: ConstructibleFromJSValue {}
extension Int8: ConstructibleFromJSValue {}
extension Int16: ConstructibleFromJSValue {}
extension Int32: ConstructibleFromJSValue {}
extension Int64: ConstructibleFromJSValue {}

extension UnsignedInteger where Self: ConstructibleFromJSValue {
    #if !hasFeature(Embedded)
    public init(_ bigInt: JSBigIntExtended) {
        self.init(bigInt.uInt64Value)
    }
    #endif
    public static func construct(from value: JSValue) -> Self? {
        if let number = value.number {
            return Self(number)
        }
        #if !hasFeature(Embedded)
        if let bigInt = value.bigInt as? JSBigIntExtended {
            return Self(bigInt)
        }
        #endif
        return nil
    }
}
extension UInt: ConstructibleFromJSValue {}
extension UInt8: ConstructibleFromJSValue {}
extension UInt16: ConstructibleFromJSValue {}
extension UInt32: ConstructibleFromJSValue {}
extension UInt64: ConstructibleFromJSValue {}
