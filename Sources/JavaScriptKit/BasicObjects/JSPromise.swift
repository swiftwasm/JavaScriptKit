/** A wrapper around [the JavaScript `Promise` class](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise)
that exposes its functions in a type-safe and Swifty way. The `JSPromise` API is generic over both
`Success` and `Failure` types, which improves compatibility with other statically-typed APIs such
as Combine. If you don't know the exact type of your `Success` value, you should use `JSValue`, e.g.
`JSPromise<JSValue, JSError>`. In the rare case, where you can't guarantee that the error thrown
is of actual JavaScript `Error` type, you should use `JSPromise<JSValue, JSValue>`.
*/
public final class JSPromise<Success, Failure>: JSValueConvertible, JSValueConstructible
where Success: JSValueConstructible, Failure: JSValueConstructible {
    /// The underlying JavaScript `Promise` object.
    public let jsObject: JSObject

    private var callbacks = [JSClosure]()

    /// The underlying JavaScript `Promise` object wrapped as `JSValue`.
    public func jsValue() -> JSValue {
        .object(jsObject)
    }

    /// This private initializer assumes that the passed object is a JavaScript `Promise`
    private init(unsafe object: JSObject) {
        self.jsObject = object
    }

    /** Creates a new `JSPromise` instance from a given JavaScript `Promise` object. If `jsObject`
    is not an instance of JavaScript `Promise`, this initializer will return `nil`.
    */
    public init?(_ jsObject: JSObject) {
        guard jsObject.isInstanceOf(JSObject.global.Promise.function!) else { return nil }
        self.jsObject = jsObject
    }

    /** Creates a new `JSPromise` instance from a given JavaScript `Promise` object. If `value`
    is not an object and is not an instance of JavaScript `Promise`, this function will 
    return `nil`.
    */
    public static func construct(from value: JSValue) -> Self? {
        guard case let .object(jsObject) = value else { return nil }
        return Self.init(jsObject)
    }

    /** Schedules the `success` closure to be invoked on sucessful completion of `self`.
    */
    public func then(success: @escaping (Success) -> ()) {
        let closure = JSClosure {
            success(Success.construct(from: $0[0])!)
        }
        callbacks.append(closure)
        jsObject.then.function!(closure)
    }

    /** Returns a new promise created from chaining the current `self` promise with the `success`
    closure invoked on sucessful completion of `self`. The returned promise will have a new 
    `Success` type equal to the return type of `success`.
    */
    public func then<ResultType: JSValueConvertible>(
        success: @escaping (Success) -> ResultType
    ) -> JSPromise<ResultType, Failure> {
        let closure = JSClosure {
            success(Success.construct(from: $0[0])!).jsValue()
        }
        callbacks.append(closure)
        return .init(unsafe: jsObject.then.function!(closure).object!)
    }

    /** Returns a new promise created from chaining the current `self` promise with the `success`
    closure invoked on sucessful completion of `self`. The returned promise will have a new type
    equal to the return type of `success`.
    */
    public func then<ResultSuccess: JSValueConvertible, ResultFailure: JSValueConstructible>(
        success: @escaping (Success) -> JSPromise<ResultSuccess, ResultFailure>
    ) -> JSPromise<ResultSuccess, ResultFailure> {
        let closure = JSClosure {
            success(Success.construct(from: $0[0])!).jsValue()
        }
        callbacks.append(closure)
        return .init(unsafe: jsObject.then.function!(closure).object!)
    }

    /** Schedules the `failure` closure to be invoked on rejected completion of `self`.
    */
    public func `catch`(failure: @escaping (Failure) -> ()) {
        let closure = JSClosure {
            failure(Failure.construct(from: $0[0])!)
        }
        callbacks.append(closure)
        jsObject.then.function!(JSValue.undefined, closure)
    }

    /** Returns a new promise created from chaining the current `self` promise with the `failure`
    closure invoked on rejected completion of `self`. The returned promise will have a new `Success`
    type equal to the return type of the callback.
    */
    public func `catch`<ResultSuccess: JSValueConvertible>(
        failure: @escaping (Failure) -> ResultSuccess
    ) -> JSPromise<ResultSuccess, Never> {
        let closure = JSClosure {
            failure(Failure.construct(from: $0[0])!).jsValue()
        }
        callbacks.append(closure)
        return .init(unsafe: jsObject.then.function!(JSValue.undefined, closure).object!)
    }

    /** Returns a new promise created from chaining the current `self` promise with the `failure`
    closure invoked on rejected completion of `self`.  The returned promise will have a new type
    equal to the return type of `success`.
    */
    public func `catch`<ResultSuccess: JSValueConvertible, ResultFailure: JSValueConstructible>(
        failure: @escaping (Failure) -> JSPromise<ResultSuccess, ResultFailure>
    ) -> JSPromise<ResultSuccess, ResultFailure> {
        let closure = JSClosure {
            failure(Failure.construct(from: $0[0])!).jsValue()
        }
        callbacks.append(closure)
        return .init(unsafe: jsObject.then.function!(JSValue.undefined, closure).object!)
    }

    /** Schedules the `failure` closure to be invoked on either successful or rejected completion of 
    `self`.
    */
    public func finally(successOrFailure: @escaping () -> ()) -> Self {
        let closure = JSClosure { _ in
            successOrFailure()
        }
        callbacks.append(closure)
        return .init(unsafe: jsObject.finally.function!(closure).object!)
    }

    deinit {
        callbacks.forEach { $0.release() }
    }
}
