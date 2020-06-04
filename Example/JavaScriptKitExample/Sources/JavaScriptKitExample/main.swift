import JavaScriptKit

let alert = JSObjectRef.global.alert.function!
let document = JSObjectRef.global.document.object!
let bluetooth = JSBluetooth.shared!

let divElement = document.createElement!("div").object!
divElement.innerText = "Swift Bluetooth Web App"
let body = document.body.object!
_ = body.appendChild!(divElement)

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
    }.then { (server: JSBluetoothRemoteGATTServer) -> () in
        JSConsole.info(server)
        JSConsole.debug("\(#file) \(#function) \(#line) \(server)")
        alert("Connected")
    }.catch { (error: JSError) in
        alert("Error: \(error)")
    }
    JSConsole.debug("\(#file) \(#function) \(#line)")
    return .undefined
}

_ = body.appendChild!(buttonElement)
