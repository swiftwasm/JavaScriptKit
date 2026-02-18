import XCTest
import JavaScriptKit

@JSClass struct SwiftClassSupportImports {
    @JSFunction static func jsRoundTripGreeter(_ greeter: Greeter) throws(JSException) -> Greeter
    @JSFunction static func jsRoundTripOptionalGreeter(_ greeter: Greeter?) throws(JSException) -> Greeter?
}

@JSFunction(from: .global) func gc() throws(JSException) -> Void

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

    func testSwiftClassToJSObject() throws {
        let greeter = Greeter(name: "BridgeJS")
        let jsGreeter = try XCTUnwrap(greeter.jsValue.object)
        XCTAssertEqual(jsGreeter["name"].string, "BridgeJS")
    }

    func testJSWrapperIsDeallocatedAfterFinalization() async throws {
        weak var weakGreeter: Greeter?
        var wrapperObject: JSObject?
        do {
            let greeter: Greeter = Greeter(name: "Hello")
            weakGreeter = greeter
            // Create a JS wrapper object but don't keep a reference to it
            wrapperObject = try XCTUnwrap(greeter.jsValue.object)
        }
        // Here, the wrapper object is still alive so the greeter should still be alive
        XCTAssertNotNil(weakGreeter)

        // Release the strong reference to the greeter
        wrapperObject = nil
        _ = wrapperObject

        // Trigger garbage collection to call the finalizer of the JS wrapper object
        for _ in 0..<100 {
            try gc()
            // Tick the event loop to allow the garbage collector to run finalizers
            // registered by FinalizationRegistry.
            try await Task.sleep(for: .milliseconds(0))
            if weakGreeter == nil {
                break
            }
        }
        // Here, the greeter should be deallocated
        XCTAssertNil(weakGreeter)
    }
}
