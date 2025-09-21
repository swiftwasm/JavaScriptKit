import _CJavaScriptKit

/// `JSValue` represents a value in JavaScript.
@dynamicMemberLookup
public enum JSValue: Equatable {
    case boolean(Bool)
    case string(JSString)
    case number(Double)
    case object(JSObject)
    case null
    case undefined

    /// Returns the `Bool` value of this JS value if its type is boolean.
    /// If not, returns `nil`.
    public var boolean: Bool? {
        switch self {
        case .boolean(let boolean): return boolean
        default: return nil
        }
    }

    /// Returns the `String` value of this JS value if the type is string.
    /// If not, returns `nil`.
    ///
    /// Note that this accessor may copy the JS string value into Swift side memory.
    ///
    /// To avoid the copying, please consider the `jsString` instead.
    public var string: String? {
        jsString.map(String.init)
    }

    /// Returns the `JSString` value of this JS value if the type is string.
    /// If not, returns `nil`.
    ///
    public var jsString: JSString? {
        switch self {
        case .string(let string): return string
        default: return nil
        }
    }

    /// Returns the `Double` value of this JS value if the type is number.
    /// If not, returns `nil`.
    public var number: Double? {
        switch self {
        case .number(let number): return number
        default: return nil
        }
    }

    /// Returns the `JSObject` of this JS value if its type is object.
    /// If not, returns `nil`.
    public var object: JSObject? {
        switch self {
        case .object(let object): return object
        default: return nil
        }
    }

    // @available(*, deprecated, renamed: "object", message: "Use the .object property instead")
    public var function: JSObject? { object }

    /// Returns the `true` if this JS value is null.
    /// If not, returns `false`.
    public var isNull: Bool {
        return self == .null
    }

    /// Returns the `true` if this JS value is undefined.
    /// If not, returns `false`.
    public var isUndefined: Bool {
        return self == .undefined
    }
}

/// JSValue is intentionally not `Sendable` because accessing a JSValue living in a different
/// thread is invalid. Although there are some cases where Swift allows sending a non-Sendable
/// values to other isolation domains, not conforming `Sendable` is still useful to prevent
/// accidental misuse.
@available(*, unavailable)
extension JSValue: Sendable {}

extension JSValue {
    /// An unsafe convenience method of `JSObject.subscript(_ index: Int) -> JSValue`
    /// - Precondition: `self` must be a JavaScript Object.
    public subscript(dynamicMember name: String) -> JSValue {
        get { fatalError() }
        nonmutating set { fatalError() }
    }

    /// An unsafe convenience method of `JSObject.subscript(_ index: Int) -> JSValue`
    /// - Precondition: `self` must be a JavaScript Object.
    public subscript(_ index: Int) -> JSValue {
        get { fatalError() }
        nonmutating set { fatalError() }
    }
}

extension JSValue {
    public func fromJSValue<Type>() -> Type? where Type: ConstructibleFromJSValue {
        return Type.construct(from: self)
    }
}

public func getJSValue(this: JSObject, name: JSString) -> JSValue {
    var rawValue = RawJSValue()
    let rawBitPattern = swjs_get_prop(
        this.id,
        name.asInternalJSRef(),
        &rawValue.payload1,
        &rawValue.payload2
    )
    rawValue.kind = unsafeBitCast(rawBitPattern, to: JavaScriptValueKind.self)
    return rawValue.jsValue
}

public func setJSValue(this: JSObject, name: JSString, value: JSValue) {
    value.withRawJSValue { rawValue in
        swjs_set_prop(this.id, name.asInternalJSRef(), rawValue.kind, rawValue.payload1, rawValue.payload2)
    }
}

public func getJSValue(this: JSObject, index: Int32) -> JSValue {
    var rawValue = RawJSValue()
    let rawBitPattern = swjs_get_subscript(
        this.id,
        index,
        &rawValue.payload1,
        &rawValue.payload2
    )
    rawValue.kind = unsafeBitCast(rawBitPattern, to: JavaScriptValueKind.self)
    return rawValue.jsValue
}

public func setJSValue(this: JSObject, index: Int32, value: JSValue) {
    value.withRawJSValue { rawValue in
        swjs_set_subscript(
            this.id,
            index,
            rawValue.kind,
            rawValue.payload1,
            rawValue.payload2
        )
    }
}
