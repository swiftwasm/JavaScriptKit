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
        case .status(let param0, let param1, let param2):
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(2)
        case .coordinates(let param0, let param1, let param2):
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            _swift_js_push_f64(param2)
            return Int32(3)
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
            return Int32(4)
        case .info:
            return Int32(5)
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

extension Utilities.Result: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> Utilities.Result {
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

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(0)
        case .failure(let param0, let param1):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
            return Int32(1)
        case .status(let param0, let param1, let param2):
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(2)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> Utilities.Result {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> Utilities.Result {
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

extension NetworkingResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> NetworkingResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        default:
            fatalError("Unknown NetworkingResult case ID: \(caseId)")
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
        case .failure(let param0, let param1):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
            return Int32(1)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> NetworkingResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> NetworkingResult {
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

extension APIOptionalResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> APIOptionalResult {
        switch caseId {
        case 0:
            return .success(Optional<String>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(Optional<Int>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Optional<Bool>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 2:
            return .status(Optional<Bool>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Optional<Int>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Optional<String>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        default:
            fatalError("Unknown APIOptionalResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                var __bjs_str_param0 = __bjs_unwrapped_param0
                __bjs_str_param0.withUTF8 { ptr in
                    _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
                }
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            return Int32(0)
        case .failure(let param0, let param1):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                _swift_js_push_int(Int32(__bjs_unwrapped_param0))
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                _swift_js_push_int(__bjs_unwrapped_param1 ? 1 : 0)
            }
            _swift_js_push_int(__bjs_isSome_param1 ? 1 : 0)
            return Int32(1)
        case .status(let param0, let param1, let param2):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                _swift_js_push_int(__bjs_unwrapped_param0 ? 1 : 0)
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                _swift_js_push_int(Int32(__bjs_unwrapped_param1))
            }
            _swift_js_push_int(__bjs_isSome_param1 ? 1 : 0)
            let __bjs_isSome_param2 = param2 != nil
            if let __bjs_unwrapped_param2 = param2 {
                var __bjs_str_param2 = __bjs_unwrapped_param2
                __bjs_str_param2.withUTF8 { ptr in
                    _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
                }
            }
            _swift_js_push_int(__bjs_isSome_param2 ? 1 : 0)
            return Int32(2)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> APIOptionalResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> APIOptionalResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            _swift_js_push_tag(Int32(0))
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                var __bjs_str_param0 = __bjs_unwrapped_param0
                __bjs_str_param0.withUTF8 { ptr in
                    _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
                }
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
        case .failure(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                _swift_js_push_int(Int32(__bjs_unwrapped_param0))
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                _swift_js_push_int(__bjs_unwrapped_param1 ? 1 : 0)
            }
            _swift_js_push_int(__bjs_isSome_param1 ? 1 : 0)
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                _swift_js_push_int(__bjs_unwrapped_param0 ? 1 : 0)
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                _swift_js_push_int(Int32(__bjs_unwrapped_param1))
            }
            _swift_js_push_int(__bjs_isSome_param1 ? 1 : 0)
            let __bjs_isSome_param2 = param2 != nil
            if let __bjs_unwrapped_param2 = param2 {
                var __bjs_str_param2 = __bjs_unwrapped_param2
                __bjs_str_param2.withUTF8 { ptr in
                    _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
                }
            }
            _swift_js_push_int(__bjs_isSome_param2 ? 1 : 0)
        }
    }
}

@_expose(wasm, "bjs_handle")
@_cdecl("bjs_handle")
public func _bjs_handle(_ result: Int32) -> Void {
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
public func _bjs_roundtripAPIResult(_ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripAPIResult(result: APIResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalAPIResult")
@_cdecl("bjs_roundTripOptionalAPIResult")
public func _bjs_roundTripOptionalAPIResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalAPIResult(result: Optional<APIResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_handleComplex")
@_cdecl("bjs_handleComplex")
public func _bjs_handleComplex(_ result: Int32) -> Void {
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
public func _bjs_roundtripComplexResult(_ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripComplexResult(_: ComplexResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalComplexResult")
@_cdecl("bjs_roundTripOptionalComplexResult")
public func _bjs_roundTripOptionalComplexResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalComplexResult(result: Optional<ComplexResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalUtilitiesResult")
@_cdecl("bjs_roundTripOptionalUtilitiesResult")
public func _bjs_roundTripOptionalUtilitiesResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalUtilitiesResult(result: Optional<Utilities.Result>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalNetworkingResult")
@_cdecl("bjs_roundTripOptionalNetworkingResult")
public func _bjs_roundTripOptionalNetworkingResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalNetworkingResult(result: Optional<NetworkingResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalAPIOptionalResult")
@_cdecl("bjs_roundTripOptionalAPIOptionalResult")
public func _bjs_roundTripOptionalAPIOptionalResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalAPIOptionalResult(result: Optional<APIOptionalResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_compareAPIResults")
@_cdecl("bjs_compareAPIResults")
public func _bjs_compareAPIResults(_ result1IsSome: Int32, _ result1CaseId: Int32, _ result2IsSome: Int32, _ result2CaseId: Int32) -> Void {
    #if arch(wasm32)
    let _tmp_result2 = Optional<APIOptionalResult>.bridgeJSLiftParameter(result2IsSome, result2CaseId)
    let _tmp_result1 = Optional<APIOptionalResult>.bridgeJSLiftParameter(result1IsSome, result1CaseId)
    let ret = compareAPIResults(result1: _tmp_result1, result2: _tmp_result2)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}