import JavaScriptKit

let alert = JSObjectRef.global.alert.function!
let document = JSObjectRef.global.document.object!
let bluetooth = JSBluetooth.shared!

let divElement = document.createElement!("div").object!
divElement.innerText = "Hello, world"
let body = document.body.object!
_ = body.appendChild!(divElement)

let buttonElement = document.createElement!("button").object!
buttonElement.innerText = "Click me!"
buttonElement.onclick = .function { _ in
    JSConsole.debug("\(#file) \(#function) \(#line)")
    alert("Swift is running on browser!")
    JSConsole.log("Requesting device")
    bluetooth.requestDevice().then {
        JSConsole.info("\($0)")
        alert("Got device \($0)")
    }
    JSConsole.debug("\(#file) \(#function) \(#line)")
    return .undefined
}

_ = body.appendChild!(buttonElement)
