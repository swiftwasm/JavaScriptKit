import JavaScriptKit

@JS public class Person {
    public let name: String

    @JS public init(name: String) {
        self.name = name
    }
}

@JS class TestProcessor {
    private var transform: (String) -> String

    @JS init(transform: @escaping (String) -> String) {
        self.transform = transform
    }

    @JS func getTransform() -> (String) -> String

    @JS func processWithCustom(_ text: String, customTransform: (String) -> String) -> String

    @JS func printTogether(
        person: Person,
        name: String,
        ratio: Double,
        customTransform: (Person?, String?, Double?) -> String
    ) -> String

    @JS func roundtrip(_ personClosure: (Person) -> String) -> (Person) -> String
    @JS func roundtripOptional(_ personClosure: (Person?) -> String) -> (Person?) -> String

    @JS func processDirection(_ callback: (Direction) -> String) -> String
    @JS func processTheme(_ callback: (Theme) -> String) -> String
    @JS func processHttpStatus(_ callback: (HttpStatus) -> Int) -> Int
    @JS func processAPIResult(_ callback: (APIResult) -> String) -> String

    @JS func makeDirectionChecker() -> (Direction) -> Bool
    @JS func makeThemeValidator() -> (Theme) -> Bool
    @JS func makeStatusCodeExtractor() -> (HttpStatus) -> Int
    @JS func makeAPIResultHandler() -> (APIResult) -> String

    @JS func processOptionalDirection(_ callback: (Direction?) -> String) -> String
    @JS func processOptionalTheme(_ callback: (Theme?) -> String) -> String
    @JS func processOptionalAPIResult(_ callback: (APIResult?) -> String) -> String
    @JS func makeOptionalDirectionFormatter() -> (Direction?) -> String
}

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
