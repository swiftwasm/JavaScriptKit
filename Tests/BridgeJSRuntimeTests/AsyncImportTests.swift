import Testing
import JavaScriptKit

@JSClass struct AsyncImportImports {
    @JSFunction static func jsAsyncRoundTripVoid() async throws(JSException)
    @JSFunction static func jsAsyncRoundTripNumber(_ v: Double) async throws(JSException) -> Double
    @JSFunction static func jsAsyncRoundTripBool(_ v: Bool) async throws(JSException) -> Bool
    @JSFunction static func jsAsyncRoundTripString(_ v: String) async throws(JSException) -> String
    @JSFunction static func jsAsyncRoundTripOptionalString(_ v: String?) async throws(JSException) -> String?
    @JSFunction static func jsAsyncRoundTripOptionalNumber(_ v: Double?) async throws(JSException) -> Double?
    @JSFunction static func jsAsyncRoundTripBoolArray(_ values: [Bool]) async throws(JSException) -> [Bool]
    @JSFunction static func jsAsyncRoundTripIntArray(_ values: [Double]) async throws(JSException) -> [Double]
    @JSFunction static func jsAsyncRoundTripStringArray(_ values: [String]) async throws(JSException) -> [String]
    @JSFunction static func jsAsyncRoundTripFeatureFlag(_ v: FeatureFlag) async throws(JSException) -> FeatureFlag
}

@Suite struct AsyncImportTests {
    @Test func asyncRoundTripVoid() async throws {
        try await AsyncImportImports.jsAsyncRoundTripVoid()
    }

    @Test(arguments: [0.0, 1.0, -1.0, Double.pi, Double.infinity])
    func asyncRoundTripNumber(v: Double) async throws {
        try #expect(await AsyncImportImports.jsAsyncRoundTripNumber(v) == v)
    }

    @Test(arguments: [true, false])
    func asyncRoundTripBool(v: Bool) async throws {
        try #expect(await AsyncImportImports.jsAsyncRoundTripBool(v) == v)
    }

    @Test(arguments: ["", "Hello, world!", "🧑‍🧑‍🧒"])
    func asyncRoundTripString(v: String) async throws {
        try #expect(await AsyncImportImports.jsAsyncRoundTripString(v) == v)
    }

    // MARK: - Stack ABI types

    @Test(arguments: ["hello" as String?, nil, "🧑‍🧑‍🧒" as String?])
    func asyncRoundTripOptionalString(v: String?) async throws {
        try #expect(await AsyncImportImports.jsAsyncRoundTripOptionalString(v) == v)
    }

    @Test(arguments: [42.0 as Double?, nil, 0.0 as Double?])
    func asyncRoundTripOptionalNumber(v: Double?) async throws {
        try #expect(await AsyncImportImports.jsAsyncRoundTripOptionalNumber(v) == v)
    }

    @Test func asyncRoundTripBoolArray() async throws {
        let values: [Bool] = [true, false, true]
        try #expect(await AsyncImportImports.jsAsyncRoundTripBoolArray(values) == values)
        try #expect(await AsyncImportImports.jsAsyncRoundTripBoolArray([]) == [])
    }

    @Test func asyncRoundTripIntArray() async throws {
        let values: [Double] = [1, 2, 3, 4, 5]
        try #expect(await AsyncImportImports.jsAsyncRoundTripIntArray(values) == values)
        try #expect(await AsyncImportImports.jsAsyncRoundTripIntArray([]) == [])
    }

    @Test func asyncRoundTripStringArray() async throws {
        let values = ["Hello", "World", "🎉"]
        try #expect(await AsyncImportImports.jsAsyncRoundTripStringArray(values) == values)
        try #expect(await AsyncImportImports.jsAsyncRoundTripStringArray([]) == [])
    }

    @Test(arguments: [FeatureFlag.foo, .bar])
    func asyncRoundTripFeatureFlag(v: FeatureFlag) async throws {
        try #expect(await AsyncImportImports.jsAsyncRoundTripFeatureFlag(v) == v)
    }

    // MARK: - Structured return type

    @Test func fetchWeatherData() async throws {
        let weather = try await BridgeJSRuntimeTests.fetchWeatherData("London")
        #expect(try weather.temperature == 15.5)
        #expect(try weather.description == "Cloudy")
        #expect(try weather.humidity == 80)

        let weather2 = try await BridgeJSRuntimeTests.fetchWeatherData("Tokyo")
        #expect(try weather2.temperature == 25.0)
        #expect(try weather2.description == "Sunny")
        #expect(try weather2.humidity == 40)
    }
}
