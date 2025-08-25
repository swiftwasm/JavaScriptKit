// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

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
        case .status(let param0, let param1, let param2):
    _swift_js_return_tag(Int32(2))
            _swift_js_return_bool(param0 ? 1 : 0)
            _swift_js_return_int(Int32(param1))
            var mutableParam2 = param2
mutableParam2.withUTF8 { ptr in
    _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
}
        case .info:
    _swift_js_return_tag(Int32(3))
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

                static func constructFromComplexResult_2(param0: Int32, param1: Int32, param2: String) -> ComplexResult { 
    return .status((param0 != 0), Int(param1), param2) 
}

                static func constructFromComplexResult_3() -> ComplexResult { 
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
    let param0 = Int32(params["param0"] as! Bool ? 1 : 0); let param1 = params["param1"] as! Int32; let param2 = params["param2"] as! String
    return constructFromComplexResult_2(param0: param0, param1: param1, param2: param2)
                    case 3: return constructFromComplexResult_3()
        default: fatalError("Unknown ComplexResult case ID: \(caseId)")
        }
    }
}

@_expose(wasm, "bjs_handle")
@_cdecl("bjs_handle")
public func _bjs_handle(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    handle(result: APIResult.dispatchConstruct(resultCaseId, resultParamsId, resultParamsLen))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getResult")
@_cdecl("bjs_getResult")
public func _bjs_getResult() -> Void {
    #if arch(wasm32)
    let ret = getResult()
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_handleComplex")
@_cdecl("bjs_handleComplex")
public func _bjs_handleComplex(resultCaseId: Int32, resultParamsId: Int32, resultParamsLen: Int32) -> Void {
    #if arch(wasm32)
    handleComplex(result: ComplexResult.dispatchConstruct(resultCaseId, resultParamsId, resultParamsLen))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getComplexResult")
@_cdecl("bjs_getComplexResult")
public func _bjs_getComplexResult() -> Void {
    #if arch(wasm32)
    let ret = getComplexResult()
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}