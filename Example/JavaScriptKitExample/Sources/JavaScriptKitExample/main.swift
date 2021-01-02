import JavaScriptKit
import JavaScriptEventLoop

JavaScriptEventLoop.install()

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
buttonElement.onclick = .function(listener)

_ = document.body.appendChild(buttonElement)

let fetch = JSObject.global.fetch.function!.async

func printZen() async {
  let result = await try! fetch("https://api.github.com/zen").object!
  let text = await try! result.asyncing.text!()
  print(text)
}

JavaScriptEventLoop.runAsync {
  await printZen()
}
