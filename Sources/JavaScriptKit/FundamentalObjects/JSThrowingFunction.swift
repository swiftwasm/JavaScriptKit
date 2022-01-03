import _CJavaScriptKit


/// A `JSFunction` wrapper that enables throwing function calls.
/// Exceptions produced by JavaScript functions will be thrown as `JSValue`.
public class JSThrowingFunction {
    private let base: JSFunction
    public init(_ base: JSFunction) {
        self.base = base
    }

    /// Call this function with given `arguments` and binding given `this` as context.
    /// - Parameters:
    ///   - this: The value to be passed as the `this` parameter to this function.
    ///   - arguments: Arguments to be passed to this function.
    /// - Returns: The result of this call.
    @discardableResult
    public func callAsFunction(this: JSObject? = nil, arguments: [ConvertibleToJSValue]) throws -> JSValue {
        try invokeJSFunction(base, arguments: arguments, this: this)
    }

    /// A variadic arguments version of `callAsFunction`.
    @discardableResult
    public func callAsFunction(this: JSObject? = nil, _ arguments: ConvertibleToJSValue...) throws -> JSValue {
        try self(this: this, arguments: arguments)
    }

    /// Instantiate an object from this function as a throwing constructor.
    ///
    /// Guaranteed to return an object because either:
    ///
    /// - a. the constructor explicitly returns an object, or
    /// - b. the constructor returns nothing, which causes JS to return the `this` value, or
    /// - c. the constructor returns undefined, null or a non-object, in which case JS also returns `this`.
    ///
    /// - Parameter arguments: Arguments to be passed to this constructor function.
    /// - Returns: A new instance of this constructor.
    public func new(arguments: [ConvertibleToJSValue]) throws -> JSObject {
        let result = arguments.withRawJSValues(using: base.bridge) { rawValues in
            base.bridge.throwingNew(class: base.id, args: rawValues)
        }
        switch result {
        case .success(let id):
            return JSObject(id: id, using: base.bridge)
        case .exception(let error):
            throw error.jsValue(using: base.bridge)
        }
    }

    /// A variadic arguments version of `new`.
    public func new(_ arguments: ConvertibleToJSValue...) throws -> JSObject {
        try new(arguments: arguments)
    }
}
