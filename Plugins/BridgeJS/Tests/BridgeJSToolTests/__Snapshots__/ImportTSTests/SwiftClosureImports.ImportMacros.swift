#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_Check_5CheckSi_Si")
fileprivate func invoke_js_callback_Check_5CheckSi_Si(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_Check_5CheckSi_Si(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private final class _BJS_ClosureBox_5CheckSi_Si: _BridgedSwiftClosureBox {
    let closure: (Int) -> Int
    init(_ closure: @escaping (Int) -> Int) {
        self.closure = closure
    }
}

private enum _BJS_Closure_5CheckSi_Si {
    static func bridgeJSLower(_ closure: @escaping (Int) -> Int) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_5CheckSi_Si(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
    static func bridgeJSLift(_ callbackId: Int32) -> (Int) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_Check_5CheckSi_Si(callbackValue, param0Value)
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

@_expose(wasm, "invoke_swift_closure_Check_5CheckSi_Si")
@_cdecl("invoke_swift_closure_Check_5CheckSi_Si")
public func _invoke_swift_closure_Check_5CheckSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_5CheckSi_Si>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Int.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_applyInt")
fileprivate func bjs_applyInt(_ value: Int32, _ transform: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func bjs_applyInt(_ value: Int32, _ transform: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$applyInt(_ value: Int, _ transform: (Int) -> Int) throws(JSException) -> Int {
    let valueValue = value.bridgeJSLowerParameter()
    let transformPointer = _BJS_Closure_5CheckSi_Si.bridgeJSLower(transform)
    let ret = bjs_applyInt(valueValue, transformPointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_makeAdder")
fileprivate func bjs_makeAdder(_ base: Int32) -> Int32
#else
fileprivate func bjs_makeAdder(_ base: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$makeAdder(_ base: Int) throws(JSException) -> (Int) -> Int {
    let baseValue = base.bridgeJSLowerParameter()
    let ret = bjs_makeAdder(baseValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _BJS_Closure_5CheckSi_Si.bridgeJSLift(ret)
}