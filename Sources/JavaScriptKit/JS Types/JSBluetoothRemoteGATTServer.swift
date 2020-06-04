//
//  JSBluetoothRemoteGATTServer.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// Represents a GATT Server on a remote device.
// https://developer.mozilla.org/en-US/docs/Web/API/BluetoothRemoteGATTServer
public final class JSBluetoothRemoteGATTServer: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
    }
    
    // MARK: - Accessors
    
    public var isConnected: Bool {
        return jsObject.connected.boolean ?? false
    }
    
    // MARK: - Methods
    
    public func connect() -> JSPromise<JSBluetoothRemoteGATTServer> {
        guard let function = jsObject.connect.function
            else { fatalError("Missing function \(#function)") }
        let result = function.apply(this: jsObject)
        guard let promise = result.object.flatMap({ JSPromise<JSBluetoothRemoteGATTServer>($0) })
            else { fatalError("Invalid object \(result)") }
        return promise
    }
    
    public func disconnect() {
        jsObject.disconnect.function?.apply(this: jsObject)
    }
}
