@JS struct DataPoint {
    let x: Double
    let y: Double
    var label: String
    var optCount: Int?
    var optFlag: Bool?

    @JS init(x: Double, y: Double, label: String, optCount: Int?, optFlag: Bool?)
}

@JS struct Address {
    var street: String
    var city: String
    var zipCode: Int?
}

@JS struct Person {
    var name: String
    var age: Int
    var address: Address
    var email: String?
}

@JS class Greeter {
    @JS var name: String

    @JS init(name: String)
    @JS func greet() -> String
}

@JS struct Session {
    var id: Int
    var owner: Greeter
}

@JS func roundtrip(_ session: Person) -> Person

@JS struct ConfigStruct {
    @JS static let maxRetries: Int = 3
    @JS nonisolated(unsafe) static var defaultConfig: String = "production"
    @JS nonisolated(unsafe) static var timeout: Double = 30.0
    @JS static var computedSetting: String { "Config: \(defaultConfig)" }
    @JS static func update(_ timeout: Double) -> Double
}
