import XCTest
@testable import JavaScriptKit

final class ThreadLocalTests: XCTestCase {
    class MyHeapObject {}
    struct MyStruct {
        var object: MyHeapObject
    }

    func testLeak() throws {
        struct Check {
            @ThreadLocal
            static var value: MyHeapObject?
            @ThreadLocal(boxing: ())
            static var value2: MyStruct?
        }
        weak var weakObject: MyHeapObject?
        do {
            let object = MyHeapObject()
            weakObject = object
            Check.value = object
            XCTAssertNotNil(Check.value)
            XCTAssertTrue(Check.value === object)
            Check.value = nil
        }
        XCTAssertNil(weakObject)

        weak var weakObject2: MyHeapObject?
        do {
            let object = MyHeapObject()
            weakObject2 = object
            Check.value2 = MyStruct(object: object)
            XCTAssertNotNil(Check.value2)
            XCTAssertTrue(Check.value2!.object === object)
            Check.value2 = nil
        }
        XCTAssertNil(weakObject2)
    }

    func testLazyThreadLocal() throws {
        struct Check {
            @LazyThreadLocal(initialize: { MyHeapObject() })
            static var value: MyHeapObject
        }
        let object1 = Check.value
        let object2 = Check.value
        XCTAssertTrue(object1 === object2)
    }
}
