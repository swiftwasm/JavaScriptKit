import JavaScriptEventLoop
@_spi(Experimental) import JavaScriptKit

@JSFunction(from: .global) func alert(_ message: String) throws(JSException)

@JSClass(jsName: "Document", from: .global)
struct JSDocument {
    @JSGetter var body: JSHTMLElement
    @JSFunction func createElement(_ tagName: String) throws(JSException) -> JSHTMLElement
}

@JSClass(jsName: "HTMLElement", from: .global)
struct JSHTMLElement {
    @JSGetter var innerText: String
    @JSSetter func setInnerText(_ value: String) throws(JSException)
    @JSFunction func appendChild(_ element: JSHTMLElement) throws(JSException)
}

@JSClass(jsName: "HTMLButtonElement", from: .global)
struct JSHTMLButtonElement {
    @JSGetter var onclick: () -> Void
    @JSSetter func setOnclick(_ handler: @escaping () -> Void) throws(JSException)
}

@JSGetter(from: .global) var document: JSDocument

var divElement = try document.createElement("div")
try divElement.setInnerText("Hello, world")
try document.body.appendChild(divElement)

var buttonElement = try document.createElement("button")
try buttonElement.setInnerText("Alert demo")
let buttonHTMLElement = JSHTMLButtonElement(unsafelyWrapping: buttonElement.jsObject)
try buttonHTMLElement.setOnclick {
    try! alert("Swift is running on browser!")
}

_ = try document.body.appendChild(buttonElement)

private let jsFetch = JSObject.global.fetch.object!
func fetch(_ url: String) -> JSPromise {
    JSPromise(jsFetch(url).object!)!
}

JavaScriptEventLoop.installGlobalExecutor()

struct Response: Decodable {
    let uuid: String
}

var asyncButtonElement = try document.createElement("button")
try asyncButtonElement.setInnerText("Fetch UUID demo")
try JSHTMLButtonElement(unsafelyWrapping: asyncButtonElement.jsObject).setOnclick {
    Task {
        do {
            let response = try await fetch("https://httpbin.org/uuid").value
            let json = try await JSPromise(response.json().object!)!.value
            let parsedResponse = try JSValueDecoder().decode(Response.self, from: json)
            try alert(parsedResponse.uuid)
        } catch {
            print(error)
        }
    }
}

try document.body.appendChild(asyncButtonElement)
