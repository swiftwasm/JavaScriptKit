//
//  JSPromise.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

public final class JSPromise: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init?(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
        // validate if promise type
    }
    
    public init() {
        self.jsObject = Self.classObject.new()
    }
}

internal extension JSPromise {
    
    static let classObject = JSObjectRef.global.Promise.function!
}
