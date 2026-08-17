#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC")
fileprivate func invoke_js_callback_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC_extern(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC_extern(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    return invoke_js_callback_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC")
fileprivate func make_swift_closure_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule14Workshop.BenchC_14Workshop.BenchC {
    static func bridgeJSLift(_ callbackId: Int32) -> (Workshop.Bench) -> Workshop.Bench {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let param0Pointer = param0.bridgeJSLowerParameter()
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC(callbackValue, param0Pointer)
            return Workshop.Bench.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Workshop.Bench) -> Workshop.Bench {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Workshop.Bench) -> Workshop.Bench) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC")
@_cdecl("invoke_swift_closure_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC")
public func _invoke_swift_closure_TestModule_10TestModule14Workshop.BenchC_14Workshop.BenchC(_ boxPtr: UnsafeMutableRawPointer, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Workshop.Bench) -> Workshop.Bench>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Workshop.Bench.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeBench")
@_cdecl("bjs_makeBench")
public func _bjs_makeBench() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = makeBench()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_refitBench")
@_cdecl("bjs_refitBench")
public func _bjs_refitBench(_ bench: UnsafeMutableRawPointer, _ transform: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = refitBench(_: Workshop.Bench.bridgeJSLiftParameter(bench), _: _BJS_Closure_10TestModule14Workshop.BenchC_14Workshop.BenchC.bridgeJSLift(transform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Workshop_Bench_init")
@_cdecl("bjs_Workshop_Bench_init")
public func _bjs_Workshop_Bench_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Workshop.Bench()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Workshop_Bench_deinit")
@_cdecl("bjs_Workshop_Bench_deinit")
public func _bjs_Workshop_Bench_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Workshop.Bench>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Workshop.Bench: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Workshop_Bench_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Workshop_Bench_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Workshop_Bench_wrap")
fileprivate func _bjs_Workshop_Bench_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Workshop_Bench_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Workshop_Bench_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Workshop_Bench_wrap_extern(pointer)
}