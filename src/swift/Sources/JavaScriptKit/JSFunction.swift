import _CJavaScriptKit

@dynamicCallable
public class JSFunctionRef: Equatable {
    let id: UInt32

    init(id: UInt32) {
        self.id = id
    }

    public static func == (lhs: JSFunctionRef, rhs: JSFunctionRef) -> Bool {
        return lhs.id == rhs.id
    }

    public func dynamicallyCall(withArguments arguments: [JSValue]) -> JSValue {
        let result = arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer -> RawJSValue in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var result = RawJSValue()
                _call_function(
                    self.id, argv, Int32(argc),
                    &result.kind, &result.payload1, &result.payload2
                )
                return result
            }
        }
        return result.jsValue()
    }

    public func apply(this: JSObjectRef, arguments: [JSValue]) -> JSValue {
        let result = arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer -> RawJSValue in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var result = RawJSValue()
                _call_function_with_this(this.id,
                    self.id, argv, Int32(argc),
                    &result.kind, &result.payload1, &result.payload2
                )
                return result
            }
        }
        return result.jsValue()
    }

    public func new(_ arguments: [JSValue]) -> JSObjectRef {
        return arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var resultObj = JavaScriptPayload()
                _call_new(
                    self.id, argv, Int32(argc),
                    &resultObj
                )
                return JSObjectRef(id: resultObj)
            }
        }
    }

    static var sharedFunctions: [([JSValue]) -> JSValue] = []
    public static func from(_ body: @escaping ([JSValue]) -> JSValue) -> JSFunctionRef {
        let id = JavaScriptHostFuncRef(sharedFunctions.count)
        sharedFunctions.append(body)
        var funcRef: JavaScriptObjectRef = 0
        _create_function(id, &funcRef)

        return JSFunctionRef(id: funcRef)
    }
}


@_cdecl("swjs_prepare_host_function_call")
public func _prepare_host_function_call(_ argc: Int32) -> UnsafeMutableRawPointer {
    let argumentSize = MemoryLayout<RawJSValue>.size * Int(argc)
    return malloc(Int(argumentSize))!
}

@_cdecl("swjs_call_host_function")
public func _call_host_function(
    _ hostFuncRef: JavaScriptHostFuncRef,
    _ argv: UnsafePointer<RawJSValue>, _ argc: Int32,
    _ callbackFuncRef: JavaScriptPayload) {
    let hostFunc = JSFunctionRef.sharedFunctions[Int(hostFuncRef)]
    let args = UnsafeBufferPointer(start: argv, count: Int(argc)).map {
        $0.jsValue()
    }
    let result = hostFunc(args)
    let callbackFuncRef = JSFunctionRef(id: callbackFuncRef)
    _ = callbackFuncRef(result)
}
