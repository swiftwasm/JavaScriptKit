#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuley_y")
fileprivate func invoke_js_callback_TestModule_10TestModuley_y_extern(_ callback: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuley_y_extern(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuley_y(_ callback: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuley_y_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuley_y")
fileprivate func make_swift_closure_TestModule_10TestModuley_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuley_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuley_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuley_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuley_y {
    static func bridgeJSLift(_ callbackId: Int32) -> () -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuley_y(callbackValue)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == () -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping () -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuley_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuley_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModuley_y")
public func _invoke_swift_closure_TestModule_10TestModuley_y(_ boxPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<() -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ReservedWordDelegate where Self: _BridgedSwiftProtocolWrapper {
    func handle(`in`: Int, `for`: String, _ `default`: Bool) -> Void {
        `for`.bridgeJSWithLoweredParameter { (forWord0, forWord1, forWord2) in
            let defaultValue = `default`.bridgeJSLowerParameter()
            let inValue = `in`.bridgeJSLowerParameter()
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_ReservedWordDelegate_handle(jsObjectValue, inValue, forWord0, forWord1, forWord2, defaultValue)
        }
    }
}

struct AnyReservedWordDelegate: ReservedWordDelegate, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyReservedWordDelegate(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ReservedWordDelegate_handle")
fileprivate func bjs_ReservedWordDelegate_handle_extern(_ jsObject: Int32, _ `in`: Int32, _ forWord0: Int32, _ forWord1: Int32, _ forWord2: Int32, _ `default`: Int32) -> Void
#else
fileprivate func bjs_ReservedWordDelegate_handle_extern(_ jsObject: Int32, _ `in`: Int32, _ forWord0: Int32, _ forWord1: Int32, _ forWord2: Int32, _ `default`: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ReservedWordDelegate_handle(_ jsObject: Int32, _ `in`: Int32, _ forWord0: Int32, _ forWord1: Int32, _ forWord2: Int32, _ `default`: Int32) -> Void {
    return bjs_ReservedWordDelegate_handle_extern(jsObject, `in`, forWord0, forWord1, forWord2, `default`)
}

extension BacktickedLabelDelegate where Self: _BridgedSwiftProtocolWrapper {
    func handle(`in`: Int) -> Void {
        let inValue = `in`.bridgeJSLowerParameter()
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        bjs_BacktickedLabelDelegate_handle(jsObjectValue, inValue)
    }
}

struct AnyBacktickedLabelDelegate: BacktickedLabelDelegate, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyBacktickedLabelDelegate(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_BacktickedLabelDelegate_handle")
fileprivate func bjs_BacktickedLabelDelegate_handle_extern(_ jsObject: Int32, _ `in`: Int32) -> Void
#else
fileprivate func bjs_BacktickedLabelDelegate_handle_extern(_ jsObject: Int32, _ `in`: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_BacktickedLabelDelegate_handle(_ jsObject: Int32, _ `in`: Int32) -> Void {
    return bjs_BacktickedLabelDelegate_handle_extern(jsObject, `in`)
}

@_expose(wasm, "bjs_check")
@_cdecl("bjs_check")
public func _bjs_check(_ `extension`: Int32, _ `break`: Float64, _ function: Int32, _ inBytes: Int32, _ inLength: Int32) -> Void {
    #if arch(wasm32)
    let `in` = String.bridgeJSLiftParameter(inBytes, inLength)
    let function = Bool.bridgeJSLiftParameter(function)
    let `break` = Double.bridgeJSLiftParameter(`break`)
    let `extension` = Int.bridgeJSLiftParameter(`extension`)
    check(extension: `extension`, break: `break`, function: function, in: `in`)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkEscaped")
@_cdecl("bjs_checkEscaped")
public func _bjs_checkEscaped(_ inBytes: Int32, _ inLength: Int32) -> Void {
    #if arch(wasm32)
    let `in` = String.bridgeJSLiftParameter(inBytes, inLength)
    checkEscaped(_: `in`)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkEscapedCollision")
@_cdecl("bjs_checkEscapedCollision")
public func _bjs_checkEscapedCollision(_ `in`: Int32, _ _in: Int32) -> Void {
    #if arch(wasm32)
    let _in = Int.bridgeJSLiftParameter(_in)
    let `in` = Int.bridgeJSLiftParameter(`in`)
    checkEscapedCollision(in: `in`, _in: _in)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkGlueNameCollision")
@_cdecl("bjs_checkGlueNameCollision")
public func _bjs_checkGlueNameCollision(_ instance: Int32, _ swiftBytes: Int32, _ swiftLength: Int32) -> Void {
    #if arch(wasm32)
    let swift = String.bridgeJSLiftParameter(swiftBytes, swiftLength)
    let instance = Int.bridgeJSLiftParameter(instance)
    checkGlueNameCollision(instance: instance, swift: swift)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ReservedWordBox_init")
@_cdecl("bjs_ReservedWordBox_init")
public func _bjs_ReservedWordBox_init(_ `in`: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let `in` = Int.bridgeJSLiftParameter(`in`)
    let ret = ReservedWordBox(in: `in`)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ReservedWordBox_run")
@_cdecl("bjs_ReservedWordBox_run")
public func _bjs_ReservedWordBox_run(_ _self: UnsafeMutableRawPointer, _ `for`: Int32) -> Void {
    #if arch(wasm32)
    let `for` = Int.bridgeJSLiftParameter(`for`)
    let _self = ReservedWordBox.bridgeJSLiftParameter(_self)
    _self.run(for: `for`)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ReservedWordBox_static_make")
@_cdecl("bjs_ReservedWordBox_static_make")
public func _bjs_ReservedWordBox_static_make(_ `default`: Int32) -> Int32 {
    #if arch(wasm32)
    let `default` = Int.bridgeJSLiftParameter(`default`)
    let ret = ReservedWordBox.make(default: `default`)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ReservedWordBox_deinit")
@_cdecl("bjs_ReservedWordBox_deinit")
public func _bjs_ReservedWordBox_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ReservedWordBox>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ReservedWordBox: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ReservedWordBox_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_ReservedWordBox_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ReservedWordBox_wrap")
fileprivate func _bjs_ReservedWordBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ReservedWordBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_ReservedWordBox_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_ReservedWordBox_wrap_extern(pointer)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importedCheck")
fileprivate func bjs_importedCheck_extern(_ `in`: Int32, _ forWord0: Int32, _ forWord1: Int32, _ forWord2: Int32, _ `default`: Int32) -> Void
#else
fileprivate func bjs_importedCheck_extern(_ `in`: Int32, _ forWord0: Int32, _ forWord1: Int32, _ forWord2: Int32, _ `default`: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_importedCheck(_ `in`: Int32, _ forWord0: Int32, _ forWord1: Int32, _ forWord2: Int32, _ `default`: Int32) -> Void {
    return bjs_importedCheck_extern(`in`, forWord0, forWord1, forWord2, `default`)
}

func _$importedCheck(_ `in`: Int, _ `for`: String, _ `default`: Bool) throws(JSException) -> Void {
    `for`.bridgeJSWithLoweredParameter { (forWord0, forWord1, forWord2) in
        let defaultValue = `default`.bridgeJSLowerParameter()
        let inValue = `in`.bridgeJSLowerParameter()
        bjs_importedCheck(inValue, forWord0, forWord1, forWord2, defaultValue)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importedSelfClosure")
fileprivate func bjs_importedSelfClosure_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_importedSelfClosure_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_importedSelfClosure(_ self: Int32) -> Void {
    return bjs_importedSelfClosure_extern(self)
}

func _$importedSelfClosure(_ self: @escaping () -> Void) throws(JSException) -> Void {
    let `self` = JSTypedClosure<() -> Void>(self)
    let selfFuncRef = self.bridgeJSLowerParameter()
    withExtendedLifetime((self)) {
        bjs_importedSelfClosure(selfFuncRef)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}