import JavaScriptKit

/// A `JSFunction` wrapper that enables throwing function calls.
/// Exceptions produced by JavaScript functions will be thrown as `JSValue`.
public class JSAsyncFunction {
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
    public func callAsFunction(this: JSObject? = nil, arguments: [ConvertibleToJSValue]) async throws -> JSValue {
        let result = base.callAsFunction(this: this, arguments: arguments)
        return await try JSPromise(result.object!)!.await()
    }

    /// A variadic arguments version of `callAsFunction`.
    @discardableResult
    public func callAsFunction(this: JSObject? = nil, _ arguments: ConvertibleToJSValue...) async throws -> JSValue {
        await try callAsFunction(this: this, arguments: arguments)
    }
}

public extension JSFunction {
    var `async`: JSAsyncFunction {
        JSAsyncFunction(self)
    }
}

/// A `JSObject` wrapper that enables throwing method calls capturing `this`.
/// Exceptions produced by JavaScript functions will be thrown as `JSValue`.
@dynamicMemberLookup
public class JSAsyncingObject {
    private let base: JSObject
    public init(_ base: JSObject) {
        self.base = base
    }

    /// Returns the `name` member method binding this object as `this` context.
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The `name` member method binding this object as `this` context.
    @_disfavoredOverload
    public subscript(_ name: String) -> ((ConvertibleToJSValue...) async throws -> JSValue)? {
        guard let function = base[name].function?.async else { return nil }
        return { [base] (arguments: ConvertibleToJSValue...) in
            await try function(this: base, arguments: arguments)
        }
    }

    /// A convenience method of `subscript(_ name: String) -> ((ConvertibleToJSValue...) throws -> JSValue)?`
    /// to access the member through Dynamic Member Lookup.
    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) async throws -> JSValue)? {
        self[name]
    }
}


public extension JSObject {
    var asyncing: JSAsyncingObject {
        JSAsyncingObject(self)
    }
}
