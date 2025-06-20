@JS func asyncReturnVoid() async {}
@JS func asyncRoundTripInt(_ v: Int) async -> Int {
    return v
}
@JS func asyncRoundTripString(_ v: String) async -> String {
    return v
}
@JS func asyncRoundTripBool(_ v: Bool) async -> Bool {
    return v
}
@JS func asyncRoundTripFloat(_ v: Float) async -> Float {
    return v
}
@JS func asyncRoundTripDouble(_ v: Double) async -> Double {
    return v
}
@JS func asyncRoundTripJSObject(_ v: JSObject) async -> JSObject {
    return v
}
