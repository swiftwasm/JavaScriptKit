import JavaScriptKit

let alert = JSObject.global.alert.function!
let document = JSObject.global.document.object!

let divElement = document.createElement!("div").object!
divElement.innerText = "Hello, world"
let body = document.body.object!
_ = body.appendChild!(divElement)

let buttonElement = document.createElement!("button").object!
buttonElement.innerText = "Click me!"
let listener = JSClosure { _ in
    alert("Swift is running on browser!")
}
buttonElement.onclick = .function(listener)

_ = body.appendChild!(buttonElement)
