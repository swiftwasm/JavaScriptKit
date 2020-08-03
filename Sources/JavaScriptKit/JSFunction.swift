import _CJavaScriptKit

public enum _JSFunctionConstructorSymbol {
    case new
}

public class JSFunctionRef: JSObjectRef {
    @discardableResult
    func callAsFunction(this: JSObjectRef? = nil, args: [JSValueConvertible]) -> JSValue {
        let result = args.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer -> RawJSValue in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var result = RawJSValue()
                if let thisId = this?.id {
                    _call_function_with_this(thisId,
                                             self.id, argv, Int32(argc),
                                             &result.kind, &result.payload1, &result.payload2, &result.payload3)
                } else {
                    _call_function(
                        self.id, argv, Int32(argc),
                        &result.kind, &result.payload1, &result.payload2, &result.payload3
                    )
                }
                return result
            }
        }
        return JSValue(from: result)
    }

    @discardableResult
    public func callAsFunction(this: JSObjectRef? = nil, _ args: JSValueConvertible...) -> JSValue {
        self(this: this, args: args)
    }

    public func callAsFunction(new args: JSValueConvertible...) -> JSObjectRef {
        self(.new, args: args)
    }

    public func callAsFunction(_: _JSFunctionConstructorSymbol, args: [JSValueConvertible] = []) -> JSObjectRef {
        args.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var resultObj = JavaScriptObjectRef()
                _call_new(
                    self.id, argv, Int32(argc),
                    &resultObj
                )
                return JSObjectRef(id: resultObj)
            }
        }
    }

    @available(*, unavailable, message: "Please use JSClosure instead")
    public static func from(_: @escaping ([JSValue]) -> JSValue) -> JSFunctionRef {
        fatalError("unavailable")
    }

    public override subscript(jsValue _: ()) -> JSValue {
        .function(self)
    }
}

public class JSClosure: JSFunctionRef {
    static var sharedFunctions: [JavaScriptHostFuncRef: ([JSValue]) -> JSValue] = [:]

    private var hostFuncRef: JavaScriptHostFuncRef = 0

    public init(_ body: @escaping ([JSValue]) -> JSValue) {
        super.init(id: 0)
        let objectId = ObjectIdentifier(self)
        let funcRef = JavaScriptHostFuncRef(bitPattern: Int32(objectId.hashValue))
        Self.sharedFunctions[funcRef] = body

        var objectRef: JavaScriptObjectRef = 0
        _create_function(funcRef, &objectRef)

        hostFuncRef = funcRef
        id = objectRef
    }

    public func release() {
        Self.sharedFunctions[hostFuncRef] = nil
    }
}

@_cdecl("swjs_prepare_host_function_call")
public func _prepare_host_function_call(_ argc: Int32) -> UnsafeMutableRawPointer {
    let argumentSize = MemoryLayout<RawJSValue>.size * Int(argc)
    return malloc(Int(argumentSize))!
}

@_cdecl("swjs_cleanup_host_function_call")
public func _cleanup_host_function_call(_ pointer: UnsafeMutableRawPointer) {
    free(pointer)
}

@_cdecl("swjs_call_host_function")
public func _call_host_function(
    _ hostFuncRef: JavaScriptHostFuncRef,
    _ argv: UnsafePointer<RawJSValue>, _ argc: Int32,
    _ callbackFuncRef: JavaScriptObjectRef
) {
    guard let hostFunc = JSClosure.sharedFunctions[hostFuncRef] else {
        fatalError("The function was already released")
    }
    let args = UnsafeBufferPointer(start: argv, count: Int(argc)).map(JSValue.init(from:))
    let result = hostFunc(args)
    let callbackFuncRef = JSFunctionRef(id: callbackFuncRef)
    _ = callbackFuncRef(result)
}
