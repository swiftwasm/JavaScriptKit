#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleAl7Polygon_Si")
fileprivate func invoke_js_callback_TestModule_10TestModuleAl7Polygon_Si_extern(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleAl7Polygon_Si_extern(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleAl7Polygon_Si(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleAl7Polygon_Si_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleAl7Polygon_Si")
fileprivate func make_swift_closure_TestModule_10TestModuleAl7Polygon_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleAl7Polygon_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleAl7Polygon_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleAl7Polygon_Si_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleAl7Polygon_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (Polygon) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Pointer = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleAl7Polygon_Si(callbackValue, param0Pointer)
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Polygon) -> Int {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Polygon) -> Int) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleAl7Polygon_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleAl7Polygon_Si")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleAl7Polygon_Si")
public func _invoke_swift_closure_TestModule_10TestModuleAl7Polygon_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Polygon) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Polygon.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuley_Al7Polygon")
fileprivate func invoke_js_callback_TestModule_10TestModuley_Al7Polygon_extern(_ callback: Int32) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_TestModule_10TestModuley_Al7Polygon_extern(_ callback: Int32) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuley_Al7Polygon(_ callback: Int32) -> UnsafeMutableRawPointer {
    return invoke_js_callback_TestModule_10TestModuley_Al7Polygon_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuley_Al7Polygon")
fileprivate func make_swift_closure_TestModule_10TestModuley_Al7Polygon_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuley_Al7Polygon_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuley_Al7Polygon(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuley_Al7Polygon_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuley_Al7Polygon {
    static func bridgeJSLift(_ callbackId: Int32) -> () -> Polygon {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuley_Al7Polygon(callbackValue)
            return Polygon.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == () -> Polygon {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping () -> Polygon) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuley_Al7Polygon,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuley_Al7Polygon")
@_cdecl("invoke_swift_closure_TestModule_10TestModuley_Al7Polygon")
public func _invoke_swift_closure_TestModule_10TestModuley_Al7Polygon(_ boxPtr: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<() -> Polygon>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure()
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makePolygonFactory")
@_cdecl("bjs_makePolygonFactory")
public func _bjs_makePolygonFactory() -> Int32 {
    #if arch(wasm32)
    let ret = makePolygonFactory()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makePolygonInspector")
@_cdecl("bjs_makePolygonInspector")
public func _bjs_makePolygonInspector() -> Int32 {
    #if arch(wasm32)
    let ret = makePolygonInspector()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PolygonReference_init")
@_cdecl("bjs_PolygonReference_init")
public func _bjs_PolygonReference_init(_ sides: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PolygonReference(sides: Int.bridgeJSLiftParameter(sides))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PolygonReference_deinit")
@_cdecl("bjs_PolygonReference_deinit")
public func _bjs_PolygonReference_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PolygonReference>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PolygonReference: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PolygonReference_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_PolygonReference_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PolygonReference_wrap")
fileprivate func _bjs_PolygonReference_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PolygonReference_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_PolygonReference_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_PolygonReference_wrap_extern(pointer)
}

extension Polygon: _BridgedSwiftAlias, _BridgedSwiftStackType {}