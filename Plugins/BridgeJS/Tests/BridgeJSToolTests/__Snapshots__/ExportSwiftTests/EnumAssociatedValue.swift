// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

private extension APIResult {
    static func bridgeJSLiftParameter(_ caseId: Int32, _ paramsId: Int32, _ paramsLen: Int32) -> APIResult {
        let params: [UInt8] = .init(unsafeUninitializedCapacity: Int(paramsLen)) { buf, initializedCount in
            _swift_js_init_memory(paramsId, buf.baseAddress.unsafelyUnwrapped)
            initializedCount = Int(paramsLen)
        }
        return params.withUnsafeBytes { raw in
            var reader = _BJSBinaryReader(raw: raw)
            switch caseId {
            case 0:
                reader.readParamCount(expected: 1)
                reader.expectTag(.string)
                let param0 = reader.readString()
                return .success(param0)
            case 1:
                reader.readParamCount(expected: 1)
                reader.expectTag(.int32)
                let param0 = Int(reader.readInt32())
                return .failure(param0)
            case 2:
                reader.readParamCount(expected: 1)
                reader.expectTag(.bool)
                let param0 = Int32(reader.readUInt8()) != 0
                return .flag(param0)
            case 3:
                reader.readParamCount(expected: 1)
                reader.expectTag(.float32)
                let param0 = reader.readFloat32()
                return .rate(param0)
            case 4:
                reader.readParamCount(expected: 1)
                reader.expectTag(.float64)
                let param0 = reader.readFloat64()
                return .precise(param0)
            case 5:
                return .info
            default:
                fatalError("Unknown APIResult case ID: \(caseId)")
            }
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

private extension ComplexResult {
    static func bridgeJSLiftParameter(_ caseId: Int32, _ paramsId: Int32, _ paramsLen: Int32) -> ComplexResult {
        let params: [UInt8] = .init(unsafeUninitializedCapacity: Int(paramsLen)) { buf, initializedCount in
            _swift_js_init_memory(paramsId, buf.baseAddress.unsafelyUnwrapped)
            initializedCount = Int(paramsLen)
        }
        return params.withUnsafeBytes { raw in
            var reader = _BJSBinaryReader(raw: raw)
            switch caseId {
            case 0:
                reader.readParamCount(expected: 1)
                reader.expectTag(.string)
                let param0 = reader.readString()
                return .success(param0)
            case 1:
                reader.readParamCount(expected: 2)
                reader.expectTag(.string)
                let param0 = reader.readString()
                reader.expectTag(.int32)
                let param1 = Int(reader.readInt32())
                return .error(param0, param1)
            case 2:
                reader.readParamCount(expected: 3)
                reader.expectTag(.bool)
                let param0 = Int32(reader.readUInt8()) != 0
                reader.expectTag(.int32)
                let param1 = Int(reader.readInt32())
                reader.expectTag(.string)
                let param2 = reader.readString()
                return .status(param0, param1, param2)
            case 3:
                reader.readParamCount(expected: 3)
                reader.expectTag(.float64)
                let param0 = reader.readFloat64()
                reader.expectTag(.float64)
                let param1 = reader.readFloat64()
                reader.expectTag(.float64)
                let param2 = reader.readFloat64()
                return .coordinates(param0, param1, param2)
            case 4:
                reader.readParamCount(expected: 9)
                reader.expectTag(.bool)
                let param0 = Int32(reader.readUInt8()) != 0
                reader.expectTag(.bool)
                let param1 = Int32(reader.readUInt8()) != 0
                reader.expectTag(.int32)
                let param2 = Int(reader.readInt32())
                reader.expectTag(.int32)
                let param3 = Int(reader.readInt32())
                reader.expectTag(.float64)
                let param4 = reader.readFloat64()
                reader.expectTag(.float64)
                let param5 = reader.readFloat64()
                reader.expectTag(.string)
                let param6 = reader.readString()
                reader.expectTag(.string)
                let param7 = reader.readString()
                reader.expectTag(.string)
                let param8 = reader.readString()
                return .comprehensive(param0, param1, param2, param3, param4, param5, param6, param7, param8)
            case 5:
                return .info
            default:
                fatalError("Unknown ComplexResult case ID: \(caseId)")
            }
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
        case .error(let param0, let param1):
            _swift_js_return_tag(Int32(1))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_return_int(Int32(param1))
        case .status(let param0, let param1, let param2):
            _swift_js_return_tag(Int32(2))
            _swift_js_return_bool(param0 ? 1 : 0)
            _swift_js_return_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .coordinates(let param0, let param1, let param2):
            _swift_js_return_tag(Int32(3))
            _swift_js_return_f64(param0)
            _swift_js_return_f64(param1)
            _swift_js_return_f64(param2)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            _swift_js_return_tag(Int32(4))
            _swift_js_return_bool(param0 ? 1 : 0)
            _swift_js_return_bool(param1 ? 1 : 0)
            _swift_js_return_int(Int32(param2))
            _swift_js_return_int(Int32(param3))
            _swift_js_return_f64(param4)
            _swift_js_return_f64(param5)
            var __bjs_param6 = param6
            __bjs_param6.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param7 = param7
            __bjs_param7.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param8 = param8
            __bjs_param8.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .info:
            _swift_js_return_tag(Int32(5))
        }
    }
}

private extension Utilities.Result {
    static func bridgeJSLiftParameter(_ caseId: Int32, _ paramsId: Int32, _ paramsLen: Int32) -> Utilities.Result {
        let params: [UInt8] = .init(unsafeUninitializedCapacity: Int(paramsLen)) { buf, initializedCount in
            _swift_js_init_memory(paramsId, buf.baseAddress.unsafelyUnwrapped)
            initializedCount = Int(paramsLen)
        }
        return params.withUnsafeBytes { raw in
            var reader = _BJSBinaryReader(raw: raw)
            switch caseId {
            case 0:
                reader.readParamCount(expected: 1)
                reader.expectTag(.string)
                let param0 = reader.readString()
                return .success(param0)
            case 1:
                reader.readParamCount(expected: 2)
                reader.expectTag(.string)
                let param0 = reader.readString()
                reader.expectTag(.int32)
                let param1 = Int(reader.readInt32())
                return .failure(param0, param1)
            case 2:
                reader.readParamCount(expected: 3)
                reader.expectTag(.bool)
                let param0 = Int32(reader.readUInt8()) != 0
                reader.expectTag(.int32)
                let param1 = Int(reader.readInt32())
                reader.expectTag(.string)
                let param2 = reader.readString()
                return .status(param0, param1, param2)
            default:
                fatalError("Unknown Utilities.Result case ID: \(caseId)")
            }
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
        case .failure(let param0, let param1):
            _swift_js_return_tag(Int32(1))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_return_int(Int32(param1))
        case .status(let param0, let param1, let param2):
            _swift_js_return_tag(Int32(2))
            _swift_js_return_bool(param0 ? 1 : 0)
            _swift_js_return_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
        }
    }
}

private extension NetworkingResult {
    static func bridgeJSLiftParameter(_ caseId: Int32, _ paramsId: Int32, _ paramsLen: Int32) -> NetworkingResult {
        let params: [UInt8] = .init(unsafeUninitializedCapacity: Int(paramsLen)) { buf, initializedCount in
            _swift_js_init_memory(paramsId, buf.baseAddress.unsafelyUnwrapped)
            initializedCount = Int(paramsLen)
        }
        return params.withUnsafeBytes { raw in
            var reader = _BJSBinaryReader(raw: raw)
            switch caseId {
            case 0:
                reader.readParamCount(expected: 1)
                reader.expectTag(.string)
                let param0 = reader.readString()
                return .success(param0)
            case 1:
                reader.readParamCount(expected: 2)
                reader.expectTag(.string)
                let param0 = reader.readString()
                reader.expectTag(.int32)
                let param1 = Int(reader.readInt32())
                return .failure(param0, param1)
            default:
                fatalError("Unknown NetworkingResult case ID: \(caseId)")
            }
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
        case .failure(let param0, let param1):
            _swift_js_return_tag(Int32(1))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_return_int(Int32(param1))
        }
    }
}

@_expose(wasm, "bjs_handle")
@_cdecl("bjs_handle")
public func _bjs_handle(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    handle(result: APIResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
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

@_expose(wasm, "bjs_handleComplex")
@_cdecl("bjs_handleComplex")
public func _bjs_handleComplex(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    handleComplex(result: ComplexResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
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