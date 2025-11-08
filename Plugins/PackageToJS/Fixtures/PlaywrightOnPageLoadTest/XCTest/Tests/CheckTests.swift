import XCTest
import JavaScriptKit
import JavaScriptEventLoop

final class CheckTests: XCTestCase {
    func testExpectToBeTrue() async throws {
        guard let expectToBeTrue = JSObject.global.expectToBeTrue.function
        else { return XCTFail("Function expectToBeTrue not found") }

        // expectToBeTrue returns a Promise, so we need to await it
        guard let promiseObject = expectToBeTrue().object
        else { return XCTFail("expectToBeTrue() did not return an object") }

        guard let promise = JSPromise(promiseObject)
        else { return XCTFail("expectToBeTrue() did not return a Promise") }

        let resultValue = try await promise.value
        guard let result = resultValue.boolean
        else { return XCTFail("expectToBeTrue() returned nil") }

        XCTAssertTrue(result)
    }

    func testTileOfPage() async throws {
        guard let getTitle = JSObject.global.getTitle.function
        else { return XCTFail("Function getTitle not found") }

        // getTitle returns a Promise, so we need to await it
        guard let promiseObject = getTitle().object
        else { return XCTFail("getTitle() did not return an object") }

        guard let promise = JSPromise(promiseObject)
        else { return XCTFail("expectToBeTrue() did not return a Promise") }

        let resultValue = try await promise.value
        guard let title = resultValue.string
        else { return XCTFail("expectToBeTrue() returned nil") }

        XCTAssertTrue(title == "")
    }
}
