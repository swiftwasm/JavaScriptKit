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
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJS_update")
@_cdecl("bjs_PlayBridgeJS_update")
public func _bjs_PlayBridgeJS_update(_self: UnsafeMutableRawPointer, swiftSourceBytes: Int32, swiftSourceLen: Int32, dtsSourceBytes: Int32, dtsSourceLen: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    do {
        let swiftSource = String(unsafeUninitializedCapacity: Int(swiftSourceLen)) { b in
            _swift_js_init_memory(swiftSourceBytes, b.baseAddress.unsafelyUnwrapped)
            return Int(swiftSourceLen)
        }
        let dtsSource = String(unsafeUninitializedCapacity: Int(dtsSourceLen)) { b in
            _swift_js_init_memory(dtsSourceBytes, b.baseAddress.unsafelyUnwrapped)
            return Int(dtsSourceLen)
        }
        let ret = try Unmanaged<PlayBridgeJS>.fromOpaque(_self).takeUnretainedValue().update(swiftSource: swiftSource, dtsSource: dtsSource)
        return Unmanaged.passRetained(ret).toOpaque()
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

extension PlayBridgeJS: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "PlayBridgeJS", name: "bjs_PlayBridgeJS_wrap")
        func _bjs_PlayBridgeJS_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PlayBridgeJS_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_outputJs")
@_cdecl("bjs_PlayBridgeJSOutput_outputJs")
public func _bjs_PlayBridgeJSOutput_outputJs(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<PlayBridgeJSOutput>.fromOpaque(_self).takeUnretainedValue().outputJs()
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_outputDts")
@_cdecl("bjs_PlayBridgeJSOutput_outputDts")
public func _bjs_PlayBridgeJSOutput_outputDts(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<PlayBridgeJSOutput>.fromOpaque(_self).takeUnretainedValue().outputDts()
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_importSwiftGlue")
@_cdecl("bjs_PlayBridgeJSOutput_importSwiftGlue")
public func _bjs_PlayBridgeJSOutput_importSwiftGlue(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<PlayBridgeJSOutput>.fromOpaque(_self).takeUnretainedValue().importSwiftGlue()
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_exportSwiftGlue")
@_cdecl("bjs_PlayBridgeJSOutput_exportSwiftGlue")
public func _bjs_PlayBridgeJSOutput_exportSwiftGlue(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<PlayBridgeJSOutput>.fromOpaque(_self).takeUnretainedValue().exportSwiftGlue()
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PlayBridgeJSOutput_deinit")
@_cdecl("bjs_PlayBridgeJSOutput_deinit")
public func _bjs_PlayBridgeJSOutput_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PlayBridgeJSOutput>.fromOpaque(pointer).release()
}

extension PlayBridgeJSOutput: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "PlayBridgeJS", name: "bjs_PlayBridgeJSOutput_wrap")
        func _bjs_PlayBridgeJSOutput_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PlayBridgeJSOutput_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}