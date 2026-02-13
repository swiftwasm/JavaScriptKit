import XCTest
import JavaScriptKit

@JSClass struct SwiftClassSupportImports {
    @JSFunction static func jsRoundTripGreeter(_ greeter: Greeter) throws(JSException) -> Greeter
    @JSFunction static func jsRoundTripOptionalGreeter(_ greeter: Greeter?) throws(JSException) -> Greeter?
}

final class SwiftClassSupportTests: XCTestCase {
    func testRoundTripGreeter() throws {
        let greeter = try SwiftClassSupportImports.jsRoundTripGreeter(Greeter(name: "Hello"))
        XCTAssertEqual(greeter.name, "Hello")
    }

    func testRoundTripOptionalGreeter() throws {
        let greeter1 = try SwiftClassSupportImports.jsRoundTripOptionalGreeter(nil)
        XCTAssertNil(greeter1)

        let greeter2 = try SwiftClassSupportImports.jsRoundTripOptionalGreeter(Greeter(name: "Hello"))
        XCTAssertEqual(greeter2?.name, "Hello")
    }
}
