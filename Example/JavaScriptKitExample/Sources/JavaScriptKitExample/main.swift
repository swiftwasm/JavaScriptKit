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
    JSObjectRef.global.console.object?.log.function?("\(#file) \(#function) \(#line)")
    alert("Swift is running on browser!")
    bluetooth.requestDevice().then {
        JSObjectRef.global.console.object?.log.function?("\($0)")
        alert("Got device \($0)")
    }
    JSObjectRef.global.console.object?.log.function?("\(#file) \(#function) \(#line)")
    return .undefined
}

_ = body.appendChild!(buttonElement)
