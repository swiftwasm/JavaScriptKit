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
