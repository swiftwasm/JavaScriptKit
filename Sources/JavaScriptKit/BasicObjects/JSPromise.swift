/// A wrapper around [the JavaScript `Promise` class](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Promise)
public final class JSPromise: JSBridgedClass {
    /// The underlying JavaScript `Promise` object.
    public let jsObject: JSObject

    /// The underlying JavaScript `Promise` object wrapped as `JSValue`.
    public func jsValue() -> JSValue {
        .object(jsObject)
    }

    public static var constructor: JSFunction? {
        JSObject.global.Promise.function!
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
        guard case let .object(jsObject) = value else { return nil }
        return Self(jsObject)
    }

    /// Creates a new `JSPromise` instance from a given `resolver` closure.
    /// The closure is passed a completion handler. Passing a successful
    /// `Result` to the completion handler will cause the promise to resolve
    /// with the corresponding value; passing a failure `Result` will cause the
    /// promise to reject with the corresponding value.
    /// Calling the completion handler more than once will have no effect
    /// (per the JavaScript specification).
    public convenience init(resolver: @escaping (@escaping (Result<JSValue, JSValue>) -> Void) -> Void) {
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
        #if hasFeature(Embedded)
        self.init(unsafelyWrapping: Self.constructor!.new(closure.jsValue))
        #else
        self.init(unsafelyWrapping: Self.constructor!.new(closure))
        #endif
    }

    #if hasFeature(Embedded)
    public static func resolve(_ value: JSValue) -> JSPromise {
        self.init(unsafelyWrapping: Self.constructor!.resolve!(value).object!)
    }
    #else
    public static func resolve(_ value: ConvertibleToJSValue) -> JSPromise {
        self.init(unsafelyWrapping: Self.constructor!.resolve!(value).object!)
    }
    #endif

    #if hasFeature(Embedded)
    public static func reject(_ reason: JSValue) -> JSPromise {
        self.init(unsafelyWrapping: Self.constructor!.reject!(reason).object!)
    }
    #else
    public static func reject(_ reason: ConvertibleToJSValue) -> JSPromise {
        self.init(unsafelyWrapping: Self.constructor!.reject!(reason).object!)
    }
    #endif

    /// Schedules the `success` closure to be invoked on successful completion of `self`.
    #if hasFeature(Embedded)
    @discardableResult
    public func then(success: @escaping (JSValue) -> JSValue) -> JSPromise {
        let closure = JSOneshotClosure {
            success($0[0]).jsValue
        }
        return JSPromise(unsafelyWrapping: jsObject.then!(closure.jsValue).object!)
    }
    #else
    @discardableResult
    public func then(success: @escaping (JSValue) -> ConvertibleToJSValue) -> JSPromise {
        let closure = JSOneshotClosure {
            success($0[0]).jsValue
        }
        return JSPromise(unsafelyWrapping: jsObject.then!(closure).object!)
    }
    #endif

    #if !hasFeature(Embedded)
    #if compiler(>=5.5)
        /// Schedules the `success` closure to be invoked on successful completion of `self`.
        @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
        @discardableResult
        public func then(success: @escaping (JSValue) async throws -> ConvertibleToJSValue) -> JSPromise {
            let closure = JSOneshotClosure.async {
                try await success($0[0]).jsValue
            }
            return JSPromise(unsafelyWrapping: jsObject.then!(closure).object!)
        }
    #endif
    #endif

    /// Schedules the `success` closure to be invoked on successful completion of `self`.
    @discardableResult
    public func then(
        success: @escaping (JSValue) -> JSValue,
        failure: @escaping (JSValue) -> JSValue
    ) -> JSPromise {
        let successClosure = JSOneshotClosure {
            success($0[0]).jsValue
        }
        let failureClosure = JSOneshotClosure {
            failure($0[0]).jsValue
        }
        #if hasFeature(Embedded)
        return JSPromise(unsafelyWrapping: jsObject.then!(successClosure.jsValue, failureClosure.jsValue).object!)
        #else
        return JSPromise(unsafelyWrapping: jsObject.then!(successClosure, failureClosure).object!)
        #endif
    }

    #if !hasFeature(Embedded)
    #if compiler(>=5.5)
        /// Schedules the `success` closure to be invoked on successful completion of `self`.
        @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
        @discardableResult
        public func then(success: @escaping (JSValue) async throws -> ConvertibleToJSValue,
                         failure: @escaping (JSValue) async throws -> ConvertibleToJSValue) -> JSPromise
        {
            let successClosure = JSOneshotClosure.async {
                try await success($0[0]).jsValue
            }
            let failureClosure = JSOneshotClosure.async {
                try await failure($0[0]).jsValue
            }
            return JSPromise(unsafelyWrapping: jsObject.then!(successClosure, failureClosure).object!)
        }
    #endif
    #endif

    /// Schedules the `failure` closure to be invoked on rejected completion of `self`.
    @discardableResult
    public func `catch`(failure: @escaping (JSValue) -> JSValue) -> JSPromise {
        let closure = JSOneshotClosure {
            failure($0[0]).jsValue
        }
        #if hasFeature(Embedded)
        return .init(unsafelyWrapping: jsObject.catch!(closure.jsValue).object!)
        #else
        return .init(unsafelyWrapping: jsObject.catch!(closure).object!)
        #endif
    }

    #if !hasFeature(Embedded)
    #if compiler(>=5.5)
        /// Schedules the `failure` closure to be invoked on rejected completion of `self`.
        @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
        @discardableResult
        public func `catch`(failure: @escaping (JSValue) async throws -> ConvertibleToJSValue) -> JSPromise {
            let closure = JSOneshotClosure.async {
                try await failure($0[0]).jsValue
            }
            return .init(unsafelyWrapping: jsObject.catch!(closure).object!)
        }
    #endif
    #endif

    /// Schedules the `failure` closure to be invoked on either successful or rejected
    /// completion of `self`.
    @discardableResult
    public func finally(successOrFailure: @escaping () -> Void) -> JSPromise {
        let closure = JSOneshotClosure { _ in
            successOrFailure()
            return .undefined
        }
        #if hasFeature(Embedded)
        return .init(unsafelyWrapping: jsObject.finally!(closure.jsValue).object!)
        #else
        return .init(unsafelyWrapping: jsObject.finally!(closure).object!)
        #endif
    }
}
