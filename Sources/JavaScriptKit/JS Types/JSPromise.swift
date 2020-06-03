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
            return .undefined
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
    
    // MARK: - Properties
    
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
    
    public func then(_ completion: (Success) -> ()) {
        
    }
    
    public func `catch`(_ completion: (Error) -> ()) {
        
        
    }
    
    public func finally() {
        
        
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
