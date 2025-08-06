// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_setTheme")
@_cdecl("bjs_setTheme")
public func _bjs_setTheme(themeBytes: Int32, themeLen: Int32) -> Void {
    #if arch(wasm32)
    let theme = String(unsafeUninitializedCapacity: Int(themeLen)) { b in
        _swift_js_init_memory(themeBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(themeLen)
    }
    setTheme(_: Theme(rawValue: theme)!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTheme")
@_cdecl("bjs_getTheme")
public func _bjs_getTheme() -> Void {
    #if arch(wasm32)
    let ret = getTheme()
    return ret.rawValue.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setFeatureFlag")
@_cdecl("bjs_setFeatureFlag")
public func _bjs_setFeatureFlag(flag: Int32) -> Void {
    #if arch(wasm32)
    setFeatureFlag(_: FeatureFlag(rawValue: flag != 0)!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getFeatureFlag")
@_cdecl("bjs_getFeatureFlag")
public func _bjs_getFeatureFlag() -> Int32 {
    #if arch(wasm32)
    let ret = getFeatureFlag()
    return Int32(ret.rawValue ? 1 : 0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setHttpStatus")
@_cdecl("bjs_setHttpStatus")
public func _bjs_setHttpStatus(status: Int32) -> Void {
    #if arch(wasm32)
    setHttpStatus(_: HttpStatus(rawValue: Int(status))!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getHttpStatus")
@_cdecl("bjs_getHttpStatus")
public func _bjs_getHttpStatus() -> Int32 {
    #if arch(wasm32)
    let ret = getHttpStatus()
    return Int32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setPriority")
@_cdecl("bjs_setPriority")
public func _bjs_setPriority(priority: Int32) -> Void {
    #if arch(wasm32)
    setPriority(_: Priority(rawValue: Int32(priority))!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getPriority")
@_cdecl("bjs_getPriority")
public func _bjs_getPriority() -> Int32 {
    #if arch(wasm32)
    let ret = getPriority()
    return Int32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setFileSize")
@_cdecl("bjs_setFileSize")
public func _bjs_setFileSize(size: Int64) -> Void {
    #if arch(wasm32)
    setFileSize(_: FileSize(rawValue: Int64(size))!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getFileSize")
@_cdecl("bjs_getFileSize")
public func _bjs_getFileSize() -> Int64 {
    #if arch(wasm32)
    let ret = getFileSize()
    return Int64(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setUserId")
@_cdecl("bjs_setUserId")
public func _bjs_setUserId(id: Int32) -> Void {
    #if arch(wasm32)
    setUserId(_: UserId(rawValue: UInt(bitPattern: id))!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getUserId")
@_cdecl("bjs_getUserId")
public func _bjs_getUserId() -> Int32 {
    #if arch(wasm32)
    let ret = getUserId()
    return Int32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTokenId")
@_cdecl("bjs_setTokenId")
public func _bjs_setTokenId(token: Int32) -> Void {
    #if arch(wasm32)
    setTokenId(_: TokenId(rawValue: UInt32(bitPattern: token))!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTokenId")
@_cdecl("bjs_getTokenId")
public func _bjs_getTokenId() -> Int32 {
    #if arch(wasm32)
    let ret = getTokenId()
    return Int32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setSessionId")
@_cdecl("bjs_setSessionId")
public func _bjs_setSessionId(session: Int64) -> Void {
    #if arch(wasm32)
    setSessionId(_: SessionId(rawValue: UInt64(bitPattern: Int64(session)))!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getSessionId")
@_cdecl("bjs_getSessionId")
public func _bjs_getSessionId() -> Int64 {
    #if arch(wasm32)
    let ret = getSessionId()
    return Int64(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setPrecision")
@_cdecl("bjs_setPrecision")
public func _bjs_setPrecision(precision: Float32) -> Void {
    #if arch(wasm32)
    setPrecision(_: Precision(rawValue: Float(precision))!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getPrecision")
@_cdecl("bjs_getPrecision")
public func _bjs_getPrecision() -> Float32 {
    #if arch(wasm32)
    let ret = getPrecision()
    return Float32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setRatio")
@_cdecl("bjs_setRatio")
public func _bjs_setRatio(ratio: Float64) -> Void {
    #if arch(wasm32)
    setRatio(_: Ratio(rawValue: Double(ratio))!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getRatio")
@_cdecl("bjs_getRatio")
public func _bjs_getRatio() -> Float64 {
    #if arch(wasm32)
    let ret = getRatio()
    return Float64(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setFeatureFlag")
@_cdecl("bjs_setFeatureFlag")
public func _bjs_setFeatureFlag(featureFlag: Int32) -> Void {
    #if arch(wasm32)
    setFeatureFlag(_: FeatureFlag(rawValue: featureFlag != 0)!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getFeatureFlag")
@_cdecl("bjs_getFeatureFlag")
public func _bjs_getFeatureFlag() -> Int32 {
    #if arch(wasm32)
    let ret = getFeatureFlag()
    return Int32(ret.rawValue ? 1 : 0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processTheme")
@_cdecl("bjs_processTheme")
public func _bjs_processTheme(themeBytes: Int32, themeLen: Int32) -> Int32 {
    #if arch(wasm32)
    let theme = String(unsafeUninitializedCapacity: Int(themeLen)) { b in
        _swift_js_init_memory(themeBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(themeLen)
    }
    let ret = processTheme(_: Theme(rawValue: theme)!)
    return Int32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_convertPriority")
@_cdecl("bjs_convertPriority")
public func _bjs_convertPriority(status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = convertPriority(_: HttpStatus(rawValue: Int(status))!)
    return Int32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_validateSession")
@_cdecl("bjs_validateSession")
public func _bjs_validateSession(session: Int64) -> Void {
    #if arch(wasm32)
    let ret = validateSession(_: SessionId(rawValue: UInt64(bitPattern: Int64(session)))!)
    return ret.rawValue.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}