//
//  Created by Manuel Burghard. Licensed unter MIT.
//

import _CJavaScriptKit

public protocol TypedArrayElement: JSValueConvertible, JSValueConstructible {
    static var typedArrayClass: JSFunction { get }
}

/// A wrapper around [the JavaScript TypedArray class](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)
/// that exposes its properties in a type-safe and Swifty way.
public class JSTypedArray<Element>: JSValueConvertible, ExpressibleByArrayLiteral where Element: TypedArrayElement {
    let ref: JSObject
    public func jsValue() -> JSValue {
        .object(ref)
    }

    public subscript(_ index: Int) -> Element {
        get {
            return Element.construct(from: getJSValue(this: ref, index: Int32(index)))!
        }
        set {
            setJSValue(this: ref, index: Int32(index), value: newValue.jsValue())
        }
    }

    // This private initializer assumes that the passed object is TypedArray
    private init(unsafe object: JSObject) {
        self.ref = object
    }

    /// Construct a `JSTypedArray` from TypedArray `JSObject`.
    /// Return `nil` if the object is not TypedArray.
    ///
    /// - Parameter object: A `JSObject` expected to be TypedArray
    public init?(_ object: JSObject) {
        guard object.isInstanceOf(Element.typedArrayClass) else { return nil }
        self.ref = object
    }

    /// Initialize a new instance of TypedArray in JavaScript environment with given length zero value.
    ///
    /// - Parameter length: The length of elements that will be allocated.
    public convenience init(length: Int) {
        let jsObject = Element.typedArrayClass.new(length)
        self.init(unsafe: jsObject)
    }

    required public convenience init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    
    /// Initialize a new instance of TypedArray in JavaScript environment with given elements.
    ///
    /// - Parameter array: The array that will be copied to create a new instance of TypedArray
    public convenience init(_ array: [Element]) {
        var resultObj = JavaScriptObjectRef()
        array.withUnsafeBufferPointer { ptr in
            _create_typed_array(Element.typedArrayClass.id, ptr.baseAddress!, Int32(array.count), &resultObj)
        }
        self.init(unsafe: JSObject(id: resultObj))
    }
    
    /// Convenience initializer for `Sequence`.
    public convenience init<S: Sequence>(_ sequence: S) {
        self.init(sequence.map({ $0 }))
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

// MARK: - Concrete TypedArray classes

extension Int8: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Int8Array.function!
}
extension UInt8: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Uint8Array.function!
}
// TODO: Support Uint8ClampedArray?

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

// FIXME: Support passing BigInts across the bridge
//extension Int64: TypedArrayElement {
//    public static var typedArrayClass = JSObject.global.BigInt64Array.function!
//}
//extension UInt64: TypedArrayElement {
//    public static var typedArrayClass = JSObject.global.BigUint64Array.function!
//}

extension Float32: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Float32Array.function!
}
extension Float64: TypedArrayElement {
    public static var typedArrayClass = JSObject.global.Float64Array.function!
}
