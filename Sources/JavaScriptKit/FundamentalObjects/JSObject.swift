import _CJavaScriptKit

@dynamicMemberLookup
public class JSObject: Equatable {
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

    public func isInstanceOf(_ constructor: JSFunction) -> Bool {
        _instanceof(id, constructor.id)
    }

    static let _JS_Predef_Value_Global: JavaScriptObjectRef = 0
    public static let global = JSObject(id: _JS_Predef_Value_Global)

    deinit { _release(id) }

    public static func == (lhs: JSObject, rhs: JSObject) -> Bool {
        return lhs.id == rhs.id
    }

    public class func construct(from value: JSValue) -> Self? {
        return value.object as? Self
    }

    public func jsValue() -> JSValue {
        .object(self)
    }
}

extension JSObject: CustomStringConvertible {
    public var description: String { self.toString!().string! }
}
