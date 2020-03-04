import _CJavaScriptKit

public class JSObjectRef: Equatable {
    let id: UInt32
    init(id: UInt32) {
        self.id = id
    }
    public static func global() -> JSObjectRef {
        .init(id: _JS_Predef_Value_Global)
    }

    deinit {

    }

    public static func == (lhs: JSObjectRef, rhs: JSObjectRef) -> Bool {
        return lhs.id == rhs.id
    }
}

public class JSFunctionRef: Equatable {
    let id: UInt32

    init(id: UInt32) {
        self.id = id
    }

    public static func == (lhs: JSFunctionRef, rhs: JSFunctionRef) -> Bool {
        return lhs.id == rhs.id
    }
}

public enum JSValue: Equatable {
    case boolean(Bool)
    case string(String)
    case number(Int32)
    case object(JSObjectRef)
    case null
    case undefined
    case function(JSFunctionRef)
}

public func getJSValue(this: JSObjectRef, name: String) -> JSValue {
    var rawValue = RawJSValue()
    _get_prop(this.id, name, Int32(name.count),
                  &rawValue.kind,
                  &rawValue.payload1, &rawValue.payload2)
    return rawValue.jsValue()
}

public func setJSValue(this: JSObjectRef, name: String, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_prop(this.id, name, Int32(name.count), rawValue.kind, rawValue.payload1, rawValue.payload2)
    }
}


public func getJSValue(this: JSObjectRef, index: Int32) -> JSValue {
    var rawValue = RawJSValue()
    _get_subscript(this.id, index,
                   &rawValue.kind,
                   &rawValue.payload1, &rawValue.payload2)
    return rawValue.jsValue()
}


public func setJSValue(this: JSObjectRef, index: Int32, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_subscript(this.id, index,
                       rawValue.kind,
                       rawValue.payload1, rawValue.payload2)
    }
}

