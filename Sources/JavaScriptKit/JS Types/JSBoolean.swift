//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// The Boolean object is an object wrapper for a boolean value.
public final class JSBoolean: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
    }
    
    public init(_ value: Bool) {
        self.jsObject = Self.classObject.new(value.jsValue())
    }
}

internal extension JSBoolean {
    
    static let classObject = JSObjectRef.global.Boolean.function!
}

// MARK: - CustomStringConvertible

extension JSBoolean: CustomStringConvertible { }

// MARK: - ExpressibleByBooleanLiteral

extension JSBoolean: ExpressibleByBooleanLiteral {
    
    public convenience init(booleanLiteral value: Bool) {
        self.init(value)
    }
}
