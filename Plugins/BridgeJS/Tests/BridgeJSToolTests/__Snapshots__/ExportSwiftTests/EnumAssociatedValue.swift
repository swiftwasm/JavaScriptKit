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

    func bridgeJSLowerReturn() {
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

private extension ComplexResult {
    static func bridgeJSLiftParameter(_ caseId: Int32) -> ComplexResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .error(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        case 2:
            return .status(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 3:
            return .coordinates(Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()))
        case 4:
            return .comprehensive(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 5:
            return .info
        default:
            fatalError("Unknown ComplexResult case ID: \(caseId)")
        }
    }

    func bridgeJSLowerReturn() {
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
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .coordinates(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(3))
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            _swift_js_push_f64(param2)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            _swift_js_push_tag(Int32(4))
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
            _swift_js_push_tag(Int32(5))
        }
    }
}

private extension Utilities.Result {
    static func bridgeJSLiftParameter(_ caseId: Int32) -> Utilities.Result {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        case 2:
            return .status(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        default:
            fatalError("Unknown Utilities.Result case ID: \(caseId)")
        }
    }

    func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            _swift_js_push_tag(Int32(0))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .failure(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        }
    }
}

private extension NetworkingResult {
    static func bridgeJSLiftParameter(_ caseId: Int32) -> NetworkingResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        default:
            fatalError("Unknown NetworkingResult case ID: \(caseId)")
        }
    }

    func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            _swift_js_push_tag(Int32(0))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .failure(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
        }
    }
}

@_expose(wasm, "bjs_handle")
@_cdecl("bjs_handle")
public func _bjs_handle(result: Int32) -> Void {
    #if arch(wasm32)
    handle(result: APIResult.bridgeJSLiftParameter(result))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getResult")
@_cdecl("bjs_getResult")
public func _bjs_getResult() -> Void {
    #if arch(wasm32)
    let ret = getResult()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripAPIResult")
@_cdecl("bjs_roundtripAPIResult")
public func _bjs_roundtripAPIResult(result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripAPIResult(result: APIResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_handleComplex")
@_cdecl("bjs_handleComplex")
public func _bjs_handleComplex(result: Int32) -> Void {
    #if arch(wasm32)
    handleComplex(result: ComplexResult.bridgeJSLiftParameter(result))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getComplexResult")
@_cdecl("bjs_getComplexResult")
public func _bjs_getComplexResult() -> Void {
    #if arch(wasm32)
    let ret = getComplexResult()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripComplexResult")
@_cdecl("bjs_roundtripComplexResult")
public func _bjs_roundtripComplexResult(result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripComplexResult(_: ComplexResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}