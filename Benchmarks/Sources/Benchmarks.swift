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

    @JS func roundtrip(_ result: APIResult) -> APIResult {
        return result
    }
}

@JS
enum ComplexResult {
    case success(String)
    case error(String, Int)
    case location(Double, Double, String)
    case status(Bool, Int, String)
    case coordinates(Double, Double, Double)
    case comprehensive(Bool, Bool, Int, Int, Double, Double, String, String, String)
    case info
}

@JS class ComplexResultRoundtrip {
    @JS init() {}

    @JS func take(_ value: ComplexResult) {}

    @JS func makeSuccess() -> ComplexResult {
        return .success("Hello, world")
    }

    @JS func makeError() -> ComplexResult {
        return .error("Network timeout", 503)
    }

    @JS func makeLocation() -> ComplexResult {
        return .location(37.7749, -122.4194, "San Francisco")
    }

    @JS func makeStatus() -> ComplexResult {
        return .status(true, 200, "OK")
    }

    @JS func makeCoordinates() -> ComplexResult {
        return .coordinates(10.5, 20.3, 30.7)
    }

    @JS func makeComprehensive() -> ComplexResult {
        return .comprehensive(true, false, 42, 100, 3.14, 2.718, "Hello", "World", "Test")
    }

    @JS func makeInfo() -> ComplexResult {
        return .info
    }

    @JS func roundtrip(_ result: ComplexResult) -> ComplexResult {
        return result
    }
}
@JS class StringRoundtrip {
    @JS init() {}
    @JS func take(_ value: String) {}
    @JS func make() -> String {
        return "Hello, world"
    }
}

@JS class OptionalReturnRoundtrip {
    @JS init() {}

    @JS func makeIntSome() -> Int? { 42 }
    @JS func makeIntNone() -> Int? { nil }

    @JS func makeBoolSome() -> Bool? { true }
    @JS func makeBoolNone() -> Bool? { nil }

    @JS func makeDoubleSome() -> Double? { 0.5 }
    @JS func makeDoubleNone() -> Double? { nil }

    @JS func makeStringSome() -> String? { "Hello, world" }
    @JS func makeStringNone() -> String? { nil }
}

// MARK: - Struct Performance Tests

@JS struct SimpleStruct {
    var name: String
    var count: Int
    var flag: Bool
    var rate: Float
    var precise: Double
}

@JS struct Address {
    var street: String
    var city: String
    var zipCode: Int
}

@JS struct Person {
    var name: String
    var age: Int
    var address: Address
    var email: String?
}

@JS struct ComplexStruct {
    var id: Int
    var title: String
    var active: Bool
    var score: Double
    var tags: String
    var metadata: String
}

@JS class StructRoundtrip {
    @JS init() {}

    @JS func takeSimple(_ value: SimpleStruct) {}
    @JS func makeSimple() -> SimpleStruct {
        return SimpleStruct(name: "Hello", count: 42, flag: true, rate: 0.5, precise: 3.14159)
    }
    @JS func roundtripSimple(_ value: SimpleStruct) -> SimpleStruct {
        return value
    }

    @JS func takeAddress(_ value: Address) {}
    @JS func makeAddress() -> Address {
        return Address(street: "123 Main St", city: "San Francisco", zipCode: 94102)
    }
    @JS func roundtripAddress(_ value: Address) -> Address {
        return value
    }

    @JS func takePerson(_ value: Person) {}
    @JS func makePerson() -> Person {
        return Person(
            name: "John Doe",
            age: 30,
            address: Address(street: "456 Oak Ave", city: "New York", zipCode: 10001),
            email: "john@example.com"
        )
    }
    @JS func roundtripPerson(_ value: Person) -> Person {
        return value
    }

    @JS func takeComplex(_ value: ComplexStruct) {}
    @JS func makeComplex() -> ComplexStruct {
        return ComplexStruct(
            id: 12345,
            title: "Test Item",
            active: true,
            score: 98.6,
            tags: "swift,wasm,benchmark",
            metadata: "{\"version\":1}"
        )
    }
    @JS func roundtripComplex(_ value: ComplexStruct) -> ComplexStruct {
        return value
    }
}

// MARK: - Class vs Struct Comparison Tests

@JS class SimpleClass {
    @JS var name: String
    @JS var count: Int
    @JS var flag: Bool
    @JS var rate: Float
    @JS var precise: Double

    @JS init(name: String, count: Int, flag: Bool, rate: Float, precise: Double) {
        self.name = name
        self.count = count
        self.flag = flag
        self.rate = rate
        self.precise = precise
    }
}

@JS class AddressClass {
    @JS var street: String
    @JS var city: String
    @JS var zipCode: Int

    @JS init(street: String, city: String, zipCode: Int) {
        self.street = street
        self.city = city
        self.zipCode = zipCode
    }
}

@JS class ClassRoundtrip {
    @JS init() {}

    @JS func takeSimpleClass(_ value: SimpleClass) {}
    @JS func makeSimpleClass() -> SimpleClass {
        return SimpleClass(name: "Hello", count: 42, flag: true, rate: 0.5, precise: 3.14159)
    }
    @JS func roundtripSimpleClass(_ value: SimpleClass) -> SimpleClass {
        return value
    }

    @JS func takeAddressClass(_ value: AddressClass) {}
    @JS func makeAddressClass() -> AddressClass {
        return AddressClass(street: "123 Main St", city: "San Francisco", zipCode: 94102)
    }
    @JS func roundtripAddressClass(_ value: AddressClass) -> AddressClass {
        return value
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
