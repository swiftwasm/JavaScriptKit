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
@JS func roundtripAPIResult(result: APIResult) -> APIResult
@JS func roundTripOptionalAPIResult(result: APIResult?) -> APIResult?

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
@JS func roundtripComplexResult(_ result: ComplexResult) -> ComplexResult
@JS func roundTripOptionalComplexResult(result: ComplexResult?) -> ComplexResult?

@JS
enum Utilities {
    @JS enum Result {
        case success(String)
        case failure(String, Int)
        case status(Bool, Int, String)
    }
}

@JS func roundTripOptionalUtilitiesResult(result: Utilities.Result?) -> Utilities.Result?

@JS(namespace: "API")
@JS enum NetworkingResult {
    case success(String)
    case failure(String, Int)
}

@JS func roundTripOptionalNetworkingResult(result: NetworkingResult?) -> NetworkingResult?

@JS
enum APIOptionalResult {
    case success(String?)
    case failure(Int?, Bool?)
    case status(Bool?, Int?, String?)
}
@JS func roundTripOptionalAPIOptionalResult(result: APIOptionalResult?) -> APIOptionalResult?
@JS func compareAPIResults(result1: APIOptionalResult?, result2: APIOptionalResult?) -> APIOptionalResult?

@JS enum Precision: Float {
    case rough = 0.1
    case fine = 0.001
}

@JS enum CardinalDirection {
    case north
    case south
    case east
    case west
}

@JS
enum TypedPayloadResult {
    case precision(Precision)
    case direction(CardinalDirection)
    case optPrecision(Precision?)
    case optDirection(CardinalDirection?)
    case empty
}

@JS func roundTripTypedPayloadResult(_ result: TypedPayloadResult) -> TypedPayloadResult
@JS func roundTripOptionalTypedPayloadResult(_ result: TypedPayloadResult?) -> TypedPayloadResult?
