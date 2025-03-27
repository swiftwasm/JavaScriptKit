//
//  Created by Manuel Burghard. Licensed unter MIT.
//
import _CJavaScriptKit

/// A protocol that allows a Swift numeric type to be mapped to the JavaScript TypedArray that holds integers of its type
public protocol TypedArrayElement {
    associatedtype Element: ConvertibleToJSValue, ConstructibleFromJSValue = Self
    /// The constructor function for the TypedArray class for this particular kind of number
    static var typedArrayClass: JSFunction { get }
}

/// A wrapper around all [JavaScript `TypedArray`
/// classes](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)
/// that exposes their properties in a type-safe way.
public final class JSTypedArray<Traits>: JSBridgedClass, ExpressibleByArrayLiteral where Traits: TypedArrayElement {
    public typealias Element = Traits.Element
    public class var constructor: JSFunction? { Traits.typedArrayClass }
    public var jsObject: JSObject

    public subscript(_ index: Int) -> Element {
        get {
            return Element.construct(from: jsObject[index])!
        }
        set {
            jsObject[index] = newValue.jsValue
        }
    }

    /// Initialize a new instance of TypedArray in JavaScript environment with given length.
    ///  All the elements will be initialized to zero.
    ///
    /// - Parameter length: The number of elements that will be allocated.
    public init(length: Int) {
        jsObject = Self.constructor!.new(length)
    }

    public required init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public required convenience init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    /// Initialize a new instance of TypedArray in JavaScript environment with given elements.
    ///
    /// - Parameter array: The array that will be copied to create a new instance of TypedArray
    public convenience init(_ array: [Element]) {
        let object = array.withUnsafeBufferPointer { buffer in
            Self.createTypedArray(from: buffer)
        }
        self.init(unsafelyWrapping: object)
    }

    /// Convenience initializer for `Sequence`.
    public convenience init<S: Sequence>(_ sequence: S) where S.Element == Element {
        self.init(Array(sequence))
    }

    /// Initialize a new instance of TypedArray in JavaScript environment with given buffer contents.
    ///
    /// - Parameter buffer: The buffer that will be copied to create a new instance of TypedArray
    public convenience init(buffer: UnsafeBufferPointer<Element>) {
        self.init(unsafelyWrapping: Self.createTypedArray(from: buffer))
    }

    private static func createTypedArray(from buffer: UnsafeBufferPointer<Element>) -> JSObject {
        // Retain the constructor function to avoid it being released before calling `swjs_create_typed_array`
        let jsArrayRef = withExtendedLifetime(Self.constructor!) { ctor in
            swjs_create_typed_array(ctor.id, buffer.baseAddress, Int32(buffer.count))
        }
        return JSObject(id: jsArrayRef)
    }

    /// Length (in bytes) of the typed array.
    /// The value is established when a TypedArray is constructed and cannot be changed.
    /// If the TypedArray is not specifying a `byteOffset` or a `length`, the `length` of the referenced `ArrayBuffer` will be returned.
    public var lengthInBytes: Int {
        Int(jsObject["byteLength"].number!)
    }

    /// Length (in elements) of the typed array.
    public var length: Int {
        Int(jsObject["length"].number!)
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
        let buffer = UnsafeMutableBufferPointer<Element>.allocate(capacity: length)
        defer { buffer.deallocate() }
        copyMemory(to: buffer)
        let result = try body(UnsafeBufferPointer(buffer))
        return result
    }

    #if compiler(>=5.5)
    /// Calls the given async closure with a pointer to a copy of the underlying bytes of the
    /// array's storage.
    ///
    /// - Note: The pointer passed as an argument to `body` is valid only for the
    /// lifetime of the closure. Do not escape it from the async closure for later
    /// use.
    ///
    /// - Parameter body: A closure with an `UnsafeBufferPointer` parameter
    ///   that points to the contiguous storage for the array.
    ///    If `body` has a return value, that value is also
    ///   used as the return value for the `withUnsafeBytes(_:)` method. The
    ///   argument is valid only for the duration of the closure's execution.
    /// - Returns: The return value, if any, of the `body`async closure parameter.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func withUnsafeBytesAsync<R>(_ body: (UnsafeBufferPointer<Element>) async throws -> R) async rethrows -> R {
        let buffer = UnsafeMutableBufferPointer<Element>.allocate(capacity: length)
        defer { buffer.deallocate() }
        copyMemory(to: buffer)
        let result = try await body(UnsafeBufferPointer(buffer))
        return result
    }
    #endif

    /// Copies the contents of the array to the given buffer.
    ///
    /// - Parameter buffer: The buffer to copy the contents of the array to.
    ///   The buffer must have enough space to accommodate the contents of the array.
    public func copyMemory(to buffer: UnsafeMutableBufferPointer<Element>) {
        precondition(buffer.count >= length, "Buffer is too small to hold the contents of the array")
        swjs_load_typed_array(jsObject.id, buffer.baseAddress!)
    }
}

extension Int: TypedArrayElement {
    public static var typedArrayClass: JSFunction {
        #if _pointerBitWidth(_32)
        return JSObject.global.Int32Array.function!
        #elseif _pointerBitWidth(_64)
        return JSObject.global.Int64Array.function!
        #else
        #error("Unsupported pointer width")
        #endif
    }
}

extension UInt: TypedArrayElement {
    public static var typedArrayClass: JSFunction {
        #if _pointerBitWidth(_32)
        return JSObject.global.Uint32Array.function!
        #elseif _pointerBitWidth(_64)
        return JSObject.global.Uint64Array.function!
        #else
        #error("Unsupported pointer width")
        #endif
    }
}

extension Int8: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Int8Array.function! }
}

extension UInt8: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Uint8Array.function! }
}

extension Int16: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Int16Array.function! }
}

extension UInt16: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Uint16Array.function! }
}

extension Int32: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Int32Array.function! }
}

extension UInt32: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Uint32Array.function! }
}

extension Float32: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Float32Array.function! }
}

extension Float64: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Float64Array.function! }
}

public enum JSUInt8Clamped: TypedArrayElement {
    public typealias Element = UInt8
    public static var typedArrayClass: JSFunction { JSObject.global.Uint8ClampedArray.function! }
}

public typealias JSUInt8ClampedArray = JSTypedArray<JSUInt8Clamped>
