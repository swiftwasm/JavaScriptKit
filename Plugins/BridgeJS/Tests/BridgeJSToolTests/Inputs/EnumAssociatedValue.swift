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
    case info
}

@JS func handleComplex(result: ComplexResult)
@JS func getComplexResult() -> ComplexResult
