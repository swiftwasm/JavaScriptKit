import JavaScriptKit

// BridgeJS generic imports work under Embedded Swift: `echoValue` is
// implemented in JavaScript (see index.html) and a single piece of generated
// glue serves every conforming type, selected by a runtime type ID.
@JS struct CounterLabel {
    var count: Int
    var text: String
}

@JSFunction func echoValue<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T

let alert = JSObject.global.alert.object!
let document = JSObject.global.document

print("Hello from Wasm, document title: \(document.title.string ?? "")")

var count = 0

let divElement = document.createElement("div")
divElement.innerText = .string("Count \(count)")
_ = document.body.appendChild(divElement)

let clickMeElement = document.createElement("button")
clickMeElement.innerText = "Click me"
clickMeElement.onclick = JSValue.object(
    JSClosure { _ in
        count += 1
        divElement.innerText = .string("Count \(count)")
        return .undefined
    }
)
_ = document.body.appendChild(clickMeElement)

let encodeResultElement = document.createElement("pre")
let textInputElement = document.createElement("input")
textInputElement.type = "text"
textInputElement.placeholder = "Enter text to encode to UTF-8"
textInputElement.oninput = JSValue.object(
    JSClosure { _ in
        let textEncoder = JSObject.global.TextEncoder.object!.new()
        let encode = textEncoder.encode.object!
        let encodedData = JSTypedArray<UInt8>(
            unsafelyWrapping: encode(this: textEncoder, textInputElement.value).object!
        )
        encodeResultElement.innerText = .string(
            encodedData.withUnsafeBytes { bytes in
                bytes.map { hex($0) }.joined(separator: " ")
            }
        )
        return .undefined
    }
)
let encoderContainer = document.createElement("div")
_ = encoderContainer.appendChild(textInputElement)
_ = encoderContainer.appendChild(encodeResultElement)
_ = document.body.appendChild(encoderContainer)

let genericResultElement = document.createElement("pre")
do {
    let number = try echoValue(42)
    let text = try echoValue("hello")
    let label = try echoValue(CounterLabel(count: number, text: text))
    genericResultElement.innerText = .string("Generic import round-trip: \(label.text) \(label.count)")
} catch {
    genericResultElement.innerText = "Generic import round-trip failed"
}
_ = document.body.appendChild(genericResultElement)

func print(_ message: String) {
    _ = JSObject.global.console.log(message)
}

func hex(_ value: UInt8) -> String {
    var result = "0x"
    let hexChars: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
    result.append(hexChars[Int(value / 16)])
    result.append(hexChars[Int(value % 16)])
    return result
}
