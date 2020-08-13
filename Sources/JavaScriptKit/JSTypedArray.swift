//
//  Created by Manuel Burghard. Licensed unter MIT.
//

import _CJavaScriptKit

public protocol TypedArrayElement: JSValueConvertible, JSValueConstructible {
    associatedtype ArrayType: JSTypedArray
    static func createTypedArray(_ array: [Self]) -> ArrayType
    static var typedArrayKind: JavaScriptTypedArrayKind { get }
}

func createTypedArray<Element>(_ array: [Element]) -> Element.ArrayType where Element: TypedArrayElement {
    return Element.createTypedArray(array) 
}

public protocol JSTypedArray: JSObjectRef, ExpressibleByArrayLiteral where ArrayLiteralElement == Element {
    associatedtype Element: TypedArrayElement
    static var classRef: JSFunctionRef { get }
}

extension JSTypedArray {
    public static var classRef: JSFunctionRef {
        let name = String(describing: Self.self)
        let jsName = String(name[name.index(name.startIndex, offsetBy: 2)...name.endIndex])
        return JSObjectRef.global[jsName].function!
    }

    public subscript(_ index: Int) -> Element {
        get {
            return Element.construct(from: getJSValue(this: self, index: Int32(index)))!
        }
        set {
            setJSValue(this: self, index: Int32(index), value: newValue.jsValue())
        }
    }

    public init(length: Int) {
        self.init(id: Self.classRef.new(length).id)
    }

    public init(arrayLiteral elements: Element...) {

        self.init(elements)
    }

    public init(_ array: [Element]) {
        var resultObj = JavaScriptObjectRef()
        array.withUnsafeBufferPointer { ptr in
            _create_typed_array(Element.typedArrayKind, ptr.baseAddress!, Int32(array.count), &resultObj)
        }
        self.init(id: resultObj)
    }

    public init<Type: Strideable>(_ stride: StrideTo<Type>) where Element == Type {
        let array = stride.map { $0 }
        self.init(array)
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
    public static func createTypedArray(_ array: [Self]) -> some JSTypedArray {
        valueForBitWidth(
            typeName: "Int",
            bitWidth: Int.bitWidth,
            when32: { JSInt32Array(array.map(Int32.init(_:))) }
        )()
    }
    public static var typedArrayKind: JavaScriptTypedArrayKind {
        valueForBitWidth(typeName: "Int", bitWidth: Int.bitWidth, when32: .int32)
    }
}
extension UInt: TypedArrayElement {
    public static func createTypedArray(_ array: [Self]) -> some JSTypedArray {
        valueForBitWidth(
            typeName: "Int",
            bitWidth: Int.bitWidth,
            when32: { JSUint32Array(array.map(UInt32.init(_:))) }
        )()
    }
    public static var typedArrayKind: JavaScriptTypedArrayKind {
        valueForBitWidth(typeName: "UInt", bitWidth: UInt.bitWidth, when32: .uint32)
    }
}

// MARK: - Concrete TypedArray classes

extension Int8: TypedArrayElement {
    public static func createTypedArray(_ array: [Self]) -> JSInt8Array { JSInt8Array(array) }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .int8 }
}
public class JSInt8Array: JSObjectRef, JSTypedArray {
    public typealias Element = Int8
}

extension UInt8: TypedArrayElement {
    public static func createTypedArray(_ array: [Self]) -> JSUint8Array { JSUint8Array(array) }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .uint8 }
}
public class JSUint8Array: JSObjectRef, JSTypedArray {
    public typealias Element = UInt8
}
// TODO: Implement?
//public class JSUint8ClampedArray: JSObjectRef, JSTypedArray {
//    public typealias Element = UInt8
//}

extension Int16: TypedArrayElement {
    public static func createTypedArray(_ array: [Self]) -> JSInt16Array { JSInt16Array(array) }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .int16 }
}
public class JSInt16Array: JSObjectRef, JSTypedArray {
    public typealias Element = Int16
}

extension UInt16: TypedArrayElement {
    public static func createTypedArray(_ array: [Self]) -> JSUint16Array { JSUint16Array(array) }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .uint16 }
}
public class JSUint16Array: JSObjectRef, JSTypedArray {
    public typealias Element = UInt16
}

extension Int32: TypedArrayElement {
    public static func createTypedArray(_ array: [Self]) -> JSInt32Array { JSInt32Array(array) }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .int32 }
}
public class JSInt32Array: JSObjectRef, JSTypedArray {
    public typealias Element = Int32
}

extension UInt32: TypedArrayElement {
    public static func createTypedArray(_ array: [Self]) -> JSUint32Array { JSUint32Array(array) }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .uint32 }
}
public class JSUint32Array: JSObjectRef, JSTypedArray {
    public typealias Element = UInt32
}

// FIXME: Support passing BigInts across the bridge
//extension Int64: TypedArrayElement {
//    public static func createTypedArray(_ array: [Self]) -> JSBigInt64Array { JSBigInt64Array(array) }
//    public static var type: JavaScriptTypedArrayKind { .bigInt64 }
//}
//public class JSBigInt64Array: JSObjectRef, JSTypedArray {
//    public typealias Element = Int64
//}
//
//extension UInt64: TypedArrayElement {
//    public static func createTypedArray(_ array: [Self]) -> BigUint64Array { BigUint64Array(array) }
//    public static var type: JavaScriptTypedArrayKind { .bigUint64 }
//}
//public class BigUint64Array: JSObjectRef, JSTypedArray {
//    public typealias Element = UInt64
//}

extension Float32: TypedArrayElement {
    public static func createTypedArray(_ array: [Self]) -> JSFloat32Array { JSFloat32Array(array) }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .float32 }
}
public class JSFloat32Array: JSObjectRef, JSTypedArray {
    public typealias Element = Float
}

extension Float64: TypedArrayElement {
    public static func createTypedArray(_ array: [Self]) -> JSFloat64Array { JSFloat64Array(array) }
    public static var typedArrayKind: JavaScriptTypedArrayKind { .float64 }
}
public class JSFloat64Array: JSObjectRef, JSTypedArray {
    public typealias Element = Double
}
