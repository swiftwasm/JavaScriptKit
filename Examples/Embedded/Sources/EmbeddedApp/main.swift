import JavaScriptKit

let alert = JSObject.global.alert.function!
let document = JSObject.global.document

print("Hello from WASM, document title: \(document.title.string ?? "")")

var count = 0

var divElement = document.createElement("div")
divElement.innerText = .string("Count \(count)")
_ = document.body.appendChild(divElement)

var buttonElement = document.createElement("button")
buttonElement.innerText = "Click me"
buttonElement.onclick = JSValue.object(JSClosure { _ in
    count += 1    
    divElement.innerText = .string("Count \(count)")
    return .undefined
})

_ = document.body.appendChild(buttonElement)

func print(_ message: String) {
    _ = JSObject.global.console.log(message)
}
