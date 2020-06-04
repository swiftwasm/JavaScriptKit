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

    public init?(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
    }
    
    // MARK: - Accessors
    
    /// A string that uniquely identifies a device.
    public lazy var id: String = self.jsObject.get("id").string!
    
    /// A string that provices a human-readable name for the device.
    public var name: String? {
        return self.jsObject.name.string
    }
    
    /// Interface of the Web Bluetooth API represents a GATT Server on a remote device.
    public lazy var gatt = self.jsObject.gatt.object.flatMap({ JSBluetoothRemoteGATTServer($0) })!
}

// MARK: - CustomStringConvertible

extension JSBluetoothDevice: CustomStringConvertible {
    
    public var description: String {
        return "JSBluetoothDevice(id: \(id), name: \(name ?? "nil"))"
    }
}

// MARK: - Identifiable

extension JSBluetoothDevice: Identifiable { }
