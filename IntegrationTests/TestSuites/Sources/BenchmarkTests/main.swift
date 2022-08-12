import JavaScriptKit
import CHelpers

let serialization = Benchmark("Serialization")

let noopFunction = JSObject.global.noopFunction.function!

serialization.testSuite("JavaScript function call through Wasm import") { n in
    for _ in 0 ..< n {
        benchmark_helper_noop()
    }
}

serialization.testSuite("JavaScript function call through Wasm import with int") { n in
    for _ in 0 ..< n {
        benchmark_helper_noop_with_int(42)
    }
}

serialization.testSuite("JavaScript function call from Swift") { n in
    for _ in 0 ..< n {
        _ = noopFunction()
    }
}

let swiftInt: Double = 42
serialization.testSuite("Swift Int to JavaScript with assignment") { n in
    let jsNumber = JSValue.number(swiftInt)
    let object = JSObject.global
    let key = JSString("numberValue")
    for _ in 0 ..< n {
        object[key] = jsNumber
    }
}

serialization.testSuite("Swift Int to JavaScript with call") { n in
    let jsNumber = JSValue.number(swiftInt)
    for _ in 0 ..< n {
        _ = noopFunction(jsNumber)
    }
}

serialization.testSuite("JavaScript Number to Swift Int") { n in
    let object = JSObject.global
    let key = JSString("jsNumber")
    for _ in 0 ..< n {
        _ = object[key].number
    }
}

let swiftString = "Hello, world"
serialization.testSuite("Swift String to JavaScript with assignment") { n in
    let jsString = JSValue.string(swiftString)
    let object = JSObject.global
    let key = JSString("stringValue")
    for _ in 0 ..< n {
        object[key] = jsString
    }
}

serialization.testSuite("Swift String to JavaScript with call") { n in
    let jsString = JSValue.string(swiftString)
    for _ in 0 ..< n {
        _ = noopFunction(jsString)
    }
}

serialization.testSuite("JavaScript String to Swift String") { n in
    let object = JSObject.global
    let key = JSString("jsString")
    for _ in 0 ..< n {
        _ = object[key].string
    }
}

let objectHeap = Benchmark("Object heap")

let global = JSObject.global
let Object = global.Object.function!
global.objectHeapDummy = .object(Object.new())
objectHeap.testSuite("Increment and decrement RC") { n in
    for _ in 0 ..< n {
        _ = global.objectHeapDummy
    }
}
