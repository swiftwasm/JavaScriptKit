//
//  JSType.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// JavaScript Type (Class)
public protocol JSType: JSValueConvertible {
    
    init?(_ jsObject: JSObjectRef)
    
    var jsObject: JSObjectRef { get }
}

public extension JSType {
    
    func toString() -> String? {
        return jsObject.toString.function?().string
    }
}

// MARK: - JSValueConvertible

public extension JSType {
    
    func jsValue() -> JSValue { return .object(jsObject) }
}
