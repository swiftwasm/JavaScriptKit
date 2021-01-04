import JavaScriptKit

let alert = JSObject.global.alert.function!
let document = JSObject.global.document

var divElement = document.createElement("div")
divElement.innerText = "Hello, world"
_ = document.body.appendChild(divElement)

var buttonElement = document.createElement("button")
buttonElement.innerText = "Click me!"
let listener = JSClosure { _ in
    alert("Swift is running on browser!")
}
buttonElement.onclick = .object(listener)

_ = document.body.appendChild(buttonElement)
