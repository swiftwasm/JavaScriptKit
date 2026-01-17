extension Calculator: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Calculator {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Calculator {
        return Calculator(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .scientific
        case 1:
            self = .basic
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .scientific:
            return 0
        case .basic:
            return 1
        }
    }
}

@_expose(wasm, "bjs_Calculator_static_square")
@_cdecl("bjs_Calculator_static_square")
public func _bjs_Calculator_static_square(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Calculator.square(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension APIResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> APIResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
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
        }
    }
}

@_expose(wasm, "bjs_APIResult_static_roundtrip")
@_cdecl("bjs_APIResult_static_roundtrip")
public func _bjs_APIResult_static_roundtrip(_ value: Int32) -> Void {
    #if arch(wasm32)
    let ret = APIResult.roundtrip(value: APIResult.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Utils_String_static_uppercase")
@_cdecl("bjs_Utils_String_static_uppercase")
public func _bjs_Utils_String_static_uppercase(_ textBytes: Int32, _ textLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Utils.String.uppercase(_: String.bridgeJSLiftParameter(textBytes, textLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathUtils_init")
@_cdecl("bjs_MathUtils_init")
public func _bjs_MathUtils_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = MathUtils()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathUtils_static_subtract")
@_cdecl("bjs_MathUtils_static_subtract")
public func _bjs_MathUtils_static_subtract(_ a: Int32, _ b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MathUtils.subtract(a: Int.bridgeJSLiftParameter(a), b: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathUtils_static_add")
@_cdecl("bjs_MathUtils_static_add")
public func _bjs_MathUtils_static_add(_ a: Int32, _ b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MathUtils.add(a: Int.bridgeJSLiftParameter(a), b: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathUtils_multiply")
@_cdecl("bjs_MathUtils_multiply")
public func _bjs_MathUtils_multiply(_ _self: UnsafeMutableRawPointer, _ x: Int32, _ y: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MathUtils.bridgeJSLiftParameter(_self).multiply(x: Int.bridgeJSLiftParameter(x), y: Int.bridgeJSLiftParameter(y))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathUtils_deinit")
@_cdecl("bjs_MathUtils_deinit")
public func _bjs_MathUtils_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<MathUtils>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension MathUtils: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_MathUtils_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_MathUtils_wrap")
fileprivate func _bjs_MathUtils_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_MathUtils_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif