import JavaScriptKit

@JS struct PointerFields {
    var raw: UnsafeRawPointer
    var mutRaw: UnsafeMutableRawPointer
    var opaque: OpaquePointer
    var ptr: UnsafePointer<UInt8>
    var mutPtr: UnsafeMutablePointer<UInt8>

    @JS init(
        raw: UnsafeRawPointer,
        mutRaw: UnsafeMutableRawPointer,
        opaque: OpaquePointer,
        ptr: UnsafePointer<UInt8>,
        mutPtr: UnsafeMutablePointer<UInt8>
    ) {
        self.raw = raw
        self.mutRaw = mutRaw
        self.opaque = opaque
        self.ptr = ptr
        self.mutPtr = mutPtr
    }
}

@JS func roundTripPointerFields(_ value: PointerFields) -> PointerFields { value }

@JS struct DataPoint {
    let x: Double
    let y: Double
    var label: String
    var optCount: Int?
    var optFlag: Bool?

    @JS init(x: Double, y: Double, label: String, optCount: Int?, optFlag: Bool?) {
        self.x = x
        self.y = y
        self.label = label
        self.optCount = optCount
        self.optFlag = optFlag
    }
}

@JS public struct PublicPoint {
    public var x: Int
    public var y: Int

    @JS public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

@JS struct Address {
    var street: String
    var city: String
    var zipCode: Int?
}

@JS struct Contact {
    var name: String
    var age: Int
    var address: Address
    var email: String?
    var secondaryAddress: Address?
}

@JS struct Config {
    var name: String
    var theme: Theme?
    var direction: Direction?
    var status: Status
}

@JS struct SessionData {
    var id: Int
    var owner: Greeter?
}

@JS struct ValidationReport {
    var id: Int
    var result: APIResult
    var status: Status?
    var outcome: APIResult?
}

@JS struct AdvancedConfig {
    var id: Int
    var title: String
    var enabled: Bool
    var theme: Theme
    var status: Status
    var result: APIResult?
    var metadata: JSObject?
    var location: DataPoint?
    var defaults: ConfigStruct
    var overrideDefaults: ConfigStruct?
}

@JS struct MeasurementConfig {
    var precision: Precision
    var ratio: Ratio
    var optionalPrecision: Precision?
    var optionalRatio: Ratio?
}

@JS struct MathOperations {
    var baseValue: Double

    @JS init(baseValue: Double = 0.0) {
        self.baseValue = baseValue
    }

    @JS func add(a: Double, b: Double = 10.0) -> Double {
        return baseValue + a + b
    }

    @JS func multiply(a: Double, b: Double) -> Double {
        return a * b
    }

    @JS static func subtract(a: Double, b: Double = 5.0) -> Double {
        return a - b
    }
}

@JS func testStructDefault(
    point: DataPoint = DataPoint(x: 1.0, y: 2.0, label: "default", optCount: nil, optFlag: nil)
) -> String {
    return "\(point.x),\(point.y),\(point.label)"
}

@JS struct CopyableCart {
    var x: Int
    var note: String?

    @JS static func fromJSObject(_ object: JSObject) -> CopyableCart {
        CopyableCart(unsafelyCopying: object)
    }
}

@JS func cartToJSObject(_ cart: CopyableCart) -> JSObject {
    cart.toJSObject()
}

@JS struct CopyableCartItem {
    var sku: String
    var quantity: Int
}

@JS struct CopyableNestedCart {
    var id: Int
    var item: CopyableCartItem
    var shippingAddress: Address?

    @JS static func fromJSObject(_ object: JSObject) -> CopyableNestedCart {
        CopyableNestedCart(unsafelyCopying: object)
    }
}

@JS func nestedCartToJSObject(_ cart: CopyableNestedCart) -> JSObject {
    cart.toJSObject()
}

@JS struct ConfigStruct {
    var name: String
    var value: Int

    @JS nonisolated(unsafe) static var defaultConfig: String = "production"
    @JS static let maxRetries: Int = 3
    @JS nonisolated(unsafe) static var timeout: Double = 30.0

    @JS static var computedSetting: String {
        return "Config: \(defaultConfig)"
    }
}

@JS func roundTripDataPoint(_ data: DataPoint) -> DataPoint {
    return data
}

@JS public func roundTripPublicPoint(_ point: PublicPoint) -> PublicPoint {
    point
}

@JS func roundTripContact(_ contact: Contact) -> Contact {
    return contact
}

@JS func roundTripConfig(_ config: Config) -> Config {
    return config
}

@JS func roundTripSessionData(_ session: SessionData) -> SessionData {
    return session
}

@JS func roundTripValidationReport(_ report: ValidationReport) -> ValidationReport {
    return report
}

@JS func roundTripAdvancedConfig(_ config: AdvancedConfig) -> AdvancedConfig {
    return config
}

@JS func roundTripMeasurementConfig(_ config: MeasurementConfig) -> MeasurementConfig {
    return config
}

@JS func updateValidationReport(_ newResult: APIResult?, _ report: ValidationReport) -> ValidationReport {
    return ValidationReport(
        id: report.id,
        result: newResult ?? report.result,
        status: report.status,
        outcome: report.outcome
    )
}

@JS class Container {
    @JS var location: DataPoint
    @JS var config: Config?

    @JS init(location: DataPoint, config: Config?) {
        self.location = location
        self.config = config
    }
}

@JS func testContainerWithStruct(_ point: DataPoint) -> Container {
    return Container(location: point, config: nil)
}

// Struct with JSObject fields
@JS struct JSObjectContainer {
    var object: JSObject
    var optionalObject: JSObject?
}

@JS func roundTripJSObjectContainer(_ container: JSObjectContainer) -> JSObjectContainer {
    return container
}

// Struct with @JSClass fields (Foo is defined in ExportAPITests.swift)
@JS struct FooContainer {
    var foo: Foo
    var optionalFoo: Foo?
}

@JS func roundTripFooContainer(_ container: FooContainer) -> FooContainer {
    return container
}

@JS struct ArrayMembers {
    var ints: [Int]
    var optStrings: [String]?

    @JS func sumValues(_ values: [Int]) -> Int {
        values.reduce(0, +)
    }

    @JS func firstString(_ values: [String]) -> String? {
        values.first
    }
}

@JS func roundTripArrayMembers(_ value: ArrayMembers) -> ArrayMembers {
    value
}

@JS func arrayMembersSum(_ value: ArrayMembers, _ values: [Int]) -> Int {
    value.sumValues(values)
}

@JS func arrayMembersFirst(_ value: ArrayMembers, _ values: [String]) -> String? {
    value.firstString(values)
}
