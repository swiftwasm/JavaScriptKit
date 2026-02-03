extension APIResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> APIResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter())
        case 1:
            return .failure(Int.bridgeJSLiftParameter())
        case 2:
            return .flag(Bool.bridgeJSLiftParameter())
        case 3:
            return .rate(Float.bridgeJSLiftParameter())
        case 4:
            return .precise(Double.bridgeJSLiftParameter())
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
            param0.bridgeJSLowerStackReturn()
            return Int32(0)
        case .failure(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(1)
        case .flag(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(2)
        case .rate(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(3)
        case .precise(let param0):
            param0.bridgeJSLowerStackReturn()
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
            param0.bridgeJSLowerStackReturn()
        case .failure(let param0):
            _swift_js_push_tag(Int32(1))
            param0.bridgeJSLowerStackReturn()
        case .flag(let param0):
            _swift_js_push_tag(Int32(2))
            param0.bridgeJSLowerStackReturn()
        case .rate(let param0):
            _swift_js_push_tag(Int32(3))
            param0.bridgeJSLowerStackReturn()
        case .precise(let param0):
            _swift_js_push_tag(Int32(4))
            param0.bridgeJSLowerStackReturn()
        case .info:
            _swift_js_push_tag(Int32(5))
        }
    }
}

extension ComplexResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> ComplexResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter())
        case 1:
            return .error(String.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter())
        case 2:
            return .status(Bool.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), String.bridgeJSLiftParameter())
        case 3:
            return .coordinates(Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter())
        case 4:
            return .comprehensive(Bool.bridgeJSLiftParameter(), Bool.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), String.bridgeJSLiftParameter(), String.bridgeJSLiftParameter(), String.bridgeJSLiftParameter())
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
            param0.bridgeJSLowerStackReturn()
            return Int32(0)
        case .error(let param0, let param1):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            return Int32(1)
        case .status(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            return Int32(2)
        case .coordinates(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            return Int32(3)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            param3.bridgeJSLowerStackReturn()
            param4.bridgeJSLowerStackReturn()
            param5.bridgeJSLowerStackReturn()
            param6.bridgeJSLowerStackReturn()
            param7.bridgeJSLowerStackReturn()
            param8.bridgeJSLowerStackReturn()
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
            param0.bridgeJSLowerStackReturn()
        case .error(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
        case .coordinates(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(3))
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            _swift_js_push_tag(Int32(4))
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            param3.bridgeJSLowerStackReturn()
            param4.bridgeJSLowerStackReturn()
            param5.bridgeJSLowerStackReturn()
            param6.bridgeJSLowerStackReturn()
            param7.bridgeJSLowerStackReturn()
            param8.bridgeJSLowerStackReturn()
        case .info:
            _swift_js_push_tag(Int32(5))
        }
    }
}

extension Utilities.Result: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> Utilities.Result {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter())
        case 1:
            return .failure(String.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter())
        case 2:
            return .status(Bool.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), String.bridgeJSLiftParameter())
        default:
            fatalError("Unknown Utilities.Result case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(0)
        case .failure(let param0, let param1):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            return Int32(1)
        case .status(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
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
            param0.bridgeJSLowerStackReturn()
        case .failure(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
        }
    }
}

extension NetworkingResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> NetworkingResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter())
        case 1:
            return .failure(String.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter())
        default:
            fatalError("Unknown NetworkingResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(0)
        case .failure(let param0, let param1):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
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
            param0.bridgeJSLowerStackReturn()
        case .failure(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
        }
    }
}

extension APIOptionalResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> APIOptionalResult {
        switch caseId {
        case 0:
            return .success(Optional<String>.bridgeJSLiftParameter())
        case 1:
            return .failure(Optional<Int>.bridgeJSLiftParameter(), Optional<Bool>.bridgeJSLiftParameter())
        case 2:
            return .status(Optional<Bool>.bridgeJSLiftParameter(), Optional<Int>.bridgeJSLiftParameter(), Optional<String>.bridgeJSLiftParameter())
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
                __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            return Int32(0)
        case .failure(let param0, let param1):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                __bjs_unwrapped_param1.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param1 ? 1 : 0)
            return Int32(1)
        case .status(let param0, let param1, let param2):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                __bjs_unwrapped_param1.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param1 ? 1 : 0)
            let __bjs_isSome_param2 = param2 != nil
            if let __bjs_unwrapped_param2 = param2 {
                __bjs_unwrapped_param2.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param2 ? 1 : 0)
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
                __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
        case .failure(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                __bjs_unwrapped_param1.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param1 ? 1 : 0)
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                __bjs_unwrapped_param1.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param1 ? 1 : 0)
            let __bjs_isSome_param2 = param2 != nil
            if let __bjs_unwrapped_param2 = param2 {
                __bjs_unwrapped_param2.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param2 ? 1 : 0)
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