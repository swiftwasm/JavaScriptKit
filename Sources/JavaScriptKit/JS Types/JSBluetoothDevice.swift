//
//  JSBluetoothDevice.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// JavaScript Bluetooth Device object.
public final class JSBluetoothDevice: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
    }
    
    // MARK: - Accessors
    
    public lazy var id: String = self.jsObject.get("id").string!
    
    public lazy var name: String = self.jsObject.name.string!
    
    
}

// MARK: - Identifiable

extension JSBluetoothDevice: Identifiable { }
