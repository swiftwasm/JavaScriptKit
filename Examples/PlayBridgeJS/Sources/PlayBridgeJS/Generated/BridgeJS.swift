// bridge-js: skip
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
public func _bjs_PlayBridgeJS_update(_ _self: UnsafeMutableRawPointer, _ swiftSourceBytes: Int32, _ swiftSourceLength: Int32, _ dtsSourceBytes: Int32, _ dtsSourceLength: Int32) -> UnsafeMutableRawPointer {
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
public func _bjs_PlayBridgeJS_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PlayBridgeJS>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PlayBridgeJS: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PlayBridgeJS_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "PlayBridgeJS", name: "bjs_PlayBridgeJS_wrap")
fileprivate func _bjs_PlayBridgeJS_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PlayBridgeJS_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_PlayBridgeJSOutput_outputJs")
@_cdecl("bjs_PlayBridgeJSOutput_outputJs")
public func _bjs_PlayBridgeJSOutput_outputJs(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PlayBridgeJSOutput.bridgeJSLiftParameter(_self).outputJs()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_outputDts")
@_cdecl("bjs_PlayBridgeJSOutput_outputDts")
public func _bjs_PlayBridgeJSOutput_outputDts(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PlayBridgeJSOutput.bridgeJSLiftParameter(_self).outputDts()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_importSwiftGlue")
@_cdecl("bjs_PlayBridgeJSOutput_importSwiftGlue")
public func _bjs_PlayBridgeJSOutput_importSwiftGlue(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PlayBridgeJSOutput.bridgeJSLiftParameter(_self).importSwiftGlue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_exportSwiftGlue")
@_cdecl("bjs_PlayBridgeJSOutput_exportSwiftGlue")
public func _bjs_PlayBridgeJSOutput_exportSwiftGlue(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PlayBridgeJSOutput.bridgeJSLiftParameter(_self).exportSwiftGlue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_deinit")
@_cdecl("bjs_PlayBridgeJSOutput_deinit")
public func _bjs_PlayBridgeJSOutput_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PlayBridgeJSOutput>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PlayBridgeJSOutput: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PlayBridgeJSOutput_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "PlayBridgeJS", name: "bjs_PlayBridgeJSOutput_wrap")
fileprivate func _bjs_PlayBridgeJSOutput_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PlayBridgeJSOutput_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "PlayBridgeJS", name: "bjs_createTS2Swift")
fileprivate func bjs_createTS2Swift() -> Int32
#else
fileprivate func bjs_createTS2Swift() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$createTS2Swift() throws(JSException) -> TS2Swift {
    let ret = bjs_createTS2Swift()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return TS2Swift.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "PlayBridgeJS", name: "bjs_TS2Swift_convert")
fileprivate func bjs_TS2Swift_convert(_ self: Int32, _ ts: Int32) -> Int32
#else
fileprivate func bjs_TS2Swift_convert(_ self: Int32, _ ts: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$TS2Swift_convert(_ self: JSObject, _ ts: String) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let tsValue = ts.bridgeJSLowerParameter()
    let ret = bjs_TS2Swift_convert(selfValue, tsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}