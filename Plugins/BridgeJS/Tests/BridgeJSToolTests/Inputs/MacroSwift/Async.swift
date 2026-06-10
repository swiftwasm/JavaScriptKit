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

@JS struct AsyncPoint {
    var x: Int
    var y: Int
}

@JS func asyncRoundTripStruct(_ v: AsyncPoint) async -> AsyncPoint {
    return v
}

@JS func asyncRoundTripStructThrows(_ v: AsyncPoint) async throws(JSException) -> AsyncPoint {
    return v
}

@JS func asyncThrowsZeroArg() async throws(JSException) -> String {
    return "ok"
}

@JS func asyncCombineStructs(_ a: AsyncPoint, _ b: AsyncPoint) async -> AsyncPoint {
    return AsyncPoint(x: a.x + b.x, y: a.y + b.y)
}

@JS enum AsyncDirection {
    case north
    case south
}

@JS func asyncRoundTripEnum(_ v: AsyncDirection) async -> AsyncDirection {
    return v
}

@JS enum AsyncTheme: String {
    case light
    case dark
}

@JS func asyncRoundTripRawEnum(_ v: AsyncTheme) async -> AsyncTheme {
    return v
}

@JS func asyncRoundTripOptionalEnum(_ v: AsyncDirection?) async -> AsyncDirection? {
    return v
}

@JS func asyncRoundTripOptionalRawEnum(_ v: AsyncTheme?) async -> AsyncTheme? {
    return v
}

@JS func asyncRoundTripOptionalStruct(_ v: AsyncPoint?) async -> AsyncPoint? {
    return v
}

@JS func asyncRoundTripStructArray(_ v: [AsyncPoint]) async -> [AsyncPoint] {
    return v
}

@JS func asyncRoundTripEnumArray(_ v: [AsyncDirection]) async -> [AsyncDirection] {
    return v
}

@JS func asyncRoundTripStructDictionary(_ v: [String: AsyncPoint]) async -> [String: AsyncPoint] {
    return v
}

@JS func asyncRoundTripEnumDictionary(_ v: [String: AsyncDirection]) async -> [String: AsyncDirection] {
    return v
}
