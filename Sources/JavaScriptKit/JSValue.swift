import _CJavaScriptKit

/// `JSValue` represents a value in JavaScript.
@dynamicMemberLookup
public struct JSValue: Equatable {
    /// The internal storage of the JSValue, which is intentionally not public
    /// to leave the flexibility to change the storage.
    internal enum Storage: Equatable {
        case boolean(Bool)
        case string(JSString)
        case number(Double)
        case object(JSObject)
        case null
        case undefined
        case symbol(JSSymbol)
        case bigInt(JSBigInt)
    }

    internal var storage: Storage

    internal init(storage: Storage) {
        self.storage = storage
    }

    public static func boolean(_ value: Bool) -> JSValue {
        .init(storage: .boolean(value))
    }
    public static func string(_ value: JSString) -> JSValue {
        .init(storage: .string(value))
    }
    public static func number(_ value: Double) -> JSValue {
        .init(storage: .number(value))
    }
    public static func object(_ value: JSObject) -> JSValue {
        .init(storage: .object(value))
    }
    public static var null: JSValue {
        .init(storage: .null)
    }
    public static var undefined: JSValue {
        .init(storage: .undefined)
    }
    public static func symbol(_ value: JSSymbol) -> JSValue {
        .init(storage: .symbol(value))
    }
    public static func bigInt(_ value: JSBigInt) -> JSValue {
        .init(storage: .bigInt(value))
    }

    /// Returns the `Bool` value of this JS value if its type is boolean.
    /// If not, returns `nil`.
    public var boolean: Bool? {
        switch storage {
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
        switch storage {
        case .string(let string): return string
        default: return nil
        }
    }

    /// Returns the `Double` value of this JS value if the type is number.
    /// If not, returns `nil`.
    public var number: Double? {
        switch storage {
        case .number(let number): return number
        default: return nil
        }
    }

    /// Returns the `JSObject` of this JS value if its type is object.
    /// If not, returns `nil`.
    public var object: JSObject? {
        switch storage {
        case .object(let object): return object
        default: return nil
        }
    }

    // @available(*, deprecated, renamed: "object", message: "Use the .object property instead")
    public var function: JSObject? { object }

    /// Returns the `JSSymbol` of this JS value if its type is function.
    /// If not, returns `nil`.
    public var symbol: JSSymbol? {
        switch storage {
        case .symbol(let symbol): return symbol
        default: return nil
        }
    }

    /// Returns the `JSBigInt` of this JS value if its type is function.
    /// If not, returns `nil`.
    public var bigInt: JSBigInt? {
        switch storage {
        case .bigInt(let bigInt): return bigInt
        default: return nil
        }
    }

    /// Returns the `true` if this JS value is null.
    /// If not, returns `false`.
    public var isNull: Bool {
        return storage == .null
    }

    /// Returns the `true` if this JS value is undefined.
    /// If not, returns `false`.
    public var isUndefined: Bool {
        return storage == .undefined
    }
}

/// JSValue is intentionally not `Sendable` because accessing a JSValue living in a different
/// thread is invalid. Although there are some cases where Swift allows sending a non-Sendable
/// values to other isolation domains, not conforming `Sendable` is still useful to prevent
/// accidental misuse.
@available(*, unavailable)
extension JSValue: Sendable {}

extension JSValue {
    #if !hasFeature(Embedded)
    /// An unsafe convenience method of `JSObject.subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)?`
    /// - Precondition: `self` must be a JavaScript Object and specified member should be a callable object.
    public subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) -> JSValue) {
        object![dynamicMember: name]!
    }
    #endif

    /// An unsafe convenience method of `JSObject.subscript(_ index: Int) -> JSValue`
    /// - Precondition: `self` must be a JavaScript Object.
    public subscript(dynamicMember name: String) -> JSValue {
        get { self.object![name] }
        nonmutating set { self.object![name] = newValue }
    }

    /// An unsafe convenience method of `JSObject.subscript(_ index: Int) -> JSValue`
    /// - Precondition: `self` must be a JavaScript Object.
    public subscript(_ index: Int) -> JSValue {
        get { object![index] }
        nonmutating set { object![index] = newValue }
    }
}

extension JSValue {
    public func fromJSValue<Type>() -> Type? where Type: ConstructibleFromJSValue {
        return Type.construct(from: self)
    }
}

extension JSValue {
    public static func string(_ value: String) -> JSValue {
        .init(storage: .string(JSString(value)))
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
    /// let eventListener = JSClosure { _ in
    ///     ...
    ///     return JSValue.undefined
    /// }
    ///
    /// button.addEventListener!("click", JSValue.function(eventListener))
    /// ...
    /// button.removeEventListener!("click", JSValue.function(eventListener))
    /// eventListener.release()
    /// ```
    @available(*, deprecated, message: "Please create JSClosure directly and manage its lifetime manually.")
    public static func function(_ body: @escaping ([JSValue]) -> JSValue) -> JSValue {
        .init(storage: .object(JSClosure(body)))
    }

    @available(
        *,
        deprecated,
        renamed: "object",
        message: "JSClosure is no longer a subclass of JSFunction. Use .object(closure) instead."
    )
    public static func function(_ closure: JSClosure) -> JSValue {
        .init(storage: .object(closure))
    }

    @available(*, deprecated, renamed: "object", message: "Use .object(function) instead")
    public static func function(_ function: JSObject) -> JSValue { .init(storage: .object(function)) }
}

extension JSValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .init(storage: .string(JSString(value)))
    }
}

extension JSValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int32) {
        self = .init(storage: .number(Double(value)))
    }
}

extension JSValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .init(storage: .number(value))
    }
}

extension JSValue: ExpressibleByNilLiteral {
    public init(nilLiteral _: ()) {
        self = .init(storage: .null)
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

public func getJSValue(this: JSObject, symbol: JSSymbol) -> JSValue {
    var rawValue = RawJSValue()
    let rawBitPattern = swjs_get_prop(
        this.id,
        symbol.id,
        &rawValue.payload1,
        &rawValue.payload2
    )
    rawValue.kind = unsafeBitCast(rawBitPattern, to: JavaScriptValueKind.self)
    return rawValue.jsValue
}

public func setJSValue(this: JSObject, symbol: JSSymbol, value: JSValue) {
    value.withRawJSValue { rawValue in
        swjs_set_prop(this.id, symbol.id, rawValue.kind, rawValue.payload1, rawValue.payload2)
    }
}

extension JSValue {
    /// Return `true` if this value is an instance of the passed `constructor` function.
    /// Returns `false` for everything except objects and functions.
    /// - Parameter constructor: The constructor function to check.
    /// - Returns: The result of `instanceof` in the JavaScript environment.
    public func isInstanceOf(_ constructor: JSObject) -> Bool {
        switch storage {
        case .boolean, .string, .number, .null, .undefined, .symbol, .bigInt:
            return false
        case .object(let ref):
            return ref.isInstanceOf(constructor)
        }
    }
}

extension JSValue: CustomStringConvertible {
    public var description: String {
        // per https://tc39.es/ecma262/multipage/text-processing.html#sec-string-constructor-string-value
        // this always returns a string
        JSObject.global.String.object!(self).string!
    }
}

#if hasFeature(Embedded)
// Overloads of `JSValue.subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) -> JSValue)`
// for 0 through 7 arguments for Embedded Swift.
//
// These are required because the `ConvertibleToJSValue...` subscript is not
// available in Embedded Swift due to lack of support for existentials.
//
// Note: Once Embedded Swift supports parameter packs/variadic generics, we can
// replace all of these with a single method that takes a generic pack.
extension JSValue {
    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> (() -> JSValue) {
        object![dynamicMember: name]!
    }

    @_disfavoredOverload
    public subscript<A0: ConvertibleToJSValue>(dynamicMember name: String) -> ((A0) -> JSValue) {
        object![dynamicMember: name]!
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1) -> JSValue) {
        object![dynamicMember: name]!
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2) -> JSValue) {
        object![dynamicMember: name]!
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue,
        A3: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2, A3) -> JSValue) {
        object![dynamicMember: name]!
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue,
        A3: ConvertibleToJSValue,
        A4: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2, A3, A4) -> JSValue) {
        object![dynamicMember: name]!
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue,
        A3: ConvertibleToJSValue,
        A4: ConvertibleToJSValue,
        A5: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2, A3, A4, A5) -> JSValue) {
        object![dynamicMember: name]!
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue,
        A3: ConvertibleToJSValue,
        A4: ConvertibleToJSValue,
        A5: ConvertibleToJSValue,
        A6: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2, A3, A4, A5, A6) -> JSValue) {
        object![dynamicMember: name]!
    }
}
#endif
