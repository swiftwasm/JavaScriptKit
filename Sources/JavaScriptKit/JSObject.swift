import _CJavaScriptKit

@dynamicMemberLookup
public class JSObjectRef: Equatable {
    internal var id: UInt32
    init(id: UInt32) {
        self.id = id
    }

    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((JSValueConvertible...) -> JSValue)? {
        guard let function = self[dynamicMember: name].function else { return nil }
        return { (arguments: JSValueConvertible...) in
            function.apply(this: self, argumentList: arguments)
        }
    }

    public subscript(dynamicMember name: String) -> JSValue {
        get { get(name) }
        set { set(name, newValue) }
    }

    public func get(_ name: String) -> JSValue {
        getJSValue(this: self, name: name)
    }

    public func set(_ name: String, _ value: JSValue) {
        setJSValue(this: self, name: name, value: value)
    }

    public func get(_ index: Int) -> JSValue {
        getJSValue(this: self, index: Int32(index))
    }

    public func instanceof(_ constructor: JSFunctionRef) -> Bool {
        _instanceof(self.id, constructor.id)
    }

    public subscript(_ index: Int) -> JSValue {
        get { get(index) }
        set { set(index, newValue) }
    }

    public func set(_ index: Int, _ value: JSValue) {
        setJSValue(this: self, index: Int32(index), value: value)
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
