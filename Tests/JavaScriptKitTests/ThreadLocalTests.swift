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
            var value: MyHeapObject?
            @ThreadLocal(boxing: ())
            var value2: MyStruct?
        }
        weak var weakObject: MyHeapObject?
        do {
            let object = MyHeapObject()
            weakObject = object
            let check = Check()
            check.value = object
            XCTAssertNotNil(check.value)
            XCTAssertTrue(check.value === object)
        }
        XCTAssertNil(weakObject)

        weak var weakObject2: MyHeapObject?
        do {
            let object = MyHeapObject()
            weakObject2 = object
            let check = Check()
            check.value2 = MyStruct(object: object)
            XCTAssertNotNil(check.value2)
            XCTAssertTrue(check.value2!.object === object)
        }
        XCTAssertNil(weakObject2)
    }

    func testLazyThreadLocal() throws {
        struct Check {
            @LazyThreadLocal(initialize: { MyHeapObject() })
            var value: MyHeapObject
        }
        let check = Check()
        let object1 = check.value
        let object2 = check.value
        XCTAssertTrue(object1 === object2)
    }
}
