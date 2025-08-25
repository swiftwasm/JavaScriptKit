// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

fileprivate enum _BJSParamType: UInt8 {
    case string = 1
    case int32 = 2
    case bool = 3
    case float32 = 4
    case float64 = 5
}

fileprivate struct _BJSBinaryReader {
    let raw: UnsafeRawBufferPointer
    var offset: Int = 0

    @inline(__always)
    mutating func readUInt8() -> UInt8 {
        let b = raw[offset]
        offset += 1
        return b
    }

    @inline(__always)
    mutating func readUInt32() -> UInt32 {
        var v = UInt32(0)
        withUnsafeMutableBytes(of: &v) { dst in
            dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 4)]))
        }
        offset += 4
        return UInt32(littleEndian: v)
    }

    @inline(__always)
    mutating func readInt32() -> Int32 {
        var v = Int32(0)
        withUnsafeMutableBytes(of: &v) { dst in
            dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 4)]))
        }
        offset += 4
        return Int32(littleEndian: v)
    }

    @inline(__always)
    mutating func readFloat32() -> Float32 {
        var bits = UInt32(0)
        withUnsafeMutableBytes(of: &bits) { dst in
            dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 4)]))
        }
        offset += 4
        return Float32(bitPattern: UInt32(littleEndian: bits))
    }

    @inline(__always)
    mutating func readFloat64() -> Float64 {
        var bits = UInt64(0)
        withUnsafeMutableBytes(of: &bits) { dst in
            dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 8)]))
        }
        offset += 8
        return Float64(bitPattern: UInt64(littleEndian: bits))
    }

    @inline(__always)
    mutating func readString() -> String {
        let len = Int(readUInt32())
        let s = String(decoding: UnsafeBufferPointer(
            start: raw.baseAddress!.advanced(by: offset).assumingMemoryBound(to: UInt8.self),
            count: len
        ), as: UTF8.self)
        offset += len
        return s
    }

    @inline(__always)
    mutating func expectTag(_ expected: _BJSParamType) {
        let rawTag = readUInt8()
        guard let got = _BJSParamType(rawValue: rawTag), got == expected else {
            preconditionFailure("BridgeJS: mismatched enum param tag. Expected \(expected) got \(String(describing: _BJSParamType(rawValue: rawTag)))")
        }
    }

    @inline(__always)
    mutating func readParamCount(expected: Int) {
        let count = Int(readUInt32())
        precondition(count == expected, "BridgeJS: mismatched enum param count. Expected \(expected) got \(count)")
    }
}

@_extern(wasm, module: "bjs", name: "swift_js_init_memory")
func _swift_js_init_memory(_: Int32, _: UnsafeMutablePointer<UInt8>)

@_extern(wasm, module: "bjs", name: "swift_js_return_tag")
func _swift_js_return_tag(_: Int32)
@_extern(wasm, module: "bjs", name: "swift_js_return_string")
func _swift_js_return_string(_: UnsafePointer<UInt8>?, _: Int32)
@_extern(wasm, module: "bjs", name: "swift_js_return_int")
func _swift_js_return_int(_: Int32)
@_extern(wasm, module: "bjs", name: "swift_js_return_f32")
func _swift_js_return_f32(_: Float32)
@_extern(wasm, module: "bjs", name: "swift_js_return_f64")
func _swift_js_return_f64(_: Float64)
@_extern(wasm, module: "bjs", name: "swift_js_return_bool")
func _swift_js_return_bool(_: Int32)

extension Direction {
    init?(bridgeJSRawValue: Int32) {
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

    var bridgeJSRawValue: Int32 {
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
    init?(bridgeJSRawValue: Int32) {
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

    var bridgeJSRawValue: Int32 {
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

extension TSDirection {
    init?(bridgeJSRawValue: Int32) {
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

    var bridgeJSRawValue: Int32 {
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

extension Networking.API.Method {
    init?(bridgeJSRawValue: Int32) {
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

    var bridgeJSRawValue: Int32 {
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

extension Internal.SupportedMethod {
    init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .get
        case 1:
            self = .post
        default:
            return nil
        }
    }

    var bridgeJSRawValue: Int32 {
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
    let ret = roundTripInt(v: Int(v))
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripFloat")
@_cdecl("bjs_roundTripFloat")
public func _bjs_roundTripFloat(v: Float32) -> Float32 {
    #if arch(wasm32)
    let ret = roundTripFloat(v: v)
    return Float32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDouble")
@_cdecl("bjs_roundTripDouble")
public func _bjs_roundTripDouble(v: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = roundTripDouble(v: v)
    return Float64(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripBool")
@_cdecl("bjs_roundTripBool")
public func _bjs_roundTripBool(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripBool(v: v == 1)
    return Int32(ret ? 1 : 0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripString")
@_cdecl("bjs_roundTripString")
public func _bjs_roundTripString(vBytes: Int32, vLen: Int32) -> Void {
    #if arch(wasm32)
    let v = String(unsafeUninitializedCapacity: Int(vLen)) { b in
        _swift_js_init_memory(vBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(vLen)
    }
    var ret = roundTripString(v: v)
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSwiftHeapObject")
@_cdecl("bjs_roundTripSwiftHeapObject")
public func _bjs_roundTripSwiftHeapObject(v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripSwiftHeapObject(v: Unmanaged<Greeter>.fromOpaque(v).takeUnretainedValue())
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSObject")
@_cdecl("bjs_roundTripJSObject")
public func _bjs_roundTripJSObject(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripJSObject(v: JSObject(id: UInt32(bitPattern: v)))
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsSwiftError")
@_cdecl("bjs_throwsSwiftError")
public func _bjs_throwsSwiftError(shouldThrow: Int32) -> Void {
    #if arch(wasm32)
    do {
        try throwsSwiftError(shouldThrow: shouldThrow == 1)
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
        return Int32(ret)
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
        var ret = try throwsWithStringResult()
        return ret.withUTF8 { ptr in
            _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
        }
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
        return Int32(ret ? 1 : 0)
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
        return Float32(ret)
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
        return Float64(ret)
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
        return Unmanaged.passRetained(ret).toOpaque()
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
        return _swift_js_retain(Int32(bitPattern: ret.id))
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
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripInt")
@_cdecl("bjs_asyncRoundTripInt")
public func _bjs_asyncRoundTripInt(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripInt(v: Int(v)).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripFloat")
@_cdecl("bjs_asyncRoundTripFloat")
public func _bjs_asyncRoundTripFloat(v: Float32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripFloat(v: v).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripDouble")
@_cdecl("bjs_asyncRoundTripDouble")
public func _bjs_asyncRoundTripDouble(v: Float64) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripDouble(v: v).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripBool")
@_cdecl("bjs_asyncRoundTripBool")
public func _bjs_asyncRoundTripBool(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripBool(v: v == 1).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripString")
@_cdecl("bjs_asyncRoundTripString")
public func _bjs_asyncRoundTripString(vBytes: Int32, vLen: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        let v = String(unsafeUninitializedCapacity: Int(vLen)) { b in
            _swift_js_init_memory(vBytes, b.baseAddress.unsafelyUnwrapped)
            return Int(vLen)
        }
        return await asyncRoundTripString(v: v).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripSwiftHeapObject")
@_cdecl("bjs_asyncRoundTripSwiftHeapObject")
public func _bjs_asyncRoundTripSwiftHeapObject(v: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripSwiftHeapObject(v: Unmanaged<Greeter>.fromOpaque(v).takeUnretainedValue()).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripJSObject")
@_cdecl("bjs_asyncRoundTripJSObject")
public func _bjs_asyncRoundTripJSObject(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripJSObject(v: JSObject(id: UInt32(bitPattern: v))).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeGreeter")
@_cdecl("bjs_takeGreeter")
public func _bjs_takeGreeter(g: UnsafeMutableRawPointer, nameBytes: Int32, nameLen: Int32) -> Void {
    #if arch(wasm32)
    let name = String(unsafeUninitializedCapacity: Int(nameLen)) { b in
        _swift_js_init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(nameLen)
    }
    takeGreeter(g: Unmanaged<Greeter>.fromOpaque(g).takeUnretainedValue(), name: name)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createCalculator")
@_cdecl("bjs_createCalculator")
public func _bjs_createCalculator() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createCalculator()
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_useCalculator")
@_cdecl("bjs_useCalculator")
public func _bjs_useCalculator(calc: UnsafeMutableRawPointer, x: Int32, y: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = useCalculator(calc: Unmanaged<Calculator>.fromOpaque(calc).takeUnretainedValue(), x: Int(x), y: Int(y))
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testGreeterToJSValue")
@_cdecl("bjs_testGreeterToJSValue")
public func _bjs_testGreeterToJSValue() -> Int32 {
    #if arch(wasm32)
    let ret = testGreeterToJSValue()
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testCalculatorToJSValue")
@_cdecl("bjs_testCalculatorToJSValue")
public func _bjs_testCalculatorToJSValue() -> Int32 {
    #if arch(wasm32)
    let ret = testCalculatorToJSValue()
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testSwiftClassAsJSValue")
@_cdecl("bjs_testSwiftClassAsJSValue")
public func _bjs_testSwiftClassAsJSValue(greeter: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = testSwiftClassAsJSValue(greeter: Unmanaged<Greeter>.fromOpaque(greeter).takeUnretainedValue())
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setDirection")
@_cdecl("bjs_setDirection")
public func _bjs_setDirection(direction: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = setDirection(_: Direction(bridgeJSRawValue: direction)!)
    return ret.bridgeJSRawValue
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getDirection")
@_cdecl("bjs_getDirection")
public func _bjs_getDirection() -> Int32 {
    #if arch(wasm32)
    let ret = getDirection()
    return ret.bridgeJSRawValue
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processDirection")
@_cdecl("bjs_processDirection")
public func _bjs_processDirection(input: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processDirection(_: Direction(bridgeJSRawValue: input)!)
    return ret.bridgeJSRawValue
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTheme")
@_cdecl("bjs_setTheme")
public func _bjs_setTheme(themeBytes: Int32, themeLen: Int32) -> Void {
    #if arch(wasm32)
    let theme = String(unsafeUninitializedCapacity: Int(themeLen)) { b in
        _swift_js_init_memory(themeBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(themeLen)
    }
    let ret = setTheme(_: Theme(rawValue: theme)!)
    var rawValue = ret.rawValue
    return rawValue.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTheme")
@_cdecl("bjs_getTheme")
public func _bjs_getTheme() -> Void {
    #if arch(wasm32)
    let ret = getTheme()
    var rawValue = ret.rawValue
    return rawValue.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setHttpStatus")
@_cdecl("bjs_setHttpStatus")
public func _bjs_setHttpStatus(status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = setHttpStatus(_: HttpStatus(rawValue: Int(status))!)
    return Int32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getHttpStatus")
@_cdecl("bjs_getHttpStatus")
public func _bjs_getHttpStatus() -> Int32 {
    #if arch(wasm32)
    let ret = getHttpStatus()
    return Int32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processTheme")
@_cdecl("bjs_processTheme")
public func _bjs_processTheme(themeBytes: Int32, themeLen: Int32) -> Int32 {
    #if arch(wasm32)
    let theme = String(unsafeUninitializedCapacity: Int(themeLen)) { b in
        _swift_js_init_memory(themeBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(themeLen)
    }
    let ret = processTheme(_: Theme(rawValue: theme)!)
    return Int32(ret.rawValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTSDirection")
@_cdecl("bjs_setTSDirection")
public func _bjs_setTSDirection(direction: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = setTSDirection(_: TSDirection(bridgeJSRawValue: direction)!)
    return ret.bridgeJSRawValue
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTSDirection")
@_cdecl("bjs_getTSDirection")
public func _bjs_getTSDirection() -> Int32 {
    #if arch(wasm32)
    let ret = getTSDirection()
    return ret.bridgeJSRawValue
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTSTheme")
@_cdecl("bjs_setTSTheme")
public func _bjs_setTSTheme(themeBytes: Int32, themeLen: Int32) -> Void {
    #if arch(wasm32)
    let theme = String(unsafeUninitializedCapacity: Int(themeLen)) { b in
        _swift_js_init_memory(themeBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(themeLen)
    }
    let ret = setTSTheme(_: TSTheme(rawValue: theme)!)
    var rawValue = ret.rawValue
    return rawValue.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTSTheme")
@_cdecl("bjs_getTSTheme")
public func _bjs_getTSTheme() -> Void {
    #if arch(wasm32)
    let ret = getTSTheme()
    var rawValue = ret.rawValue
    return rawValue.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_echoAPIResult")
@_cdecl("bjs_echoAPIResult")
public func _bjs_echoAPIResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = echoAPIResult(result: APIResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultSuccess")
@_cdecl("bjs_makeAPIResultSuccess")
public func _bjs_makeAPIResultSuccess(valueBytes: Int32, valueLen: Int32) -> Void {
    #if arch(wasm32)
    let value = String(unsafeUninitializedCapacity: Int(valueLen)) { b in
        _swift_js_init_memory(valueBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(valueLen)
    }
    let ret = makeAPIResultSuccess(_: value)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultFailure")
@_cdecl("bjs_makeAPIResultFailure")
public func _bjs_makeAPIResultFailure(value: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultFailure(_: Int(value))
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultInfo")
@_cdecl("bjs_makeAPIResultInfo")
public func _bjs_makeAPIResultInfo() -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultInfo()
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultFlag")
@_cdecl("bjs_makeAPIResultFlag")
public func _bjs_makeAPIResultFlag(value: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultFlag(_: value == 1)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultRate")
@_cdecl("bjs_makeAPIResultRate")
public func _bjs_makeAPIResultRate(value: Float32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultRate(_: value)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultPrecise")
@_cdecl("bjs_makeAPIResultPrecise")
public func _bjs_makeAPIResultPrecise(value: Float64) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultPrecise(_: value)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_echoComplexResult")
@_cdecl("bjs_echoComplexResult")
public func _bjs_echoComplexResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = echoComplexResult(result: ComplexResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultSuccess")
@_cdecl("bjs_makeComplexResultSuccess")
public func _bjs_makeComplexResultSuccess(valueBytes: Int32, valueLen: Int32) -> Void {
    #if arch(wasm32)
    let value = String(unsafeUninitializedCapacity: Int(valueLen)) { b in
        _swift_js_init_memory(valueBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(valueLen)
    }
    let ret = makeComplexResultSuccess(_: value)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultError")
@_cdecl("bjs_makeComplexResultError")
public func _bjs_makeComplexResultError(messageBytes: Int32, messageLen: Int32, code: Int32) -> Void {
    #if arch(wasm32)
    let message = String(unsafeUninitializedCapacity: Int(messageLen)) { b in
        _swift_js_init_memory(messageBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(messageLen)
    }
    let ret = makeComplexResultError(_: message, _: Int(code))
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultLocation")
@_cdecl("bjs_makeComplexResultLocation")
public func _bjs_makeComplexResultLocation(lat: Float64, lng: Float64, nameBytes: Int32, nameLen: Int32) -> Void {
    #if arch(wasm32)
    let name = String(unsafeUninitializedCapacity: Int(nameLen)) { b in
        _swift_js_init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(nameLen)
    }
    let ret = makeComplexResultLocation(_: lat, _: lng, _: name)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultStatus")
@_cdecl("bjs_makeComplexResultStatus")
public func _bjs_makeComplexResultStatus(active: Int32, code: Int32, messageBytes: Int32, messageLen: Int32) -> Void {
    #if arch(wasm32)
    let message = String(unsafeUninitializedCapacity: Int(messageLen)) { b in
        _swift_js_init_memory(messageBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(messageLen)
    }
    let ret = makeComplexResultStatus(_: active == 1, _: Int(code), _: message)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultCoordinates")
@_cdecl("bjs_makeComplexResultCoordinates")
public func _bjs_makeComplexResultCoordinates(x: Float64, y: Float64, z: Float64) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultCoordinates(_: x, _: y, _: z)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultComprehensive")
@_cdecl("bjs_makeComplexResultComprehensive")
public func _bjs_makeComplexResultComprehensive(flag1: Int32, flag2: Int32, count1: Int32, count2: Int32, value1: Float64, value2: Float64, text1Bytes: Int32, text1Len: Int32, text2Bytes: Int32, text2Len: Int32, text3Bytes: Int32, text3Len: Int32) -> Void {
    #if arch(wasm32)
    let text1 = String(unsafeUninitializedCapacity: Int(text1Len)) { b in
        _swift_js_init_memory(text1Bytes, b.baseAddress.unsafelyUnwrapped)
        return Int(text1Len)
    }
    let text2 = String(unsafeUninitializedCapacity: Int(text2Len)) { b in
        _swift_js_init_memory(text2Bytes, b.baseAddress.unsafelyUnwrapped)
        return Int(text2Len)
    }
    let text3 = String(unsafeUninitializedCapacity: Int(text3Len)) { b in
        _swift_js_init_memory(text3Bytes, b.baseAddress.unsafelyUnwrapped)
        return Int(text3Len)
    }
    let ret = makeComplexResultComprehensive(_: flag1 == 1, _: flag2 == 1, _: Int(count1), _: Int(count2), _: value1, _: value2, _: text1, _: text2, _: text3)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultInfo")
@_cdecl("bjs_makeComplexResultInfo")
public func _bjs_makeComplexResultInfo() -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultInfo()
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripComplexResult")
@_cdecl("bjs_roundtripComplexResult")
public func _bjs_roundtripComplexResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripComplexResult(_: ComplexResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultSuccess")
@_cdecl("bjs_makeUtilitiesResultSuccess")
public func _bjs_makeUtilitiesResultSuccess(messageBytes: Int32, messageLen: Int32) -> Void {
    #if arch(wasm32)
    let message = String(unsafeUninitializedCapacity: Int(messageLen)) { b in
        _swift_js_init_memory(messageBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(messageLen)
    }
    let ret = makeUtilitiesResultSuccess(_: message)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultFailure")
@_cdecl("bjs_makeUtilitiesResultFailure")
public func _bjs_makeUtilitiesResultFailure(errorBytes: Int32, errorLen: Int32, code: Int32) -> Void {
    #if arch(wasm32)
    let error = String(unsafeUninitializedCapacity: Int(errorLen)) { b in
        _swift_js_init_memory(errorBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(errorLen)
    }
    let ret = makeUtilitiesResultFailure(_: error, _: Int(code))
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultStatus")
@_cdecl("bjs_makeUtilitiesResultStatus")
public func _bjs_makeUtilitiesResultStatus(active: Int32, code: Int32, messageBytes: Int32, messageLen: Int32) -> Void {
    #if arch(wasm32)
    let message = String(unsafeUninitializedCapacity: Int(messageLen)) { b in
        _swift_js_init_memory(messageBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(messageLen)
    }
    let ret = makeUtilitiesResultStatus(_: active == 1, _: Int(code), _: message)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPINetworkingResultSuccess")
@_cdecl("bjs_makeAPINetworkingResultSuccess")
public func _bjs_makeAPINetworkingResultSuccess(messageBytes: Int32, messageLen: Int32) -> Void {
    #if arch(wasm32)
    let message = String(unsafeUninitializedCapacity: Int(messageLen)) { b in
        _swift_js_init_memory(messageBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(messageLen)
    }
    let ret = makeAPINetworkingResultSuccess(_: message)
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPINetworkingResultFailure")
@_cdecl("bjs_makeAPINetworkingResultFailure")
public func _bjs_makeAPINetworkingResultFailure(errorBytes: Int32, errorLen: Int32, code: Int32) -> Void {
    #if arch(wasm32)
    let error = String(unsafeUninitializedCapacity: Int(errorLen)) { b in
        _swift_js_init_memory(errorBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(errorLen)
    }
    let ret = makeAPINetworkingResultFailure(_: error, _: Int(code))
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripUtilitiesResult")
@_cdecl("bjs_roundtripUtilitiesResult")
public func _bjs_roundtripUtilitiesResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripUtilitiesResult(_: Utilities.Result.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripAPINetworkingResult")
@_cdecl("bjs_roundtripAPINetworkingResult")
public func _bjs_roundtripAPINetworkingResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripAPINetworkingResult(_: API.NetworkingResult.bridgeJSLiftParameter(resultCaseId, resultParamsId, resultParamsLen))
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(nameBytes: Int32, nameLen: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let name = String(unsafeUninitializedCapacity: Int(nameLen)) { b in
        _swift_js_init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(nameLen)
    }
    let ret = Greeter(name: name)
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<Greeter>.fromOpaque(_self).takeUnretainedValue().greet()
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_changeName")
@_cdecl("bjs_Greeter_changeName")
public func _bjs_Greeter_changeName(_self: UnsafeMutableRawPointer, nameBytes: Int32, nameLen: Int32) -> Void {
    #if arch(wasm32)
    let name = String(unsafeUninitializedCapacity: Int(nameLen)) { b in
        _swift_js_init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(nameLen)
    }
    Unmanaged<Greeter>.fromOpaque(_self).takeUnretainedValue().changeName(name: name)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Greeter>.fromOpaque(pointer).release()
}

extension Greeter: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Greeter_wrap")
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_Calculator_square")
@_cdecl("bjs_Calculator_square")
public func _bjs_Calculator_square(_self: UnsafeMutableRawPointer, value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<Calculator>.fromOpaque(_self).takeUnretainedValue().square(value: Int(value))
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_add")
@_cdecl("bjs_Calculator_add")
public func _bjs_Calculator_add(_self: UnsafeMutableRawPointer, a: Int32, b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<Calculator>.fromOpaque(_self).takeUnretainedValue().add(a: Int(a), b: Int(b))
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_deinit")
@_cdecl("bjs_Calculator_deinit")
public func _bjs_Calculator_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Calculator>.fromOpaque(pointer).release()
}

extension Calculator: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Calculator_wrap")
        func _bjs_Calculator_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Calculator_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_Converter_init")
@_cdecl("bjs_Converter_init")
public func _bjs_Converter_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Utils.Converter()
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_toString")
@_cdecl("bjs_Converter_toString")
public func _bjs_Converter_toString(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<Utils.Converter>.fromOpaque(_self).takeUnretainedValue().toString(value: Int(value))
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_deinit")
@_cdecl("bjs_Converter_deinit")
public func _bjs_Converter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Utils.Converter>.fromOpaque(pointer).release()
}

extension Utils.Converter: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Converter_wrap")
        func _bjs_Converter_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Converter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_HTTPServer_init")
@_cdecl("bjs_HTTPServer_init")
public func _bjs_HTTPServer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Networking.API.HTTPServer()
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_HTTPServer_call")
@_cdecl("bjs_HTTPServer_call")
public func _bjs_HTTPServer_call(_self: UnsafeMutableRawPointer, method: Int32) -> Void {
    #if arch(wasm32)
    Unmanaged<Networking.API.HTTPServer>.fromOpaque(_self).takeUnretainedValue().call(_: Networking.API.Method(bridgeJSRawValue: method)!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_HTTPServer_deinit")
@_cdecl("bjs_HTTPServer_deinit")
public func _bjs_HTTPServer_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Networking.API.HTTPServer>.fromOpaque(pointer).release()
}

extension Networking.API.HTTPServer: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_HTTPServer_wrap")
        func _bjs_HTTPServer_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_HTTPServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_TestServer_init")
@_cdecl("bjs_TestServer_init")
public func _bjs_TestServer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Internal.TestServer()
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestServer_call")
@_cdecl("bjs_TestServer_call")
public func _bjs_TestServer_call(_self: UnsafeMutableRawPointer, method: Int32) -> Void {
    #if arch(wasm32)
    Unmanaged<Internal.TestServer>.fromOpaque(_self).takeUnretainedValue().call(_: Internal.SupportedMethod(bridgeJSRawValue: method)!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestServer_deinit")
@_cdecl("bjs_TestServer_deinit")
public func _bjs_TestServer_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Internal.TestServer>.fromOpaque(pointer).release()
}

extension Internal.TestServer: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_TestServer_wrap")
        func _bjs_TestServer_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TestServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}