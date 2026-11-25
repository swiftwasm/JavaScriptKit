#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule17NoncopyableObjectV_y")
fileprivate func invoke_js_callback_TestModule_10TestModule17NoncopyableObjectV_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModule17NoncopyableObjectV_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule17NoncopyableObjectV_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModule17NoncopyableObjectV_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule17NoncopyableObjectV_y")
fileprivate func make_swift_closure_TestModule_10TestModule17NoncopyableObjectV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule17NoncopyableObjectV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule17NoncopyableObjectV_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule17NoncopyableObjectV_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule17NoncopyableObjectV_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (borrowing NoncopyableObject) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let param0Value = param0.bridgeJSLowerParameter()
            let callbackValue = callback.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModule17NoncopyableObjectV_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (borrowing NoncopyableObject) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (borrowing NoncopyableObject) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule17NoncopyableObjectV_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule17NoncopyableObjectV_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModule17NoncopyableObjectV_y")
public func _invoke_swift_closure_TestModule_10TestModule17NoncopyableObjectV_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let param0 = NoncopyableObject.bridgeJSLiftParameter(param0)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(borrowing NoncopyableObject) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(param0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if compiler(>=6.4)
#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV_Si")
fileprivate func invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV_Si_extern(_ callback: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV_Si_extern(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV_Si(_ callback: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV_Si_extern(callback)
}
#endif

#if compiler(>=6.4)
#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV_Si")
fileprivate func make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV_Si_extern(boxPtr, file, line)
}
#endif

#if compiler(>=6.4)
@available(anyAppleOS 27.0, *)
private enum _BJS_Closure_10TestModuleSa17NoncopyableObjectV_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (borrowing UniqueArray<NoncopyableObject>) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let _ = param0.bridgeJSLowerParameter()
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV_Si(callbackValue)
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}
#endif

#if compiler(>=6.4)
@available(anyAppleOS 27.0, *)
extension JSTypedClosure where Signature == (borrowing UniqueArray<NoncopyableObject>) -> Int {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (borrowing UniqueArray<NoncopyableObject>) -> Int) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}
#endif

#if compiler(>=6.4)
@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV_Si")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV_Si")
public func _invoke_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV_Si(_ boxPtr: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let param0 = UniqueArray<NoncopyableObject>.bridgeJSStackPop()
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(borrowing UniqueArray<NoncopyableObject>) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let ret = closure(param0)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModules17NoncopyableObjectV_y")
fileprivate func invoke_js_callback_TestModule_10TestModules17NoncopyableObjectV_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModules17NoncopyableObjectV_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModules17NoncopyableObjectV_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModules17NoncopyableObjectV_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModules17NoncopyableObjectV_y")
fileprivate func make_swift_closure_TestModule_10TestModules17NoncopyableObjectV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModules17NoncopyableObjectV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModules17NoncopyableObjectV_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModules17NoncopyableObjectV_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModules17NoncopyableObjectV_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (consuming sending NoncopyableObject) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let param0Value = param0.bridgeJSLowerParameter()
            let callbackValue = callback.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModules17NoncopyableObjectV_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (consuming sending NoncopyableObject) -> Void {
    static func sending(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (consuming sending NoncopyableObject) -> Void) -> Self {
        Self(
            makeClosure: make_swift_closure_TestModule_10TestModules17NoncopyableObjectV_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModules17NoncopyableObjectV_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModules17NoncopyableObjectV_y")
public func _invoke_swift_closure_TestModule_10TestModules17NoncopyableObjectV_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let param0 = NoncopyableObject.bridgeJSLiftParameter(param0)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(consuming sending NoncopyableObject) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(param0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModules7JSValueV_y")
fileprivate func invoke_js_callback_TestModule_10TestModules7JSValueV_y_extern(_ callback: Int32, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModules7JSValueV_y_extern(_ callback: Int32, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModules7JSValueV_y(_ callback: Int32, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void {
    return invoke_js_callback_TestModule_10TestModules7JSValueV_y_extern(callback, param0Kind, param0Payload1, param0Payload2)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModules7JSValueV_y")
fileprivate func make_swift_closure_TestModule_10TestModules7JSValueV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModules7JSValueV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModules7JSValueV_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModules7JSValueV_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModules7JSValueV_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending JSValue) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let (param0Kind, param0Payload1, param0Payload2) = param0.bridgeJSLowerParameter()
            let callbackValue = callback.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModules7JSValueV_y(callbackValue, param0Kind, param0Payload1, param0Payload2)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending JSValue) -> Void {
    static func sending(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending JSValue) -> Void) -> Self {
        Self(
            makeClosure: make_swift_closure_TestModule_10TestModules7JSValueV_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModules7JSValueV_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModules7JSValueV_y")
public func _invoke_swift_closure_TestModule_10TestModules7JSValueV_y(_ boxPtr: UnsafeMutableRawPointer, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void {
    #if arch(wasm32)
    let param0 = JSValue.bridgeJSLiftParameter(param0Kind, param0Payload1, param0Payload2)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending JSValue) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(param0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension NoncopyableObjectSource where Self: _BridgedSwiftProtocolWrapper {
    func name() -> String {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = bjs_NoncopyableObjectSource_name(jsObjectValue)
        return String.bridgeJSLiftReturn(ret)
    }

    #if compiler(>=6.4)
    @available(anyAppleOS 27.0, *)
    func makeAll(_ count: Int) -> UniqueArray<NoncopyableObject> {
        let countValue = count.bridgeJSLowerParameter()
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        bjs_NoncopyableObjectSource_makeAll(jsObjectValue, countValue)
        return UniqueArray<NoncopyableObject>.bridgeJSLiftReturn()
    }
    #endif
}

struct AnyNoncopyableObjectSource: NoncopyableObjectSource, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyNoncopyableObjectSource(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectSource_name")
fileprivate func bjs_NoncopyableObjectSource_name_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObjectSource_name_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectSource_name(_ jsObject: Int32) -> Int32 {
    return bjs_NoncopyableObjectSource_name_extern(jsObject)
}

#if compiler(>=6.4)
#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectSource_makeAll")
fileprivate func bjs_NoncopyableObjectSource_makeAll_extern(_ jsObject: Int32, _ count: Int32) -> Void
#else
fileprivate func bjs_NoncopyableObjectSource_makeAll_extern(_ jsObject: Int32, _ count: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectSource_makeAll(_ jsObject: Int32, _ count: Int32) -> Void {
    return bjs_NoncopyableObjectSource_makeAll_extern(jsObject, count)
}
#endif

@_expose(wasm, "bjs_useNoncopyableObject")
@_cdecl("bjs_useNoncopyableObject")
public func _bjs_useNoncopyableObject(_ object: Int32) -> Int32 {
    #if arch(wasm32)
    let object = NoncopyableObject.bridgeJSLiftParameter(object)
    let ret = useNoncopyableObject(_: object)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeNoncopyableObjectInSwift")
@_cdecl("bjs_makeNoncopyableObjectInSwift")
public func _bjs_makeNoncopyableObjectInSwift(_ start: Int32) -> Int32 {
    #if arch(wasm32)
    let start = Int.bridgeJSLiftParameter(start)
    let ret = makeNoncopyableObjectInSwift(_: start)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_findNoncopyableObjectInSwift")
@_cdecl("bjs_findNoncopyableObjectInSwift")
public func _bjs_findNoncopyableObjectInSwift(_ start: Int32) -> Void {
    #if arch(wasm32)
    let start = Int.bridgeJSLiftParameter(start)
    let ret = findNoncopyableObjectInSwift(_: start)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if compiler(>=6.4)
@_expose(wasm, "bjs_countNoncopyableObjects")
@_cdecl("bjs_countNoncopyableObjects")
public func _bjs_countNoncopyableObjects() -> Int32 {
    #if arch(wasm32)
    let objects = UniqueArray<NoncopyableObject>.bridgeJSStackPop()
    let ret = countNoncopyableObjects(_: objects)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
#endif

#if compiler(>=6.4)
@_expose(wasm, "bjs_countNoncopyableObjectsWith")
@_cdecl("bjs_countNoncopyableObjectsWith")
public func _bjs_countNoncopyableObjectsWith(_ body: Int32) -> Int32 {
    #if arch(wasm32)
    let body = _BJS_Closure_10TestModuleSa17NoncopyableObjectV_Si.bridgeJSLift(body)
    let ret = countNoncopyableObjectsWith(_: body)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
#endif

@_expose(wasm, "bjs_loadNoncopyableObject")
@_cdecl("bjs_loadNoncopyableObject")
public func _bjs_loadNoncopyableObject(_ start: Int32) -> Int32 {
    #if arch(wasm32)
    let start = Int.bridgeJSLiftParameter(start)
    return _bjs_makePromise(resolve: Promise_resolve_17NoncopyableObjectV, reject: Promise_reject) {
        return await loadNoncopyableObject(_: start)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if compiler(>=6.4)
@_expose(wasm, "bjs_loadNoncopyableObjects")
@_cdecl("bjs_loadNoncopyableObjects")
public func _bjs_loadNoncopyableObjects(_ count: Int32) -> Int32 {
    #if arch(wasm32)
    let count = Int.bridgeJSLiftParameter(count)
    return _bjs_makePromise(resolve: Promise_resolve_Sa17NoncopyableObjectV, reject: Promise_reject) {
        return await loadNoncopyableObjects(_: count)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
#endif

@_expose(wasm, "bjs_NoncopyableObjectBox_init")
@_cdecl("bjs_NoncopyableObjectBox_init")
public func _bjs_NoncopyableObjectBox_init(_ start: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let start = Int.bridgeJSLiftParameter(start)
    let ret = NoncopyableObjectBox(_: start)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_NoncopyableObjectBox_object_get")
@_cdecl("bjs_NoncopyableObjectBox_object_get")
public func _bjs_NoncopyableObjectBox_object_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let _self = NoncopyableObjectBox.bridgeJSLiftParameter(_self)
    let ret = NoncopyableObject.bridgeJSRetaining(_self.object)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_NoncopyableObjectBox_object_set")
@_cdecl("bjs_NoncopyableObjectBox_object_set")
public func _bjs_NoncopyableObjectBox_object_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    let value = NoncopyableObject.bridgeJSLiftParameter(value)
    let _self = NoncopyableObjectBox.bridgeJSLiftParameter(_self)
    _self.object = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_NoncopyableObjectBox_deinit")
@_cdecl("bjs_NoncopyableObjectBox_deinit")
public func _bjs_NoncopyableObjectBox_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<NoncopyableObjectBox>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension NoncopyableObjectBox: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_NoncopyableObjectBox_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_NoncopyableObjectBox_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectBox_wrap")
fileprivate func _bjs_NoncopyableObjectBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_NoncopyableObjectBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_NoncopyableObjectBox_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_NoncopyableObjectBox_wrap_extern(pointer)
}

@JSFunction func Promise_reject(_ promise: JSObject, _ value: JSValue) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_reject_TestModule")
fileprivate func promise_reject_TestModule_extern(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void
#else
fileprivate func promise_reject_TestModule_extern(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_reject_TestModule(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    return promise_reject_TestModule_extern(promise, valueKind, valuePayload1, valuePayload2)
}

func _$Promise_reject(_ promise: JSObject, _ value: JSValue) throws(JSException) -> Void {
    let (valueKind, valuePayload1, valuePayload2) = value.bridgeJSLowerParameter()
    let promiseValue = promise.bridgeJSLowerParameter()
    promise_reject_TestModule(promiseValue, valueKind, valuePayload1, valuePayload2)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_17NoncopyableObjectV(_ promise: JSObject, _ value: borrowing NoncopyableObject) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_17NoncopyableObjectV")
fileprivate func promise_resolve_TestModule_17NoncopyableObjectV_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_17NoncopyableObjectV_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_17NoncopyableObjectV(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_17NoncopyableObjectV_extern(promise, value)
}

func _$Promise_resolve_17NoncopyableObjectV(_ promise: JSObject, _ value: borrowing NoncopyableObject) throws(JSException) -> Void {
    let valueValue = value.bridgeJSLowerParameter()
    let promiseValue = promise.bridgeJSLowerParameter()
    promise_resolve_TestModule_17NoncopyableObjectV(promiseValue, valueValue)
    if let error = _swift_js_take_exception() { throw error }
}

#if compiler(>=6.4)
@available(anyAppleOS 27.0, *)
@JSFunction func Promise_resolve_Sa17NoncopyableObjectV(_ promise: JSObject, _ value: borrowing UniqueArray<NoncopyableObject>) throws(JSException)
#endif

#if compiler(>=6.4)
#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sa17NoncopyableObjectV")
fileprivate func promise_resolve_TestModule_Sa17NoncopyableObjectV_extern(_ promise: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_Sa17NoncopyableObjectV_extern(_ promise: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sa17NoncopyableObjectV(_ promise: Int32) -> Void {
    return promise_resolve_TestModule_Sa17NoncopyableObjectV_extern(promise)
}
#endif

#if compiler(>=6.4)
@available(anyAppleOS 27.0, *)
func _$Promise_resolve_Sa17NoncopyableObjectV(_ promise: JSObject, _ value: borrowing UniqueArray<NoncopyableObject>) throws(JSException) -> Void {
    let _ = value.bridgeJSLowerParameter()
    let promiseValue = promise.bridgeJSLowerParameter()
    promise_resolve_TestModule_Sa17NoncopyableObjectV(promiseValue)
    if let error = _swift_js_take_exception() { throw error }
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_makeNoncopyableObject")
fileprivate func bjs_makeNoncopyableObject_extern(_ start: Int32) -> Int32
#else
fileprivate func bjs_makeNoncopyableObject_extern(_ start: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_makeNoncopyableObject(_ start: Int32) -> Int32 {
    return bjs_makeNoncopyableObject_extern(start)
}

func _$makeNoncopyableObject(_ start: Int) throws(JSException) -> NoncopyableObject {
    let startValue = start.bridgeJSLowerParameter()
    let ret = bjs_makeNoncopyableObject(startValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return NoncopyableObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObject_init")
fileprivate func bjs_NoncopyableObject_init_extern(_ start: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObject_init_extern(_ start: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObject_init(_ start: Int32) -> Int32 {
    return bjs_NoncopyableObject_init_extern(start)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObject_name_get")
fileprivate func bjs_NoncopyableObject_name_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObject_name_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObject_name_get(_ self: Int32) -> Int32 {
    return bjs_NoncopyableObject_name_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObject_value")
fileprivate func bjs_NoncopyableObject_value_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObject_value_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObject_value(_ self: Int32) -> Int32 {
    return bjs_NoncopyableObject_value_extern(self)
}

func _$NoncopyableObject_init(_ start: Int) throws(JSException) -> JSUniqueRef {
    let startValue = start.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObject_init(startValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUniqueRef.bridgeJSLiftReturn(ret)
}

func _$NoncopyableObject_name_get(_ self: borrowing JSUniqueRef) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObject_name_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$NoncopyableObject_value(_ self: borrowing JSUniqueRef) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObject_value(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_child_get")
fileprivate func bjs_NoncopyableObjectRoundtrip_child_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_child_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_child_get(_ self: Int32) -> Int32 {
    return bjs_NoncopyableObjectRoundtrip_child_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_child_set")
fileprivate func bjs_NoncopyableObjectRoundtrip_child_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_child_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_child_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_NoncopyableObjectRoundtrip_child_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_take")
fileprivate func bjs_NoncopyableObjectRoundtrip_take_extern(_ self: Int32, _ object: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_take_extern(_ self: Int32, _ object: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_take(_ self: Int32, _ object: Int32) -> Int32 {
    return bjs_NoncopyableObjectRoundtrip_take_extern(self, object)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_adopt")
fileprivate func bjs_NoncopyableObjectRoundtrip_adopt_extern(_ self: Int32, _ object: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_adopt_extern(_ self: Int32, _ object: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_adopt(_ self: Int32, _ object: Int32) -> Int32 {
    return bjs_NoncopyableObjectRoundtrip_adopt_extern(self, object)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_make")
fileprivate func bjs_NoncopyableObjectRoundtrip_make_extern(_ self: Int32, _ start: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_make_extern(_ self: Int32, _ start: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_make(_ self: Int32, _ start: Int32) -> Int32 {
    return bjs_NoncopyableObjectRoundtrip_make_extern(self, start)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_find")
fileprivate func bjs_NoncopyableObjectRoundtrip_find_extern(_ self: Int32, _ start: Int32) -> Void
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_find_extern(_ self: Int32, _ start: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_find(_ self: Int32, _ start: Int32) -> Void {
    return bjs_NoncopyableObjectRoundtrip_find_extern(self, start)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_takeOptional")
fileprivate func bjs_NoncopyableObjectRoundtrip_takeOptional_extern(_ self: Int32, _ objectIsSome: Int32, _ objectValue: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_takeOptional_extern(_ self: Int32, _ objectIsSome: Int32, _ objectValue: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_takeOptional(_ self: Int32, _ objectIsSome: Int32, _ objectValue: Int32) -> Int32 {
    return bjs_NoncopyableObjectRoundtrip_takeOptional_extern(self, objectIsSome, objectValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_forEach")
fileprivate func bjs_NoncopyableObjectRoundtrip_forEach_extern(_ self: Int32, _ body: Int32) -> Void
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_forEach_extern(_ self: Int32, _ body: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_forEach(_ self: Int32, _ body: Int32) -> Void {
    return bjs_NoncopyableObjectRoundtrip_forEach_extern(self, body)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_load")
fileprivate func bjs_NoncopyableObjectRoundtrip_load_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ self: Int32, _ start: Int32) -> Void
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_load_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ self: Int32, _ start: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_load(_ resolveRef: Int32, _ rejectRef: Int32, _ self: Int32, _ start: Int32) -> Void {
    return bjs_NoncopyableObjectRoundtrip_load_extern(resolveRef, rejectRef, self, start)
}

#if compiler(>=6.4)
#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_takeAll")
fileprivate func bjs_NoncopyableObjectRoundtrip_takeAll_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_takeAll_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_takeAll(_ self: Int32) -> Int32 {
    return bjs_NoncopyableObjectRoundtrip_takeAll_extern(self)
}
#endif

#if compiler(>=6.4)
#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_makeAll")
fileprivate func bjs_NoncopyableObjectRoundtrip_makeAll_extern(_ self: Int32, _ count: Int32) -> Void
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_makeAll_extern(_ self: Int32, _ count: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_makeAll(_ self: Int32, _ count: Int32) -> Void {
    return bjs_NoncopyableObjectRoundtrip_makeAll_extern(self, count)
}
#endif

#if compiler(>=6.4)
#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_makeMaybe")
fileprivate func bjs_NoncopyableObjectRoundtrip_makeMaybe_extern(_ self: Int32, _ count: Int32) -> Void
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_makeMaybe_extern(_ self: Int32, _ count: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_makeMaybe(_ self: Int32, _ count: Int32) -> Void {
    return bjs_NoncopyableObjectRoundtrip_makeMaybe_extern(self, count)
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObjectRoundtrip_raw")
fileprivate func bjs_NoncopyableObjectRoundtrip_raw_extern(_ self: Int32, _ start: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObjectRoundtrip_raw_extern(_ self: Int32, _ start: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObjectRoundtrip_raw(_ self: Int32, _ start: Int32) -> Int32 {
    return bjs_NoncopyableObjectRoundtrip_raw_extern(self, start)
}

func _$NoncopyableObjectRoundtrip_child_get(_ self: borrowing JSUniqueRef) throws(JSException) -> NoncopyableObject {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObjectRoundtrip_child_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return NoncopyableObject.bridgeJSLiftReturn(ret)
}

func _$NoncopyableObjectRoundtrip_child_set(_ self: borrowing JSUniqueRef, _ newValue: borrowing NoncopyableObject) throws(JSException) -> Void {
    let newValueValue = newValue.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    bjs_NoncopyableObjectRoundtrip_child_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$NoncopyableObjectRoundtrip_take(_ self: borrowing JSUniqueRef, _ object: borrowing NoncopyableObject) throws(JSException) -> Int {
    let objectValue = object.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObjectRoundtrip_take(selfValue, objectValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$NoncopyableObjectRoundtrip_adopt(_ self: borrowing JSUniqueRef, _ object: borrowing NoncopyableObject) throws(JSException) -> Int {
    let objectValue = object.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObjectRoundtrip_adopt(selfValue, objectValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$NoncopyableObjectRoundtrip_make(_ self: borrowing JSUniqueRef, _ start: Int) throws(JSException) -> NoncopyableObject {
    let startValue = start.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObjectRoundtrip_make(selfValue, startValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return NoncopyableObject.bridgeJSLiftReturn(ret)
}

func _$NoncopyableObjectRoundtrip_find(_ self: borrowing JSUniqueRef, _ start: Int) throws(JSException) -> Optional<NoncopyableObject> {
    let startValue = start.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    bjs_NoncopyableObjectRoundtrip_find(selfValue, startValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<NoncopyableObject>.bridgeJSLiftReturn()
}

func _$NoncopyableObjectRoundtrip_takeOptional(_ self: borrowing JSUniqueRef, _ object: borrowing Optional<NoncopyableObject>) throws(JSException) -> Int {
    let (objectIsSome, objectValue) = object.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObjectRoundtrip_takeOptional(selfValue, objectIsSome, objectValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$NoncopyableObjectRoundtrip_forEach(_ self: borrowing JSUniqueRef, _ body: JSTypedClosure<(borrowing NoncopyableObject) -> Void>) throws(JSException) -> Void {
    let bodyFuncRef = body.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    bjs_NoncopyableObjectRoundtrip_forEach(selfValue, bodyFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$NoncopyableObjectRoundtrip_load(_ self: borrowing JSUniqueRef, _ start: Int) async throws(JSException) -> NoncopyableObject {
    let resolved = try await _bjs_awaitPromise(makeResolveClosure: {
            JSTypedClosure<(consuming sending NoncopyableObject) -> Void>.sending($0)
        }, makeRejectClosure: {
            JSTypedClosure<(sending JSValue) -> Void>.sending($0)
        }) { resolveRef, rejectRef in
        let startValue = start.bridgeJSLowerParameter()
        let selfValue = self.bridgeJSLowerParameter()
        bjs_NoncopyableObjectRoundtrip_load(resolveRef, rejectRef, selfValue, startValue)
    }
    return resolved
}

#if compiler(>=6.4)
@available(anyAppleOS 27.0, *)
func _$NoncopyableObjectRoundtrip_takeAll(_ self: borrowing JSUniqueRef, _ objects: borrowing UniqueArray<NoncopyableObject>) throws(JSException) -> Int {
    let _ = objects.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObjectRoundtrip_takeAll(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}
#endif

#if compiler(>=6.4)
@available(anyAppleOS 27.0, *)
func _$NoncopyableObjectRoundtrip_makeAll(_ self: borrowing JSUniqueRef, _ count: Int) throws(JSException) -> UniqueArray<NoncopyableObject> {
    let countValue = count.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    bjs_NoncopyableObjectRoundtrip_makeAll(selfValue, countValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return UniqueArray<NoncopyableObject>.bridgeJSLiftReturn()
}
#endif

#if compiler(>=6.4)
@available(anyAppleOS 27.0, *)
func _$NoncopyableObjectRoundtrip_makeMaybe(_ self: borrowing JSUniqueRef, _ count: Int) throws(JSException) -> Optional<UniqueArray<NoncopyableObject>> {
    let countValue = count.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    bjs_NoncopyableObjectRoundtrip_makeMaybe(selfValue, countValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<UniqueArray<NoncopyableObject>>.bridgeJSLiftReturn()
}
#endif

func _$NoncopyableObjectRoundtrip_raw(_ self: borrowing JSUniqueRef, _ start: Int) throws(JSException) -> JSUniqueRef {
    let startValue = start.bridgeJSLowerParameter()
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObjectRoundtrip_raw(selfValue, startValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUniqueRef.bridgeJSLiftReturn(ret)
}