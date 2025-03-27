import JavaScriptKit
import XCTest

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

    func testTypedArray() {
        func checkArray<T>(_ array: [T]) where T: TypedArrayElement & Equatable, T.Element == T {
            XCTAssertEqual(toString(JSTypedArray<T>(array).jsValue.object!), jsStringify(array))
            checkArrayUnsafeBytes(array)
        }

        func toString<T: JSObject>(_ object: T) -> String {
            return object.toString!().string!
        }

        func jsStringify(_ array: [Any]) -> String {
            array.map({ String(describing: $0) }).joined(separator: ",")
        }

        func checkArrayUnsafeBytes<T>(_ array: [T]) where T: TypedArrayElement & Equatable, T.Element == T {
            let copyOfArray: [T] = JSTypedArray<T>(array).withUnsafeBytes { buffer in
                Array(buffer)
            }
            XCTAssertEqual(copyOfArray, array)
        }

        let numbers = [UInt8](0...255)
        let typedArray = JSTypedArray<UInt8>(numbers)
        XCTAssertEqual(typedArray[12], 12)
        XCTAssertEqual(numbers.count, typedArray.lengthInBytes)

        let numbersSet = Set(0...255)
        let typedArrayFromSet = JSTypedArray<Int>(numbersSet)
        XCTAssertEqual(typedArrayFromSet.jsObject.length, 256)
        XCTAssertEqual(typedArrayFromSet.lengthInBytes, 256 * MemoryLayout<Int>.size)

        checkArray([0, .max, 127, 1] as [UInt8])
        checkArray([0, 1, .max, .min, -1] as [Int8])

        checkArray([0, .max, 255, 1] as [UInt16])
        checkArray([0, 1, .max, .min, -1] as [Int16])

        checkArray([0, .max, 255, 1] as [UInt32])
        checkArray([0, 1, .max, .min, -1] as [Int32])

        checkArray([0, .max, 255, 1] as [UInt])
        checkArray([0, 1, .max, .min, -1] as [Int])

        let float32Array: [Float32] = [
            0, 1, .pi, .greatestFiniteMagnitude, .infinity, .leastNonzeroMagnitude,
            .leastNormalMagnitude, 42,
        ]
        let jsFloat32Array = JSTypedArray<Float32>(float32Array)
        for (i, num) in float32Array.enumerated() {
            XCTAssertEqual(num, jsFloat32Array[i])
        }

        let float64Array: [Float64] = [
            0, 1, .pi, .greatestFiniteMagnitude, .infinity, .leastNonzeroMagnitude,
            .leastNormalMagnitude, 42,
        ]
        let jsFloat64Array = JSTypedArray<Float64>(float64Array)
        for (i, num) in float64Array.enumerated() {
            XCTAssertEqual(num, jsFloat64Array[i])
        }
    }

    func testTypedArrayMutation() {
        let array = JSTypedArray<Int>(length: 100)
        for i in 0..<100 {
            array[i] = i
        }
        for i in 0..<100 {
            XCTAssertEqual(i, array[i])
        }

        func toString<T: JSObject>(_ object: T) -> String {
            return object.toString!().string!
        }

        func jsStringify(_ array: [Any]) -> String {
            array.map({ String(describing: $0) }).joined(separator: ",")
        }

        XCTAssertEqual(toString(array.jsValue.object!), jsStringify(Array(0..<100)))
    }

    func testInitWithBufferPointer() {
        let buffer = UnsafeMutableBufferPointer<Float32>.allocate(capacity: 20)
        defer { buffer.deallocate() }
        for i in 0..<20 {
            buffer[i] = Float32(i)
        }
        let typedArray = JSTypedArray<Float32>(buffer: UnsafeBufferPointer(buffer))
        for i in 0..<20 {
            XCTAssertEqual(typedArray[i], Float32(i))
        }
    }

    func testCopyMemory() {
        let array = JSTypedArray<Int>(length: 100)
        for i in 0..<100 {
            array[i] = i
        }
        let destination = UnsafeMutableBufferPointer<Int>.allocate(capacity: 100)
        defer { destination.deallocate() }
        array.copyMemory(to: destination)

        for i in 0..<100 {
            XCTAssertEqual(destination[i], i)
        }
    }
}
