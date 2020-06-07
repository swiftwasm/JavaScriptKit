import _CJavaScriptKit

@dynamicCallable
public class JSFunctionRef: JSObjectRef {

    public override class func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isFunction
    }

    @discardableResult
    public func dynamicallyCall(withArguments arguments: [JSValueEncodable]) -> JSValue {
        let result = arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer -> RawJSValue in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var result = RawJSValue()
                _call_function(
                    self._id, argv, Int32(argc),
                    &result
                )
                return result
            }
        }
        return result.jsValue()
    }

    public func apply(this: JSObjectRef, arguments: JSValueEncodable...) -> JSValue {
        apply(this: this, argumentList: arguments)
    }
    public func apply(this: JSObjectRef, argumentList: [JSValueEncodable]) -> JSValue {
        let result = argumentList.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer -> RawJSValue in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var result = RawJSValue()
                _call_function_with_this(this._id,
                    self._id, argv, Int32(argc),
                    &result
                )
                return result
            }
        }
        return result.jsValue()
    }

    public func new(_ arguments: JSValueEncodable...) -> JSObjectRef {
        return arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var resultObj = JavaScriptPayload()
                _call_new(
                    self._id, argv, Int32(argc),
                    &resultObj
                )
                return JSObjectRef(id: resultObj)
            }
        }
    }

    public static var sharedFunctions: [([JSValue]) -> JSValue] = []
    public static func from(_ body: @escaping ([JSValue]) -> JSValue) -> JSFunctionRef {
        let id = JavaScriptHostFuncRef(sharedFunctions.count)
        sharedFunctions.append(body)
        var funcRef: JavaScriptObjectRef = 0
        _create_function(id, &funcRef)

        return JSFunctionRef(id: funcRef)
    }

    public convenience required init(jsValue: JSValue) {
        switch jsValue {
        case .function(let value):
            self.init(id: value._id)
        default:
            fatalError()
        }
    }

    public override func jsValue() -> JSValue {
        .function(self)
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
    _ callbackFuncRef: JavaScriptPayload) {
    let hostFunc = JSFunctionRef.sharedFunctions[Int(hostFuncRef)]
    let args = UnsafeBufferPointer(start: argv, count: Int(argc)).map {
        $0.jsValue()
    }
    let result = hostFunc(args)
    let callbackFuncRef = JSFunctionRef(id: callbackFuncRef)
    _ = callbackFuncRef(result)
}


extension JSFunctionRef {

    public static func from<A0: JSValueDecodable, RT: JSValueEncodable>(_ body: @escaping (A0) -> RT) -> JSFunctionRef {

        return from({ arguments in body(arguments[0].fromJSValue()).jsValue() })
    }

    public static func from<A0: JSValueDecodable, A1: JSValueDecodable, RT: JSValueEncodable>(_ body: @escaping (A0, A1) -> RT) -> JSFunctionRef {

        return from({ arguments in body(arguments[0].fromJSValue(), arguments[1].fromJSValue()).jsValue() })
    }

    public static func from<A0: JSValueDecodable, A1: JSValueDecodable, A2: JSValueDecodable, RT: JSValueEncodable>(_ body: @escaping (A0, A1, A2) -> RT) -> JSFunctionRef {

        return from({ arguments in body(arguments[0].fromJSValue(), arguments[1].fromJSValue(), arguments[2].fromJSValue()).jsValue() })
    }

    public static func from<A0: JSValueDecodable, A1: JSValueDecodable, A2: JSValueDecodable, A3: JSValueDecodable, RT: JSValueEncodable>(_ body: @escaping (A0, A1, A2, A3) -> RT) -> JSFunctionRef {

        return from({ arguments in body(arguments[0].fromJSValue(), arguments[1].fromJSValue(), arguments[2].fromJSValue(), arguments[3].fromJSValue()).jsValue() })
    }

    public static func from<A0: JSValueDecodable, A1: JSValueDecodable, A2: JSValueDecodable, A3: JSValueDecodable, A4: JSValueDecodable, RT: JSValueEncodable>(_ body: @escaping (A0, A1, A2, A3, A4) -> RT) -> JSFunctionRef {

        return from({ arguments in body(arguments[0].fromJSValue(), arguments[1].fromJSValue(), arguments[2].fromJSValue(), arguments[3].fromJSValue(), arguments[4].fromJSValue()).jsValue() })
    }

    public func wrappedClosure<A0: JSValueEncodable, RT: JSValueDecodable>() -> (A0) -> RT {
        return { (arg0) in self.dynamicallyCall(withArguments: [arg0]).fromJSValue() }
    }

    public func wrappedClosure<A0: JSValueEncodable, A1: JSValueEncodable, RT: JSValueDecodable>() -> (A0, A1) -> RT {
        return { (arg0, arg1) in self.dynamicallyCall(withArguments: [arg0, arg1]).fromJSValue() }
    }

    public func wrappedClosure<A0: JSValueEncodable, A1: JSValueEncodable, A2: JSValueEncodable, RT: JSValueDecodable>() -> (A0, A1, A2) -> RT {
        return { (arg0, arg1, arg2) in self.dynamicallyCall(withArguments: [arg0, arg1, arg2]).fromJSValue() }
    }

    public func wrappedClosure<A0: JSValueEncodable, A1: JSValueEncodable, A2: JSValueEncodable, A3: JSValueEncodable, RT: JSValueDecodable>() -> (A0, A1, A2, A3) -> RT {
        return { (arg0, arg1, arg2, arg3) in self.dynamicallyCall(withArguments: [arg0, arg1, arg2, arg3]).fromJSValue() }
    }

    public func wrappedClosure<A0: JSValueEncodable, A1: JSValueEncodable, A2: JSValueEncodable, A3: JSValueEncodable, A4: JSValueEncodable, RT: JSValueDecodable>() -> (A0, A1, A2, A3, A4) -> RT {
        return { (arg0, arg1, arg2, arg3, arg4) in self.dynamicallyCall(withArguments: [arg0, arg1, arg2, arg3, arg4]).fromJSValue() }
    }
}
