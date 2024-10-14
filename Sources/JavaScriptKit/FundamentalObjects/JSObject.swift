import _CJavaScriptKit

/// `JSObject` represents an object in JavaScript and supports dynamic member lookup.
/// Any member access like `object.foo` will dynamically request the JavaScript and Swift
/// runtime bridge library for a member with the specified name in this object.
///
/// And this object supports to call a member method of the object.
///
/// e.g.
/// ```swift
/// let document = JSObject.global.document.object!
/// let divElement = document.createElement!("div")
/// ```
///
/// The lifetime of this object is managed by the JavaScript and Swift runtime bridge library with
/// reference counting system.
@dynamicMemberLookup
public class JSObject: _JSObjectProtocol, Equatable {
    @_spi(JSObject_id)
    public var id: JavaScriptObjectRef
    @_spi(JSObject_id)
    public init(id: JavaScriptObjectRef) {
        self.id = id
    }

#if !hasFeature(Embedded)
    /// Returns the `name` member method binding this object as `this` context.
    ///
    /// e.g.
    /// ```swift
    /// let document = JSObject.global.document.object!
    /// let divElement = document.createElement!("div")
    /// ```
    ///
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The `name` member method binding this object as `this` context.
    @_disfavoredOverload
    public subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)? {
        guard let function = self[name].function else { return nil }
        return { (arguments: ConvertibleToJSValue...) in
            function(this: self, arguments: arguments)
        }
    }

    /// Returns the `name` member method binding this object as `this` context.
    ///
    /// e.g.
    /// ```swift
    /// let document = JSObject.global.document.object!
    /// let divElement = document.createElement!("div")
    /// ```
    ///
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The `name` member method binding this object as `this` context.
    @_disfavoredOverload
    public subscript(_ name: JSString) -> ((ConvertibleToJSValue...) -> JSValue)? {
        guard let function = self[name].function else { return nil }
        return { (arguments: ConvertibleToJSValue...) in
            function(this: self, arguments: arguments)
        }
    }

    /// A convenience method of `subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)?`
    /// to access the member through Dynamic Member Lookup.
    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) -> JSValue)? {
        self[name]
    }
#endif

    /// A convenience method of `subscript(_ name: String) -> JSValue`
    /// to access the member through Dynamic Member Lookup.
    public subscript(dynamicMember name: String) -> JSValue {
        get { self[name] }
        set { self[name] = newValue }
    }

    /// Access the `name` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The value of the `name` member of this object.
    public subscript(_ name: String) -> JSValue {
        get { getJSValue(this: self, name: JSString(name)) }
        set { setJSValue(this: self, name: JSString(name), value: newValue) }
    }

    /// Access the `name` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The value of the `name` member of this object.
    public subscript(_ name: JSString) -> JSValue {
        get { getJSValue(this: self, name: name) }
        set { setJSValue(this: self, name: name, value: newValue) }
    }

    /// Access the `index` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter index: The index of this object's member to access.
    /// - Returns: The value of the `index` member of this object.
    public subscript(_ index: Int) -> JSValue {
        get { getJSValue(this: self, index: Int32(index)) }
        set { setJSValue(this: self, index: Int32(index), value: newValue) }
    }

    /// Access the `symbol` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter symbol: The name of this object's member to access.
    /// - Returns: The value of the `name` member of this object.
    public subscript(_ name: JSSymbol) -> JSValue {
        get { getJSValue(this: self, symbol: name) }
        set { setJSValue(this: self, symbol: name, value: newValue) }
    }

#if !hasFeature(Embedded)
    /// A modifier to call methods as throwing methods capturing `this`
    ///
    ///
    /// ```javascript
    /// const animal = {
    ///   validateAge: function() {
    ///     if (this.age < 0) {
    ///       throw new Error("Invalid age");
    ///     }
    ///   }
    /// }
    /// ```
    ///
    /// ```swift
    /// let animal = JSObject.global.animal.object!
    /// try animal.throwing.validateAge!()
    /// ```
    public var throwing: JSThrowingObject {
        JSThrowingObject(self)
    }
#endif

    /// Return `true` if this value is an instance of the passed `constructor` function.
    /// - Parameter constructor: The constructor function to check.
    /// - Returns: The result of `instanceof` in the JavaScript environment.
    public func isInstanceOf(_ constructor: JSFunction) -> Bool {
        swjs_instanceof(id, constructor.id)
    }

    static let _JS_Predef_Value_Global: JavaScriptObjectRef = 0

    /// A `JSObject` of the global scope object.
    /// This allows access to the global properties and global names by accessing the `JSObject` returned.
    public static var global: JSObject { return _global }

    // `JSObject` storage itself is immutable, and use of `JSObject.global` from other
    // threads maintains the same semantics as `globalThis` in JavaScript.
    #if compiler(>=5.10)
    nonisolated(unsafe)
    static let _global = JSObject(id: _JS_Predef_Value_Global)
    #else
    static let _global = JSObject(id: _JS_Predef_Value_Global)
    #endif

    deinit { swjs_release(id) }

    /// Returns a Boolean value indicating whether two values point to same objects.
    ///
    /// - Parameters:
    ///   - lhs: A object to compare.
    ///   - rhs: Another object to compare.
    public static func == (lhs: JSObject, rhs: JSObject) -> Bool {
        return lhs.id == rhs.id
    }

    public static func construct(from value: JSValue) -> Self? {
        switch value {
        case .boolean,
                .string,
                .number,
                .null,
                .undefined: return nil
        case .object(let object):
            return object as? Self
        case .function(let function):
            return function as? Self
        case .symbol(let symbol):
            return symbol as? Self
        case .bigInt(let bigInt):
            return bigInt as? Self
        }
    }

    public var jsValue: JSValue {
        .object(self)
    }
}

extension JSObject: CustomStringConvertible {
    public var description: String { self.toString!().string! }
}

extension JSObject: Hashable {
    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#if !hasFeature(Embedded)
/// A `JSObject` wrapper that enables throwing method calls capturing `this`.
/// Exceptions produced by JavaScript functions will be thrown as `JSValue`.
@dynamicMemberLookup
public class JSThrowingObject {
    private let base: JSObject
    public init(_ base: JSObject) {
        self.base = base
    }

    /// Returns the `name` member method binding this object as `this` context.
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The `name` member method binding this object as `this` context.
    @_disfavoredOverload
    public subscript(_ name: String) -> ((ConvertibleToJSValue...) throws -> JSValue)? {
        guard let function = base[name].function?.throws else { return nil }
        return { [base] (arguments: ConvertibleToJSValue...) in
            try function(this: base, arguments: arguments)
        }
    }

    /// A convenience method of `subscript(_ name: String) -> ((ConvertibleToJSValue...) throws -> JSValue)?`
    /// to access the member through Dynamic Member Lookup.
    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) throws -> JSValue)? {
        self[name]
    }
}
#endif

/// Internal protocol to support generic arguments for `JSObject`.
/// 
/// In Swift Embedded, non-final classes cannot have generic methods.
public protocol _JSObjectProtocol: JSObject {
}

#if hasFeature(Embedded)
// NOTE: once embedded supports variadic generics, we can remove these overloads
public extension _JSObjectProtocol {
    @_disfavoredOverload
    subscript(dynamicMember name: String) -> (() -> JSValue)? {
        self[name].function.map { function in 
            { function(this: self) }
        }
    }

    @_disfavoredOverload
    subscript<A0: ConvertibleToJSValue>(dynamicMember name: String) -> ((A0) -> JSValue)? {
        self[name].function.map { function in 
            { function(this: self, $0) }
        }
    }

    @_disfavoredOverload
    subscript<A0: ConvertibleToJSValue, A1: ConvertibleToJSValue>(dynamicMember name: String) -> ((A0, A1) -> JSValue)? {
        self[name].function.map { function in 
            { function(this: self, $0, $1) }
        }
    }
}
#endif