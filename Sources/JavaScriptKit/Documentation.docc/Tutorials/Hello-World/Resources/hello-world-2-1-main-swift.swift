import JavaScriptKit

let document = JSObject.global.document
let div = document.createElement("div")
div.innerText = "Hello from Swift!"
_ = document.body.appendChild(div)
