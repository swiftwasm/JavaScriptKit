@JSFunction func asyncReturnVoid() async throws(JSException)
@JSFunction func asyncRoundTripInt(_ v: Int) async throws(JSException) -> Int
@JSFunction func asyncRoundTripString(_ v: String) async throws(JSException) -> String
@JSFunction func asyncRoundTripBool(_ v: Bool) async throws(JSException) -> Bool
@JSFunction func asyncRoundTripDouble(_ v: Double) async throws(JSException) -> Double
@JSFunction func asyncRoundTripJSObject(_ v: JSObject) async throws(JSException) -> JSObject
