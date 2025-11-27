// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

extension APIResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> APIResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        case 2:
            return .flag(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        case 3:
            return .rate(Float.bridgeJSLiftParameter(_swift_js_pop_param_f32()))
        case 4:
            return .precise(Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()))
        case 5:
            return .info
        default:
            fatalError("Unknown APIResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(0)
        case .failure(let param0):
            _swift_js_push_int(Int32(param0))
            return Int32(1)
        case .flag(let param0):
            _swift_js_push_int(param0 ? 1 : 0)
            return Int32(2)
        case .rate(let param0):
            _swift_js_push_f32(param0)
            return Int32(3)
        case .precise(let param0):
            _swift_js_push_f64(param0)
            return Int32(4)
        case .info:
            return Int32(5)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> APIResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> APIResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            _swift_js_push_tag(Int32(0))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .failure(let param0):
            _swift_js_push_tag(Int32(1))
            _swift_js_push_int(Int32(param0))
        case .flag(let param0):
            _swift_js_push_tag(Int32(2))
            _swift_js_push_int(param0 ? 1 : 0)
        case .rate(let param0):
            _swift_js_push_tag(Int32(3))
            _swift_js_push_f32(param0)
        case .precise(let param0):
            _swift_js_push_tag(Int32(4))
            _swift_js_push_f64(param0)
        case .info:
            _swift_js_push_tag(Int32(5))
        }
    }
}

extension ComplexResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> ComplexResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .error(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        case 2:
            return .location(Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 3:
            return .status(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 4:
            return .coordinates(Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()))
        case 5:
            return .comprehensive(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 6:
            return .info
        default:
            fatalError("Unknown ComplexResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(0)
        case .error(let param0, let param1):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
            return Int32(1)
        case .location(let param0, let param1, let param2):
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(2)
        case .status(let param0, let param1, let param2):
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(3)
        case .coordinates(let param0, let param1, let param2):
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            _swift_js_push_f64(param2)
            return Int32(4)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(param1 ? 1 : 0)
            _swift_js_push_int(Int32(param2))
            _swift_js_push_int(Int32(param3))
            _swift_js_push_f64(param4)
            _swift_js_push_f64(param5)
            var __bjs_param6 = param6
            __bjs_param6.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param7 = param7
            __bjs_param7.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param8 = param8
            __bjs_param8.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(5)
        case .info:
            return Int32(6)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> ComplexResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> ComplexResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            _swift_js_push_tag(Int32(0))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .error(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
        case .location(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(3))
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .coordinates(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(4))
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            _swift_js_push_f64(param2)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            _swift_js_push_tag(Int32(5))
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(param1 ? 1 : 0)
            _swift_js_push_int(Int32(param2))
            _swift_js_push_int(Int32(param3))
            _swift_js_push_f64(param4)
            _swift_js_push_f64(param5)
            var __bjs_param6 = param6
            __bjs_param6.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param7 = param7
            __bjs_param7.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param8 = param8
            __bjs_param8.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .info:
            _swift_js_push_tag(Int32(6))
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
public func _bjs_EnumRoundtrip_take(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    EnumRoundtrip.bridgeJSLiftParameter(_self).take(_: APIResult.bridgeJSLiftParameter(value))
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

@_expose(wasm, "bjs_EnumRoundtrip_roundtrip")
@_cdecl("bjs_EnumRoundtrip_roundtrip")
public func _bjs_EnumRoundtrip_roundtrip(_self: UnsafeMutableRawPointer, result: Int32) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).roundtrip(_: APIResult.bridgeJSLiftParameter(result))
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
        return .object(JSObject(id: UInt32(bitPattern: _bjs_EnumRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_EnumRoundtrip_wrap")
fileprivate func _bjs_EnumRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_EnumRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_ComplexResultRoundtrip_init")
@_cdecl("bjs_ComplexResultRoundtrip_init")
public func _bjs_ComplexResultRoundtrip_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_take")
@_cdecl("bjs_ComplexResultRoundtrip_take")
public func _bjs_ComplexResultRoundtrip_take(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    ComplexResultRoundtrip.bridgeJSLiftParameter(_self).take(_: ComplexResult.bridgeJSLiftParameter(value))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeSuccess")
@_cdecl("bjs_ComplexResultRoundtrip_makeSuccess")
public func _bjs_ComplexResultRoundtrip_makeSuccess(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeSuccess()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeError")
@_cdecl("bjs_ComplexResultRoundtrip_makeError")
public func _bjs_ComplexResultRoundtrip_makeError(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeError()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeLocation")
@_cdecl("bjs_ComplexResultRoundtrip_makeLocation")
public func _bjs_ComplexResultRoundtrip_makeLocation(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeLocation()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeStatus")
@_cdecl("bjs_ComplexResultRoundtrip_makeStatus")
public func _bjs_ComplexResultRoundtrip_makeStatus(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeStatus()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeCoordinates")
@_cdecl("bjs_ComplexResultRoundtrip_makeCoordinates")
public func _bjs_ComplexResultRoundtrip_makeCoordinates(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeCoordinates()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeComprehensive")
@_cdecl("bjs_ComplexResultRoundtrip_makeComprehensive")
public func _bjs_ComplexResultRoundtrip_makeComprehensive(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeComprehensive()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeInfo")
@_cdecl("bjs_ComplexResultRoundtrip_makeInfo")
public func _bjs_ComplexResultRoundtrip_makeInfo(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeInfo()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_roundtrip")
@_cdecl("bjs_ComplexResultRoundtrip_roundtrip")
public func _bjs_ComplexResultRoundtrip_roundtrip(_self: UnsafeMutableRawPointer, result: Int32) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).roundtrip(_: ComplexResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_deinit")
@_cdecl("bjs_ComplexResultRoundtrip_deinit")
public func _bjs_ComplexResultRoundtrip_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<ComplexResultRoundtrip>.fromOpaque(pointer).release()
}

extension ComplexResultRoundtrip: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ComplexResultRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_ComplexResultRoundtrip_wrap")
fileprivate func _bjs_ComplexResultRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ComplexResultRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        return .object(JSObject(id: UInt32(bitPattern: _bjs_StringRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_StringRoundtrip_wrap")
fileprivate func _bjs_StringRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_StringRoundtrip_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif