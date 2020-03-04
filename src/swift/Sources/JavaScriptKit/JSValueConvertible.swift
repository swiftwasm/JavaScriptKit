import _CJavaScriptKit

protocol JSValueConvertible {
    func jsValue() -> JSValue
}

extension Bool: JSValueConvertible {
    func jsValue() -> JSValue {
        .boolean(self)
    }
}

struct RawJSValue {
    var kind: JavaScriptValueKind = JavaScriptValueKind_Invalid
    var payload1: JavaScriptPayload = 0
    var payload2: JavaScriptPayload = 0
}

extension RawJSValue: JSValueConvertible {
    func jsValue() -> JSValue {
        switch kind {
        case JavaScriptValueKind_Invalid:
            fatalError()
        case JavaScriptValueKind_Boolean:
            return .boolean(payload1 != 0)
        case JavaScriptValueKind_Number:
            return .number(Int32(bitPattern: payload1))
        case JavaScriptValueKind_String:
            // +1 for null terminator
            let buffer = malloc(Int(payload2 + 1))!.assumingMemoryBound(to: UInt8.self)
            defer { free(buffer) }
            _load_string(payload1 as JavaScriptValueId, buffer)
            buffer[Int(payload2)] = 0
            let string = String(decodingCString: UnsafePointer(buffer), as: UTF8.self)
            return .string(string)
        case JavaScriptValueKind_Object:
            return .object(JSObjectRef(id: payload1))
        case JavaScriptValueKind_Null:
            return .null
        case JavaScriptValueKind_Undefined:
            return .undefined
        case JavaScriptValueKind_Function:
            return .function(JSFunctionRef(id: payload1))
        default:
            fatalError("unreachable")
        }
    }
}

extension JSValue {
    func withRawJSValue<T>(_ body: (RawJSValue) -> T) -> T {
        let kind: JavaScriptValueKind
        let payload1: JavaScriptPayload
        let payload2: JavaScriptPayload
        switch self {
        case let .boolean(boolValue):
            kind = JavaScriptValueKind_Boolean
            payload1 = boolValue ? 1 : 0
            payload2 = 0
        case let .number(numberValue):
            kind = JavaScriptValueKind_Number
            payload1 = JavaScriptPayload(bitPattern: numberValue)
            payload2 = 0
        case var .string(stringValue):
            kind = JavaScriptValueKind_String
            return stringValue.withUTF8 { bufferPtr in
                let ptrValue = UInt32(UInt(bitPattern: bufferPtr.baseAddress!))
                let rawValue = RawJSValue(kind: kind, payload1: ptrValue, payload2: JavaScriptPayload(bufferPtr.count))
                return body(rawValue)
            }
        case let .object(ref):
            kind = JavaScriptValueKind_Object
            payload1 = ref.id
            payload2 = 0
        case .null:
            kind = JavaScriptValueKind_Null
            payload1 = 0
            payload2 = 0
        case .undefined:
            kind = JavaScriptValueKind_Undefined
            payload1 = 0
            payload2 = 0
        case let .function(functionRef):
            kind = JavaScriptValueKind_Function
            payload1 = functionRef.id
            payload2 = 0
        }
        let rawValue = RawJSValue(kind: kind, payload1: payload1, payload2: payload2)
        return body(rawValue)
    }
}
