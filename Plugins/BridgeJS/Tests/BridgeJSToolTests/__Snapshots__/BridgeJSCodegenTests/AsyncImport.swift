#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule7JSValueV_y")
fileprivate func invoke_js_callback_TestModule_10TestModule7JSValueV_y_extern(_ callback: Int32, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModule7JSValueV_y_extern(_ callback: Int32, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule7JSValueV_y(_ callback: Int32, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void {
    return invoke_js_callback_TestModule_10TestModule7JSValueV_y_extern(callback, param0Kind, param0Payload1, param0Payload2)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule7JSValueV_y")
fileprivate func make_swift_closure_TestModule_10TestModule7JSValueV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule7JSValueV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule7JSValueV_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule7JSValueV_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule7JSValueV_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (JSValue) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0Kind, param0Payload1, param0Payload2) = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModule7JSValueV_y(callbackValue, param0Kind, param0Payload1, param0Payload2)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (JSValue) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (JSValue) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule7JSValueV_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule7JSValueV_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModule7JSValueV_y")
public func _invoke_swift_closure_TestModule_10TestModule7JSValueV_y(_ boxPtr: UnsafeMutableRawPointer, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(JSValue) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(JSValue.bridgeJSLiftParameter(param0Kind, param0Payload1, param0Payload2))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule8JSObjectC_y")
fileprivate func invoke_js_callback_TestModule_10TestModule8JSObjectC_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModule8JSObjectC_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule8JSObjectC_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModule8JSObjectC_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule8JSObjectC_y")
fileprivate func make_swift_closure_TestModule_10TestModule8JSObjectC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule8JSObjectC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule8JSObjectC_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule8JSObjectC_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule8JSObjectC_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (JSObject) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModule8JSObjectC_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (JSObject) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (JSObject) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule8JSObjectC_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule8JSObjectC_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModule8JSObjectC_y")
public func _invoke_swift_closure_TestModule_10TestModule8JSObjectC_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(JSObject) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(JSObject.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSS_y")
fileprivate func invoke_js_callback_TestModule_10TestModuleSS_y_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSS_y_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSS_y(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSS_y_extern(callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSS_y")
fileprivate func make_swift_closure_TestModule_10TestModuleSS_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSS_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSS_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSS_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSS_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                invoke_js_callback_TestModule_10TestModuleSS_y(callbackValue, param0Bytes, param0Length)
            }
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (String) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (String) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSS_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSS_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSS_y")
public func _invoke_swift_closure_TestModule_10TestModuleSS_y(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(String) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSb_y")
fileprivate func invoke_js_callback_TestModule_10TestModuleSb_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSb_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSb_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSb_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSb_y")
fileprivate func make_swift_closure_TestModule_10TestModuleSb_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSb_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSb_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSb_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSb_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (Bool) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSb_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Bool) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Bool) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSb_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSb_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSb_y")
public func _invoke_swift_closure_TestModule_10TestModuleSb_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Bool) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(Bool.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSd_y")
fileprivate func invoke_js_callback_TestModule_10TestModuleSd_y_extern(_ callback: Int32, _ param0: Float64) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSd_y_extern(_ callback: Int32, _ param0: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSd_y(_ callback: Int32, _ param0: Float64) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSd_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSd_y")
fileprivate func make_swift_closure_TestModule_10TestModuleSd_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSd_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSd_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSd_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSd_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (Double) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSd_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Double) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Double) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSd_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSd_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSd_y")
public func _invoke_swift_closure_TestModule_10TestModuleSd_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Float64) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Double) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(Double.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSi_y")
fileprivate func invoke_js_callback_TestModule_10TestModuleSi_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSi_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSi_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSi_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSi_y")
fileprivate func make_swift_closure_TestModule_10TestModuleSi_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSi_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSi_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSi_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSi_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (Int) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSi_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Int) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Int) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSi_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSi_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSi_y")
public func _invoke_swift_closure_TestModule_10TestModuleSi_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Int) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
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
            JSTypedClosure<(JSValue) -> Void>($0)
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
            JSTypedClosure<(Int) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(JSValue) -> Void>($0)
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
            JSTypedClosure<(String) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(JSValue) -> Void>($0)
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
            JSTypedClosure<(Bool) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(JSValue) -> Void>($0)
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
            JSTypedClosure<(Double) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(JSValue) -> Void>($0)
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
            JSTypedClosure<(JSObject) -> Void>($0)
        }, makeRejectClosure: {
            JSTypedClosure<(JSValue) -> Void>($0)
        }) { resolveRef, rejectRef in
        let vValue = v.bridgeJSLowerParameter()
        bjs_asyncRoundTripJSObject(resolveRef, rejectRef, vValue)
    }
    return resolved
}