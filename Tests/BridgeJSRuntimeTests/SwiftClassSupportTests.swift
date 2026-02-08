import XCTest
@_spi(Experimental) import JavaScriptKit

@JSClass struct SwiftClassSupportImports {
    @JSFunction static func jsRoundTripGreeter(_ greeter: Greeter) throws(JSException) -> Greeter
}

final class SwiftClassSupportTests: XCTestCase {
    func testRoundTripGreeter() throws {
        let greeter = try SwiftClassSupportImports.jsRoundTripGreeter(Greeter(name: "Hello"))
        XCTAssertEqual(greeter.name, "Hello")
    }
}
