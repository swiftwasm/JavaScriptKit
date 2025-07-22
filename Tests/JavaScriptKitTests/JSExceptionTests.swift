import XCTest
import JavaScriptKit

class JSExceptionTests: XCTestCase {
    private func eval(_ code: String) -> JSValue {
        return JSObject.global.eval!(code)
    }

    func testThrowingMethodCalls() {
        let context = eval(
            """
            (() => ({
                func1: () => { throw new Error(); },
                func2: () => { throw 'String Error'; },
                func3: () => { throw 3.0; },
            }))()
            """
        ).object!

        // MARK: Throwing method calls
        XCTAssertThrowsError(try context.throwing.func1!()) { error in
            XCTAssertTrue(error is JSException)
            let errorObject = JSError(from: (error as! JSException).thrownValue)
            XCTAssertNotNil(errorObject)
        }

        XCTAssertThrowsError(try context.throwing.func2!()) { error in
            XCTAssertTrue(error is JSException)
            let thrownValue = (error as! JSException).thrownValue
            XCTAssertEqual(thrownValue.string, "String Error")
        }

        XCTAssertThrowsError(try context.throwing.func3!()) { error in
            XCTAssertTrue(error is JSException)
            let thrownValue = (error as! JSException).thrownValue
            XCTAssertEqual(thrownValue.number, 3.0)
        }
    }

    func testThrowingUnboundFunctionCalls() {
        let jsThrowError = eval("() => { throw new Error(); }")
        XCTAssertThrowsError(try jsThrowError.function!.throws()) { error in
            XCTAssertTrue(error is JSException)
            let errorObject = JSError(from: (error as! JSException).thrownValue)
            XCTAssertNotNil(errorObject)
        }
    }

    func testThrowingConstructorCalls() {
        let Animal = JSObject.global.Animal.function!
        XCTAssertNoThrow(try Animal.throws.new("Tama", 3, true))
        XCTAssertThrowsError(try Animal.throws.new("Tama", -3, true)) { error in
            XCTAssertTrue(error is JSException)
            let errorObject = JSError(from: (error as! JSException).thrownValue)
            XCTAssertNotNil(errorObject)
        }
    }

    func testInitWithMessage() {
        let message = "THIS IS AN ERROR MESSAGE"
        let exception = JSException(message: message)
        XCTAssertTrue(exception.description.contains(message))
    }
}
