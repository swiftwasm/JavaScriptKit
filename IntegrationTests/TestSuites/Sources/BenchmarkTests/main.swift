import JavaScriptKit

let serialization = Benchmark("Serialization")


let swiftInt: Double = 42
serialization.testSuite("Swift Int to JavaScript") {
    let jsNumber = JSValue.number(swiftInt)
    let object = JSObjectRef.global
    for i in 0..<100 {
        object.set("numberValue\(i)", jsNumber)
    }
}

let swiftString = "Hello, world"
serialization.testSuite("Swift String to JavaScript") {
    let jsString = JSValue.string(swiftString)
    let object = JSObjectRef.global
    for i in 0..<100 {
        object.set("stringValue\(i)", jsString)
    }
}
