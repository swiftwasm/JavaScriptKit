// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_PlayBridgeJS_init")
@_cdecl("bjs_PlayBridgeJS_init")
public func _bjs_PlayBridgeJS_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PlayBridgeJS()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJS_update")
@_cdecl("bjs_PlayBridgeJS_update")
public func _bjs_PlayBridgeJS_update(_self: UnsafeMutableRawPointer, swiftSourceBytes: Int32, swiftSourceLength: Int32, dtsSourceBytes: Int32, dtsSourceLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    do {
        let ret = try PlayBridgeJS.bridgeJSLiftParameter(_self).update(swiftSource: String.bridgeJSLiftParameter(swiftSourceBytes, swiftSourceLength), dtsSource: String.bridgeJSLiftParameter(dtsSourceBytes, dtsSourceLength))
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return UnsafeMutableRawPointer(bitPattern: -1).unsafelyUnwrapped
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJS_deinit")
@_cdecl("bjs_PlayBridgeJS_deinit")
public func _bjs_PlayBridgeJS_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PlayBridgeJS>.fromOpaque(pointer).release()
}

extension PlayBridgeJS: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PlayBridgeJS_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "PlayBridgeJS", name: "bjs_PlayBridgeJS_wrap")
fileprivate func _bjs_PlayBridgeJS_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PlayBridgeJS_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_PlayBridgeJSOutput_outputJs")
@_cdecl("bjs_PlayBridgeJSOutput_outputJs")
public func _bjs_PlayBridgeJSOutput_outputJs(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PlayBridgeJSOutput.bridgeJSLiftParameter(_self).outputJs()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_outputDts")
@_cdecl("bjs_PlayBridgeJSOutput_outputDts")
public func _bjs_PlayBridgeJSOutput_outputDts(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PlayBridgeJSOutput.bridgeJSLiftParameter(_self).outputDts()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_importSwiftGlue")
@_cdecl("bjs_PlayBridgeJSOutput_importSwiftGlue")
public func _bjs_PlayBridgeJSOutput_importSwiftGlue(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PlayBridgeJSOutput.bridgeJSLiftParameter(_self).importSwiftGlue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_exportSwiftGlue")
@_cdecl("bjs_PlayBridgeJSOutput_exportSwiftGlue")
public func _bjs_PlayBridgeJSOutput_exportSwiftGlue(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PlayBridgeJSOutput.bridgeJSLiftParameter(_self).exportSwiftGlue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_deinit")
@_cdecl("bjs_PlayBridgeJSOutput_deinit")
public func _bjs_PlayBridgeJSOutput_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PlayBridgeJSOutput>.fromOpaque(pointer).release()
}

extension PlayBridgeJSOutput: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PlayBridgeJSOutput_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "PlayBridgeJS", name: "bjs_PlayBridgeJSOutput_wrap")
fileprivate func _bjs_PlayBridgeJSOutput_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PlayBridgeJSOutput_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif