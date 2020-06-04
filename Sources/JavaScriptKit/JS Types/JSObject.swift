//
//  JSObject.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// JavaScript Object
public final class JSObject: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init?(_ jsObject: JSObjectRef) {
        guard Self.isObject(jsObject)
            else { return nil }
        self.jsObject = jsObject
    }
    
    public init() {
        self.jsObject = Self.classObject.new()
        //assert(Self.isObject(jsObject))
    }
    
    public convenience init(_ elements: [(key: String, value: JSValue)]) {
        self.init()
        elements.forEach { self[$0.key] = $0.value }
    }
}

internal extension JSObject {
    
    static let classObject = JSObjectRef.global.Object.function!

    static func isObject(_ object: JSObjectRef) -> Bool {
        classObject.isObject.function?(object).boolean ?? false
    }
}

public extension JSObject {
    
    subscript (key: String) -> JSValue {
        get { jsObject.get(key) }
        set { jsObject.set(key, newValue) }
    }
}

// MARK: - CustomStringConvertible

extension JSObject: CustomStringConvertible { }

// MARK: - ExpressibleByDictionaryLiteral

extension JSObject: ExpressibleByDictionaryLiteral {
    
    public convenience init(dictionaryLiteral elements: (String, JSValue)...) {
        self.init(elements)
    }
}
