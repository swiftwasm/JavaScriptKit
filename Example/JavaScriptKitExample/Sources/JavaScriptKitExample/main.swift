import JavaScriptKit

let alert = JSObjectRef.global.alert.function!
let document = JSObjectRef.global.document.object!

let divElement = document.createElement!("div").object!
divElement.innerText = "Hello, world"
let body = document.body.object!
_ = body.appendChild!(divElement)

let buttonElement = document.createElement!("button").object!
buttonElement.innerText = "Click me!"
buttonElement.onclick = .function { _ in
    alert("Swift is running on browser!")
}

_ = body.appendChild!(buttonElement)
