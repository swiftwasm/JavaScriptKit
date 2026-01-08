// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_ClassA_linkedB_get")
@_cdecl("bjs_ClassA_linkedB_get")
public func _bjs_ClassA_linkedB_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ClassA.bridgeJSLiftParameter(_self).linkedB
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassA_linkedB_set")
@_cdecl("bjs_ClassA_linkedB_set")
public func _bjs_ClassA_linkedB_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    ClassA.bridgeJSLiftParameter(_self).linkedB = Optional<ClassB>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassA_deinit")
@_cdecl("bjs_ClassA_deinit")
public func _bjs_ClassA_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<ClassA>.fromOpaque(pointer).release()
}

extension ClassA: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ClassA_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ClassA_wrap")
fileprivate func _bjs_ClassA_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ClassA_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_ClassB_init")
@_cdecl("bjs_ClassB_init")
public func _bjs_ClassB_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ClassB()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassB_deinit")
@_cdecl("bjs_ClassB_deinit")
public func _bjs_ClassB_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<ClassB>.fromOpaque(pointer).release()
}

extension ClassB: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ClassB_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ClassB_wrap")
fileprivate func _bjs_ClassB_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ClassB_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif