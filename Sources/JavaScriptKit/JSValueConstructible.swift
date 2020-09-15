/// Objects that can be constructed from a JavaScript value
public protocol JSValueConstructible {
    /// Return `nil` if the value is not compatible with the conforming Swift type.
    static func construct(from value: JSValue) -> Self?
}

extension Bool: JSValueConstructible {
    public static func construct(from value: JSValue) -> Bool? {
        value.boolean
    }
}

extension String: JSValueConstructible {
    public static func construct(from value: JSValue) -> String? {
        value.string
    }
}

extension Double: JSValueConstructible {
    public static func construct(from value: JSValue) -> Double? {
        return value.number
    }
}

extension Float: JSValueConstructible {
    public static func construct(from value: JSValue) -> Float? {
        return value.number.map(Float.init)
    }
}

extension Int: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension Int8: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension Int16: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension Int32: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension Int64: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt8: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt16: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt32: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}

extension UInt64: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        value.number.map(Self.init)
    }
}
