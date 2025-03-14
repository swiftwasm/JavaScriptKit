import JavaScriptKit

let document = JSObject.global.document
var div = document.createElement("div")
div.innerText = "Hello from Swift!"
document.body.appendChild(div) 
