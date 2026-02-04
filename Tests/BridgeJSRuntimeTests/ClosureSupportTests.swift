import XCTest
@_spi(Experimental) import JavaScriptKit

@JSClass struct ClosureSupportImports {

    @JSFunction static func jsApplyVoid(_ callback: JSTypedClosure<() -> Void>) throws(JSException)
    @JSFunction static func jsApplyBool(_ callback: JSTypedClosure<() -> Bool>) throws(JSException) -> Bool
    @JSFunction static func jsApplyInt(
        _ value: Int,
        _ transform: JSTypedClosure<(Int) -> Int>
    ) throws(JSException) -> Int
    @JSFunction static func jsApplyDouble(
        _ value: Double,
        _ transform: JSTypedClosure<(Double) -> Double>
    ) throws(JSException) -> Double
    @JSFunction static func jsApplyString(
        _ value: String,
        _ transform: JSTypedClosure<(String) -> String>
    ) throws(JSException) -> String
    // @JSFunction static func jsApplyJSValue(
    //     _ value: JSValue,
    //     _ transform: JSTypedClosure<(JSValue) -> JSValue>
    // ) throws(JSException) -> JSValue
    @JSFunction static func jsApplyJSObject(
        _ value: JSObject,
        _ transform: JSTypedClosure<(JSObject) -> JSObject>
    ) throws(JSException) -> JSObject
    // @JSFunction static func jsApplyArrayInt(
    //     _ value: [Int],
    //     _ transform: JSTypedClosure<([Int]) -> [Int]>
    // ) throws(JSException) -> [Int]
    // @JSFunction static func jsApplyArrayDouble(
    //     _ value: [Double],
    //     _ transform: JSTypedClosure<([Double]) -> [Double]>
    // ) throws(JSException) -> [Double]
    // @JSFunction static func jsApplyArrayString(
    //     _ value: [String],
    //     _ transform: JSTypedClosure<([String]) -> [String]>
    // ) throws(JSException) -> [String]
    // @JSFunction static func jsApplyArrayJSValue(
    //     _ value: [JSValue],
    //     _ transform: JSTypedClosure<([JSValue]) -> [JSValue]>
    // ) throws(JSException) -> [JSValue]
    // @JSFunction static func jsApplyArrayJSObject(
    //     _ value: [JSObject],
    //     _ transform: JSTypedClosure<([JSObject]) -> [JSObject]>
    // ) throws(JSException) -> [JSObject]

    @JSFunction static func jsMakeIntToInt(_ base: Int) throws(JSException) -> (Int) -> Int
    @JSFunction static func jsMakeDoubleToDouble(_ base: Double) throws(JSException) -> (Double) -> Double
    @JSFunction static func jsMakeStringToString(_ `prefix`: String) throws(JSException) -> (String) -> String

    @JSFunction static func jsCallTwice(
        _ value: Int,
        _ callback: JSTypedClosure<(Int) -> Void>
    ) throws(JSException) -> Int
    @JSFunction static func jsCallBinary(_ callback: JSTypedClosure<(Int, Int) -> Int>) throws(JSException) -> Int
    @JSFunction static func jsCallTriple(_ callback: JSTypedClosure<(Int, Int, Int) -> Int>) throws(JSException) -> Int
    @JSFunction static func jsCallAfterRelease(_ callback: JSTypedClosure<() -> Void>) throws(JSException) -> String
    @JSFunction static func jsOptionalInvoke(_ callback: JSTypedClosure<() -> Bool>?) throws(JSException) -> Bool
    @JSFunction static func jsStoreClosure(_ callback: JSTypedClosure<() -> Void>) throws(JSException)
    @JSFunction static func jsCallStoredClosure() throws(JSException)
    @JSFunction static func jsHeapCount() throws(JSException) -> Int

    @JSFunction static func runJsClosureSupportTests() throws(JSException)
}

@JS class ClosureSupportExports {
    @JS static func makeIntToInt(_ base: Int) -> (Int) -> Int {
        return { $0 + base }
    }
    @JS static func makeDoubleToDouble(_ base: Double) -> (Double) -> Double {
        return { $0 + base }
    }
    @JS static func makeStringToString(_ prefix: String) -> (String) -> String {
        return { prefix + $0 }
    }

    @JS static func makeJSIntToInt(_ base: Int) -> JSTypedClosure<(Int) -> Int> {
        return JSTypedClosure { $0 + base }
    }
    @JS static func makeJSDoubleToDouble(_ base: Double) -> JSTypedClosure<(Double) -> Double> {
        return JSTypedClosure { $0 + base }
    }
    @JS static func makeJSStringToString(_ prefix: String) -> JSTypedClosure<(String) -> String> {
        return JSTypedClosure { prefix + $0 }
    }
}

final class ClosureSupportTests: XCTestCase {

    func testRunJsClosureSupportTests() throws {
        try ClosureSupportImports.runJsClosureSupportTests()
    }

    func testClosureParameterVoidToVoid() throws {
        var called = false
        let transform = JSTypedClosure<() -> Void> {
            called = true
        }
        defer { transform.release() }
        try ClosureSupportImports.jsApplyVoid(transform)
        XCTAssertTrue(called)
    }

    func testClosureParameterBoolToBool() throws {
        let transform = JSTypedClosure<() -> Bool> { true }
        defer { transform.release() }
        let result = try ClosureSupportImports.jsApplyBool(transform)
        XCTAssertTrue(result)
    }

    func testClosureParameterIntToInt() throws {
        let transform = JSTypedClosure { $0 * 2 }
        defer { transform.release() }
        let result = try ClosureSupportImports.jsApplyInt(21, transform)
        XCTAssertEqual(result, 42)
    }

    func testClosureParameterDoubleToDouble() throws {
        let transform = JSTypedClosure<(Double) -> Double> { $0 * 2 }
        defer { transform.release() }
        let result = try ClosureSupportImports.jsApplyDouble(21.0, transform)
        XCTAssertEqual(result, 42.0)
    }

    func testClosureParameterStringToString() throws {
        let transform = JSTypedClosure { (value: String) in
            value + ", world!"
        }
        defer { transform.release() }
        let result = try ClosureSupportImports.jsApplyString("Hello", transform)
        XCTAssertEqual(result, "Hello, world!")
    }

    // func testClosureParameterJSValueToJSValue() throws {
    //     let transform = JSTypedClosure<(JSValue) -> JSValue> { $0 }
    //     defer { transform.release() }
    //     let result = try JSTypedClosureImports.jsApplyJSValue(.number(1), transform)
    //     XCTAssertEqual(result, .number(1))
    // }

    func testClosureParameterJSObjectToJSObject() throws {
        let transform = JSTypedClosure<(JSObject) -> JSObject> { $0 }
        defer { transform.release() }
        let obj = JSObject()
        let result = try ClosureSupportImports.jsApplyJSObject(obj, transform)
        XCTAssertEqual(result, obj)
    }

    // func testClosureParameterArrayIntToArrayInt() throws {
    //     let transform = JSTypedClosure<([Int]) -> [Int]> { $0 }
    //     defer { transform.release() }
    //     let result = try ClosureSupportImports.jsApplyArrayInt([1, 2, 3], transform)
    //     XCTAssertEqual(result, [1, 2, 3])
    // }

    // func testClosureParameterArrayDoubleToArrayDouble() throws {
    //     let transform = JSTypedClosure<([Double]) -> [Double]> { $0 }
    //     defer { transform.release() }
    //     let result = try ClosureSupportImports.jsApplyArrayDouble([1.0, 2.0, 3.0], transform)
    //     XCTAssertEqual(result, [1.0, 2.0, 3.0])
    // }

    // func testClosureParameterArrayStringToArrayString() throws {
    //     let transform = JSTypedClosure<([String]) -> [String]> { $0 }
    //     defer { transform.release() }
    //     let result = try ClosureSupportImports.jsApplyArrayString(["a", "b", "c"], transform)
    //     XCTAssertEqual(result, ["a", "b", "c"])
    // }

    // func testClosureParameterArrayJSValueToArrayJSValue() throws {
    //     let transform = JSTypedClosure<([JSValue]) -> [JSValue]> { $0 }
    //     defer { transform.release() }
    //     let result = try ClosureSupportImports.jsApplyArrayJSValue([.number(1), .number(2), .number(3)], transform)
    //     XCTAssertEqual(result, [.number(1), .number(2), .number(3)])
    // }

    // func testClosureParameterArrayJSObjectToArrayJSObject() throws {
    //     let transform = JSTypedClosure<([JSObject]) -> [JSObject]> { $0 }
    //     defer { transform.release() }
    //     let obj1 = JSObject()
    //     let obj2 = JSObject()
    //     let obj3 = JSObject()
    //     let result = try ClosureSupportImports.jsApplyArrayJSObject([obj1, obj2, obj3], transform)
    //     XCTAssertEqual(result, [obj1, obj2, obj3])
    // }

    func testClosureReturnIntToInt() throws {
        let c = try ClosureSupportImports.jsMakeIntToInt(10)
        XCTAssertEqual(c(0), 10)
        XCTAssertEqual(c(32), 42)
    }

    func testClosureReturnDoubleToDouble() throws {
        let c = try ClosureSupportImports.jsMakeDoubleToDouble(10.0)
        XCTAssertEqual(c(0.0), 10.0)
        XCTAssertEqual(c(32.0), 42.0)
    }

    func testClosureReturnStringToString() throws {
        let c = try ClosureSupportImports.jsMakeStringToString("Hello, ")
        XCTAssertEqual(c("world!"), "Hello, world!")
    }

    func testClosureParameterIntToVoid() throws {
        var total = 0
        let callback = JSTypedClosure<(Int) -> Void> { value in
            total += value
        }
        defer { callback.release() }
        let ret = try ClosureSupportImports.jsCallTwice(5, callback)
        XCTAssertEqual(ret, 5)
        XCTAssertEqual(total, 10)
    }

    func testCallingReleasedClosureThrows() {
        let transform = JSTypedClosure<(Int) -> Int> { $0 + 1 }
        transform.release()

        do {
            _ = try ClosureSupportImports.jsApplyInt(41, transform)
            XCTFail("Expected JSException for released closure")
        } catch let error {
            let message = error.thrownValue.object?["message"].string
            XCTAssertNotNil(message)
            XCTAssertTrue(message?.contains(#fileID) ?? false, "message=\(message ?? "nil")")
        }
    }

    func testMultipleArity() throws {
        let sum = JSTypedClosure<(Int, Int) -> Int> { $0 + $1 }
        defer { sum.release() }
        XCTAssertEqual(try ClosureSupportImports.jsCallBinary(sum), 3)
    }

    func testTripleArity() throws {
        let sum = JSTypedClosure<(Int, Int, Int) -> Int> { $0 + $1 + $2 }
        defer { sum.release() }
        XCTAssertEqual(try ClosureSupportImports.jsCallTriple(sum), 6)
    }

    func testOptionalNoneSkipsCall() throws {
        XCTAssertFalse(try ClosureSupportImports.jsOptionalInvoke(nil))
    }

    func testOptionalSomeCalls() throws {
        var called = false
        let closure = JSTypedClosure<() -> Bool> {
            called = true
            return true
        }
        defer { closure.release() }
        XCTAssertTrue(try ClosureSupportImports.jsOptionalInvoke(closure))
        XCTAssertTrue(called)
    }

    func testDropDuringCallThenThrows() throws {
        var closure: JSTypedClosure<() -> Void>! = nil
        closure = JSTypedClosure {
            closure.release()
        }
        let message = try ClosureSupportImports.jsCallAfterRelease(closure)
        XCTAssertTrue(
            message.contains(#fileID),
            "\"\(message)\" does not contain expected file name"
        )
    }

    func testStoredClosureAfterReleaseThrows() throws {
        let closure = JSTypedClosure<() -> Void> {}
        try ClosureSupportImports.jsStoreClosure(closure)
        closure.release()
        XCTAssertThrowsError(try ClosureSupportImports.jsCallStoredClosure())
    }

    func testClosuresDoNotLeakHeapEntries() throws {
        let baseline = try ClosureSupportImports.jsHeapCount()

        for _ in 0..<50 {
            let closure: JSTypedClosure<(Int) -> Void> = JSTypedClosure { _ in }
            _ = try? ClosureSupportImports.jsCallTwice(0, closure)
        }

        // Trigger GC and read heap size from JS side
        let after = try ClosureSupportImports.jsHeapCount()
        XCTAssertEqual(after, baseline, "Heap entry count should return to baseline after GC")
    }

}
