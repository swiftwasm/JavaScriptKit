import SwiftFoundation
import JavaScriptKit

let alert = JSObjectRef.global.alert.function!
let document = JSObjectRef.global.document.object!

let divElement = document.createElement!("div").object!
divElement.innerText = "Swift Bluetooth Web App"
let body = document.body.object!
_ = body.appendChild!(divElement)

let date = Date()
JSConsole.info("Date:", date)
JSConsole.log(date.description)

if let bluetooth = JSBluetooth.shared {
    bluetooth.isAvailable.then {
        JSConsole.assert($0, "Bluetooth not available")
    }.catch { (error: JSError) in
        JSConsole.debug(#file, #function, #line)
        JSConsole.error(error)
    }
    let buttonElement = document.createElement!("button").object!
    buttonElement.innerText = "Scan for Bluetooth devices"
    buttonElement.onclick = .function { _ in
        JSConsole.info("Swift is running on browser!")
        JSConsole.debug("\(#file) \(#function) \(#line)")
        alert("Swift is running on browser!")
        JSConsole.log("Requesting any Bluetooth Device...")
        bluetooth.requestDevice().then { (device: JSBluetoothDevice) -> (JSPromise<JSBluetoothRemoteGATTServer>) in
            JSConsole.info(device)
            JSConsole.debug("\(#file) \(#function) \(#line) \(device)")
            alert("Got device \(device)")
            JSConsole.log("Connecting to GATT Server...")
            return device.gatt.connect()
        }.then { (server: JSBluetoothRemoteGATTServer) -> (JSPromise<JSBluetoothRemoteGATTService>) in
            JSConsole.info(server)
            JSConsole.debug("\(#file) \(#function) \(#line) \(server)")
            alert("Connected")
            JSConsole.log("Getting Device Information Service...")
            return server.getPrimaryService("device_information")
        }.then { (service: JSBluetoothRemoteGATTService) -> () in
            JSConsole.info(service)
            JSConsole.debug("\(#file) \(#function) \(#line) isPrimary \(service.isPrimary) uuid \(service.uuid)")
        }.catch { (error: JSError) in
            JSConsole.debug(#file, #function, #line)
            JSConsole.error(error)
            alert("Error: \(error.message)")
        }
        JSConsole.debug("\(#file) \(#function) \(#line)")
        return .undefined
    }
    _ = body.appendChild!(buttonElement)
} else {
    JSConsole.error("Cannot access Bluetooth API")
    let divElement = document.createElement!("div").object!
    divElement.innerText = "Bluetooth Web API not enabled"
    _ = body.appendChild!(divElement)
}
