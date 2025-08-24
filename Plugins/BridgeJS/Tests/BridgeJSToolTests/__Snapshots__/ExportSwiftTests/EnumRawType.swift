// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

extension Theme: _BridgedSwiftEnumNoPayload {
}

extension TSTheme: _BridgedSwiftEnumNoPayload {
}

extension FeatureFlag: _BridgedSwiftEnumNoPayload {
}

extension HttpStatus: _BridgedSwiftEnumNoPayload {
}

extension TSHttpStatus: _BridgedSwiftEnumNoPayload {
}

extension Priority: _BridgedSwiftEnumNoPayload {
}

extension FileSize: _BridgedSwiftEnumNoPayload {
}

extension UserId: _BridgedSwiftEnumNoPayload {
}

extension TokenId: _BridgedSwiftEnumNoPayload {
}

extension SessionId: _BridgedSwiftEnumNoPayload {
}

extension Precision: _BridgedSwiftEnumNoPayload {
}

extension Ratio: _BridgedSwiftEnumNoPayload {
}

@_expose(wasm, "bjs_setTheme")
@_cdecl("bjs_setTheme")
public func _bjs_setTheme(themeBytes: Int32, themeLength: Int32) -> Void {
    #if arch(wasm32)
    setTheme(_: Theme.bridgeJSLiftParameter(themeBytes, themeLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTheme")
@_cdecl("bjs_getTheme")
public func _bjs_getTheme() -> Void {
    #if arch(wasm32)
    let ret = getTheme()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTSTheme")
@_cdecl("bjs_setTSTheme")
public func _bjs_setTSTheme(themeBytes: Int32, themeLength: Int32) -> Void {
    #if arch(wasm32)
    setTSTheme(_: TSTheme.bridgeJSLiftParameter(themeBytes, themeLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTSTheme")
@_cdecl("bjs_getTSTheme")
public func _bjs_getTSTheme() -> Void {
    #if arch(wasm32)
    let ret = getTSTheme()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setFeatureFlag")
@_cdecl("bjs_setFeatureFlag")
public func _bjs_setFeatureFlag(flag: Int32) -> Void {
    #if arch(wasm32)
    setFeatureFlag(_: FeatureFlag.bridgeJSLiftParameter(flag))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getFeatureFlag")
@_cdecl("bjs_getFeatureFlag")
public func _bjs_getFeatureFlag() -> Int32 {
    #if arch(wasm32)
    let ret = getFeatureFlag()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setHttpStatus")
@_cdecl("bjs_setHttpStatus")
public func _bjs_setHttpStatus(status: Int32) -> Void {
    #if arch(wasm32)
    setHttpStatus(_: HttpStatus.bridgeJSLiftParameter(status))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getHttpStatus")
@_cdecl("bjs_getHttpStatus")
public func _bjs_getHttpStatus() -> Int32 {
    #if arch(wasm32)
    let ret = getHttpStatus()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTSHttpStatus")
@_cdecl("bjs_setTSHttpStatus")
public func _bjs_setTSHttpStatus(status: Int32) -> Void {
    #if arch(wasm32)
    setTSHttpStatus(_: TSHttpStatus.bridgeJSLiftParameter(status))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTSHttpStatus")
@_cdecl("bjs_getTSHttpStatus")
public func _bjs_getTSHttpStatus() -> Int32 {
    #if arch(wasm32)
    let ret = getTSHttpStatus()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setPriority")
@_cdecl("bjs_setPriority")
public func _bjs_setPriority(priority: Int32) -> Void {
    #if arch(wasm32)
    setPriority(_: Priority.bridgeJSLiftParameter(priority))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getPriority")
@_cdecl("bjs_getPriority")
public func _bjs_getPriority() -> Int32 {
    #if arch(wasm32)
    let ret = getPriority()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setFileSize")
@_cdecl("bjs_setFileSize")
public func _bjs_setFileSize(size: Int32) -> Void {
    #if arch(wasm32)
    setFileSize(_: FileSize.bridgeJSLiftParameter(size))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getFileSize")
@_cdecl("bjs_getFileSize")
public func _bjs_getFileSize() -> Int32 {
    #if arch(wasm32)
    let ret = getFileSize()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setUserId")
@_cdecl("bjs_setUserId")
public func _bjs_setUserId(id: Int32) -> Void {
    #if arch(wasm32)
    setUserId(_: UserId.bridgeJSLiftParameter(id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getUserId")
@_cdecl("bjs_getUserId")
public func _bjs_getUserId() -> Int32 {
    #if arch(wasm32)
    let ret = getUserId()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTokenId")
@_cdecl("bjs_setTokenId")
public func _bjs_setTokenId(token: Int32) -> Void {
    #if arch(wasm32)
    setTokenId(_: TokenId.bridgeJSLiftParameter(token))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTokenId")
@_cdecl("bjs_getTokenId")
public func _bjs_getTokenId() -> Int32 {
    #if arch(wasm32)
    let ret = getTokenId()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setSessionId")
@_cdecl("bjs_setSessionId")
public func _bjs_setSessionId(session: Int32) -> Void {
    #if arch(wasm32)
    setSessionId(_: SessionId.bridgeJSLiftParameter(session))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getSessionId")
@_cdecl("bjs_getSessionId")
public func _bjs_getSessionId() -> Int32 {
    #if arch(wasm32)
    let ret = getSessionId()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setPrecision")
@_cdecl("bjs_setPrecision")
public func _bjs_setPrecision(precision: Float32) -> Void {
    #if arch(wasm32)
    setPrecision(_: Precision.bridgeJSLiftParameter(precision))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getPrecision")
@_cdecl("bjs_getPrecision")
public func _bjs_getPrecision() -> Float32 {
    #if arch(wasm32)
    let ret = getPrecision()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setRatio")
@_cdecl("bjs_setRatio")
public func _bjs_setRatio(ratio: Float64) -> Void {
    #if arch(wasm32)
    setRatio(_: Ratio.bridgeJSLiftParameter(ratio))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getRatio")
@_cdecl("bjs_getRatio")
public func _bjs_getRatio() -> Float64 {
    #if arch(wasm32)
    let ret = getRatio()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setFeatureFlag")
@_cdecl("bjs_setFeatureFlag")
public func _bjs_setFeatureFlag(featureFlag: Int32) -> Void {
    #if arch(wasm32)
    setFeatureFlag(_: FeatureFlag.bridgeJSLiftParameter(featureFlag))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getFeatureFlag")
@_cdecl("bjs_getFeatureFlag")
public func _bjs_getFeatureFlag() -> Int32 {
    #if arch(wasm32)
    let ret = getFeatureFlag()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processTheme")
@_cdecl("bjs_processTheme")
public func _bjs_processTheme(themeBytes: Int32, themeLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processTheme(_: Theme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_convertPriority")
@_cdecl("bjs_convertPriority")
public func _bjs_convertPriority(status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = convertPriority(_: HttpStatus.bridgeJSLiftParameter(status))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_validateSession")
@_cdecl("bjs_validateSession")
public func _bjs_validateSession(session: Int32) -> Void {
    #if arch(wasm32)
    let ret = validateSession(_: SessionId.bridgeJSLiftParameter(session))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}