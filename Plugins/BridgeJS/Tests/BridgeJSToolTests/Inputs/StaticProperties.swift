@JS class PropertyClass {
    @JS init() {}

    @JS static let staticConstant: String = "constant"
    @JS static var staticVariable: Int = 42
    @JS static var jsObjectProperty: JSObject = JSObject()
    @JS class var classVariable: String = "overridable"

    @JS static var computedProperty: String {
        get { return "\(staticVariable) computed" }
        set { staticVariable = newValue + 5 }
    }

    @JS static var readOnlyComputed: Int {
        return 100
    }

    @JS static var optionalProperty: String? = nil
}

@JS enum PropertyEnum {
    case value1
    case value2

    @JS static var enumProperty: String = "enum value"
    @JS static let enumConstant: Int = 42
    @JS static var computedEnum: String {
        get { return enumProperty + " computed" }
        set { enumProperty = newValue + " computed" }
    }
}

@JS enum PropertyNamespace {
    @JS static var namespaceProperty: String = "namespace"
    @JS static let namespaceConstant: String = "constant"

    @JS enum Nested {
        @JS nonisolated(unsafe) static var nestedProperty: Int = 999
        @JS static let nestedConstant: String = "nested"
        @JS nonisolated(unsafe) static var nestedDouble: Double = 1.414
    }
}
