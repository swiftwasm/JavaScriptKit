// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_standaloneFunction")
@_cdecl("bjs_standaloneFunction")
public func _bjs_standaloneFunction(_ b: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = standaloneFunction(b: FunctionB.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionB_init")
@_cdecl("bjs_FunctionB_init")
public func _bjs_FunctionB_init(_ valueBytes: Int32, _ valueLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = FunctionB(value: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionB_value_get")
@_cdecl("bjs_FunctionB_value_get")
public func _bjs_FunctionB_value_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = FunctionB.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionB_value_set")
@_cdecl("bjs_FunctionB_value_set")
public func _bjs_FunctionB_value_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    FunctionB.bridgeJSLiftParameter(_self).value = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionB_deinit")
@_cdecl("bjs_FunctionB_deinit")
public func _bjs_FunctionB_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<FunctionB>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension FunctionB: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_FunctionB_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_FunctionB_wrap")
fileprivate func _bjs_FunctionB_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_FunctionB_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
public func _bjs_FunctionA_processB(_ _self: UnsafeMutableRawPointer, _ b: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = FunctionA.bridgeJSLiftParameter(_self).processB(b: FunctionB.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionA_createB")
@_cdecl("bjs_FunctionA_createB")
public func _bjs_FunctionA_createB(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = FunctionA.bridgeJSLiftParameter(_self).createB(value: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_FunctionA_deinit")
@_cdecl("bjs_FunctionA_deinit")
public func _bjs_FunctionA_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<FunctionA>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension FunctionA: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_FunctionA_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_FunctionA_wrap")
fileprivate func _bjs_FunctionA_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_FunctionA_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif