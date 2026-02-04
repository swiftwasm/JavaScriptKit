@JS class Greeter {
    @JS var name: String?

    @JS init(name: String?) {
        self.name = name
    }

    @JS func greet() -> String {
        return "Hello, " + (self.name ?? "stranger") + "!"
    }

    @JS func changeName(name: String?) {
        self.name = name
    }
}

@JS
func roundTripOptionalClass(value: Greeter?) -> Greeter? {
    return value
}

@JS
class OptionalPropertyHolder {
    @JS var optionalName: String? = nil
    @JS var optionalAge: Int? = nil
    @JS var optionalGreeter: Greeter? = nil

    @JS init() {}
}

@JS func testOptionalPropertyRoundtrip(_ holder: OptionalPropertyHolder?) -> OptionalPropertyHolder?

@JS
func roundTripString(name: String?) -> String? {
    return name
}

@JS
func roundTripInt(value: Int?) -> Int? {
    return value
}

@JS
func roundTripBool(flag: Bool?) -> Bool? {
    return flag
}

@JS
func roundTripFloat(number: Float?) -> Float? {
    return number
}

@JS
func roundTripDouble(precision: Double?) -> Double? {
    return precision
}

@JS func roundTripSyntax(name: Optional<String>) -> Optional<String> {
    return name
}

@JS func roundTripMixSyntax(name: String?) -> Optional<String> {
    return name
}

@JS func roundTripSwiftSyntax(name: Swift.Optional<String>) -> Swift.Optional<String> {
    return name
}

@JS func roundTripMixedSwiftSyntax(name: String?) -> Swift.Optional<String> {
    return name
}

@JS func roundTripWithSpaces(value: Optional<Double>) -> Optional<Double> {
    return value
}

typealias OptionalAge = Int?

@JS func roundTripAlias(age: OptionalAge) -> OptionalAge {
    return age
}

typealias OptionalNameAlias = Optional<String>
@JS func roundTripOptionalAlias(name: OptionalNameAlias) -> OptionalNameAlias {
    return name
}

@JS
func testMixedOptionals(firstName: String?, lastName: String?, age: Int?, active: Bool) -> String? {
    return nil
}

@JSClass struct WithOptionalJSClass {
    @JSFunction init(valueOrNull: String?, valueOrUndefined: JSUndefinedOr<String>) throws(JSException)

    @JSGetter var stringOrNull: String?
    @JSSetter func setStringOrNull(_ value: String?) throws(JSException)
    @JSGetter var stringOrUndefined: JSUndefinedOr<String>
    @JSSetter func setStringOrUndefined(_ value: JSUndefinedOr<String>) throws(JSException)
    @JSFunction func roundTripStringOrNull(value: String?) throws(JSException) -> String?
    @JSFunction func roundTripStringOrUndefined(
        value: JSUndefinedOr<String>
    ) throws(JSException) -> JSUndefinedOr<String>

    @JSGetter var doubleOrNull: Double?
    @JSSetter func setDoubleOrNull(_ value: Double?) throws(JSException)
    @JSGetter var doubleOrUndefined: JSUndefinedOr<Double>
    @JSSetter func setDoubleOrUndefined(_ value: JSUndefinedOr<Double>) throws(JSException)
    @JSFunction func roundTripDoubleOrNull(value: Double?) throws(JSException) -> Double?
    @JSFunction func roundTripDoubleOrUndefined(
        value: JSUndefinedOr<Double>
    ) throws(JSException) -> JSUndefinedOr<Double>

    @JSGetter var boolOrNull: Bool?
    @JSSetter func setBoolOrNull(_ value: Bool?) throws(JSException)
    @JSGetter var boolOrUndefined: JSUndefinedOr<Bool>
    @JSSetter func setBoolOrUndefined(_ value: JSUndefinedOr<Bool>) throws(JSException)
    @JSFunction func roundTripBoolOrNull(value: Bool?) throws(JSException) -> Bool?
    @JSFunction func roundTripBoolOrUndefined(value: JSUndefinedOr<Bool>) throws(JSException) -> JSUndefinedOr<Bool>

    @JSGetter var intOrNull: Int?
    @JSSetter func setIntOrNull(_ value: Int?) throws(JSException)
    @JSGetter var intOrUndefined: JSUndefinedOr<Int>
    @JSSetter func setIntOrUndefined(_ value: JSUndefinedOr<Int>) throws(JSException)
    @JSFunction func roundTripIntOrNull(value: Int?) throws(JSException) -> Int?
    @JSFunction func roundTripIntOrUndefined(value: JSUndefinedOr<Int>) throws(JSException) -> JSUndefinedOr<Int>
}
