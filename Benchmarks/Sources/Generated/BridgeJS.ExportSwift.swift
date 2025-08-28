// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

private extension APIResult {
    static func bridgeJSLiftParameter(_ caseId: Int32) -> APIResult {
        switch caseId {
        case 0:
            let bytes = _swift_js_pop_param_int32()
            let count = _swift_js_pop_param_int32()
            return .success(String.bridgeJSLiftParameter(bytes, count))
        case 1:
            let param0 = _swift_js_pop_param_int32()
            return .failure(Int(param0))
        case 2:
            let param0 = _swift_js_pop_param_int32()
            return .flag(Int32(param0) != 0)
        case 3:
            let param0 = _swift_js_pop_param_float64()
            return .rate(Float(param0))
        case 4:
            let param0 = _swift_js_pop_param_float64()
            return .precise(param0)
        case 5:
            return .info
        default:
            fatalError("Unknown APIResult case ID: \(caseId)")
        }
    }

    func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            _swift_js_return_tag(Int32(0))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .failure(let param0):
            _swift_js_return_tag(Int32(1))
            _swift_js_return_int(Int32(param0))
        case .flag(let param0):
            _swift_js_return_tag(Int32(2))
            _swift_js_return_bool(param0 ? 1 : 0)
        case .rate(let param0):
            _swift_js_return_tag(Int32(3))
            _swift_js_return_f32(param0)
        case .precise(let param0):
            _swift_js_return_tag(Int32(4))
            _swift_js_return_f64(param0)
        case .info:
            _swift_js_return_tag(Int32(5))
        }
    }
}

@_expose(wasm, "bjs_run")
@_cdecl("bjs_run")
public func _bjs_run() -> Void {
    #if arch(wasm32)
    run()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_init")
@_cdecl("bjs_EnumRoundtrip_init")
public func _bjs_EnumRoundtrip_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = EnumRoundtrip()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_take")
@_cdecl("bjs_EnumRoundtrip_take")
public func _bjs_EnumRoundtrip_take(_self: UnsafeMutableRawPointer, valueCaseId: Int32) -> Void {
    #if arch(wasm32)
    EnumRoundtrip.bridgeJSLiftParameter(_self).take(_: APIResult.bridgeJSLiftParameter(valueCaseId))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeSuccess")
@_cdecl("bjs_EnumRoundtrip_makeSuccess")
public func _bjs_EnumRoundtrip_makeSuccess(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeSuccess()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeFailure")
@_cdecl("bjs_EnumRoundtrip_makeFailure")
public func _bjs_EnumRoundtrip_makeFailure(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeFailure()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeFlag")
@_cdecl("bjs_EnumRoundtrip_makeFlag")
public func _bjs_EnumRoundtrip_makeFlag(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeFlag()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeRate")
@_cdecl("bjs_EnumRoundtrip_makeRate")
public func _bjs_EnumRoundtrip_makeRate(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeRate()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makePrecise")
@_cdecl("bjs_EnumRoundtrip_makePrecise")
public func _bjs_EnumRoundtrip_makePrecise(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makePrecise()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeInfo")
@_cdecl("bjs_EnumRoundtrip_makeInfo")
public func _bjs_EnumRoundtrip_makeInfo(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeInfo()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_deinit")
@_cdecl("bjs_EnumRoundtrip_deinit")
public func _bjs_EnumRoundtrip_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<EnumRoundtrip>.fromOpaque(pointer).release()
}

extension EnumRoundtrip: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "Benchmarks", name: "bjs_EnumRoundtrip_wrap")
        func _bjs_EnumRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_EnumRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_EnumRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_StringRoundtrip_init")
@_cdecl("bjs_StringRoundtrip_init")
public func _bjs_StringRoundtrip_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = StringRoundtrip()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StringRoundtrip_take")
@_cdecl("bjs_StringRoundtrip_take")
public func _bjs_StringRoundtrip_take(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    StringRoundtrip.bridgeJSLiftParameter(_self).take(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StringRoundtrip_make")
@_cdecl("bjs_StringRoundtrip_make")
public func _bjs_StringRoundtrip_make(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StringRoundtrip.bridgeJSLiftParameter(_self).make()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StringRoundtrip_deinit")
@_cdecl("bjs_StringRoundtrip_deinit")
public func _bjs_StringRoundtrip_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<StringRoundtrip>.fromOpaque(pointer).release()
}

extension StringRoundtrip: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "Benchmarks", name: "bjs_StringRoundtrip_wrap")
        func _bjs_StringRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_StringRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_StringRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}