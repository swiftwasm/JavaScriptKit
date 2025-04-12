import JavaScriptKit

class Benchmark {
    init(_ title: String) {
        self.title = title
    }

    let title: String

    func testSuite(_ name: String, _ body: @escaping () -> Void) {
        let jsBody = JSClosure { arguments -> JSValue in
            body()
            return .undefined
        }
        benchmarkRunner("\(title)/\(name)", jsBody)
    }
}

@JS func run() {

    let call = Benchmark("Call")

    call.testSuite("JavaScript function call through Wasm import") {
        for _ in 0..<20_000_000 {
            benchmarkHelperNoop()
        }
    }

    call.testSuite("JavaScript function call through Wasm import with int") {
        for _ in 0..<10_000_000 {
            benchmarkHelperNoopWithNumber(42)
        }
    }

    let propertyAccess = Benchmark("Property access")

    do {
        let swiftInt: Double = 42
        let object = JSObject()
        object.jsNumber = JSValue.number(swiftInt)
        propertyAccess.testSuite("Write Number") {
            for _ in 0..<1_000_000 {
                object.jsNumber = JSValue.number(swiftInt)
            }
        }
    }

    do {
        let object = JSObject()
        object.jsNumber = JSValue.number(42)
        propertyAccess.testSuite("Read Number") {
            for _ in 0..<1_000_000 {
                _ = object.jsNumber.number
            }
        }
    }

    do {
        let swiftString = "Hello, world"
        let object = JSObject()
        object.jsString = swiftString.jsValue
        propertyAccess.testSuite("Write String") {
            for _ in 0..<1_000_000 {
                object.jsString = swiftString.jsValue
            }
        }
    }

    do {
        let object = JSObject()
        object.jsString = JSValue.string("Hello, world")
        propertyAccess.testSuite("Read String") {
            for _ in 0..<1_000_000 {
                _ = object.jsString.string
            }
        }
    }
}
