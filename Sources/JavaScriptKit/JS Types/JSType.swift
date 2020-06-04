//
//  JSType.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// JavaScript Type (Class)
public protocol JSType: JSValueConvertible, JSValueConstructible {
    
    init?(_ jsObject: JSObjectRef)
    
    var jsObject: JSObjectRef { get }
}

internal extension JSType {
    
    func toString() -> String? {
        return jsObject.toString.function?().string
    }
}

public extension JSType {
    
    static func construct(from value: JSValue) -> Self? {
        return value.object.flatMap { Self.init($0) }
    }
    
    func jsValue() -> JSValue {
        return .object(jsObject)
    }
}

public extension JSType where Self: CustomStringConvertible {
    
    var description: String {
        return toString() ?? ""
    }
}
