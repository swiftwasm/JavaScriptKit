// bridge-js: skip
// swift-format-ignore-file
// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "WASIShim", name: "bjs_HostConsole_log_static")
fileprivate func bjs_HostConsole_log_static_extern(_ lineWord0: Int32, _ lineWord1: Int32, _ lineWord2: Int32) -> Void
#else
fileprivate func bjs_HostConsole_log_static_extern(_ lineWord0: Int32, _ lineWord1: Int32, _ lineWord2: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HostConsole_log_static(_ lineWord0: Int32, _ lineWord1: Int32, _ lineWord2: Int32) -> Void {
    return bjs_HostConsole_log_static_extern(lineWord0, lineWord1, lineWord2)
}

#if arch(wasm32)
@_extern(wasm, module: "WASIShim", name: "bjs_HostConsole_error_static")
fileprivate func bjs_HostConsole_error_static_extern(_ lineWord0: Int32, _ lineWord1: Int32, _ lineWord2: Int32) -> Void
#else
fileprivate func bjs_HostConsole_error_static_extern(_ lineWord0: Int32, _ lineWord1: Int32, _ lineWord2: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HostConsole_error_static(_ lineWord0: Int32, _ lineWord1: Int32, _ lineWord2: Int32) -> Void {
    return bjs_HostConsole_error_static_extern(lineWord0, lineWord1, lineWord2)
}

func _$HostConsole_log(_ line: String) throws(JSException) -> Void {
    line.bridgeJSWithLoweredParameter { (lineWord0, lineWord1, lineWord2) in
        bjs_HostConsole_log_static(lineWord0, lineWord1, lineWord2)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$HostConsole_error(_ line: String) throws(JSException) -> Void {
    line.bridgeJSWithLoweredParameter { (lineWord0, lineWord1, lineWord2) in
        bjs_HostConsole_error_static(lineWord0, lineWord1, lineWord2)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WASIShim", name: "bjs_HostCrypto_getRandomValues_static")
fileprivate func bjs_HostCrypto_getRandomValues_static_extern(_ array: Int32) -> Void
#else
fileprivate func bjs_HostCrypto_getRandomValues_static_extern(_ array: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HostCrypto_getRandomValues_static(_ array: Int32) -> Void {
    return bjs_HostCrypto_getRandomValues_static_extern(array)
}

func _$HostCrypto_getRandomValues(_ array: HostUint8Array) throws(JSException) -> Void {
    let arrayValue = array.bridgeJSLowerParameter()
    bjs_HostCrypto_getRandomValues_static(arrayValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WASIShim", name: "bjs_HostUint8Array_init")
fileprivate func bjs_HostUint8Array_init_extern(_ length: Int32) -> Int32
#else
fileprivate func bjs_HostUint8Array_init_extern(_ length: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HostUint8Array_init(_ length: Int32) -> Int32 {
    return bjs_HostUint8Array_init_extern(length)
}

func _$HostUint8Array_init(_ length: Int) throws(JSException) -> JSObject {
    let lengthValue = length.bridgeJSLowerParameter()
    let ret = bjs_HostUint8Array_init(lengthValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WASIShim", name: "bjs_HostDate_now_static")
fileprivate func bjs_HostDate_now_static_extern() -> Float64
#else
fileprivate func bjs_HostDate_now_static_extern() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HostDate_now_static() -> Float64 {
    return bjs_HostDate_now_static_extern()
}

func _$HostDate_now() throws(JSException) -> Double {
    let ret = bjs_HostDate_now_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WASIShim", name: "bjs_HostPerformance_now_static")
fileprivate func bjs_HostPerformance_now_static_extern() -> Float64
#else
fileprivate func bjs_HostPerformance_now_static_extern() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HostPerformance_now_static() -> Float64 {
    return bjs_HostPerformance_now_static_extern()
}

func _$HostPerformance_now() throws(JSException) -> Double {
    let ret = bjs_HostPerformance_now_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WASIShim", name: "bjs_HostSharedArrayBuffer_init")
fileprivate func bjs_HostSharedArrayBuffer_init_extern(_ length: Int32) -> Int32
#else
fileprivate func bjs_HostSharedArrayBuffer_init_extern(_ length: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HostSharedArrayBuffer_init(_ length: Int32) -> Int32 {
    return bjs_HostSharedArrayBuffer_init_extern(length)
}

func _$HostSharedArrayBuffer_init(_ length: Int) throws(JSException) -> JSObject {
    let lengthValue = length.bridgeJSLowerParameter()
    let ret = bjs_HostSharedArrayBuffer_init(lengthValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WASIShim", name: "bjs_HostInt32Array_init")
fileprivate func bjs_HostInt32Array_init_extern(_ buffer: Int32) -> Int32
#else
fileprivate func bjs_HostInt32Array_init_extern(_ buffer: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HostInt32Array_init(_ buffer: Int32) -> Int32 {
    return bjs_HostInt32Array_init_extern(buffer)
}

func _$HostInt32Array_init(_ buffer: HostSharedArrayBuffer) throws(JSException) -> JSObject {
    let bufferValue = buffer.bridgeJSLowerParameter()
    let ret = bjs_HostInt32Array_init(bufferValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WASIShim", name: "bjs_HostAtomics_wait_static")
fileprivate func bjs_HostAtomics_wait_static_extern(_ array: Int32, _ index: Int32, _ value: Int32, _ timeout: Float64) -> Void
#else
fileprivate func bjs_HostAtomics_wait_static_extern(_ array: Int32, _ index: Int32, _ value: Int32, _ timeout: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HostAtomics_wait_static(_ array: Int32, _ index: Int32, _ value: Int32, _ timeout: Float64) -> Void {
    return bjs_HostAtomics_wait_static_extern(array, index, value, timeout)
}

func _$HostAtomics_wait(_ array: HostInt32Array, _ index: Int, _ value: Int, _ timeout: Double) throws(JSException) -> Void {
    let timeoutValue = timeout.bridgeJSLowerParameter()
    let valueValue = value.bridgeJSLowerParameter()
    let indexValue = index.bridgeJSLowerParameter()
    let arrayValue = array.bridgeJSLowerParameter()
    bjs_HostAtomics_wait_static(arrayValue, indexValue, valueValue, timeoutValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}