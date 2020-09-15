//
//  Created by Manuel Burghard. Licensed unter MIT.
//

import _CJavaScriptKit

public protocol TypedArrayElement: JSValueConvertible, JSValueConstructible {
    static var typedArrayKind: JavaScriptTypedArrayKind { get }
    static var typedArrayClass: JSFunction { get }
}

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

    public init?(_ object: JSObject) {
        guard object.isInstanceOf(Element.typedArrayClass) else { return nil }
        self.ref = object
    }

    public convenience init(length: Int) {
        let jsObject = Element.typedArrayClass.new(length)
        self.init(unsafe: jsObject)
    }

    required public convenience init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    public convenience init(_ array: [Element]) {
        var resultObj = JavaScriptObjectRef()
        array.withUnsafeBufferPointer { ptr in
            _create_typed_array(Element.typedArrayKind, ptr.baseAddress!, Int32(array.count), &resultObj)
        }
        self.init(unsafe: JSObject(id: resultObj))
    }

    public convenience init(_ stride: StrideTo<Element>) where Element: Strideable {
        self.init(stride.map({ $0 }))
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
    public static var typedArrayClass: JSFunction {
        valueForBitWidth(typeName: "Int", bitWidth: Int.bitWidth, when32: JSObject.global.Int32Array).function!
    }
    public static var typedArrayKind: JavaScriptTypedArrayKind {
        valueForBitWidth(typeName: "Int", bitWidth: Int.bitWidth, when32: .int32)
    }
}
extension UInt: TypedArrayElement {
    public static var typedArrayClass: JSFunction {
        valueForBitWidth(typeName: "UInt", bitWidth: Int.bitWidth, when32: JSObject.global.Uint32Array).function!
    }
    public static var typedArrayKind: JavaScriptTypedArrayKind {
        valueForBitWidth(typeName: "UInt", bitWidth: UInt.bitWidth, when32: .uint32)
    }
}

// MARK: - Concrete TypedArray classes

extension Int8: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Int8Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .int8 }
}
extension UInt8: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Uint8Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .uint8 }
}
// TODO: Support Uint8ClampedArray?

extension Int16: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Int16Array.function! }
   public static var typedArrayKind: JavaScriptTypedArrayKind { .int16 }
}
extension UInt16: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Uint16Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .uint16 }
}

extension Int32: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Int32Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .int32 }
}
extension UInt32: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Uint32Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .uint32 }
}

// FIXME: Support passing BigInts across the bridge
//extension Int64: TypedArrayElement {
//    public static var typedArrayClass: JSFunction { JSObject.global.BigInt64Array.function! }
//    public static var type: JavaScriptTypedArrayKind { .bigInt64 }
//}
//extension UInt64: TypedArrayElement {
//    public static var typedArrayClass: JSFunction { JSObject.global.BigUint64Array.function! }
//    public static var type: JavaScriptTypedArrayKind { .bigUint64 }
//}

extension Float32: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Float32Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .float32 }
}
extension Float64: TypedArrayElement {
    public static var typedArrayClass: JSFunction { JSObject.global.Float64Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .float64 }
}
