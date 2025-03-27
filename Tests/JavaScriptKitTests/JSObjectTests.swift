import JavaScriptKit
import XCTest

final class JSObjectTests: XCTestCase {
    func testEmptyObject() {
        let object = JSObject()
        let keys = JSObject.global.Object.function!.keys.function!(object)
        XCTAssertEqual(keys.array?.count, 0)
    }

    func testInitWithDictionaryLiteral() {
        let object: JSObject = [
            "key1": 1,
            "key2": "value2",
            "key3": .boolean(true),
            "key4": .object(JSObject()),
            "key5": [1, 2, 3].jsValue,
            "key6": ["key": "value"].jsValue,
        ]
        XCTAssertEqual(object.key1, .number(1))
        XCTAssertEqual(object.key2, "value2")
        XCTAssertEqual(object.key3, .boolean(true))
        let getKeys = JSObject.global.Object.function!.keys.function!
        XCTAssertEqual(getKeys(object.key4).array?.count, 0)
        XCTAssertEqual(object.key5.array.map(Array.init), [1, 2, 3])
        XCTAssertEqual(object.key6.object?.key, "value")
    }
}
