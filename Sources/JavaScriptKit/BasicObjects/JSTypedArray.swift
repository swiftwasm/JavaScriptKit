//
//  Created by Manuel Burghard. Licensed unter MIT.
//

import _CJavaScriptKit

/// A protocol that allows a Swift numeric type to be mapped to the JavaScript TypedArray that holds integers of its type
public protocol TypedArrayElement: ConvertibleToJSValue, ConstructibleFromJSValue {
    /// The constructor function for the TypedArray class for this particular kind of number
    static var typedArrayClass: JSFunction { get }
}

/// A wrapper around all JavaScript [TypedArray](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/TypedArray) classes that exposes their properties in a type-safe way.
/// FIXME: [BigInt-based TypedArrays are currently not supported](https://github.com/swiftwasm/JavaScriptKit/issues/56).
public class JSTypedArray<Element>: JSBridgedClass, ExpressibleByArrayLiteral where Element: TypedArrayElement {
    public class var constructor: JSFunction { Element.typedArrayClass }
    public var jsObject: JSObject

    public subscript(_ index: Int) -> Element {
        get {
            return Element.construct(from: jsObject[index])!
        }
        set {
            self.jsObject[index] = newValue.jsValue
        }
    }

    /// Initialize a new instance of TypedArray in JavaScript environment with given length.
    ///  All the elements will be initialized to zero.
    ///
    /// - Parameter length: The number of elements that will be allocated.
    public init(length: Int) {
        jsObject = Self.constructor.new(length)
    }

    required public init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    required public convenience init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    /// Initialize a new instance of TypedArray in JavaScript environment with given elements.
    ///
    /// - Parameter array: The array that will be copied to create a new instance of TypedArray
    public convenience init(_ array: [Element]) {
        let jsArrayRef = array.withUnsafeBufferPointer { ptr in
            _create_typed_array(Self.constructor.id, ptr.baseAddress!, Int32(array.count))
        }
        self.init(unsafelyWrapping: JSObject(id: jsArrayRef))
    }

    /// Convenience initializer for `Sequence`.
    public convenience init<S: Sequence>(_ sequence: S) where S.Element == Element {
        self.init(Array(sequence))
    }

    /// Length (in bytes) of the typed array.
    /// The value is established when a TypedArray is constructed and cannot be changed.
    /// If the TypedArray is not specifying a `byteOffset` or a `length`, the `length` of the referenced `ArrayBuffer` will be returned.
    public var lengthInBytes: Int {
        Int(jsObject["byteLength"].number!)
    }

    /// Calls the given closure with a pointer to a copy of the underlying bytes of the
    /// array's storage.
    ///
    /// - Note: The pointer passed as an argument to `body` is valid only for the
    /// lifetime of the closure. Do not escape it from the closure for later
    /// use.
    ///
    /// - Parameter body: A closure with an `UnsafeBufferPointer` parameter
    ///   that points to the contiguous storage for the array.
    ///    If `body` has a return value, that value is also
    ///   used as the return value for the `withUnsafeBytes(_:)` method. The
    ///   argument is valid only for the duration of the closure's execution.
    /// - Returns: The return value, if any, of the `body` closure parameter.
    public func withUnsafeBytes<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R {
        let bytesLength = lengthInBytes
        let rawBuffer = malloc(bytesLength)!
        defer { free(rawBuffer) }
        _load_typed_array(jsObject.id, rawBuffer.assumingMemoryBound(to: UInt8.self))
        let length = lengthInBytes /  MemoryLayout<Element>.size
        let boundPtr = rawBuffer.bindMemory(to: Element.self, capacity: length)
        let bufferPtr = UnsafeBufferPointer<Element>(start: boundPtr, count: length)
        let result = try body(bufferPtr)
        return result
    }
}

// MARK: - Int and UInt support

// FIXME: Should be updated to support wasm64 when that becomes available.
func valueForBitWidth<T>(typeName: String, bitWidth: Int, when32: T) -> T {
    if bitWidth == 32 {
        return when32
    } else if bitWidth == 64 {
        fatalError("64-bit \(typeName)s are not yet supported in JSTypedArray")
    } else {
        fatalError("Unsupported bit width for type \(typeName): \(bitWidth) (hint: stick to fixed-size \(typeName)s to avoid this issue)")
    }
}

extension Int: TypedArrayElement {
    public static var typedArrayClass: JSFunction =
        valueForBitWidth(typeName: "Int", bitWidth: Int.bitWidth, when32: JSObject.global.Int32Array).function!
}
extension UInt: TypedArrayElement {
    public static var typedArrayClass: JSFunction =
        valueForBitWidth(typeName: "UInt", bitWidth: Int.bitWidth, when32: JSObject.global.Uint32Array).function!
}

extension Int8: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Int8Array.function!
}
extension UInt8: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Uint8Array.function!
}

public class JSUInt8ClampedArray: JSTypedArray<UInt8> {
    public class override var constructor: JSFunction { JSObject.global.Uint8ClampedArray.function! }
}

extension Int16: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Int16Array.function!
}
extension UInt16: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Uint16Array.function!
}

extension Int32: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Int32Array.function!
}
extension UInt32: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Uint32Array.function!
}

extension Float32: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Float32Array.function!
}
extension Float64: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Float64Array.function!
}
