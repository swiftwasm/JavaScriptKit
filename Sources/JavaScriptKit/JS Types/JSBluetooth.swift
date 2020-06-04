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
    
    public var isAvailable: JSPromise<Bool> {
        guard let function = jsObject.getAvailability.function
            else { fatalError("Invalid function \(#function)") }
        let result = function.apply(this: jsObject)
        guard let promise = result.object.flatMap({ JSPromise<Bool>($0) })
            else { fatalError("Invalid object \(result)") }
        return promise
    }
    
    // MARK: - Methods
    
    /// Returns a Promise to a BluetoothDevice object with the specified options.
    /// If there is no chooser UI, this method returns the first device matching the criteria.
    ///
    /// - Returns: A Promise to a `BluetoothDevice` object.
    public func requestDevice(//filters: [] = [],
                              //services: [] = [],
                              acceptAllDevices: Bool = true) -> JSPromise<JSBluetoothDevice> {
        
        enum Option: String {
            case filters
            case optionalServices
            case acceptAllDevices
        }
        
        // Bluetooth.requestDevice([options])
        // .then(function(bluetoothDevice) { ... })
        
        guard let function = jsObject.requestDevice.function
            else { fatalError("Invalid function \(#function)") }
        
        // FIXME: Improve, support all options
        let options = JSObject()
        options[Option.acceptAllDevices.rawValue] = acceptAllDevices.jsValue()
        options[Option.optionalServices.rawValue] = ["device_information"].jsValue()
        
        let result = function.apply(this: jsObject, arguments: options)
        
        guard let promise = result.object.flatMap({ JSPromise<JSBluetoothDevice>($0) })
            else { fatalError("Invalid object \(result)") }
        
        return promise
    }
}
