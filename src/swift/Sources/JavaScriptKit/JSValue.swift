public class JSRef {
    let id: UInt32
    init(id: UInt32) {
        self.id = id
    }
    public static func global() -> JSRef {
        .init(id: _JS_Predef_Value_Global)
    }

    deinit {

    }
}

public enum JSValue {
    case boolean(Bool)
    case string(String)
}

protocol JSValueConvertible {
    func jsValue() -> JSValue
}

extension Bool: JSValueConvertible {
    func jsValue() -> JSValue {
        .boolean(self)
    }
}

import _CJavaScriptKit

public func getJSValue(this: JSRef, name: String) -> JSValue {
    var kind: JavaScriptValueKind = JavaScriptValueKind_Invalid
    var payload: JavaScriptPayload = 0
    _get_js_value(this.id, name, Int32(name.count), &kind, &payload)
    switch kind {
    case JavaScriptValueKind_Invalid:
        fatalError()
    case JavaScriptValueKind_Boolean:
        return .boolean(payload != 0)
    case JavaScriptValueKind_String:
        let ptr = UnsafePointer<UInt8>(bitPattern: UInt(payload))!
        return .string(String(decodingCString: ptr, as: UTF8.self))
    default:
        fatalError("unreachable")
    }
}

public func setJSValue(this: JSRef, name: String, value: JSValue) {

    let kind: JavaScriptValueKind
    let payload: JavaScriptPayload
    switch value {
    case let .boolean(boolValue):
        kind = JavaScriptValueKind_Boolean
        payload = boolValue ? 1 : 0
    case var .string(stringValue):
        kind = JavaScriptValueKind_String
        stringValue.withUTF8 { ptr in
            let ptrValue = unsafeBitCast(ptr, to: UInt32.self)
            _set_js_value(this.id, name, Int32(name.count), kind, ptrValue)
        }
        return
    }

    print("\(#function) with prop name \"\(name)\" (length: \(name.count))")
    _set_js_value(this.id, name, Int32(name.count), kind, payload)
}


#if Xcode
func _set_js_value(_ _this: JavaScriptValueId, _ prop: UnsafePointer<Int8>!, _ length: Int32, _ kind: JavaScriptValueKind, _ value: JavaScriptPayload) { fatalError() }
func _get_js_value(_ _this: JavaScriptValueId, _ prop: UnsafePointer<Int8>!, _ length: Int32, _ kind: UnsafeMutablePointer<JavaScriptValueKind>!, _ value: UnsafeMutablePointer<JavaScriptPayload>!) {}
#endif
