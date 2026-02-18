// bridge-js: skip
// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

extension PlayBridgeJSOutput: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> PlayBridgeJSOutput {
        let swiftGlue = String.bridgeJSStackPop()
        let importSwiftMacroDecls = String.bridgeJSStackPop()
        let outputDts = String.bridgeJSStackPop()
        let outputJs = String.bridgeJSStackPop()
        return PlayBridgeJSOutput(outputJs: outputJs, outputDts: outputDts, importSwiftMacroDecls: importSwiftMacroDecls, swiftGlue: swiftGlue)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.outputJs.bridgeJSStackPush()
        self.outputDts.bridgeJSStackPush()
        self.importSwiftMacroDecls.bridgeJSStackPush()
        self.swiftGlue.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_PlayBridgeJSOutput(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_PlayBridgeJSOutput()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_PlayBridgeJSOutput")
fileprivate func _bjs_struct_lower_PlayBridgeJSOutput(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_PlayBridgeJSOutput(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_PlayBridgeJSOutput")
fileprivate func _bjs_struct_lift_PlayBridgeJSOutput() -> Int32
#else
fileprivate func _bjs_struct_lift_PlayBridgeJSOutput() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension PlayBridgeJSDiagnostic: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> PlayBridgeJSDiagnostic {
        let endColumn = Int.bridgeJSStackPop()
        let endLine = Int.bridgeJSStackPop()
        let startColumn = Int.bridgeJSStackPop()
        let startLine = Int.bridgeJSStackPop()
        let message = String.bridgeJSStackPop()
        let file = String.bridgeJSStackPop()
        return PlayBridgeJSDiagnostic(file: file, message: message, startLine: startLine, startColumn: startColumn, endLine: endLine, endColumn: endColumn)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.file.bridgeJSStackPush()
        self.message.bridgeJSStackPush()
        self.startLine.bridgeJSStackPush()
        self.startColumn.bridgeJSStackPush()
        self.endLine.bridgeJSStackPush()
        self.endColumn.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_PlayBridgeJSDiagnostic(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_PlayBridgeJSDiagnostic()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_PlayBridgeJSDiagnostic")
fileprivate func _bjs_struct_lower_PlayBridgeJSDiagnostic(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_PlayBridgeJSDiagnostic(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_PlayBridgeJSDiagnostic")
fileprivate func _bjs_struct_lift_PlayBridgeJSDiagnostic() -> Int32
#else
fileprivate func _bjs_struct_lift_PlayBridgeJSDiagnostic() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension PlayBridgeJSResult: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> PlayBridgeJSResult {
        let diagnostics = [PlayBridgeJSDiagnostic].bridgeJSStackPop()
        let output = Optional<PlayBridgeJSOutput>.bridgeJSStackPop()
        return PlayBridgeJSResult(output: output, diagnostics: diagnostics)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.output.bridgeJSStackPush()
        self.diagnostics.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_PlayBridgeJSResult(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_PlayBridgeJSResult()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_PlayBridgeJSResult")
fileprivate func _bjs_struct_lower_PlayBridgeJSResult(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_PlayBridgeJSResult(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_PlayBridgeJSResult")
fileprivate func _bjs_struct_lift_PlayBridgeJSResult() -> Int32
#else
fileprivate func _bjs_struct_lift_PlayBridgeJSResult() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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

@_expose(wasm, "bjs_PlayBridgeJS_updateDetailed")
@_cdecl("bjs_PlayBridgeJS_updateDetailed")
public func _bjs_PlayBridgeJS_updateDetailed(_ _self: UnsafeMutableRawPointer, _ swiftSourceBytes: Int32, _ swiftSourceLength: Int32, _ dtsSourceBytes: Int32, _ dtsSourceLength: Int32) -> Void {
    #if arch(wasm32)
    do {
        let ret = try PlayBridgeJS.bridgeJSLiftParameter(_self).updateDetailed(swiftSource: String.bridgeJSLiftParameter(swiftSourceBytes, swiftSourceLength), dtsSource: String.bridgeJSLiftParameter(dtsSourceBytes, dtsSourceLength))
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
        return
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