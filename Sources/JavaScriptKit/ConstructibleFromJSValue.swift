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
    /// Construct an instance of `SignedInteger` from the given `JSBigIntExtended`.
    ///
    /// If the value is too large to fit in the `Self` type, `nil` is returned.
    ///
    /// - Parameter bigInt: The `JSBigIntExtended` to decode
    public init?(exactly bigInt: some JSBigIntExtended) {
        self.init(exactly: bigInt.int64Value)
    }

    /// Construct an instance of `SignedInteger` from the given `JSBigIntExtended`.
    ///
    /// Crash if the value is too large to fit in the `Self` type.
    ///
    /// - Parameter bigInt: The `JSBigIntExtended` to decode
    public init(_ bigInt: some JSBigIntExtended) {
        self.init(bigInt.int64Value)
    }

    /// Construct an instance of `SignedInteger` from the given `JSValue`.
    ///
    /// Returns `nil` if one of the following conditions is met:
    /// - The value is not a number or a bigint.
    /// - The value is a number that does not fit or cannot be represented
    ///   in the `Self` type (e.g. NaN, Infinity).
    /// - The value is a bigint that does not fit in the `Self` type.
    ///
    /// If the value is a number, it is rounded towards zero before conversion.
    ///
    /// - Parameter value: The `JSValue` to decode
    public static func construct(from value: JSValue) -> Self? {
        if let number = value.number {
            return Self(exactly: number.rounded(.towardZero))
        }
        #if !hasFeature(Embedded)
        if let bigInt = value.bigInt as? JSBigIntExtended {
            return Self(exactly: bigInt)
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

    /// Construct an instance of `UnsignedInteger` from the given `JSBigIntExtended`.
    ///
    /// Returns `nil` if the value is negative or too large to fit in the `Self` type.
    ///
    /// - Parameter bigInt: The `JSBigIntExtended` to decode
    public init?(exactly bigInt: some JSBigIntExtended) {
        self.init(exactly: bigInt.uInt64Value)
    }

    /// Construct an instance of `UnsignedInteger` from the given `JSBigIntExtended`.
    ///
    /// Crash if the value is negative or too large to fit in the `Self` type.
    ///
    /// - Parameter bigInt: The `JSBigIntExtended` to decode
    public init(_ bigInt: some JSBigIntExtended) {
        self.init(bigInt.uInt64Value)
    }

    /// Construct an instance of `UnsignedInteger` from the given `JSValue`.
    ///
    /// Returns `nil` if one of the following conditions is met:
    /// - The value is not a number or a bigint.
    /// - The value is a number that does not fit or cannot be represented
    ///  in the `Self` type (e.g. NaN, Infinity).
    /// - The value is a bigint that does not fit in the `Self` type.
    /// - The value is negative.
    ///
    /// - Parameter value: The `JSValue` to decode
    public static func construct(from value: JSValue) -> Self? {
        if let number = value.number {
            return Self(exactly: number.rounded(.towardZero))
        }
        #if !hasFeature(Embedded)
        if let bigInt = value.bigInt as? JSBigIntExtended {
            return Self(exactly: bigInt)
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
