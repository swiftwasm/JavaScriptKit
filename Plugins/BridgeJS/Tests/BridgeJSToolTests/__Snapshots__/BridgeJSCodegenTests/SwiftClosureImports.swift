#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSi_Si")
fileprivate func invoke_js_callback_TestModule_10TestModuleSi_Si_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSi_Si_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSi_Si(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSi_Si_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSi_Si")
fileprivate func make_swift_closure_TestModule_10TestModuleSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSi_Si_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSi_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (Int) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSi_Si(callbackValue, param0Value)
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Int) -> Int {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Int) -> Int) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSi_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSi_Si")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSi_Si")
public func _invoke_swift_closure_TestModule_10TestModuleSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Int) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Int.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_applyInt")
fileprivate func bjs_applyInt_extern(_ value: Int32, _ transform: Int32) -> Int32
#else
fileprivate func bjs_applyInt_extern(_ value: Int32, _ transform: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_applyInt(_ value: Int32, _ transform: Int32) -> Int32 {
    return bjs_applyInt_extern(value, transform)
}

func _$applyInt(_ value: Int, _ transform: @escaping (Int) -> Int) throws(JSException) -> Int {
    let valueValue = value.bridgeJSLowerParameter()
    let transform = JSTypedClosure<(Int) -> Int>(transform)
    let transformFuncRef = transform.bridgeJSLowerParameter()
    let ret = withExtendedLifetime((transform)) {
        bjs_applyInt(valueValue, transformFuncRef)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_makeAdder")
fileprivate func bjs_makeAdder_extern(_ base: Int32) -> Int32
#else
fileprivate func bjs_makeAdder_extern(_ base: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_makeAdder(_ base: Int32) -> Int32 {
    return bjs_makeAdder_extern(base)
}

func _$makeAdder(_ base: Int) throws(JSException) -> (Int) -> Int {
    let baseValue = base.bridgeJSLowerParameter()
    let ret = bjs_makeAdder(baseValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _BJS_Closure_10TestModuleSi_Si.bridgeJSLift(ret)
}