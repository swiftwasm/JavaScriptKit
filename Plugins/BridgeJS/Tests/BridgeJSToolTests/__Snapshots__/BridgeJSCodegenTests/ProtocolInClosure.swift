#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule10RenderableP_10RenderableP")
fileprivate func invoke_js_callback_TestModule_10TestModule10RenderableP_10RenderableP_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule10RenderableP_10RenderableP_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule10RenderableP_10RenderableP(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModule10RenderableP_10RenderableP_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP")
fileprivate func make_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule10RenderableP_10RenderableP {
    static func bridgeJSLift(_ callbackId: Int32) -> (any Renderable) -> any Renderable {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0ObjectId = (param0 as! _BridgedSwiftProtocolExportable).bridgeJSLowerAsProtocolReturn()
            let ret = invoke_js_callback_TestModule_10TestModule10RenderableP_10RenderableP(callbackValue, param0ObjectId)
            return AnyRenderable.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (any Renderable) -> any Renderable {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (any Renderable) -> any Renderable) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP")
@_cdecl("invoke_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP")
public func _invoke_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(any Renderable) -> any Renderable>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(AnyRenderable.bridgeJSLiftParameter(param0))
    return (result as! _BridgedSwiftProtocolExportable).bridgeJSLowerAsProtocolReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule10RenderableP_SS")
fileprivate func invoke_js_callback_TestModule_10TestModule10RenderableP_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule10RenderableP_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule10RenderableP_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModule10RenderableP_SS_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule10RenderableP_SS")
fileprivate func make_swift_closure_TestModule_10TestModule10RenderableP_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule10RenderableP_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule10RenderableP_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule10RenderableP_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule10RenderableP_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (any Renderable) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0ObjectId = (param0 as! _BridgedSwiftProtocolExportable).bridgeJSLowerAsProtocolReturn()
            let ret = invoke_js_callback_TestModule_10TestModule10RenderableP_SS(callbackValue, param0ObjectId)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (any Renderable) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (any Renderable) -> String) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule10RenderableP_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule10RenderableP_SS")
@_cdecl("invoke_swift_closure_TestModule_10TestModule10RenderableP_SS")
public func _invoke_swift_closure_TestModule_10TestModule10RenderableP_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(any Renderable) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(AnyRenderable.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSq10RenderableP_SS")
fileprivate func invoke_js_callback_TestModule_10TestModuleSq10RenderableP_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0ObjectId: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq10RenderableP_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0ObjectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSq10RenderableP_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0ObjectId: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSq10RenderableP_SS_extern(callback, param0IsSome, param0ObjectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq10RenderableP_SS")
fileprivate func make_swift_closure_TestModule_10TestModuleSq10RenderableP_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq10RenderableP_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSq10RenderableP_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSq10RenderableP_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSq10RenderableP_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<any Renderable>) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0ObjectId): (Int32, Int32)
            if let param0 {
                (param0IsSome, param0ObjectId) = (1, (param0 as! _BridgedSwiftProtocolExportable).bridgeJSLowerAsProtocolReturn())
            } else {
                (param0IsSome, param0ObjectId) = (0, 0)
            }
            let ret = invoke_js_callback_TestModule_10TestModuleSq10RenderableP_SS(callbackValue, param0IsSome, param0ObjectId)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<any Renderable>) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<any Renderable>) -> String) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSq10RenderableP_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSq10RenderableP_SS")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSq10RenderableP_SS")
public func _invoke_swift_closure_TestModule_10TestModuleSq10RenderableP_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<any Renderable>) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<AnyRenderable>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuley_10RenderableP")
fileprivate func invoke_js_callback_TestModule_10TestModuley_10RenderableP_extern(_ callback: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuley_10RenderableP_extern(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuley_10RenderableP(_ callback: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuley_10RenderableP_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuley_10RenderableP")
fileprivate func make_swift_closure_TestModule_10TestModuley_10RenderableP_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuley_10RenderableP_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuley_10RenderableP(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuley_10RenderableP_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuley_10RenderableP {
    static func bridgeJSLift(_ callbackId: Int32) -> () -> any Renderable {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuley_10RenderableP(callbackValue)
            return AnyRenderable.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == () -> any Renderable {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping () -> any Renderable) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuley_10RenderableP,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuley_10RenderableP")
@_cdecl("invoke_swift_closure_TestModule_10TestModuley_10RenderableP")
public func _invoke_swift_closure_TestModule_10TestModuley_10RenderableP(_ boxPtr: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<() -> any Renderable>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure()
    return (result as! _BridgedSwiftProtocolExportable).bridgeJSLowerAsProtocolReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

struct AnyRenderable: Renderable, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    func render() -> String {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_render(jsObjectValue)
        return String.bridgeJSLiftReturn(ret)
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyRenderable(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Renderable_render")
fileprivate func _extern_render_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func _extern_render_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_render(_ jsObject: Int32) -> Int32 {
    return _extern_render_extern(jsObject)
}

@_expose(wasm, "bjs_processRenderable")
@_cdecl("bjs_processRenderable")
public func _bjs_processRenderable(_ item: Int32, _ transform: Int32) -> Void {
    #if arch(wasm32)
    let ret = processRenderable(_: AnyRenderable.bridgeJSLiftParameter(item), transform: _BJS_Closure_10TestModule10RenderableP_SS.bridgeJSLift(transform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeRenderableFactory")
@_cdecl("bjs_makeRenderableFactory")
public func _bjs_makeRenderableFactory(_ defaultNameBytes: Int32, _ defaultNameLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = makeRenderableFactory(defaultName: String.bridgeJSLiftParameter(defaultNameBytes, defaultNameLength))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripRenderable")
@_cdecl("bjs_roundtripRenderable")
public func _bjs_roundtripRenderable(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripRenderable(_: _BJS_Closure_10TestModule10RenderableP_10RenderableP.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOptionalRenderable")
@_cdecl("bjs_processOptionalRenderable")
public func _bjs_processOptionalRenderable(_ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = processOptionalRenderable(_: _BJS_Closure_10TestModuleSq10RenderableP_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Widget_init")
@_cdecl("bjs_Widget_init")
public func _bjs_Widget_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Widget(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Widget_name_get")
@_cdecl("bjs_Widget_name_get")
public func _bjs_Widget_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Widget.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Widget_name_set")
@_cdecl("bjs_Widget_name_set")
public func _bjs_Widget_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    Widget.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Widget_deinit")
@_cdecl("bjs_Widget_deinit")
public func _bjs_Widget_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Widget>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Widget: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Widget_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Widget_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Widget_wrap")
fileprivate func _bjs_Widget_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Widget_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Widget_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Widget_wrap_extern(pointer)
}