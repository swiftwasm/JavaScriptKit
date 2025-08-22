@JS
enum APIResult {
    case success(String)
    case failure(Int)
    case flag(Bool)
    case rate(Float)
    case precise(Double)
    case info
}

@JS func handle(result: APIResult)
@JS func getResult() -> APIResult

@JS
enum ComplexResult {
    case success(String)
    case error(String, Int)
    case status(Bool, Int, String)
    case coordinates(Double, Double, Double)
    case comprehensive(Bool, Bool, Int, Int, Double, Double, String, String, String)
    case info
}

@JS func handleComplex(result: ComplexResult)
@JS func getComplexResult() -> ComplexResult

@JS
enum Utilities {
    @JS enum Result {
        case success(String)
        case failure(String, Int)
        case status(Bool, Int, String)
    }
}

@JS(namespace: "API")
@JS enum NetworkingResult {
    case success(String)
    case failure(String, Int)
}
