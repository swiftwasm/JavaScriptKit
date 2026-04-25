#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule13JSPublicEventC_y")
fileprivate func invoke_js_callback_TestModule_10TestModule13JSPublicEventC_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModule13JSPublicEventC_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule13JSPublicEventC_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModule13JSPublicEventC_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule13JSPublicEventC_y")
fileprivate func make_swift_closure_TestModule_10TestModule13JSPublicEventC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule13JSPublicEventC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule13JSPublicEventC_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule13JSPublicEventC_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule13JSPublicEventC_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (JSPublicEvent) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModule13JSPublicEventC_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (JSPublicEvent) -> Void {
    public init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (JSPublicEvent) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule13JSPublicEventC_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule13JSPublicEventC_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModule13JSPublicEventC_y")
public func _invoke_swift_closure_TestModule_10TestModule13JSPublicEventC_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(JSPublicEvent) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(JSPublicEvent.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule14JSPackageEventC_y")
fileprivate func invoke_js_callback_TestModule_10TestModule14JSPackageEventC_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModule14JSPackageEventC_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule14JSPackageEventC_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModule14JSPackageEventC_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule14JSPackageEventC_y")
fileprivate func make_swift_closure_TestModule_10TestModule14JSPackageEventC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule14JSPackageEventC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule14JSPackageEventC_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule14JSPackageEventC_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule14JSPackageEventC_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (JSPackageEvent) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModule14JSPackageEventC_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (JSPackageEvent) -> Void {
    package init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (JSPackageEvent) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule14JSPackageEventC_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule14JSPackageEventC_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModule14JSPackageEventC_y")
public func _invoke_swift_closure_TestModule_10TestModule14JSPackageEventC_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(JSPackageEvent) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(JSPackageEvent.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule15JSInternalEventC_y")
fileprivate func invoke_js_callback_TestModule_10TestModule15JSInternalEventC_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModule15JSInternalEventC_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule15JSInternalEventC_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModule15JSInternalEventC_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule15JSInternalEventC_y")
fileprivate func make_swift_closure_TestModule_10TestModule15JSInternalEventC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule15JSInternalEventC_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule15JSInternalEventC_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule15JSInternalEventC_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule15JSInternalEventC_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (JSInternalEvent) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModule15JSInternalEventC_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (JSInternalEvent) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (JSInternalEvent) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule15JSInternalEventC_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule15JSInternalEventC_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModule15JSInternalEventC_y")
public func _invoke_swift_closure_TestModule_10TestModule15JSInternalEventC_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(JSInternalEvent) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(JSInternalEvent.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_JSPublicTarget_addPublicListener")
fileprivate func bjs_JSPublicTarget_addPublicListener_extern(_ self: Int32, _ handler: Int32) -> Void
#else
fileprivate func bjs_JSPublicTarget_addPublicListener_extern(_ self: Int32, _ handler: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSPublicTarget_addPublicListener(_ self: Int32, _ handler: Int32) -> Void {
    return bjs_JSPublicTarget_addPublicListener_extern(self, handler)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_JSPublicTarget_addInternalListener")
fileprivate func bjs_JSPublicTarget_addInternalListener_extern(_ self: Int32, _ handler: Int32) -> Void
#else
fileprivate func bjs_JSPublicTarget_addInternalListener_extern(_ self: Int32, _ handler: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSPublicTarget_addInternalListener(_ self: Int32, _ handler: Int32) -> Void {
    return bjs_JSPublicTarget_addInternalListener_extern(self, handler)
}

func _$JSPublicTarget_addPublicListener(_ self: JSObject, _ handler: JSTypedClosure<(JSPublicEvent) -> Void>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let handlerFuncRef = handler.bridgeJSLowerParameter()
    bjs_JSPublicTarget_addPublicListener(selfValue, handlerFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$JSPublicTarget_addInternalListener(_ self: JSObject, _ handler: JSTypedClosure<(JSPublicEvent) -> Void>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let handlerFuncRef = handler.bridgeJSLowerParameter()
    bjs_JSPublicTarget_addInternalListener(selfValue, handlerFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_JSPackageTarget_addPackageListener")
fileprivate func bjs_JSPackageTarget_addPackageListener_extern(_ self: Int32, _ handler: Int32) -> Void
#else
fileprivate func bjs_JSPackageTarget_addPackageListener_extern(_ self: Int32, _ handler: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSPackageTarget_addPackageListener(_ self: Int32, _ handler: Int32) -> Void {
    return bjs_JSPackageTarget_addPackageListener_extern(self, handler)
}

func _$JSPackageTarget_addPackageListener(_ self: JSObject, _ handler: JSTypedClosure<(JSPackageEvent) -> Void>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let handlerFuncRef = handler.bridgeJSLowerParameter()
    bjs_JSPackageTarget_addPackageListener(selfValue, handlerFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_JSInternalTarget_addInternalListener")
fileprivate func bjs_JSInternalTarget_addInternalListener_extern(_ self: Int32, _ handler: Int32) -> Void
#else
fileprivate func bjs_JSInternalTarget_addInternalListener_extern(_ self: Int32, _ handler: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSInternalTarget_addInternalListener(_ self: Int32, _ handler: Int32) -> Void {
    return bjs_JSInternalTarget_addInternalListener_extern(self, handler)
}

func _$JSInternalTarget_addInternalListener(_ self: JSObject, _ handler: JSTypedClosure<(JSInternalEvent) -> Void>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let handlerFuncRef = handler.bridgeJSLowerParameter()
    bjs_JSInternalTarget_addInternalListener(selfValue, handlerFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
}