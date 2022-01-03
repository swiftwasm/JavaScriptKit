import Foundation
import _CJavaScriptKit

public typealias RawJSValue = _CJavaScriptKit.RawJSValue

extension JSObject {
    public typealias Ref = _CJavaScriptKit.JavaScriptObjectRef
}
extension JSClosure {
    public typealias Ref = _CJavaScriptKit.JavaScriptHostFuncRef
}

public enum JSThrowingCallResult<T> {
    case success(T)
    case exception(RawJSValue)

    func get(using bridge: JSBridge.Type) throws -> T {
        switch self {
        case .success(let value):
            return value
        case .exception(let rawValue):
            throw rawValue.jsValue(using: bridge)
        }
    }
}

public protocol JSBridge {
    // Objects
    static func set(on object: JSObject.Ref, property: JSObject.Ref, to value: RawJSValue)
    static func get(on object: JSObject.Ref, index: Int32) -> RawJSValue
    static func set(on object: JSObject.Ref, index: Int32, to value: RawJSValue)
    static func get(on object: JSObject.Ref, property: JSObject.Ref) -> RawJSValue

    // Strings
    static func encode(string: JSObject.Ref) -> String
    static func decode(string: inout String) -> JSObject.Ref // `inout` to enable the use of withUTF8(_:)

    // Functions
    static func call(function: JSObject.Ref, args: [RawJSValue]) -> JSThrowingCallResult<RawJSValue>
    static func call(function: JSObject.Ref, this: JSObject.Ref, args: [RawJSValue]) -> JSThrowingCallResult<RawJSValue>
    static func new(class: JSObject.Ref, args: [RawJSValue]) -> JSObject.Ref
    static func throwingNew(class: JSObject.Ref, args: [RawJSValue]) -> JSThrowingCallResult<JSObject.Ref>
    static func createFunction(calling: JSClosure.Ref) -> JSObject.Ref

    // Misc
    static func instanceof(obj: JSObject.Ref, constructor: JSObject.Ref) -> Bool
    static func createTypedArray<Element: TypedArrayElement>(copying array: [Element], as class: JSObject.Ref) -> JSObject.Ref
    static func release(_ obj: JSObject.Ref)
    static var globalThis: JSObject.Ref { get }
}

extension JSBridge {
    @inlinable public static func withRawJSValue(perform: (inout RawJSValue) -> Void) -> RawJSValue {
        var rawValue = RawJSValue()
        perform(&rawValue)
        return rawValue
    }
}
