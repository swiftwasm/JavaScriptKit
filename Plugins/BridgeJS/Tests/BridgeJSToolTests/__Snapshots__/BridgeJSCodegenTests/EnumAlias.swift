@_expose(wasm, "bjs_roundtripColor")
@_cdecl("bjs_roundtripColor")
public func _bjs_roundtripColor(_ color: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundtripColor(_: Color.bridgeFromJS(ColorBox.bridgeJSLiftParameter(color)))
    return ret.bridgeToJS().bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ColorBox_init")
@_cdecl("bjs_ColorBox_init")
public func _bjs_ColorBox_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ColorBox(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ColorBox_deinit")
@_cdecl("bjs_ColorBox_deinit")
public func _bjs_ColorBox_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ColorBox>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ColorBox: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ColorBox_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_ColorBox_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ColorBox_wrap")
fileprivate func _bjs_ColorBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ColorBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_ColorBox_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_ColorBox_wrap_extern(pointer)
}