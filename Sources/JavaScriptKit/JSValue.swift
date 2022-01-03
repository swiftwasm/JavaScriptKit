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

extension JSValue {
    /// An unsafe convenience method of `JSObject.subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)?`
    /// - Precondition: `self` must be a JavaScript Object and specified member should be a callable object.
    public subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) -> JSValue) {
        object![dynamicMember: name]!
    }

    /// An unsafe convenience method of `JSObject.subscript(_ index: Int) -> JSValue`
    /// - Precondition: `self` must be a JavaScript Object.
    public subscript(dynamicMember name: String) -> JSValue {
        get { self.object![name] }
        set { self.object![name] = newValue }
    }

    /// An unsafe convenience method of `JSObject.subscript(_ index: Int) -> JSValue`
    /// - Precondition: `self` must be a JavaScript Object.
    public subscript(_ index: Int) -> JSValue {
        get { object![index] }
        set { object![index] = newValue }
    }
}

extension JSValue: Swift.Error {}

extension JSValue {
    public func fromJSValue<Type>() -> Type? where Type: ConstructibleFromJSValue {
        return Type.construct(from: self)
    }
}

extension JSValue {

    public static func string(_ value: String) -> JSValue {
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
    public static func function(_ body: @escaping ([JSValue]) -> JSValue) -> JSValue {
        .object(JSClosure(body))
    }

    @available(*, deprecated, renamed: "object", message: "JSClosure is no longer a subclass of JSFunction. Use .object(closure) instead.")
    public static func function(_ closure: JSClosure) -> JSValue {
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
    public init(nilLiteral: ()) {
        self = .null
    }
}

public func getJSValue(this: JSObject, name: JSString, using bridge: JSBridge.Type = CJSBridge.self) -> JSValue {
    bridge.get(on: this.id, property: name.asInternalJSRef()).jsValue()
}

public func setJSValue(this: JSObject, name: JSString, value: JSValue, using bridge: JSBridge.Type = CJSBridge.self) {
    value.withRawJSValue { rawValue in
        bridge.set(on: this.id, property: name.asInternalJSRef(), to: rawValue)
    }
}

public func getJSValue(this: JSObject, index: Int32, using bridge: JSBridge.Type = CJSBridge.self) -> JSValue {
    bridge.get(on: this.id, index: index).jsValue()
}

public func setJSValue(this: JSObject, index: Int32, value: JSValue, using bridge: JSBridge.Type = CJSBridge.self) {
    value.withRawJSValue { rawValue in
        bridge.set(on: this.id, index: index, to: rawValue)
    }
}

extension JSValue {
  /// Return `true` if this value is an instance of the passed `constructor` function.
  /// Returns `false` for everything except objects and functions.
  /// - Parameter constructor: The constructor function to check.
  /// - Returns: The result of `instanceof` in the JavaScript environment.
    public func isInstanceOf(_ constructor: JSFunction) -> Bool {
        switch self {
        case .boolean, .string, .number, .null, .undefined:
            return false
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
        case .string(let string):
            return string.description
        case .number(let number):
            return number.description
        case .object(let object), .function(let object as JSObject):
            return object.toString!().fromJSValue()!
        case .null:
            return "null"
        case .undefined:
            return "undefined"
        }
    }
}
