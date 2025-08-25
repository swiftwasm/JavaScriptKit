// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

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

import Foundation

extension APIResult {
    func bridgeJSReturn() {
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
        switch self {
        case .success(let param0):
    _swift_js_return_tag(Int32(0))
            var mutableParam0 = param0
mutableParam0.withUTF8 { ptr in
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

extension APIResult {
    static func constructFromAPIResult_0(param0: String) -> APIResult { 
    return .success(param0) 
}

                static func constructFromAPIResult_1(param0: Int32) -> APIResult { 
    return .failure(Int(param0)) 
}

                static func constructFromAPIResult_2(param0: Int32) -> APIResult { 
    return .flag((param0 != 0)) 
}

                static func constructFromAPIResult_3(param0: Float32) -> APIResult { 
    return .rate(param0) 
}

                static func constructFromAPIResult_4(param0: Float64) -> APIResult { 
    return .precise(param0) 
}

                static func constructFromAPIResult_5() -> APIResult { 
    return .info 
}
    
    static func dispatchConstruct(_ caseId: Int32, _ paramsId: Int32, _ paramsLen: Int32) -> APIResult {
        let paramsString = String(unsafeUninitializedCapacity: Int(paramsLen)) { buf in
            _swift_js_init_memory(paramsId, buf.baseAddress.unsafelyUnwrapped)
            return Int(paramsLen)
        }
        return dispatchConstructFromJson(caseId, paramsString)
    }
    
    static func dispatchConstructFromJson(_ caseId: Int32, _ paramsJson: String) -> APIResult {
        switch caseId {
        case 0: 
    guard let data = paramsJson.data(using: .utf8),
          let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        fatalError("Failed to parse parameters JSON")
    }
    let param0 = params["param0"] as! String
    return constructFromAPIResult_0(param0: param0)
                    case 1: 
    guard let data = paramsJson.data(using: .utf8),
          let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        fatalError("Failed to parse parameters JSON")
    }
    let param0 = params["param0"] as! Int32
    return constructFromAPIResult_1(param0: param0)
                    case 2: 
    guard let data = paramsJson.data(using: .utf8),
          let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        fatalError("Failed to parse parameters JSON")
    }
    let param0 = Int32(params["param0"] as! Bool ? 1 : 0)
    return constructFromAPIResult_2(param0: param0)
                    case 3: 
    guard let data = paramsJson.data(using: .utf8),
          let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        fatalError("Failed to parse parameters JSON")
    }
    let param0 = params["param0"] as! Float32
    return constructFromAPIResult_3(param0: param0)
                    case 4: 
    guard let data = paramsJson.data(using: .utf8),
          let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        fatalError("Failed to parse parameters JSON")
    }
    let param0 = params["param0"] as! Float64
    return constructFromAPIResult_4(param0: param0)
                    case 5: return constructFromAPIResult_5()
        default: fatalError("Unknown APIResult case ID: \(caseId)")
        }
    }
}

import Foundation

extension ComplexResult {
    func bridgeJSReturn() {
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
        switch self {
        case .success(let param0):
    _swift_js_return_tag(Int32(0))
            var mutableParam0 = param0
mutableParam0.withUTF8 { ptr in
    _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
}
        case .error(let param0, let param1):
    _swift_js_return_tag(Int32(1))
            var mutableParam0 = param0
mutableParam0.withUTF8 { ptr in
    _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
}
            _swift_js_return_int(Int32(param1))
        case .location(let param0, let param1, let param2):
    _swift_js_return_tag(Int32(2))
            _swift_js_return_f64(param0)
            _swift_js_return_f64(param1)
            var mutableParam2 = param2
mutableParam2.withUTF8 { ptr in
    _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
}
        case .status(let param0, let param1, let param2):
    _swift_js_return_tag(Int32(3))
            _swift_js_return_bool(param0 ? 1 : 0)
            _swift_js_return_int(Int32(param1))
            var mutableParam2 = param2
mutableParam2.withUTF8 { ptr in
    _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
}
        case .info:
    _swift_js_return_tag(Int32(4))
        }
    }
}

extension ComplexResult {
    static func constructFromComplexResult_0(param0: String) -> ComplexResult { 
    return .success(param0) 
}

                static func constructFromComplexResult_1(param0: String, param1: Int32) -> ComplexResult { 
    return .error(param0, Int(param1)) 
}

                static func constructFromComplexResult_2(param0: Float64, param1: Float64, param2: String) -> ComplexResult { 
    return .location(param0, param1, param2) 
}

                static func constructFromComplexResult_3(param0: Int32, param1: Int32, param2: String) -> ComplexResult { 
    return .status((param0 != 0), Int(param1), param2) 
}

                static func constructFromComplexResult_4() -> ComplexResult { 
    return .info 
}
    
    static func dispatchConstruct(_ caseId: Int32, _ paramsId: Int32, _ paramsLen: Int32) -> ComplexResult {
        let paramsString = String(unsafeUninitializedCapacity: Int(paramsLen)) { buf in
            _swift_js_init_memory(paramsId, buf.baseAddress.unsafelyUnwrapped)
            return Int(paramsLen)
        }
        return dispatchConstructFromJson(caseId, paramsString)
    }
    
    static func dispatchConstructFromJson(_ caseId: Int32, _ paramsJson: String) -> ComplexResult {
        switch caseId {
        case 0: 
    guard let data = paramsJson.data(using: .utf8),
          let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        fatalError("Failed to parse parameters JSON")
    }
    let param0 = params["param0"] as! String
    return constructFromComplexResult_0(param0: param0)
                    case 1: 
    guard let data = paramsJson.data(using: .utf8),
          let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        fatalError("Failed to parse parameters JSON")
    }
    let param0 = params["param0"] as! String; let param1 = params["param1"] as! Int32
    return constructFromComplexResult_1(param0: param0, param1: param1)
                    case 2: 
    guard let data = paramsJson.data(using: .utf8),
          let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        fatalError("Failed to parse parameters JSON")
    }
    let param0 = params["param0"] as! Float64; let param1 = params["param1"] as! Float64; let param2 = params["param2"] as! String
    return constructFromComplexResult_2(param0: param0, param1: param1, param2: param2)
                    case 3: 
    guard let data = paramsJson.data(using: .utf8),
          let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        fatalError("Failed to parse parameters JSON")
    }
    let param0 = Int32(params["param0"] as! Bool ? 1 : 0); let param1 = params["param1"] as! Int32; let param2 = params["param2"] as! String
    return constructFromComplexResult_3(param0: param0, param1: param1, param2: param2)
                    case 4: return constructFromComplexResult_4()
        default: fatalError("Unknown ComplexResult case ID: \(caseId)")
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
    let ret = echoAPIResult(result: APIResult.dispatchConstruct(resultCaseId, resultParamsId, resultParamsLen))
    ret.bridgeJSReturn()
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
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultFailure")
@_cdecl("bjs_makeAPIResultFailure")
public func _bjs_makeAPIResultFailure(value: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultFailure(_: Int(value))
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultInfo")
@_cdecl("bjs_makeAPIResultInfo")
public func _bjs_makeAPIResultInfo() -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultInfo()
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultFlag")
@_cdecl("bjs_makeAPIResultFlag")
public func _bjs_makeAPIResultFlag(value: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultFlag(_: value == 1)
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultRate")
@_cdecl("bjs_makeAPIResultRate")
public func _bjs_makeAPIResultRate(value: Float32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultRate(_: value)
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultPrecise")
@_cdecl("bjs_makeAPIResultPrecise")
public func _bjs_makeAPIResultPrecise(value: Float64) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultPrecise(_: value)
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_echoComplexResult")
@_cdecl("bjs_echoComplexResult")
public func _bjs_echoComplexResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = echoComplexResult(result: ComplexResult.dispatchConstruct(resultCaseId, resultParamsId, resultParamsLen))
    ret.bridgeJSReturn()
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
    ret.bridgeJSReturn()
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
    ret.bridgeJSReturn()
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
    ret.bridgeJSReturn()
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
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultInfo")
@_cdecl("bjs_makeComplexResultInfo")
public func _bjs_makeComplexResultInfo() -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultInfo()
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripComplexResult")
@_cdecl("bjs_roundtripComplexResult")
public func _bjs_roundtripComplexResult(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripComplexResult(_: ComplexResult.dispatchConstruct(resultCaseId, resultParamsId, resultParamsLen))
    ret.bridgeJSReturn()
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