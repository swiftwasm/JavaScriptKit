import _CJavaScriptKit

@dynamicMemberLookup
public class JSObjectRef: Equatable {
    internal var id: UInt32
    init(id: UInt32) {
        self.id = id
    }

    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((JSValueConvertible...) -> JSValue)? {
        guard let function = self[name].function else { return nil }
        return { (arguments: JSValueConvertible...) in
            function(this: self, arguments: arguments)
        }
    }

    public subscript(dynamicMember name: String) -> JSValue {
        get { self[name] }
        set { self[name] = newValue }
    }

    public subscript(_ name: String) -> JSValue {
        get { getJSValue(this: self, name: name) }
        set { setJSValue(this: self, name: name, value: newValue) }
    }

    public subscript(_ index: Int) -> JSValue {
        get { getJSValue(this: self, index: Int32(index)) }
        set { setJSValue(this: self, index: Int32(index), value: newValue) }
    }

    public func isInstanceOf(_ constructor: JSFunctionRef) -> Bool {
        _instanceof(id, constructor.id)
    }

    static let _JS_Predef_Value_Global: UInt32 = 0
    public static let global = JSObjectRef(id: _JS_Predef_Value_Global)

    deinit { _destroy_ref(id) }

    public static func == (lhs: JSObjectRef, rhs: JSObjectRef) -> Bool {
        return lhs.id == rhs.id
    }

    public func jsValue() -> JSValue {
        .object(self)
    }

    public class func createTypedArray<Type>(_ array: [Type]) -> JSObjectRef where Type: TypedArrayElement {
        let type: JavaScriptTypedArrayKind
        switch Type.self {
        case is Int8.Type:
            type = .int8
        case is UInt8.Type:
            type = .uint8
        case is Int16.Type:
            type = .int16
        case is UInt16.Type:
            type = .uint16
        case is Int32.Type:
            type = .int32
        case is UInt32.Type:
            type = .uint32
        case is Int64.Type:
            type = .bigInt64
        case is UInt64.Type:
            type = .bigUint64
        case is Float32.Type:
            type = .float32
        case is Float64.Type:
            type = .float64
        default:
            if Type.self is UInt.Type || Type.self is Int.Type {
                if UInt.bitWidth == 32 {
                    if Type.self is UInt.Type {
                        type = .uint32
                    } else {
                        type = .int32
                    }
                } else if UInt.bitWidth == 64 {
                    if Type.self is UInt.Type {
                        type = .bigUint64
                    } else {
                        type = .bigInt64
                    }
                } else {
                    fatalError("Unsupported bit width type for UInt: \(UInt.bitWidth) (hint: stick to fixed-size ints to avoid this issue)")
                }
            } else {
                fatalError("Unsupported Swift type for TypedArray: \(Type.self)")
            }
        }
        var resultObj = JavaScriptObjectRef()
        array.withUnsafeBufferPointer { ptr in
            _create_typed_array(type, ptr.baseAddress!, Int32(array.count), &resultObj)
        }
        return JSObjectRef(id: resultObj)
    }
}

public protocol TypedArrayElement {}
extension Int8: TypedArrayElement {}
extension UInt8: TypedArrayElement {}
extension Int16: TypedArrayElement {}
extension UInt16: TypedArrayElement {}
extension Int32: TypedArrayElement {}
extension UInt32: TypedArrayElement {}
extension Int64: TypedArrayElement {}
extension UInt64: TypedArrayElement {}
extension Float32: TypedArrayElement {}
extension Float64: TypedArrayElement {}
