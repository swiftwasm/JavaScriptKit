import XCTest
import JavaScriptKit

final class JSTypedArrayTests: XCTestCase {
    func testEmptyArray() {
        _ = JSTypedArray<Int>([])
        _ = JSTypedArray<UInt>([])
        _ = JSTypedArray<Int8>([Int8]())
        _ = JSTypedArray<UInt8>([UInt8]())
        _ = JSUInt8ClampedArray([UInt8]())
        _ = JSTypedArray<Int16>([Int16]())
        _ = JSTypedArray<UInt16>([UInt16]())
        _ = JSTypedArray<Int32>([Int32]())
        _ = JSTypedArray<UInt32>([UInt32]())
        _ = JSTypedArray<Float32>([Float32]())
        _ = JSTypedArray<Float64>([Float64]())
    }
}
