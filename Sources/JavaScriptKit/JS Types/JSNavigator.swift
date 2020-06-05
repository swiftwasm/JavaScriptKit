//
//  JSNavigator.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// JavaScript Navigator object
public final class JSNavigator: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init?(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
        // TODO: validate JS class
    }
    
    public static let shared = JSObjectRef.global.navigator.object.flatMap { JSNavigator($0) }
    
    // MARK: - Properties
    
    public lazy var bluetooth = jsObject.bluetooth.object.flatMap { JSBluetooth($0) }
}

