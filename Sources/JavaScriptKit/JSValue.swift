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
    case function(JSFunction)
    case symbol(JSSymbol)
#if !JAVASCRIPTKIT_WITHOUT_BIGINTS
    case bigInt(JSBigInt)
#endif

    /// Returns the `Bool` value of this JS value if its type is boolean.
    /// If not, returns `nil`.
    public var boolean: Bool? {
        switch self {
        case let .boolean(boolean): return boolean
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
        case let .string(string): return string
        default: return nil
        }
    }

    /// Returns the `Double` value of this JS value if the type is number.
    /// If not, returns `nil`.
    public var number: Double? {
        switch self {
        case let .number(number): return number
        default: return nil
        }
    }

    /// Returns the `JSObject` of this JS value if its type is object.
    /// If not, returns `nil`.
    public var object: JSObject? {
        switch self {
        case let .object(object): return object
        default: return nil
        }
    }

    /// Returns the `JSFunction` of this JS value if its type is function.
    /// If not, returns `nil`.
    public var function: JSFunction? {
        switch self {
        case let .function(function): return function
        default: return nil
        }
    }

    /// Returns the `JSSymbol` of this JS value if its type is function.
    /// If not, returns `nil`.
    public var symbol: JSSymbol? {
        switch self {
        case let .symbol(symbol): return symbol
        default: return nil
        }
    }

#if !JAVASCRIPTKIT_WITHOUT_BIGINTS
    /// Returns the `JSBigInt` of this JS value if its type is function.
    /// If not, returns `nil`.
    public var bigInt: JSBigInt? {
        switch self {
        case let .bigInt(bigInt): return bigInt
        default: return nil
        }
    }
#endif

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

public extension JSValue {
    /// An unsafe convenience method of `JSObject.subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)?`
    /// - Precondition: `self` must be a JavaScript Object and specified member should be a callable object.
    subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) -> JSValue) {
        object![dynamicMember: name]!
    }

    /// An unsafe convenience method of `JSObject.subscript(_ index: Int) -> JSValue`
    /// - Precondition: `self` must be a JavaScript Object.
    subscript(dynamicMember name: String) -> JSValue {
        get { self.object![name] }
        set { self.object![name] = newValue }
    }

    /// An unsafe convenience method of `JSObject.subscript(_ index: Int) -> JSValue`
    /// - Precondition: `self` must be a JavaScript Object.
    subscript(_ index: Int) -> JSValue {
        get { object![index] }
        set { object![index] = newValue }
    }
}

extension JSValue: Swift.Error {}

public extension JSValue {
    func fromJSValue<Type>() -> Type? where Type: ConstructibleFromJSValue {
        return Type.construct(from: self)
    }
}

public extension JSValue {
    static func string(_ value: String) -> JSValue {
        .string(JSString(value))
    }

    /// Deprecated: Please create `JSClosure` directly and manage its lifetime manually.
    ///
    /// Migrate this usage
    ///
    /// ```swift
    /// button.addEventListener!("click", JSValue.function { _ in
    ///     ...
    ///     return JSValue.undefined
    /// })
    /// ```
    ///
    /// into below code.
    ///
    /// ```swift
    /// let eventListenter = JSClosure { _ in
    ///     ...
    ///     return JSValue.undefined
    /// }
    ///
    /// button.addEventListener!("click", JSValue.function(eventListenter))
    /// ...
    /// button.removeEventListener!("click", JSValue.function(eventListenter))
    /// eventListenter.release()
    /// ```
    @available(*, deprecated, message: "Please create JSClosure directly and manage its lifetime manually.")
    static func function(_ body: @escaping ([JSValue]) -> JSValue) -> JSValue {
        .object(JSClosure(body))
    }

    @available(*, deprecated, renamed: "object", message: "JSClosure is no longer a subclass of JSFunction. Use .object(closure) instead.")
    static func function(_ closure: JSClosure) -> JSValue {
        .object(closure)
    }
}

extension JSValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(JSString(value))
    }
}

extension JSValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int32) {
        self = .number(Double(value))
    }
}

extension JSValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number(value)
    }
}

extension JSValue: ExpressibleByNilLiteral {
    public init(nilLiteral _: ()) {
        self = .null
    }
}

public func getJSValue(this: JSObject, name: JSString) -> JSValue {
    var rawValue = RawJSValue()
    _get_prop(this.id, name.asInternalJSRef(),
              &rawValue.kind,
              &rawValue.payload1, &rawValue.payload2)
    return rawValue.jsValue
}

public func setJSValue(this: JSObject, name: JSString, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_prop(this.id, name.asInternalJSRef(), rawValue.kind, rawValue.payload1, rawValue.payload2)
    }
}

public func getJSValue(this: JSObject, index: Int32) -> JSValue {
    var rawValue = RawJSValue()
    _get_subscript(this.id, index,
                   &rawValue.kind,
                   &rawValue.payload1, &rawValue.payload2)
    return rawValue.jsValue
}

public func setJSValue(this: JSObject, index: Int32, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_subscript(this.id, index,
                       rawValue.kind,
                       rawValue.payload1, rawValue.payload2)
    }
}

public func getJSValue(this: JSObject, symbol: JSSymbol) -> JSValue {
    var rawValue = RawJSValue()
    _get_prop(this.id, symbol.id,
              &rawValue.kind,
              &rawValue.payload1, &rawValue.payload2)
    return rawValue.jsValue
}

public func setJSValue(this: JSObject, symbol: JSSymbol, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_prop(this.id, symbol.id, rawValue.kind, rawValue.payload1, rawValue.payload2)
    }
}

public extension JSValue {
    /// Return `true` if this value is an instance of the passed `constructor` function.
    /// Returns `false` for everything except objects and functions.
    /// - Parameter constructor: The constructor function to check.
    /// - Returns: The result of `instanceof` in the JavaScript environment.
    func isInstanceOf(_ constructor: JSFunction) -> Bool {
        switch self {
        case .boolean, .string, .number, .null, .undefined, .symbol:
            return false
#if !JAVASCRIPTKIT_WITHOUT_BIGINTS
        case .bigInt:
            return false
#endif
        case let .object(ref):
            return ref.isInstanceOf(constructor)
        case let .function(ref):
            return ref.isInstanceOf(constructor)
        }
    }
}

extension JSValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .boolean(boolean):
            return boolean.description
        case let .string(string):
            return string.description
        case let .number(number):
            return number.description
        case let .object(object), let .function(object as JSObject),
            let .symbol(object as JSObject):
            return object.toString!().fromJSValue()!
#if !JAVASCRIPTKIT_WITHOUT_BIGINTS
        case let .bigInt(object as JSObject):
            return object.toString!().fromJSValue()!
#endif
        case .null:
            return "null"
        case .undefined:
            return "undefined"
        }
    }
}
