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

extension Double: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Double? {
        return value.number
    }
}

extension Float: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Float? {
        return value.number.map(Float.init)
    }
}

extension Int: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension Int8: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension Int16: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension Int32: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension Int64: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt8: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt16: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt32: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt64: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension JSString: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> JSString? {
        value.jsString
    }
}
