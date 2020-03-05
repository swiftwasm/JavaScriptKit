import JavaScriptKit

let alert = JSObjectRef.global.alert.function!
let document = JSObjectRef.global.document.object!

let divElement = document.createElement!("div").object!
divElement.innerText = "Hello, world"
let body = document.body.object!
_ = body.appendChild!(divElement)

alert("Swift is running on browser!")
