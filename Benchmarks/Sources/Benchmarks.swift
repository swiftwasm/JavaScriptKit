import JavaScriptKit
import JavaScriptFoundationCompat
import Foundation

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
        try! benchmarkRunner("\(title)/\(name)", jsBody)
    }
}

@JS enum APIResult {
    case success(String)
    case failure(Int)
    case flag(Bool)
    case rate(Float)
    case precise(Double)
    case info
}

@JS class EnumRoundtrip {
    @JS init() {}

    @JS func take(_ value: APIResult) {}
    @JS func makeSuccess() -> APIResult {
        return .success("Hello, world")
    }
    @JS func makeFailure() -> APIResult {
        return .failure(42)
    }
    @JS func makeFlag() -> APIResult {
        return .flag(true)
    }
    @JS func makeRate() -> APIResult {
        return .rate(0.5)
    }
    @JS func makePrecise() -> APIResult {
        return .precise(0.5)
    }
    @JS func makeInfo() -> APIResult {
        return .info
    }
}

@JS class StringRoundtrip {
    @JS init() {}
    @JS func take(_ value: String) {}
    @JS func make() -> String {
        return "Hello, world"
    }
}

@JS func run() {

    let call = Benchmark("Call")

    call.testSuite("JavaScript function call through Wasm import") {
        for _ in 0..<20_000_000 {
            try! benchmarkHelperNoop()
        }
    }

    call.testSuite("JavaScript function call through Wasm import with int") {
        for _ in 0..<10_000_000 {
            try! benchmarkHelperNoopWithNumber(42)
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

    do {
        let conversion = Benchmark("Conversion")
        let data = Data(repeating: 0, count: 10_000)
        conversion.testSuite("Data to JSTypedArray") {
            for _ in 0..<1_000_000 {
                _ = data.jsTypedArray
            }
        }

        let uint8Array = data.jsTypedArray

        conversion.testSuite("JSTypedArray to Data") {
            for _ in 0..<1_000_000 {
                _ = Data.construct(from: uint8Array)
            }
        }
    }
}
