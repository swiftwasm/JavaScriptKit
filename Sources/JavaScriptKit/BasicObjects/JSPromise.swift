#if hasFeature(Embedded) && os(WASI)
import _Concurrency
#endif

/// A wrapper around [the JavaScript `Promise` class](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Promise)
public final class JSPromise: JSBridgedClass {
    /// The underlying JavaScript `Promise` object.
    public let jsObject: JSObject

    /// The underlying JavaScript `Promise` object wrapped as `JSValue`.
    public func jsValue() -> JSValue {
        .object(jsObject)
    }

    public static var constructor: JSObject? {
        JSObject.global.Promise.object!
    }

    /// This private initializer assumes that the passed object is a JavaScript `Promise`
    public init(unsafelyWrapping object: JSObject) {
        jsObject = object
    }

    /// Creates a new `JSPromise` instance from a given JavaScript `Promise` object. If `jsObject`
    /// is not an instance of JavaScript `Promise`, this initializer will return `nil`.
    public convenience init?(_ jsObject: JSObject) {
        self.init(from: jsObject)
    }

    /// Creates a new `JSPromise` instance from a given JavaScript `Promise` object. If `value`
    /// is not an object and is not an instance of JavaScript `Promise`, this function will
    /// return `nil`.
    public static func construct(from value: JSValue) -> Self? {
        guard let jsObject = value.object else { return nil }
        return Self(jsObject)
    }

    /// The result of a promise.
    public enum Result: Equatable {
        /// The promise resolved with a value.
        case success(JSValue)
        /// The promise rejected with a value.
        case failure(JSValue)
    }

    /// Creates a new `JSPromise` instance from a given `resolver` closure.
    /// The closure is passed a completion handler. Passing a successful
    /// `Result` to the completion handler will cause the promise to resolve
    /// with the corresponding value; passing a failure `Result` will cause the
    /// promise to reject with the corresponding value.
    /// Calling the completion handler more than once will have no effect
    /// (per the JavaScript specification).
    public convenience init(resolver: @escaping (@escaping (Result) -> Void) -> Void) {
        let closure = JSOneshotClosure { arguments in
            // The arguments are always coming from the `Promise` constructor, so we should be
            // safe to assume their type here
            let resolve = arguments[0].object!
            let reject = arguments[1].object!

            resolver {
                switch $0 {
                case .success(let success):
                    resolve(success)
                case .failure(let error):
                    reject(error)
                }
            }
            return .undefined
        }
        self.init(unsafelyWrapping: Self.constructor!.new(closure))
    }

    #if compiler(>=5.5) && (!hasFeature(Embedded) || os(WASI))
    /// Creates a new `JSPromise` instance from a given async closure.
    ///
    /// - Parameter body: The async closure to execute.
    /// - Returns: A new `JSPromise` instance.
    public static func async(body: @escaping @isolated(any) () async throws(JSException) -> Void) -> JSPromise {
        self.async { () throws(JSException) -> JSValue in
            try await body()
            return .undefined
        }
    }

    /// Creates a new `JSPromise` instance from a given async closure.
    ///
    /// - Parameter body: The async closure to execute.
    /// - Returns: A new `JSPromise` instance.
    public static func async(body: @escaping @isolated(any) () async throws(JSException) -> JSValue) -> JSPromise {
        JSPromise { resolver in
            // NOTE: The context is fully transferred to the unstructured task
            // isolation but the compiler can't prove it yet, so we need to
            // use `@unchecked Sendable` to make it compile with the Swift 6 mode.
            struct Context: @unchecked Sendable {
                let resolver: (JSPromise.Result) -> Void
                let body: () async throws(JSException) -> JSValue
            }
            let context = Context(resolver: resolver, body: body)
            Task {
                do throws(JSException) {
                    let result = try await context.body()
                    context.resolver(.success(result))
                } catch {
                    context.resolver(.failure(error.thrownValue))
                }
            }
        }
    }
    #endif

    #if !hasFeature(Embedded)
    public static func resolve(_ value: ConvertibleToJSValue) -> JSPromise {
        self.init(unsafelyWrapping: Self.constructor!.resolve!(value).object!)
    }

    public static func reject(_ reason: ConvertibleToJSValue) -> JSPromise {
        self.init(unsafelyWrapping: Self.constructor!.reject!(reason).object!)
    }
    #else
    public static func resolve(_ value: some ConvertibleToJSValue) -> JSPromise {
        self.init(unsafelyWrapping: constructor!.resolve!(value).object!)
    }

    public static func reject(_ reason: some ConvertibleToJSValue) -> JSPromise {
        self.init(unsafelyWrapping: constructor!.reject!(reason).object!)
    }
    #endif

    /// Schedules the `success` closure to be invoked on successful completion of `self`.
    @discardableResult
    public func then(success: @escaping (JSValue) -> JSValue) -> JSPromise {
        let closure = JSOneshotClosure {
            success($0[0]).jsValue
        }
        return JSPromise(unsafelyWrapping: jsObject.then!(closure).object!)
    }

    #if compiler(>=5.5) && (!hasFeature(Embedded) || os(WASI))
    /// Schedules the `success` closure to be invoked on successful completion of `self`.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    @discardableResult
    public func then(
        success: sending @escaping (sending JSValue) async throws(JSException) -> JSValue
    ) -> JSPromise {
        let closure = JSOneshotClosure.async { arguments throws(JSException) -> JSValue in
            return try await success(arguments[0])
        }
        return JSPromise(unsafelyWrapping: jsObject.then!(closure).object!)
    }
    #endif

    /// Schedules the `success` closure to be invoked on successful completion of `self`.
    @discardableResult
    public func then(
        success: @escaping (sending JSValue) -> JSValue,
        failure: @escaping (sending JSValue) -> JSValue
    ) -> JSPromise {
        let successClosure = JSOneshotClosure {
            success($0[0]).jsValue
        }
        let failureClosure = JSOneshotClosure {
            failure($0[0]).jsValue
        }
        return JSPromise(unsafelyWrapping: jsObject.then!(successClosure, failureClosure).object!)
    }

    #if compiler(>=5.5) && (!hasFeature(Embedded) || os(WASI))
    /// Schedules the `success` closure to be invoked on successful completion of `self`.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    @discardableResult
    public func then(
        success: sending @escaping (sending JSValue) async throws(JSException) -> JSValue,
        failure: sending @escaping (sending JSValue) async throws(JSException) -> JSValue
    ) -> JSPromise {
        let successClosure = JSOneshotClosure.async { arguments throws(JSException) -> JSValue in
            try await success(arguments[0]).jsValue
        }
        let failureClosure = JSOneshotClosure.async { arguments throws(JSException) -> JSValue in
            try await failure(arguments[0]).jsValue
        }
        return JSPromise(unsafelyWrapping: jsObject.then!(successClosure, failureClosure).object!)
    }
    #endif

    /// Schedules the `failure` closure to be invoked on rejected completion of `self`.
    @discardableResult
    public func `catch`(
        failure: @escaping (sending JSValue) -> JSValue
    )
        -> JSPromise
    {
        let closure = JSOneshotClosure {
            failure($0[0]).jsValue
        }
        return .init(unsafelyWrapping: jsObject.catch!(closure).object!)
    }

    #if compiler(>=5.5) && (!hasFeature(Embedded) || os(WASI))
    /// Schedules the `failure` closure to be invoked on rejected completion of `self`.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    @discardableResult
    public func `catch`(
        failure: sending @escaping (sending JSValue) async throws(JSException) -> JSValue
    ) -> JSPromise {
        let closure = JSOneshotClosure.async { arguments throws(JSException) -> JSValue in
            try await failure(arguments[0]).jsValue
        }
        return .init(unsafelyWrapping: jsObject.catch!(closure).object!)
    }
    #endif

    /// Schedules the `failure` closure to be invoked on either successful or rejected
    /// completion of `self`.
    @discardableResult
    public func finally(successOrFailure: @escaping () -> Void) -> JSPromise {
        let closure = JSOneshotClosure { _ in
            successOrFailure()
            return .undefined
        }
        return .init(unsafelyWrapping: jsObject.finally!(closure).object!)
    }
}
