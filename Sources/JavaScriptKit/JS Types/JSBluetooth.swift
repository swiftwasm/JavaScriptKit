//
//  JSBluetooth.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// JavaScript Bluetooth interface
/// 
/// - SeeAlso: [Web Bluetooth API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Bluetooth_API)
public final class JSBluetooth: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init?(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
    }
    
    public static var shared: JSBluetooth? { return JSNavigator.shared?.bluetooth }
    
    // MARK: - Accessors
    
    /**
     Returns a Promise that resolved to a Boolean indicating whether the user-agent has the ability to support Bluetooth. Some user-agents let the user configure an option that affects what is returned by this value. If this option is set, that is the value returned by this method.
     */
    public var isAvailable: JSPromise<Bool> {
        guard let function = jsObject.getAvailability.function
            else { fatalError("Invalid function \(#function)") }
        let result = function.apply(this: jsObject)
        guard let promise = result.object.flatMap({ JSPromise<Bool>($0) })
            else { fatalError("Invalid object \(result)") }
        return promise
    }
    
    /**
     Returns a `Promise` that resolved to an array of `BluetoothDevice` which the origin already obtained permission for via a call to `Bluetooth.requestDevice()`.
     */
    public var devices: JSPromise<[JSBluetoothDevice]> {
        guard let function = jsObject.getDevices.function
            else { fatalError("Invalid function \(#function)") }
        let result = function.apply(this: jsObject)
        guard let promise = result.object.flatMap({ JSPromise<[JSBluetoothDevice]>($0) })
            else { fatalError("Invalid object \(result)") }
        return promise
    }
    
    // MARK: - Methods
    
    /// Returns a Promise to a BluetoothDevice object with the specified options.
    /// If there is no chooser UI, this method returns the first device matching the criteria.
    ///
    /// - Returns: A Promise to a `BluetoothDevice` object.
    public func requestDevice() -> JSPromise<JSBluetoothDevice> {
        let options = RequestDeviceOptions(filters: nil, optionalServices: nil, acceptAllDevices: true)
        return requestDevice(options: options)
    }
    
    /// Returns a Promise to a BluetoothDevice object with the specified options.
    /// If there is no chooser UI, this method returns the first device matching the criteria.
    ///
    /// - Returns: A Promise to a `BluetoothDevice` object.
    internal func requestDevice(options: RequestDeviceOptions) -> JSPromise<JSBluetoothDevice> {
        
        // Bluetooth.requestDevice([options])
        // .then(function(bluetoothDevice) { ... })
        
        guard let function = jsObject.requestDevice.function
            else { fatalError("Invalid function \(#function)") }
        let result = function.apply(this: jsObject, arguments: options)
        guard let promise = result.object.flatMap({ JSPromise<JSBluetoothDevice>($0) })
            else { fatalError("Invalid object \(result)") }
        return promise
    }
}

// MARK: - Supporting Types

public extension JSBluetooth {
    
    struct ScanFilter: Equatable, Hashable, Codable {
                
        public var services: [String]?
        
        public var name: String?
        
        public var namePrefix: String?
        
        public init(services: [String]? = nil,
                    name: String? = nil,
                    namePrefix: String? = nil) {
            self.services = services
            self.name = name
            self.namePrefix = namePrefix
        }
    }
}

internal extension JSBluetooth {
    
    struct RequestDeviceOptions: Encodable, JSValueConvertible {
        
        var filters: [ScanFilter]?
        
        var optionalServices: [String]?
        
        var acceptAllDevices: Bool?
    }
}
