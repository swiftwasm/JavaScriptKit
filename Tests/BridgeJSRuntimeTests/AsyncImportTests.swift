import Testing
import JavaScriptKit

@Suite struct AsyncImportTests {
    @Test func asyncRoundTripVoid() async throws {
        try await jsAsyncRoundTripVoid()
    }

    @Test(arguments: [0.0, 1.0, -1.0, Double.pi, Double.infinity])
    func asyncRoundTripNumber(v: Double) async throws {
        try #expect(await jsAsyncRoundTripNumber(v) == v)
    }

    @Test(arguments: [true, false])
    func asyncRoundTripBool(v: Bool) async throws {
        try #expect(await jsAsyncRoundTripBool(v) == v)
    }

    @Test(arguments: ["", "Hello, world!", "🧑‍🧑‍🧒"])
    func asyncRoundTripString(v: String) async throws {
        try #expect(await jsAsyncRoundTripString(v) == v)
    }

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
