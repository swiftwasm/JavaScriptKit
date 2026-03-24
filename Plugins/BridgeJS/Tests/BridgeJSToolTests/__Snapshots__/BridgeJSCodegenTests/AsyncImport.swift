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
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0Kind, param0Payload1, param0Payload2) = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModules7JSValueV_y(callbackValue, param0Kind, param0Payload1, param0Payload2)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending JSValue) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending JSValue) -> Void) {
        self.init(
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
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending JSValue) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(JSValue.bridgeJSLiftParameter(param0Kind, param0Payload1, param0Payload2))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModules8JSObjectC_y")
fileprivate func invoke_js_callback_TestModule_10TestModules8JSObjectC_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModules8JSObjectC_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModules8JSObjectC_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModules8JSObjectC_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModules8JSObjectC_y")
fileprivate func make_swift_closure_TestModule_10TestModules8JSObjectC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModules8JSObjectC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModules8JSObjectC_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModules8JSObjectC_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModules8JSObjectC_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending JSObject) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModules8JSObjectC_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending JSObject) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending JSObject) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModules8JSObjectC_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModules8JSObjectC_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModules8JSObjectC_y")
public func _invoke_swift_closure_TestModule_10TestModules8JSObjectC_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending JSObject) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(JSObject.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModulesSS_y")
fileprivate func invoke_js_callback_TestModule_10TestModulesSS_y_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModulesSS_y_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModulesSS_y(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModulesSS_y_extern(callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModulesSS_y")
fileprivate func make_swift_closure_TestModule_10TestModulesSS_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModulesSS_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModulesSS_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModulesSS_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModulesSS_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending String) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                invoke_js_callback_TestModule_10TestModulesSS_y(callbackValue, param0Bytes, param0Length)
            }
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending String) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending String) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModulesSS_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModulesSS_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModulesSS_y")
public func _invoke_swift_closure_TestModule_10TestModulesSS_y(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending String) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModulesSb_y")
fileprivate func invoke_js_callback_TestModule_10TestModulesSb_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModulesSb_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModulesSb_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModulesSb_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModulesSb_y")
fileprivate func make_swift_closure_TestModule_10TestModulesSb_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModulesSb_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModulesSb_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModulesSb_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModulesSb_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending Bool) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModulesSb_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending Bool) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending Bool) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModulesSb_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModulesSb_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModulesSb_y")
public func _invoke_swift_closure_TestModule_10TestModulesSb_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending Bool) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(Bool.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModulesSd_y")
fileprivate func invoke_js_callback_TestModule_10TestModulesSd_y_extern(_ callback: Int32, _ param0: Float64) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModulesSd_y_extern(_ callback: Int32, _ param0: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModulesSd_y(_ callback: Int32, _ param0: Float64) -> Void {
    return invoke_js_callback_TestModule_10TestModulesSd_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModulesSd_y")
fileprivate func make_swift_closure_TestModule_10TestModulesSd_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModulesSd_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModulesSd_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModulesSd_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModulesSd_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending Double) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModulesSd_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending Double) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending Double) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModulesSd_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModulesSd_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModulesSd_y")
public func _invoke_swift_closure_TestModule_10TestModulesSd_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Float64) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending Double) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(Double.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModulesSi_y")
fileprivate func invoke_js_callback_TestModule_10TestModulesSi_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModulesSi_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModulesSi_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModulesSi_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModulesSi_y")
fileprivate func make_swift_closure_TestModule_10TestModulesSi_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModulesSi_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModulesSi_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModulesSi_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModulesSi_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending Int) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModulesSi_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending Int) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending Int) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModulesSi_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModulesSi_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModulesSi_y")
public func _invoke_swift_closure_TestModule_10TestModulesSi_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending Int) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(Int.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

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

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncReturnVoid")
fileprivate func bjs_asyncReturnVoid_extern(_ resolveRef: Int32, _ rejectRef: Int32) -> Void
#else
fileprivate func bjs_asyncReturnVoid_extern(_ resolveRef: Int32, _ rejectRef: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncReturnVoid(_ resolveRef: Int32, _ rejectRef: Int32) -> Void {
    return bjs_asyncReturnVoid_extern(resolveRef, rejectRef)
}

func _$asyncReturnVoid() async throws(JSException) -> Void {
    try await _bjs_awaitPromise(makeResolveClosure: {
            JSTypedClosure<() -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(sending JSValue) -> Void>($0)
        }) { resolveRef, rejectRef in
        bjs_asyncReturnVoid(resolveRef, rejectRef)
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripInt")
fileprivate func bjs_asyncRoundTripInt_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Int32) -> Void
#else
fileprivate func bjs_asyncRoundTripInt_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripInt(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Int32) -> Void {
    return bjs_asyncRoundTripInt_extern(resolveRef, rejectRef, v)
}

func _$asyncRoundTripInt(_ v: Int) async throws(JSException) -> Int {
    let resolved = try await _bjs_awaitPromise(makeResolveClosure: {
            JSTypedClosure<(sending Int) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(sending JSValue) -> Void>($0)
        }) { resolveRef, rejectRef in
        let vValue = v.bridgeJSLowerParameter()
        bjs_asyncRoundTripInt(resolveRef, rejectRef, vValue)
    }
    return resolved
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripString")
fileprivate func bjs_asyncRoundTripString_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void
#else
fileprivate func bjs_asyncRoundTripString_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripString(_ resolveRef: Int32, _ rejectRef: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void {
    return bjs_asyncRoundTripString_extern(resolveRef, rejectRef, vBytes, vLength)
}

func _$asyncRoundTripString(_ v: String) async throws(JSException) -> String {
    let resolved = try await _bjs_awaitPromise(makeResolveClosure: {
            JSTypedClosure<(sending String) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(sending JSValue) -> Void>($0)
        }) { resolveRef, rejectRef in
        v.bridgeJSWithLoweredParameter { (vBytes, vLength) in
            bjs_asyncRoundTripString(resolveRef, rejectRef, vBytes, vLength)
        }
    }
    return resolved
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripBool")
fileprivate func bjs_asyncRoundTripBool_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Int32) -> Void
#else
fileprivate func bjs_asyncRoundTripBool_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripBool(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Int32) -> Void {
    return bjs_asyncRoundTripBool_extern(resolveRef, rejectRef, v)
}

func _$asyncRoundTripBool(_ v: Bool) async throws(JSException) -> Bool {
    let resolved = try await _bjs_awaitPromise(makeResolveClosure: {
            JSTypedClosure<(sending Bool) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(sending JSValue) -> Void>($0)
        }) { resolveRef, rejectRef in
        let vValue = v.bridgeJSLowerParameter()
        bjs_asyncRoundTripBool(resolveRef, rejectRef, vValue)
    }
    return resolved
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripDouble")
fileprivate func bjs_asyncRoundTripDouble_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Float64) -> Void
#else
fileprivate func bjs_asyncRoundTripDouble_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripDouble(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Float64) -> Void {
    return bjs_asyncRoundTripDouble_extern(resolveRef, rejectRef, v)
}

func _$asyncRoundTripDouble(_ v: Double) async throws(JSException) -> Double {
    let resolved = try await _bjs_awaitPromise(makeResolveClosure: {
            JSTypedClosure<(sending Double) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(sending JSValue) -> Void>($0)
        }) { resolveRef, rejectRef in
        let vValue = v.bridgeJSLowerParameter()
        bjs_asyncRoundTripDouble(resolveRef, rejectRef, vValue)
    }
    return resolved
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripJSObject")
fileprivate func bjs_asyncRoundTripJSObject_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Int32) -> Void
#else
fileprivate func bjs_asyncRoundTripJSObject_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripJSObject(_ resolveRef: Int32, _ rejectRef: Int32, _ v: Int32) -> Void {
    return bjs_asyncRoundTripJSObject_extern(resolveRef, rejectRef, v)
}

func _$asyncRoundTripJSObject(_ v: JSObject) async throws(JSException) -> JSObject {
    let resolved = try await _bjs_awaitPromise(makeResolveClosure: {
            JSTypedClosure<(sending JSObject) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(sending JSValue) -> Void>($0)
        }) { resolveRef, rejectRef in
        let vValue = v.bridgeJSLowerParameter()
        bjs_asyncRoundTripJSObject(resolveRef, rejectRef, vValue)
    }
    return resolved
}