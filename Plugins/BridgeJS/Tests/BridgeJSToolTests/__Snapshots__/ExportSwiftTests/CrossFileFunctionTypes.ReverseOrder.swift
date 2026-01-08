// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_standaloneFunction")
@_cdecl("bjs_standaloneFunction")
public func _bjs_standaloneFunction(b: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = standaloneFunction(b: FunctionB.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionA_init")
@_cdecl("bjs_FunctionA_init")
public func _bjs_FunctionA_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = FunctionA()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionA_processB")
@_cdecl("bjs_FunctionA_processB")
public func _bjs_FunctionA_processB(_self: UnsafeMutableRawPointer, b: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = FunctionA.bridgeJSLiftParameter(_self).processB(b: FunctionB.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionA_createB")
@_cdecl("bjs_FunctionA_createB")
public func _bjs_FunctionA_createB(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = FunctionA.bridgeJSLiftParameter(_self).createB(value: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionA_deinit")
@_cdecl("bjs_FunctionA_deinit")
public func _bjs_FunctionA_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<FunctionA>.fromOpaque(pointer).release()
}

extension FunctionA: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_FunctionA_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_FunctionA_wrap")
fileprivate func _bjs_FunctionA_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_FunctionA_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_FunctionB_init")
@_cdecl("bjs_FunctionB_init")
public func _bjs_FunctionB_init(valueBytes: Int32, valueLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = FunctionB(value: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionB_value_get")
@_cdecl("bjs_FunctionB_value_get")
public func _bjs_FunctionB_value_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = FunctionB.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionB_value_set")
@_cdecl("bjs_FunctionB_value_set")
public func _bjs_FunctionB_value_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    FunctionB.bridgeJSLiftParameter(_self).value = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionB_deinit")
@_cdecl("bjs_FunctionB_deinit")
public func _bjs_FunctionB_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<FunctionB>.fromOpaque(pointer).release()
}

extension FunctionB: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_FunctionB_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_FunctionB_wrap")
fileprivate func _bjs_FunctionB_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_FunctionB_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif