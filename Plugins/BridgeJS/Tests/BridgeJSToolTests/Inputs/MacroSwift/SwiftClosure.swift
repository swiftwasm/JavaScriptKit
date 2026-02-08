import JavaScriptKit

@JS public class Person {
    public let name: String

    @JS public init(name: String) {
        self.name = name
    }
}

@JS class TestProcessor {
    @JS init(transform: @escaping (String) -> String) {}
}

@JS func roundtripString(_ stringClosure: (String) -> String) -> (String) -> String
@JS func roundtripInt(_ intClosure: (Int) -> Int) -> (Int) -> Int
@JS func roundtripBool(_ boolClosure: (Bool) -> Bool) -> (Bool) -> Bool
@JS func roundtripFloat(_ floatClosure: (Float) -> Float) -> (Float) -> Float
@JS func roundtripDouble(_ doubleClosure: (Double) -> Double) -> (Double) -> Double

@JS func roundtripOptionalString(_ stringClosure: (String?) -> String?) -> (String?) -> String?
@JS func roundtripOptionalInt(_ intClosure: (Int?) -> Int?) -> (Int?) -> Int?
@JS func roundtripOptionalBool(_ boolClosure: (Bool?) -> Bool?) -> (Bool?) -> Bool?
@JS func roundtripOptionalFloat(_ floatClosure: (Float?) -> Float?) -> (Float?) -> Float?
@JS func roundtripOptionalDouble(_ doubleClosure: (Double?) -> Double?) -> (Double?) -> Double?

@JS func roundtripPerson(_ personClosure: (Person) -> Person) -> (Person) -> Person
@JS func roundtripOptionalPerson(_ personClosure: (Person?) -> Person?) -> (Person?) -> Person?

@JS func roundtripDirection(_ callback: (Direction) -> Direction) -> (Direction) -> Direction
@JS func roundtripTheme(_ callback: (Theme) -> Theme) -> (Theme) -> Theme
@JS func roundtripHttpStatus(_ callback: (HttpStatus) -> HttpStatus) -> (HttpStatus) -> HttpStatus
@JS func roundtripAPIResult(_ callback: (APIResult) -> APIResult) -> (APIResult) -> APIResult

@JS func roundtripOptionalDirection(_ callback: (Direction?) -> Direction?) -> (Direction?) -> Direction?
@JS func roundtripOptionalTheme(_ callback: (Theme?) -> Theme?) -> (Theme?) -> Theme?
@JS func roundtripOptionalHttpStatus(_ callback: (HttpStatus?) -> HttpStatus?) -> (HttpStatus?) -> HttpStatus?
@JS func roundtripOptionalAPIResult(_ callback: (APIResult?) -> APIResult?) -> (APIResult?) -> APIResult?
@JS func roundtripOptionalDirection(_ callback: (Direction?) -> Direction?) -> (Direction?) -> Direction?

@JS enum Direction {
    case north
    case south
    case east
    case west
}

@JS enum Theme: String {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}

@JS enum HttpStatus: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
    case unknown = -1
}

@JS enum APIResult {
    case success(String)
    case failure(Int)
    case flag(Bool)
    case rate(Float)
    case precise(Double)
    case info
}
