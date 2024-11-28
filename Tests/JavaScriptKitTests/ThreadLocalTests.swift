import XCTest
@testable import JavaScriptKit

final class ThreadLocalTests: XCTestCase {
    class MyHeapObject {}

    func testLeak() throws {
        struct Check {
            @ThreadLocal
            var value: MyHeapObject?
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
