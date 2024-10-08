import JavaScriptKit

let alert = JSObject.global.alert.function!
let document = JSObject.global.document

print("Document title: \(document.title.string ?? "")")

var divElement = document.createElement("div")
divElement.innerText = "Hello, world 2"
_ = document.body.appendChild(divElement)

var buttonElement = document.createElement("button")
buttonElement.innerText = "Alert demo"
buttonElement.onclick = JSValue.object(JSClosure { _ in
    divElement.innerText = "Hello, world 3"
    return .undefined
})

_ = document.body.appendChild(buttonElement)

func print(_ message: String) {
    _ = JSObject.global.console.log(message)
}
