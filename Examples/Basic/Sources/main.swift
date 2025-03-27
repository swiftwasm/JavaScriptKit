import JavaScriptEventLoop
import JavaScriptKit

let alert = JSObject.global.alert.function!
let document = JSObject.global.document

let divElement = document.createElement("div")
divElement.innerText = "Hello, world"
_ = document.body.appendChild(divElement)

let buttonElement = document.createElement("button")
buttonElement.innerText = "Alert demo"
buttonElement.onclick = .object(
    JSClosure { _ in
        alert("Swift is running on browser!")
        return .undefined
    }
)

_ = document.body.appendChild(buttonElement)

private let jsFetch = JSObject.global.fetch.function!
func fetch(_ url: String) -> JSPromise {
    JSPromise(jsFetch(url).object!)!
}

JavaScriptEventLoop.installGlobalExecutor()

struct Response: Decodable {
    let uuid: String
}

let asyncButtonElement = document.createElement("button")
asyncButtonElement.innerText = "Fetch UUID demo"
asyncButtonElement.onclick = .object(
    JSClosure { _ in
        Task {
            do {
                let response = try await fetch("https://httpbin.org/uuid").value
                let json = try await JSPromise(response.json().object!)!.value
                let parsedResponse = try JSValueDecoder().decode(Response.self, from: json)
                alert(parsedResponse.uuid)
            } catch {
                print(error)
            }
        }

        return .undefined
    }
)

_ = document.body.appendChild(asyncButtonElement)
