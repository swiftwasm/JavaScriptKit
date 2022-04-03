/** A wrapper around [the JavaScript `Promise` class](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Promise)
that exposes its functions in a type-safe and Swifty way. The `JSPromise` API is generic over both
`Success` and `Failure` types, which improves compatibility with other statically-typed APIs such
as Combine. If you don't know the exact type of your `Success` value, you should use `JSValue`, e.g.
`JSPromise<JSValue, JSError>`. In the rare case, where you can't guarantee that the error thrown
is of actual JavaScript `Error` type, you should use `JSPromise<JSValue, JSValue>`.

This doesn't 100% match the JavaScript API, as `then` overload with two callbacks is not available.
It's impossible to unify success and failure types from both callbacks in a single returned promise
without type erasure. You should chain `then` and `catch` in those cases to avoid type erasure.
*/
public final class JSPromise: JSBridgedClass {
    /// The underlying JavaScript `Promise` object.
    public let jsObject: JSObject

    /// The underlying JavaScript `Promise` object wrapped as `JSValue`.
    public func jsValue() -> JSValue {
        .object(jsObject)
    }

    public static var constructor: JSFunction {
        JSObject.global.Promise.function!
    }

    /// This private initializer assumes that the passed object is a JavaScript `Promise`
    public init(unsafelyWrapping object: JSObject) {
        self.jsObject = object
    }

    /** Creates a new `JSPromise` instance from a given JavaScript `Promise` object. If `jsObject`
    is not an instance of JavaScript `Promise`, this initializer will return `nil`.
    */
    public convenience init?(_ jsObject: JSObject) {
        self.init(from: jsObject)
    }

    /** Creates a new `JSPromise` instance from a given JavaScript `Promise` object. If `value`
    is not an object and is not an instance of JavaScript `Promise`, this function will 
    return `nil`.
    */
    public static func construct(from value: JSValue) -> Self? {
        guard case let .object(jsObject) = value else { return nil }
        return Self.init(jsObject)
    }

    /** Creates a new `JSPromise` instance from a given `resolver` closure. `resolver` takes
    two closure that your code should call to either resolve or reject this `JSPromise` instance.
    */
    public convenience init(resolver: @escaping (@escaping (Result<JSValue, JSValue>) -> ()) -> ()) {
        let closure = JSOneshotClosure { arguments in
            // The arguments are always coming from the `Promise` constructor, so we should be
            // safe to assume their type here
            let resolve = arguments[0].function!
            let reject = arguments[1].function!

            resolver {
                switch $0 {
                case let .success(success):
                    resolve(success)
                case let .failure(error):
                    reject(error)
                }
            }
            return .undefined
        }
        self.init(unsafelyWrapping: Self.constructor.new(closure))
    }

    public static func resolve(_ value: ConvertibleToJSValue) -> JSPromise {
        self.init(unsafelyWrapping: Self.constructor.resolve!(value).object!)
    }

    public static func reject(_ reason: ConvertibleToJSValue) -> JSPromise {
        self.init(unsafelyWrapping: Self.constructor.reject!(reason).object!)
    }

    /** Schedules the `success` closure to be invoked on sucessful completion of `self`.
    */
    @discardableResult
    public func then(success: @escaping (JSValue) -> ConvertibleToJSValue) -> JSPromise {
        let closure = JSOneshotClosure {
            success($0[0]).jsValue
        }
        return JSPromise(unsafelyWrapping: jsObject.then!(closure).object!)
    }

    /** Schedules the `success` closure to be invoked on sucessful completion of `self`.
    */
    @discardableResult
    public func then(success: @escaping (JSValue) -> ConvertibleToJSValue,
                     failure: @escaping (JSValue) -> ConvertibleToJSValue) -> JSPromise {
        let successClosure = JSOneshotClosure {
            success($0[0]).jsValue
        }
        let failureClosure = JSOneshotClosure {
            failure($0[0]).jsValue
        }
        return JSPromise(unsafelyWrapping: jsObject.then!(successClosure, failureClosure).object!)
    }

    /** Schedules the `failure` closure to be invoked on rejected completion of `self`.
    */
    @discardableResult
    public func `catch`(failure: @escaping (JSValue) -> ConvertibleToJSValue) -> JSPromise {
        let closure = JSOneshotClosure {
            failure($0[0]).jsValue
        }
        return .init(unsafelyWrapping: jsObject.catch!(closure).object!)
    }

    /** Schedules the `failure` closure to be invoked on either successful or rejected completion of 
    `self`.
    */
    @discardableResult
    public func finally(successOrFailure: @escaping () -> ()) -> JSPromise {
        let closure = JSOneshotClosure { _ in
            successOrFailure()
            return .undefined
        }
        return .init(unsafelyWrapping: jsObject.finally!(closure).object!)
    }
}
