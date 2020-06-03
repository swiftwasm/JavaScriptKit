//
//  JSPromise.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/**
 JavaScript Promise
 
 A Promise is a proxy for a value not necessarily known when the promise is created. It allows you to associate handlers with an asynchronous action's eventual success value or failure reason. This lets asynchronous methods return values like synchronous methods: instead of immediately returning the final value, the asynchronous method returns a promise to supply the value at some point in the future.
 */
public final class JSPromise<Success: JSType>: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init?(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
        // validate if promise type
    }
    
    /**
     Initializes a Promise with the specified executor.
     
     - parameter executor: A function to be executed by the Promise.  The executor is custom code that ties an outcome to a promise. You, the programmer, write the executor.
     */
    public init(executor block: @escaping ((Success) -> (), (Error) -> ()) -> ()) {
        let executor = JSFunctionRef.from { (arguments) in
            let resolutionFunc = arguments[0].function
            let rejectionFunc = arguments[1].function
            block({ resolutionFunc?($0.jsValue()) }, { rejectionFunc?(JSValue(error: $0)) })
            return .null
        }
        self.jsObject = JSPromiseClassObject.new(executor)
    }
    
    /**
     Initializes a Promise with the specified executor.
     
     - parameter executor: A function to be executed by the Promise.  The executor is custom code that ties an outcome to a promise. You, the programmer, write the executor.
     */
    public convenience init(executor block: @escaping ((Result<Success, Swift.Error>) -> ()) -> ()) {
        self.init { (resolution, rejection) in
            block({
                switch $0 {
                case let .success(value):
                    resolution(value)
                case let .failure(error):
                    rejection(error)
                }
            })
        }
    }
    
    // MARK: - Accessors
    
    /// Promise State
    public var state: State {
        guard let value = jsObject.state.string.flatMap({ State(rawValue: $0) })
            else { fatalError("Invalid state: \(jsObject.state)") }
        return value
    }
    
    /// Promise result value.
    public var result: JSValue {
        return jsObject.result
    }
    
    // MARK: - Methods
    
    /**
     The `then()` method returns a Promise. It takes up to two arguments: callback functions for the success and failure cases of the Promise.
     
     - Parameter onFulfilled: A Function called if the Promise is fulfilled. This function has one argument, the fulfillment value. If it is not a function, it is internally replaced with an "Identity" function (it returns the received argument).
     
     - Parameter onRejected: A Function called if the Promise is rejected. This function has one argument, the rejection reason. If it is not a function, it is internally replaced with a "Thrower" function (it throws an error it received as argument).
     
     - Returns: Once a Promise is fulfilled or rejected, the respective handler function (onFulfilled or onRejected) will be called asynchronously (scheduled in the current thread loop). The behaviour of the handler function follows a specific set of rules.
     
     - Note: If a handler function:
     - returns a value, the promise returned by then gets resolved with the returned value as its value.
     - doesn't return anything, the promise returned by then gets resolved with an undefined value.
     - throws an error, the promise returned by then gets rejected with the thrown error as its value.
     - returns an already fulfilled promise, the promise returned by then gets fulfilled with that promise's value as its value.
     - returns an already rejected promise, the promise returned by then gets rejected with that promise's value as its value.
     - returns another pending promise object, the resolution/rejection of the promise returned by then will be subsequent to the resolution/rejection of  the promise returned by the handler. Also, the resolved value of the promise returned by then will be the same as the resolved value of the promise returned by the handler.
     */
    public func then/*<T: JSType>*/(onFulfilled: @escaping (Success) -> () /* onRejected: ((Error) -> ())? */) /* -> JSPromise<T> */ {
        
        let success = JSFunctionRef.from { (arguments) in
            if let value = arguments.first.flatMap({ Success.construct(from: $0) }) {
                onFulfilled(value)
            }
            return .null
        }
        /*
        let errorFunction = onRejected.flatMap { (onRejected) in
            JSFunctionRef.from { (arguments) in
                // TODO: Initialize error
                return .undefined
            }
        }*/
        let result = jsObject.then.function?(success, JSValue.null) //, errorFunction)
    }
    
    public func `catch`(_ completion: (Error) -> ()) {
        
        jsObject.catch.function?()
    }
    
    public func finally() {
        
        jsObject.finally.function?()
    }
}

private let JSPromiseClassObject = JSObjectRef.global.Promise.function!

// MARK: - Supporting Types

public extension JSPromise {
    
    enum State: String {
        
        /// Initial state, neither fulfilled nor rejected.
        case pending
        
        /// The operation completed successfully.
        case fulfilled
        
        /// the operation failed.
        case rejected
    }
}

extension JSPromise.State: JSValueConstructible {
    
    public static func construct(from value: JSValue) -> JSPromise.State? {
        return value.string.flatMap { JSPromise.State(rawValue: $0) }
    }
}
