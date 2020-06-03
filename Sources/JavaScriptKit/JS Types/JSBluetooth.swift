//
//  JSBluetooth.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// JavaScript Bluetooth object
public final class JSBluetooth: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
    }
    
    public static var shared: JSBluetooth? { return JSNavigator.shared?.bluetooth }
    
    // MARK: - Methods
    
    public func requestDevice() {
        
        guard let function = jsObject.requestDevice.function
            else { assertionFailure("Nil \(#function)"); return }
        
        let promise = JSPromise()
        
        let result = function(promise)
        
        
    }
    
    
}
