@JS class MathUtils {
    @JS init() {}

    @JS class func subtract(a: Int, b: Int) -> Int {
        return a - b
    }
    
    @JS static func add(a: Int, b: Int) -> Int {
        return a + b
    }

    @JS func multiply(x: Int, y: Int) -> Int {
        return x * y
    }
}

@JS enum Calculator {
    case scientific
    case basic

    @JS static func square(value: Int) -> Int {
        return value * value
    }
}

@JS
enum APIResult {
    case success(String)
    case failure(Int)

    @JS static func roundtrip(value: APIResult) -> APIResult { }
}

@JS enum Utils {
    @JS enum String {
        @JS static func uppercase(_ text: String) -> String {
            return text.uppercased()
        }
    }
}
