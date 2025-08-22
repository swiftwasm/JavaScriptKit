// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

extension Direction {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Direction {
        return Direction(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Direction {
        return Direction(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSRawValue
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .north
        case 1:
            self = .south
        case 2:
            self = .east
        case 3:
            self = .west
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .north:
            return 0
        case .south:
            return 1
        case .east:
            return 2
        case .west:
            return 3
        }
    }
}

extension Status {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Status {
        return Status(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Status {
        return Status(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSRawValue
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .loading
        case 1:
            self = .success
        case 2:
            self = .error
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .loading:
            return 0
        case .success:
            return 1
        case .error:
            return 2
        }
    }
}

extension Theme: _BridgedSwiftEnumNoPayload {
}

extension HttpStatus: _BridgedSwiftEnumNoPayload {
}

extension TSDirection {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> TSDirection {
        return TSDirection(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> TSDirection {
        return TSDirection(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSRawValue
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .north
        case 1:
            self = .south
        case 2:
            self = .east
        case 3:
            self = .west
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .north:
            return 0
        case .south:
            return 1
        case .east:
            return 2
        case .west:
            return 3
        }
    }
}

extension TSTheme: _BridgedSwiftEnumNoPayload {
}

extension Networking.API.Method {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Networking.API.Method {
        return Networking.API.Method(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Networking.API.Method {
        return Networking.API.Method(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSRawValue
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .get
        case 1:
            self = .post
        case 2:
            self = .put
        case 3:
            self = .delete
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .get:
            return 0
        case .post:
            return 1
        case .put:
            return 2
        case .delete:
            return 3
        }
    }
}

extension Configuration.LogLevel: _BridgedSwiftEnumNoPayload {
}

extension Configuration.Port: _BridgedSwiftEnumNoPayload {
}

extension Internal.SupportedMethod {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Internal.SupportedMethod {
        return Internal.SupportedMethod(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Internal.SupportedMethod {
        return Internal.SupportedMethod(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSRawValue
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .get
        case 1:
            self = .post
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .get:
            return 0
        case .post:
            return 1
        }
    }
}

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
                reader.expectTag(.float64)
                let param0 = reader.readFloat64()
                reader.expectTag(.float64)
                let param1 = reader.readFloat64()
                reader.expectTag(.string)
                let param2 = reader.readString()
                return .location(param0, param1, param2)
            case 3:
                reader.readParamCount(expected: 3)
                reader.expectTag(.bool)
                let param0 = Int32(reader.readUInt8()) != 0
                reader.expectTag(.int32)
                let param1 = Int(reader.readInt32())
                reader.expectTag(.string)
                let param2 = reader.readString()
                return .status(param0, param1, param2)
            case 4:
                reader.readParamCount(expected: 3)
                reader.expectTag(.float64)
                let param0 = reader.readFloat64()
                reader.expectTag(.float64)
                let param1 = reader.readFloat64()
                reader.expectTag(.float64)
                let param2 = reader.readFloat64()
                return .coordinates(param0, param1, param2)
            case 5:
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
            case 6:
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
        case .location(let param0, let param1, let param2):
            _swift_js_return_tag(Int32(2))
            _swift_js_return_f64(param0)
            _swift_js_return_f64(param1)
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .status(let param0, let param1, let param2):
            _swift_js_return_tag(Int32(3))
            _swift_js_return_bool(param0 ? 1 : 0)
            _swift_js_return_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .coordinates(let param0, let param1, let param2):
            _swift_js_return_tag(Int32(4))
            _swift_js_return_f64(param0)
            _swift_js_return_f64(param1)
            _swift_js_return_f64(param2)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            _swift_js_return_tag(Int32(5))
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
            _swift_js_return_tag(Int32(6))
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

private extension API.NetworkingResult {
    static func bridgeJSLiftParameter(_ caseId: Int32, _ paramsId: Int32, _ paramsLen: Int32) -> API.NetworkingResult {
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
                fatalError("Unknown API.NetworkingResult case ID: \(caseId)")
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

@_expose(wasm, "bjs_roundTripVoid")
@_cdecl("bjs_roundTripVoid")
public func _bjs_roundTripVoid() -> Void {
    #if arch(wasm32)
    roundTripVoid()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripInt")
@_cdecl("bjs_roundTripInt")
public func _bjs_roundTripInt(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripInt(v: Int.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripFloat")
@_cdecl("bjs_roundTripFloat")
public func _bjs_roundTripFloat(v: Float32) -> Float32 {
    #if arch(wasm32)
    let ret = roundTripFloat(v: Float.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDouble")
@_cdecl("bjs_roundTripDouble")
public func _bjs_roundTripDouble(v: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = roundTripDouble(v: Double.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripBool")
@_cdecl("bjs_roundTripBool")
public func _bjs_roundTripBool(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripBool(v: Bool.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripString")
@_cdecl("bjs_roundTripString")
public func _bjs_roundTripString(vBytes: Int32, vLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripString(v: String.bridgeJSLiftParameter(vBytes, vLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSwiftHeapObject")
@_cdecl("bjs_roundTripSwiftHeapObject")
public func _bjs_roundTripSwiftHeapObject(v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripSwiftHeapObject(v: Greeter.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSObject")
@_cdecl("bjs_roundTripJSObject")
public func _bjs_roundTripJSObject(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripJSObject(v: JSObject.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsSwiftError")
@_cdecl("bjs_throwsSwiftError")
public func _bjs_throwsSwiftError(shouldThrow: Int32) -> Void {
    #if arch(wasm32)
    do {
        try throwsSwiftError(shouldThrow: Bool.bridgeJSLiftParameter(shouldThrow))
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

@_expose(wasm, "bjs_throwsWithIntResult")
@_cdecl("bjs_throwsWithIntResult")
public func _bjs_throwsWithIntResult() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithIntResult()
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
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithStringResult")
@_cdecl("bjs_throwsWithStringResult")
public func _bjs_throwsWithStringResult() -> Void {
    #if arch(wasm32)
    do {
        let ret = try throwsWithStringResult()
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

@_expose(wasm, "bjs_throwsWithBoolResult")
@_cdecl("bjs_throwsWithBoolResult")
public func _bjs_throwsWithBoolResult() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithBoolResult()
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
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithFloatResult")
@_cdecl("bjs_throwsWithFloatResult")
public func _bjs_throwsWithFloatResult() -> Float32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithFloatResult()
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
        return 0.0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithDoubleResult")
@_cdecl("bjs_throwsWithDoubleResult")
public func _bjs_throwsWithDoubleResult() -> Float64 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithDoubleResult()
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
        return 0.0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithSwiftHeapObjectResult")
@_cdecl("bjs_throwsWithSwiftHeapObjectResult")
public func _bjs_throwsWithSwiftHeapObjectResult() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    do {
        let ret = try throwsWithSwiftHeapObjectResult()
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
        return UnsafeMutableRawPointer(bitPattern: -1).unsafelyUnwrapped
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithJSObjectResult")
@_cdecl("bjs_throwsWithJSObjectResult")
public func _bjs_throwsWithJSObjectResult() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithJSObjectResult()
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
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripVoid")
@_cdecl("bjs_asyncRoundTripVoid")
public func _bjs_asyncRoundTripVoid() -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        await asyncRoundTripVoid()
    } .jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripInt")
@_cdecl("bjs_asyncRoundTripInt")
public func _bjs_asyncRoundTripInt(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripInt(v: Int.bridgeJSLiftParameter(v)).jsValue
    } .jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripFloat")
@_cdecl("bjs_asyncRoundTripFloat")
public func _bjs_asyncRoundTripFloat(v: Float32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripFloat(v: Float.bridgeJSLiftParameter(v)).jsValue
    } .jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripDouble")
@_cdecl("bjs_asyncRoundTripDouble")
public func _bjs_asyncRoundTripDouble(v: Float64) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripDouble(v: Double.bridgeJSLiftParameter(v)).jsValue
    } .jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripBool")
@_cdecl("bjs_asyncRoundTripBool")
public func _bjs_asyncRoundTripBool(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripBool(v: Bool.bridgeJSLiftParameter(v)).jsValue
    } .jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripString")
@_cdecl("bjs_asyncRoundTripString")
public func _bjs_asyncRoundTripString(vBytes: Int32, vLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripString(v: String.bridgeJSLiftParameter(vBytes, vLength)).jsValue
    } .jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripSwiftHeapObject")
@_cdecl("bjs_asyncRoundTripSwiftHeapObject")
public func _bjs_asyncRoundTripSwiftHeapObject(v: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripSwiftHeapObject(v: Greeter.bridgeJSLiftParameter(v)).jsValue
    } .jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripJSObject")
@_cdecl("bjs_asyncRoundTripJSObject")
public func _bjs_asyncRoundTripJSObject(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripJSObject(v: JSObject.bridgeJSLiftParameter(v)).jsValue
    } .jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeGreeter")
@_cdecl("bjs_takeGreeter")
public func _bjs_takeGreeter(g: UnsafeMutableRawPointer, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    takeGreeter(g: Greeter.bridgeJSLiftParameter(g), name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createCalculator")
@_cdecl("bjs_createCalculator")
public func _bjs_createCalculator() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createCalculator()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_useCalculator")
@_cdecl("bjs_useCalculator")
public func _bjs_useCalculator(calc: UnsafeMutableRawPointer, x: Int32, y: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = useCalculator(calc: Calculator.bridgeJSLiftParameter(calc), x: Int.bridgeJSLiftParameter(x), y: Int.bridgeJSLiftParameter(y))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testGreeterToJSValue")
@_cdecl("bjs_testGreeterToJSValue")
public func _bjs_testGreeterToJSValue() -> Int32 {
    #if arch(wasm32)
    let ret = testGreeterToJSValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testCalculatorToJSValue")
@_cdecl("bjs_testCalculatorToJSValue")
public func _bjs_testCalculatorToJSValue() -> Int32 {
    #if arch(wasm32)
    let ret = testCalculatorToJSValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testSwiftClassAsJSValue")
@_cdecl("bjs_testSwiftClassAsJSValue")
public func _bjs_testSwiftClassAsJSValue(greeter: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = testSwiftClassAsJSValue(greeter: Greeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setDirection")
@_cdecl("bjs_setDirection")
public func _bjs_setDirection(direction: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = setDirection(_: Direction.bridgeJSLiftParameter(direction))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getDirection")
@_cdecl("bjs_getDirection")
public func _bjs_getDirection() -> Int32 {
    #if arch(wasm32)
    let ret = getDirection()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processDirection")
@_cdecl("bjs_processDirection")
public func _bjs_processDirection(input: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processDirection(_: Direction.bridgeJSLiftParameter(input))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTheme")
@_cdecl("bjs_setTheme")
public func _bjs_setTheme(themeBytes: Int32, themeLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = setTheme(_: Theme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
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

@_expose(wasm, "bjs_setHttpStatus")
@_cdecl("bjs_setHttpStatus")
public func _bjs_setHttpStatus(status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = setHttpStatus(_: HttpStatus.bridgeJSLiftParameter(status))
    return ret.bridgeJSLowerReturn()
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

@_expose(wasm, "bjs_setTSDirection")
@_cdecl("bjs_setTSDirection")
public func _bjs_setTSDirection(direction: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = setTSDirection(_: TSDirection.bridgeJSLiftParameter(direction))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTSDirection")
@_cdecl("bjs_getTSDirection")
public func _bjs_getTSDirection() -> Int32 {
    #if arch(wasm32)
    let ret = getTSDirection()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTSTheme")
@_cdecl("bjs_setTSTheme")
public func _bjs_setTSTheme(themeBytes: Int32, themeLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = setTSTheme(_: TSTheme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
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

@_expose(wasm, "bjs_echoNetworkingAPIMethod")
@_cdecl("bjs_echoNetworkingAPIMethod")
public func _bjs_echoNetworkingAPIMethod(method: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = echoNetworkingAPIMethod(_: Networking.API.Method.bridgeJSLiftParameter(method))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_echoConfigurationLogLevel")
@_cdecl("bjs_echoConfigurationLogLevel")
public func _bjs_echoConfigurationLogLevel(levelBytes: Int32, levelLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = echoConfigurationLogLevel(_: Configuration.LogLevel.bridgeJSLiftParameter(levelBytes, levelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_echoConfigurationPort")
@_cdecl("bjs_echoConfigurationPort")
public func _bjs_echoConfigurationPort(port: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = echoConfigurationPort(_: Configuration.Port.bridgeJSLiftParameter(port))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processConfigurationLogLevel")
@_cdecl("bjs_processConfigurationLogLevel")
public func _bjs_processConfigurationLogLevel(levelBytes: Int32, levelLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processConfigurationLogLevel(_: Configuration.LogLevel.bridgeJSLiftParameter(levelBytes, levelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_echoInternalSupportedMethod")
@_cdecl("bjs_echoInternalSupportedMethod")
public func _bjs_echoInternalSupportedMethod(method: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = echoInternalSupportedMethod(_: Internal.SupportedMethod.bridgeJSLiftParameter(method))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_echoAPIResult")
@_cdecl("bjs_echoAPIResult")
public func _bjs_echoAPIResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = echoAPIResult(result: APIResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultSuccess")
@_cdecl("bjs_makeAPIResultSuccess")
public func _bjs_makeAPIResultSuccess(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultSuccess(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultFailure")
@_cdecl("bjs_makeAPIResultFailure")
public func _bjs_makeAPIResultFailure(value: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultFailure(_: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultInfo")
@_cdecl("bjs_makeAPIResultInfo")
public func _bjs_makeAPIResultInfo() -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultInfo()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultFlag")
@_cdecl("bjs_makeAPIResultFlag")
public func _bjs_makeAPIResultFlag(value: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultFlag(_: Bool.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultRate")
@_cdecl("bjs_makeAPIResultRate")
public func _bjs_makeAPIResultRate(value: Float32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultRate(_: Float.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultPrecise")
@_cdecl("bjs_makeAPIResultPrecise")
public func _bjs_makeAPIResultPrecise(value: Float64) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultPrecise(_: Double.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_echoComplexResult")
@_cdecl("bjs_echoComplexResult")
public func _bjs_echoComplexResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = echoComplexResult(result: ComplexResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultSuccess")
@_cdecl("bjs_makeComplexResultSuccess")
public func _bjs_makeComplexResultSuccess(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultSuccess(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultError")
@_cdecl("bjs_makeComplexResultError")
public func _bjs_makeComplexResultError(messageBytes: Int32, messageLength: Int32, code: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultError(_: String.bridgeJSLiftParameter(messageBytes, messageLength), _: Int.bridgeJSLiftParameter(code))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultLocation")
@_cdecl("bjs_makeComplexResultLocation")
public func _bjs_makeComplexResultLocation(lat: Float64, lng: Float64, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultLocation(_: Double.bridgeJSLiftParameter(lat), _: Double.bridgeJSLiftParameter(lng), _: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultStatus")
@_cdecl("bjs_makeComplexResultStatus")
public func _bjs_makeComplexResultStatus(active: Int32, code: Int32, messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultStatus(_: Bool.bridgeJSLiftParameter(active), _: Int.bridgeJSLiftParameter(code), _: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultCoordinates")
@_cdecl("bjs_makeComplexResultCoordinates")
public func _bjs_makeComplexResultCoordinates(x: Float64, y: Float64, z: Float64) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultCoordinates(_: Double.bridgeJSLiftParameter(x), _: Double.bridgeJSLiftParameter(y), _: Double.bridgeJSLiftParameter(z))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultComprehensive")
@_cdecl("bjs_makeComplexResultComprehensive")
public func _bjs_makeComplexResultComprehensive(flag1: Int32, flag2: Int32, count1: Int32, count2: Int32, value1: Float64, value2: Float64, text1Bytes: Int32, text1Length: Int32, text2Bytes: Int32, text2Length: Int32, text3Bytes: Int32, text3Length: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultComprehensive(_: Bool.bridgeJSLiftParameter(flag1), _: Bool.bridgeJSLiftParameter(flag2), _: Int.bridgeJSLiftParameter(count1), _: Int.bridgeJSLiftParameter(count2), _: Double.bridgeJSLiftParameter(value1), _: Double.bridgeJSLiftParameter(value2), _: String.bridgeJSLiftParameter(text1Bytes, text1Length), _: String.bridgeJSLiftParameter(text2Bytes, text2Length), _: String.bridgeJSLiftParameter(text3Bytes, text3Length))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultInfo")
@_cdecl("bjs_makeComplexResultInfo")
public func _bjs_makeComplexResultInfo() -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultInfo()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripComplexResult")
@_cdecl("bjs_roundtripComplexResult")
public func _bjs_roundtripComplexResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripComplexResult(_: ComplexResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultSuccess")
@_cdecl("bjs_makeUtilitiesResultSuccess")
public func _bjs_makeUtilitiesResultSuccess(messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeUtilitiesResultSuccess(_: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultFailure")
@_cdecl("bjs_makeUtilitiesResultFailure")
public func _bjs_makeUtilitiesResultFailure(errorBytes: Int32, errorLength: Int32, code: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeUtilitiesResultFailure(_: String.bridgeJSLiftParameter(errorBytes, errorLength), _: Int.bridgeJSLiftParameter(code))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultStatus")
@_cdecl("bjs_makeUtilitiesResultStatus")
public func _bjs_makeUtilitiesResultStatus(active: Int32, code: Int32, messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeUtilitiesResultStatus(_: Bool.bridgeJSLiftParameter(active), _: Int.bridgeJSLiftParameter(code), _: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPINetworkingResultSuccess")
@_cdecl("bjs_makeAPINetworkingResultSuccess")
public func _bjs_makeAPINetworkingResultSuccess(messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPINetworkingResultSuccess(_: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPINetworkingResultFailure")
@_cdecl("bjs_makeAPINetworkingResultFailure")
public func _bjs_makeAPINetworkingResultFailure(errorBytes: Int32, errorLength: Int32, code: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPINetworkingResultFailure(_: String.bridgeJSLiftParameter(errorBytes, errorLength), _: Int.bridgeJSLiftParameter(code))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripUtilitiesResult")
@_cdecl("bjs_roundtripUtilitiesResult")
public func _bjs_roundtripUtilitiesResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripUtilitiesResult(_: Utilities.Result.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripAPINetworkingResult")
@_cdecl("bjs_roundtripAPINetworkingResult")
public func _bjs_roundtripAPINetworkingResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripAPINetworkingResult(_: API.NetworkingResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createPropertyHolder")
@_cdecl("bjs_createPropertyHolder")
public func _bjs_createPropertyHolder(intValue: Int32, floatValue: Float32, doubleValue: Float64, boolValue: Int32, stringValueBytes: Int32, stringValueLength: Int32, jsObject: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createPropertyHolder(intValue: Int.bridgeJSLiftParameter(intValue), floatValue: Float.bridgeJSLiftParameter(floatValue), doubleValue: Double.bridgeJSLiftParameter(doubleValue), boolValue: Bool.bridgeJSLiftParameter(boolValue), stringValue: String.bridgeJSLiftParameter(stringValueBytes, stringValueLength), jsObject: JSObject.bridgeJSLiftParameter(jsObject))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testPropertyHolder")
@_cdecl("bjs_testPropertyHolder")
public func _bjs_testPropertyHolder(holder: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = testPropertyHolder(holder: PropertyHolder.bridgeJSLiftParameter(holder))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_resetObserverCounts")
@_cdecl("bjs_resetObserverCounts")
public func _bjs_resetObserverCounts() -> Void {
    #if arch(wasm32)
    resetObserverCounts()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getObserverStats")
@_cdecl("bjs_getObserverStats")
public func _bjs_getObserverStats() -> Void {
    #if arch(wasm32)
    let ret = getObserverStats()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(nameBytes: Int32, nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_changeName")
@_cdecl("bjs_Greeter_changeName")
public func _bjs_Greeter_changeName(_self: UnsafeMutableRawPointer, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).changeName(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_get")
@_cdecl("bjs_Greeter_name_get")
public func _bjs_Greeter_name_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_set")
@_cdecl("bjs_Greeter_name_set")
public func _bjs_Greeter_name_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_prefix_get")
@_cdecl("bjs_Greeter_prefix_get")
public func _bjs_Greeter_prefix_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).prefix
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Greeter>.fromOpaque(pointer).release()
}

extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Greeter_wrap")
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_Calculator_square")
@_cdecl("bjs_Calculator_square")
public func _bjs_Calculator_square(_self: UnsafeMutableRawPointer, value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Calculator.bridgeJSLiftParameter(_self).square(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_add")
@_cdecl("bjs_Calculator_add")
public func _bjs_Calculator_add(_self: UnsafeMutableRawPointer, a: Int32, b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Calculator.bridgeJSLiftParameter(_self).add(a: Int.bridgeJSLiftParameter(a), b: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_deinit")
@_cdecl("bjs_Calculator_deinit")
public func _bjs_Calculator_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Calculator>.fromOpaque(pointer).release()
}

extension Calculator: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Calculator_wrap")
        func _bjs_Calculator_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_Calculator_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Calculator_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_InternalGreeter_deinit")
@_cdecl("bjs_InternalGreeter_deinit")
public func _bjs_InternalGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<InternalGreeter>.fromOpaque(pointer).release()
}

extension InternalGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    internal var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_InternalGreeter_wrap")
        func _bjs_InternalGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_InternalGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_InternalGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_PublicGreeter_deinit")
@_cdecl("bjs_PublicGreeter_deinit")
public func _bjs_PublicGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PublicGreeter>.fromOpaque(pointer).release()
}

extension PublicGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    public var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_PublicGreeter_wrap")
        func _bjs_PublicGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_PublicGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PublicGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_PackageGreeter_deinit")
@_cdecl("bjs_PackageGreeter_deinit")
public func _bjs_PackageGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PackageGreeter>.fromOpaque(pointer).release()
}

extension PackageGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    package var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_PackageGreeter_wrap")
        func _bjs_PackageGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_PackageGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PackageGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_Converter_init")
@_cdecl("bjs_Converter_init")
public func _bjs_Converter_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Utils.Converter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_toString")
@_cdecl("bjs_Converter_toString")
public func _bjs_Converter_toString(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    let ret = Utils.Converter.bridgeJSLiftParameter(_self).toString(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_deinit")
@_cdecl("bjs_Converter_deinit")
public func _bjs_Converter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Utils.Converter>.fromOpaque(pointer).release()
}

extension Utils.Converter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Converter_wrap")
        func _bjs_Converter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_Converter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Converter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_HTTPServer_init")
@_cdecl("bjs_HTTPServer_init")
public func _bjs_HTTPServer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Networking.API.HTTPServer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_HTTPServer_call")
@_cdecl("bjs_HTTPServer_call")
public func _bjs_HTTPServer_call(_self: UnsafeMutableRawPointer, method: Int32) -> Void {
    #if arch(wasm32)
    Networking.API.HTTPServer.bridgeJSLiftParameter(_self).call(_: Networking.API.Method.bridgeJSLiftParameter(method))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_HTTPServer_deinit")
@_cdecl("bjs_HTTPServer_deinit")
public func _bjs_HTTPServer_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Networking.API.HTTPServer>.fromOpaque(pointer).release()
}

extension Networking.API.HTTPServer: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_HTTPServer_wrap")
        func _bjs_HTTPServer_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_HTTPServer_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_HTTPServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_TestServer_init")
@_cdecl("bjs_TestServer_init")
public func _bjs_TestServer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Internal.TestServer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestServer_call")
@_cdecl("bjs_TestServer_call")
public func _bjs_TestServer_call(_self: UnsafeMutableRawPointer, method: Int32) -> Void {
    #if arch(wasm32)
    Internal.TestServer.bridgeJSLiftParameter(_self).call(_: Internal.SupportedMethod.bridgeJSLiftParameter(method))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestServer_deinit")
@_cdecl("bjs_TestServer_deinit")
public func _bjs_TestServer_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Internal.TestServer>.fromOpaque(pointer).release()
}

extension Internal.TestServer: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_TestServer_wrap")
        func _bjs_TestServer_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_TestServer_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TestServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_SimplePropertyHolder_init")
@_cdecl("bjs_SimplePropertyHolder_init")
public func _bjs_SimplePropertyHolder_init(value: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = SimplePropertyHolder(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimplePropertyHolder_value_get")
@_cdecl("bjs_SimplePropertyHolder_value_get")
public func _bjs_SimplePropertyHolder_value_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SimplePropertyHolder.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimplePropertyHolder_value_set")
@_cdecl("bjs_SimplePropertyHolder_value_set")
public func _bjs_SimplePropertyHolder_value_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    SimplePropertyHolder.bridgeJSLiftParameter(_self).value = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimplePropertyHolder_deinit")
@_cdecl("bjs_SimplePropertyHolder_deinit")
public func _bjs_SimplePropertyHolder_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<SimplePropertyHolder>.fromOpaque(pointer).release()
}

extension SimplePropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SimplePropertyHolder_wrap")
        func _bjs_SimplePropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_SimplePropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_SimplePropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_PropertyHolder_init")
@_cdecl("bjs_PropertyHolder_init")
public func _bjs_PropertyHolder_init(intValue: Int32, floatValue: Float32, doubleValue: Float64, boolValue: Int32, stringValueBytes: Int32, stringValueLength: Int32, jsObject: Int32, sibling: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PropertyHolder(intValue: Int.bridgeJSLiftParameter(intValue), floatValue: Float.bridgeJSLiftParameter(floatValue), doubleValue: Double.bridgeJSLiftParameter(doubleValue), boolValue: Bool.bridgeJSLiftParameter(boolValue), stringValue: String.bridgeJSLiftParameter(stringValueBytes, stringValueLength), jsObject: JSObject.bridgeJSLiftParameter(jsObject), sibling: SimplePropertyHolder.bridgeJSLiftParameter(sibling))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_getAllValues")
@_cdecl("bjs_PropertyHolder_getAllValues")
public func _bjs_PropertyHolder_getAllValues(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).getAllValues()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_get")
@_cdecl("bjs_PropertyHolder_intValue_get")
public func _bjs_PropertyHolder_intValue_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).intValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_set")
@_cdecl("bjs_PropertyHolder_intValue_set")
public func _bjs_PropertyHolder_intValue_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).intValue = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_get")
@_cdecl("bjs_PropertyHolder_floatValue_get")
public func _bjs_PropertyHolder_floatValue_get(_self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).floatValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_set")
@_cdecl("bjs_PropertyHolder_floatValue_set")
public func _bjs_PropertyHolder_floatValue_set(_self: UnsafeMutableRawPointer, value: Float32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).floatValue = Float.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_get")
@_cdecl("bjs_PropertyHolder_doubleValue_get")
public func _bjs_PropertyHolder_doubleValue_get(_self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).doubleValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_set")
@_cdecl("bjs_PropertyHolder_doubleValue_set")
public func _bjs_PropertyHolder_doubleValue_set(_self: UnsafeMutableRawPointer, value: Float64) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).doubleValue = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_get")
@_cdecl("bjs_PropertyHolder_boolValue_get")
public func _bjs_PropertyHolder_boolValue_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).boolValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_set")
@_cdecl("bjs_PropertyHolder_boolValue_set")
public func _bjs_PropertyHolder_boolValue_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).boolValue = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_get")
@_cdecl("bjs_PropertyHolder_stringValue_get")
public func _bjs_PropertyHolder_stringValue_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).stringValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_set")
@_cdecl("bjs_PropertyHolder_stringValue_set")
public func _bjs_PropertyHolder_stringValue_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).stringValue = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyInt_get")
@_cdecl("bjs_PropertyHolder_readonlyInt_get")
public func _bjs_PropertyHolder_readonlyInt_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyInt
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyFloat_get")
@_cdecl("bjs_PropertyHolder_readonlyFloat_get")
public func _bjs_PropertyHolder_readonlyFloat_get(_self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyFloat
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyDouble_get")
@_cdecl("bjs_PropertyHolder_readonlyDouble_get")
public func _bjs_PropertyHolder_readonlyDouble_get(_self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyDouble
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyBool_get")
@_cdecl("bjs_PropertyHolder_readonlyBool_get")
public func _bjs_PropertyHolder_readonlyBool_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyBool
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyString_get")
@_cdecl("bjs_PropertyHolder_readonlyString_get")
public func _bjs_PropertyHolder_readonlyString_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyString
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_get")
@_cdecl("bjs_PropertyHolder_jsObject_get")
public func _bjs_PropertyHolder_jsObject_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_set")
@_cdecl("bjs_PropertyHolder_jsObject_set")
public func _bjs_PropertyHolder_jsObject_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).jsObject = JSObject.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_get")
@_cdecl("bjs_PropertyHolder_sibling_get")
public func _bjs_PropertyHolder_sibling_get(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).sibling
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_set")
@_cdecl("bjs_PropertyHolder_sibling_set")
public func _bjs_PropertyHolder_sibling_set(_self: UnsafeMutableRawPointer, value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).sibling = SimplePropertyHolder.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_get")
@_cdecl("bjs_PropertyHolder_lazyValue_get")
public func _bjs_PropertyHolder_lazyValue_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).lazyValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_set")
@_cdecl("bjs_PropertyHolder_lazyValue_set")
public func _bjs_PropertyHolder_lazyValue_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).lazyValue = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadonly_get")
@_cdecl("bjs_PropertyHolder_computedReadonly_get")
public func _bjs_PropertyHolder_computedReadonly_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).computedReadonly
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_get")
@_cdecl("bjs_PropertyHolder_computedReadWrite_get")
public func _bjs_PropertyHolder_computedReadWrite_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).computedReadWrite
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_set")
@_cdecl("bjs_PropertyHolder_computedReadWrite_set")
public func _bjs_PropertyHolder_computedReadWrite_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).computedReadWrite = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_get")
@_cdecl("bjs_PropertyHolder_observedProperty_get")
public func _bjs_PropertyHolder_observedProperty_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).observedProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_set")
@_cdecl("bjs_PropertyHolder_observedProperty_set")
public func _bjs_PropertyHolder_observedProperty_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).observedProperty = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_deinit")
@_cdecl("bjs_PropertyHolder_deinit")
public func _bjs_PropertyHolder_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PropertyHolder>.fromOpaque(pointer).release()
}

extension PropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_PropertyHolder_wrap")
        func _bjs_PropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_PropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}