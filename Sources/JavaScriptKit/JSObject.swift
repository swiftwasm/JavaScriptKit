import _CJavaScriptKit

@dynamicMemberLookup
public class JSObjectRef: Equatable {

    public class func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isObject
    }

    private var functionCache = [String : JSFunctionRef]()
    public let _id: UInt32
    public init(id: UInt32) {
        self._id = id
    }

    public subscript(dynamicMember name: String) -> ((JSValueEncodable...) -> JSValue)? {
        get {
            let function: JSFunctionRef
            if let f = functionCache[name] {
                function = f
            } else if let f = self[dynamicMember: name].function {
                functionCache[name] = f
                function = f
            } else {
                return nil
            }
            return { (arguments: JSValueEncodable...) in
                function.apply(this: self, argumentList: arguments)
            }
        }
    }

    public subscript(dynamicMember name: String) -> JSValue {
        get { js_get(name) }
        set { js_set(name, newValue) }
    }

    public subscript<Type: JSValueEncodable & JSValueDecodable>(dynamicMember name: String) -> Type {
        get { js_get(name).fromJSValue() }
        set { js_set(name, newValue.jsValue()) }
    }

     func js_get(_ name: String) -> JSValue {
        getJSValue(this: self, name: name)
    }

     func js_set(_ name: String, _ value: JSValue) {
        setJSValue(this: self, name: name, value: value)
    }

     func js_get(_ index: Int) -> JSValue {
        getJSValue(this: self, index: Int32(index))
    }

    public subscript(_ index: Int) -> JSValue {
        get { js_get(index) }
        set { js_set(index, newValue) }
    }

    func js_set(_ index: Int, _ value: JSValue) {
        setJSValue(this: self, index: Int32(index), value: value)
    }

    public func instanceOf(_ constructor: String) -> Bool {
        var result = RawJSValue()
        _instance_of(_id, constructor, Int32(constructor.count), &result)

        return result.jsValue().fromJSValue()
    }

    public static let global = JSObjectRef(id: _JS_Predef_Value_Global)

    deinit { _destroy_ref(_id) }

    public static func == (lhs: JSObjectRef, rhs: JSObjectRef) -> Bool {
        return lhs._id == rhs._id
    }

    public convenience required init(jsValue: JSValue) {
        switch jsValue {
        case .object(let value):
            self.init(id: value._id)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        .object(self)
    }
}

extension JSObjectRef {

    public func copyTypedArrayContent<Type>(_ array: [Type]) {

        array.withUnsafeBufferPointer { (ptr)  in
            _copy_typed_array_content(_id, ptr.baseAddress, Int32(array.count))
        }
    }
}
