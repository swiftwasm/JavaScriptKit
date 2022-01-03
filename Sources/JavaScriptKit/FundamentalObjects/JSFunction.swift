import _CJavaScriptKit

/// `JSFunction` represents a function in JavaScript and supports new object instantiation.
/// This type can be callable as a function using `callAsFunction`.
///
/// e.g.
/// ```swift
/// let alert: JSFunction = JSObject.global.alert.function!
/// // Call `JSFunction` as a function
/// alert("Hello, world")
/// ```
///
public class JSFunction: JSObject {

    /// Call this function with given `arguments` and binding given `this` as context.
    /// - Parameters:
    ///   - this: The value to be passed as the `this` parameter to this function.
    ///   - arguments: Arguments to be passed to this function.
    /// - Returns: The result of this call.
    @discardableResult
    public func callAsFunction(this: JSObject? = nil, arguments: [ConvertibleToJSValue]) -> JSValue {
        try! invokeJSFunction(self, arguments: arguments, this: this)
    }

    /// A variadic arguments version of `callAsFunction`.
    @discardableResult
    public func callAsFunction(this: JSObject? = nil, _ arguments: ConvertibleToJSValue...) -> JSValue {
        self(this: this, arguments: arguments)
    }

    /// Instantiate an object from this function as a constructor.
    ///
    /// Guaranteed to return an object because either:
    ///
    /// - a. the constructor explicitly returns an object, or
    /// - b. the constructor returns nothing, which causes JS to return the `this` value, or
    /// - c. the constructor returns undefined, null or a non-object, in which case JS also returns `this`.
    ///
    /// - Parameter arguments: Arguments to be passed to this constructor function.
    /// - Returns: A new instance of this constructor.
    public func new(arguments: [ConvertibleToJSValue]) -> JSObject {
        arguments.withRawJSValues(using: bridge) { rawValues in
            return JSObject(id: bridge.new(class: self.id, args: rawValues), using: bridge)
        }
    }

    /// A modifier to call this function as a throwing function
    ///
    ///
    /// ```javascript
    /// function validateAge(age) {
    ///   if (age < 0) {
    ///     throw new Error("Invalid age");
    ///   }
    /// }
    /// ```
    ///
    /// ```swift
    /// let validateAge = JSObject.global.validateAge.function!
    /// try validateAge.throws(20)
    /// ```
    public var `throws`: JSThrowingFunction {
        JSThrowingFunction(self)
    }

    /// A variadic arguments version of `new`.
    public func new(_ arguments: ConvertibleToJSValue...) -> JSObject {
        new(arguments: arguments)
    }

    @available(*, unavailable, message: "Please use JSClosure instead")
    public static func from(_: @escaping ([JSValue]) -> JSValue) -> JSFunction {
        fatalError("unavailable")
    }

    public override class func construct(from value: JSValue) -> Self? {
        return value.function as? Self
    }

    override public func jsValue() -> JSValue {
        .function(self)
    }
}

internal func invokeJSFunction(_ jsFunc: JSFunction, arguments: [ConvertibleToJSValue], this: JSObject?) throws -> JSValue {
    let result: JSThrowingCallResult<RawJSValue> = arguments.withRawJSValues(using: jsFunc.bridge) { (rawValues) in
        if let thisId = this?.id {
            return jsFunc.bridge.call(function: jsFunc.id, this: thisId, args: rawValues)
        } else {
            return jsFunc.bridge.call(function: jsFunc.id, args: rawValues)
        }
    }
    switch result {
    case .exception(let exception):
        throw exception.jsValue(using: jsFunc.bridge)
    case .success(let value):
        return value.jsValue(using: jsFunc.bridge)
    }
}
