import XCTest
@testable import JavaScriptKit

final class ThreadLocalTests: XCTestCase {
    class MyHeapObject {}
    struct MyStruct {
        var object: MyHeapObject
    }

    func testLeak() throws {
        struct Check {
            static let value = ThreadLocal<MyHeapObject>()
            static let value2 = ThreadLocal<MyStruct>(boxing: ())
        }
        weak var weakObject: MyHeapObject?
        do {
            let object = MyHeapObject()
            weakObject = object
            Check.value.wrappedValue = object
            XCTAssertNotNil(Check.value.wrappedValue)
            XCTAssertTrue(Check.value.wrappedValue === object)
            Check.value.wrappedValue = nil
        }
        XCTAssertNil(weakObject)

        weak var weakObject2: MyHeapObject?
        do {
            let object = MyHeapObject()
            weakObject2 = object
            Check.value2.wrappedValue = MyStruct(object: object)
            XCTAssertNotNil(Check.value2.wrappedValue)
            XCTAssertTrue(Check.value2.wrappedValue!.object === object)
            Check.value2.wrappedValue = nil
        }
        XCTAssertNil(weakObject2)
    }

    func testLazyThreadLocal() throws {
        struct Check {
            static let value = LazyThreadLocal(initialize: { MyHeapObject() })
        }
        let object1 = Check.value.wrappedValue
        let object2 = Check.value.wrappedValue
        XCTAssertTrue(object1 === object2)
    }
}
