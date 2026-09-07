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

    func testTypedArrayWithByteOffset() {
        // A view over part of a larger `ArrayBuffer`: `byteOffset` is non-zero and
        // `byteLength` is smaller than the backing buffer. Copying the whole
        // buffer instead of the view's window would both shift the bytes and
        // write past the end of the destination, which is sized from `length`.
        let backingLength = 32
        let viewOffset = 8
        let viewLength = 8

        let arrayBuffer = JSObject.global.ArrayBuffer.function!.new(backingLength)
        let wholeBuffer = JSTypedArray<UInt8>(
            unsafelyWrapping: JSObject.global.Uint8Array.function!.new(arrayBuffer)
        )
        for i in 0..<backingLength {
            wholeBuffer[i] = UInt8(0xA0 + i)
        }

        let view = JSTypedArray<UInt8>(
            unsafelyWrapping: JSObject.global.Uint8Array.function!.new(
                arrayBuffer,
                viewOffset,
                viewLength
            )
        )
        XCTAssertEqual(view.length, viewLength)
        XCTAssertEqual(view.lengthInBytes, viewLength)

        let expected = (0..<viewLength).map { UInt8(0xA0 + viewOffset + $0) }
        XCTAssertEqual(view.withUnsafeBytes { Array($0) }, expected)

        // `copyMemory(to:)` must not write beyond the destination it is given.
        let sentinel: UInt8 = 0x5A
        let storage = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: backingLength)
        defer { storage.deallocate() }
        storage.initialize(repeating: sentinel)
        let destination = UnsafeMutableBufferPointer(rebasing: storage[0..<viewLength])
        view.copyMemory(to: destination)

        XCTAssertEqual(Array(destination), expected)
        for i in viewLength..<backingLength {
            XCTAssertEqual(storage[i], sentinel, "copyMemory(to:) wrote past the destination at \(i)")
        }
    }

    func testMultiByteTypedArrayWithByteOffset() {
        // Same, with a multi-byte element type, so the destination is sized in
        // elements while the overrun would be measured in bytes.
        let elements: [Int32] = [1, 2, 3, 4, 5, 6, 7, 8]
        let viewOffsetInBytes = 8
        let viewLength = 4

        let arrayBuffer = JSTypedArray<Int32>(elements).jsObject.buffer.object!
        let view = JSTypedArray<Int32>(
            unsafelyWrapping: JSObject.global.Int32Array.function!.new(
                arrayBuffer,
                viewOffsetInBytes,
                viewLength
            )
        )
        XCTAssertEqual(view.length, viewLength)
        XCTAssertEqual(view.lengthInBytes, viewLength * MemoryLayout<Int32>.size)

        let expected: [Int32] = [3, 4, 5, 6]
        XCTAssertEqual(view.withUnsafeBytes { Array($0) }, expected)

        let sentinel: Int32 = -559_038_737  // 0xDEADBEEF
        let storage = UnsafeMutableBufferPointer<Int32>.allocate(capacity: elements.count)
        defer { storage.deallocate() }
        storage.initialize(repeating: sentinel)
        let destination = UnsafeMutableBufferPointer(rebasing: storage[0..<viewLength])
        view.copyMemory(to: destination)

        XCTAssertEqual(Array(destination), expected)
        for i in viewLength..<elements.count {
            XCTAssertEqual(storage[i], sentinel, "copyMemory(to:) wrote past the destination at \(i)")
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
