//
//  Created by Manuel Burghard. Licensed unter MIT.
//

import _CJavaScriptKit

public protocol TypedArrayElement: JSValueConvertible, JSValueConstructible {
    static var typedArrayKind: JavaScriptTypedArrayKind { get }
    static var typedArrayClass: JSFunctionRef { get }
}

public class JSTypedArray<Element>: JSObjectRef, ExpressibleByArrayLiteral where Element: TypedArrayElement {
    public subscript(_ index: Int) -> Element {
        get {
            return Element.construct(from: getJSValue(this: self, index: Int32(index)))!
        }
        set {
            setJSValue(this: self, index: Int32(index), value: newValue.jsValue())
        }
    }

    public init(length: Int) {
        let jsObject = Element.typedArrayClass.new(length)
        // _retain is necessary here because the JSObjectRef we used to create the array
        // goes out of scope and is deinitialized when this init() returns, causing
        // the JS side to decrement the object's reference count. JSTypedArray will also
        // call _release() when deinitialized because it inherits from JSObjectRef, so this
        // will not leak memory.
        _retain(jsObject.id)
        super.init(id: jsObject.id)
    }

    required public convenience init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    public init(_ array: [Element]) {
        var resultObj = JavaScriptObjectRef()
        array.withUnsafeBufferPointer { ptr in
            _create_typed_array(Element.typedArrayKind, ptr.baseAddress!, Int32(array.count), &resultObj)
        }
        super.init(id: resultObj)
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
    public static var typedArrayClass: JSFunctionRef {
        valueForBitWidth(typeName: "Int", bitWidth: Int.bitWidth, when32: JSObjectRef.global.Int32Array).function!
    }
    public static var typedArrayKind: JavaScriptTypedArrayKind {
        valueForBitWidth(typeName: "Int", bitWidth: Int.bitWidth, when32: .int32)
    }
}
extension UInt: TypedArrayElement {
    public static var typedArrayClass: JSFunctionRef {
        valueForBitWidth(typeName: "UInt", bitWidth: Int.bitWidth, when32: JSObjectRef.global.Uint32Array).function!
    }
    public static var typedArrayKind: JavaScriptTypedArrayKind {
        valueForBitWidth(typeName: "UInt", bitWidth: UInt.bitWidth, when32: .uint32)
    }
}

// MARK: - Concrete TypedArray classes

extension Int8: TypedArrayElement {
    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.Int8Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .int8 }
}
extension UInt8: TypedArrayElement {
    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.Uint8Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .uint8 }
}
// TODO: Support Uint8ClampedArray?

extension Int16: TypedArrayElement {
    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.Int16Array.function! }
   public static var typedArrayKind: JavaScriptTypedArrayKind { .int16 }
}
extension UInt16: TypedArrayElement {
    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.Uint16Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .uint16 }
}

extension Int32: TypedArrayElement {
    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.Int32Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .int32 }
}
extension UInt32: TypedArrayElement {
    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.Uint32Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .uint32 }
}

// FIXME: Support passing BigInts across the bridge
//extension Int64: TypedArrayElement {
//    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.BigInt64Array.function! }
//    public static var type: JavaScriptTypedArrayKind { .bigInt64 }
//}
//extension UInt64: TypedArrayElement {
//    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.BigUint64Array.function! }
//    public static var type: JavaScriptTypedArrayKind { .bigUint64 }
//}

extension Float32: TypedArrayElement {
    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.Float32Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .float32 }
}
extension Float64: TypedArrayElement {
    public static var typedArrayClass: JSFunctionRef { JSObjectRef.global.Float64Array.function! }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .float64 }
}
