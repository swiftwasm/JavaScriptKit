// bridge-js: skip
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

extension SimpleStruct: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> SimpleStruct {
        let precise = Double.bridgeJSLiftParameter(_swift_js_pop_param_f64())
        let rate = Float.bridgeJSLiftParameter(_swift_js_pop_param_f32())
        let flag = Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let count = Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let name = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        return SimpleStruct(name: name, count: count, flag: flag, rate: rate, precise: precise)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        var __bjs_name = self.name
        __bjs_name.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        _swift_js_push_int(Int32(self.count))
        _swift_js_push_int(self.flag ? 1 : 0)
        _swift_js_push_f32(self.rate)
        _swift_js_push_f64(self.precise)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_SimpleStruct(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_raise_SimpleStruct()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_SimpleStruct")
fileprivate func _bjs_struct_lower_SimpleStruct(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_SimpleStruct(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_raise_SimpleStruct")
fileprivate func _bjs_struct_raise_SimpleStruct() -> Int32
#else
fileprivate func _bjs_struct_raise_SimpleStruct() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension Address: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Address {
        let zipCode = Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let city = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let street = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        return Address(street: street, city: city, zipCode: zipCode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        var __bjs_street = self.street
        __bjs_street.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        var __bjs_city = self.city
        __bjs_city.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        _swift_js_push_int(Int32(self.zipCode))
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Address(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_raise_Address()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Address")
fileprivate func _bjs_struct_lower_Address(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Address(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_raise_Address")
fileprivate func _bjs_struct_raise_Address() -> Int32
#else
fileprivate func _bjs_struct_raise_Address() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension Person: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Person {
        let email = Optional<String>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let address = Address.bridgeJSLiftParameter()
        let age = Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let name = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        return Person(name: name, age: age, address: address, email: email)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        var __bjs_name = self.name
        __bjs_name.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        _swift_js_push_int(Int32(self.age))
        self.address.bridgeJSLowerReturn()
        let __bjs_isSome_email = self.email != nil
        if let __bjs_unwrapped_email = self.email {
            var __bjs_str_email = __bjs_unwrapped_email
            __bjs_str_email.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        }
        _swift_js_push_int(__bjs_isSome_email ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Person(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_raise_Person()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Person")
fileprivate func _bjs_struct_lower_Person(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Person(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_raise_Person")
fileprivate func _bjs_struct_raise_Person() -> Int32
#else
fileprivate func _bjs_struct_raise_Person() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension ComplexStruct: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> ComplexStruct {
        let metadata = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let tags = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let score = Double.bridgeJSLiftParameter(_swift_js_pop_param_f64())
        let active = Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let title = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let id = Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        return ComplexStruct(id: id, title: title, active: active, score: score, tags: tags, metadata: metadata)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_int(Int32(self.id))
        var __bjs_title = self.title
        __bjs_title.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        _swift_js_push_int(self.active ? 1 : 0)
        _swift_js_push_f64(self.score)
        var __bjs_tags = self.tags
        __bjs_tags.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        var __bjs_metadata = self.metadata
        __bjs_metadata.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_ComplexStruct(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_raise_ComplexStruct()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ComplexStruct")
fileprivate func _bjs_struct_lower_ComplexStruct(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_ComplexStruct(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_raise_ComplexStruct")
fileprivate func _bjs_struct_raise_ComplexStruct() -> Int32
#else
fileprivate func _bjs_struct_raise_ComplexStruct() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
public func _bjs_EnumRoundtrip_take(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    EnumRoundtrip.bridgeJSLiftParameter(_self).take(_: APIResult.bridgeJSLiftParameter(value))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeSuccess")
@_cdecl("bjs_EnumRoundtrip_makeSuccess")
public func _bjs_EnumRoundtrip_makeSuccess(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeSuccess()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeFailure")
@_cdecl("bjs_EnumRoundtrip_makeFailure")
public func _bjs_EnumRoundtrip_makeFailure(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeFailure()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeFlag")
@_cdecl("bjs_EnumRoundtrip_makeFlag")
public func _bjs_EnumRoundtrip_makeFlag(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeFlag()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeRate")
@_cdecl("bjs_EnumRoundtrip_makeRate")
public func _bjs_EnumRoundtrip_makeRate(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeRate()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makePrecise")
@_cdecl("bjs_EnumRoundtrip_makePrecise")
public func _bjs_EnumRoundtrip_makePrecise(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makePrecise()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_makeInfo")
@_cdecl("bjs_EnumRoundtrip_makeInfo")
public func _bjs_EnumRoundtrip_makeInfo(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).makeInfo()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_roundtrip")
@_cdecl("bjs_EnumRoundtrip_roundtrip")
public func _bjs_EnumRoundtrip_roundtrip(_ _self: UnsafeMutableRawPointer, _ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = EnumRoundtrip.bridgeJSLiftParameter(_self).roundtrip(_: APIResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EnumRoundtrip_deinit")
@_cdecl("bjs_EnumRoundtrip_deinit")
public func _bjs_EnumRoundtrip_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<EnumRoundtrip>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension EnumRoundtrip: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_EnumRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_EnumRoundtrip_wrap")
fileprivate func _bjs_EnumRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_EnumRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
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
public func _bjs_ComplexResultRoundtrip_take(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    ComplexResultRoundtrip.bridgeJSLiftParameter(_self).take(_: ComplexResult.bridgeJSLiftParameter(value))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeSuccess")
@_cdecl("bjs_ComplexResultRoundtrip_makeSuccess")
public func _bjs_ComplexResultRoundtrip_makeSuccess(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeSuccess()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeError")
@_cdecl("bjs_ComplexResultRoundtrip_makeError")
public func _bjs_ComplexResultRoundtrip_makeError(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeError()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeLocation")
@_cdecl("bjs_ComplexResultRoundtrip_makeLocation")
public func _bjs_ComplexResultRoundtrip_makeLocation(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeLocation()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeStatus")
@_cdecl("bjs_ComplexResultRoundtrip_makeStatus")
public func _bjs_ComplexResultRoundtrip_makeStatus(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeStatus()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeCoordinates")
@_cdecl("bjs_ComplexResultRoundtrip_makeCoordinates")
public func _bjs_ComplexResultRoundtrip_makeCoordinates(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeCoordinates()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeComprehensive")
@_cdecl("bjs_ComplexResultRoundtrip_makeComprehensive")
public func _bjs_ComplexResultRoundtrip_makeComprehensive(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeComprehensive()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_makeInfo")
@_cdecl("bjs_ComplexResultRoundtrip_makeInfo")
public func _bjs_ComplexResultRoundtrip_makeInfo(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).makeInfo()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_roundtrip")
@_cdecl("bjs_ComplexResultRoundtrip_roundtrip")
public func _bjs_ComplexResultRoundtrip_roundtrip(_ _self: UnsafeMutableRawPointer, _ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = ComplexResultRoundtrip.bridgeJSLiftParameter(_self).roundtrip(_: ComplexResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ComplexResultRoundtrip_deinit")
@_cdecl("bjs_ComplexResultRoundtrip_deinit")
public func _bjs_ComplexResultRoundtrip_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ComplexResultRoundtrip>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ComplexResultRoundtrip: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ComplexResultRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_ComplexResultRoundtrip_wrap")
fileprivate func _bjs_ComplexResultRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ComplexResultRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
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
public func _bjs_StringRoundtrip_take(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    StringRoundtrip.bridgeJSLiftParameter(_self).take(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StringRoundtrip_make")
@_cdecl("bjs_StringRoundtrip_make")
public func _bjs_StringRoundtrip_make(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StringRoundtrip.bridgeJSLiftParameter(_self).make()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StringRoundtrip_deinit")
@_cdecl("bjs_StringRoundtrip_deinit")
public func _bjs_StringRoundtrip_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<StringRoundtrip>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension StringRoundtrip: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_StringRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_StringRoundtrip_wrap")
fileprivate func _bjs_StringRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_StringRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_OptionalReturnRoundtrip_init")
@_cdecl("bjs_OptionalReturnRoundtrip_init")
public func _bjs_OptionalReturnRoundtrip_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = OptionalReturnRoundtrip()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalReturnRoundtrip_makeIntSome")
@_cdecl("bjs_OptionalReturnRoundtrip_makeIntSome")
public func _bjs_OptionalReturnRoundtrip_makeIntSome(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalReturnRoundtrip.bridgeJSLiftParameter(_self).makeIntSome()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalReturnRoundtrip_makeIntNone")
@_cdecl("bjs_OptionalReturnRoundtrip_makeIntNone")
public func _bjs_OptionalReturnRoundtrip_makeIntNone(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalReturnRoundtrip.bridgeJSLiftParameter(_self).makeIntNone()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalReturnRoundtrip_makeBoolSome")
@_cdecl("bjs_OptionalReturnRoundtrip_makeBoolSome")
public func _bjs_OptionalReturnRoundtrip_makeBoolSome(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalReturnRoundtrip.bridgeJSLiftParameter(_self).makeBoolSome()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalReturnRoundtrip_makeBoolNone")
@_cdecl("bjs_OptionalReturnRoundtrip_makeBoolNone")
public func _bjs_OptionalReturnRoundtrip_makeBoolNone(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalReturnRoundtrip.bridgeJSLiftParameter(_self).makeBoolNone()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalReturnRoundtrip_makeDoubleSome")
@_cdecl("bjs_OptionalReturnRoundtrip_makeDoubleSome")
public func _bjs_OptionalReturnRoundtrip_makeDoubleSome(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalReturnRoundtrip.bridgeJSLiftParameter(_self).makeDoubleSome()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalReturnRoundtrip_makeDoubleNone")
@_cdecl("bjs_OptionalReturnRoundtrip_makeDoubleNone")
public func _bjs_OptionalReturnRoundtrip_makeDoubleNone(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalReturnRoundtrip.bridgeJSLiftParameter(_self).makeDoubleNone()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalReturnRoundtrip_makeStringSome")
@_cdecl("bjs_OptionalReturnRoundtrip_makeStringSome")
public func _bjs_OptionalReturnRoundtrip_makeStringSome(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalReturnRoundtrip.bridgeJSLiftParameter(_self).makeStringSome()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalReturnRoundtrip_makeStringNone")
@_cdecl("bjs_OptionalReturnRoundtrip_makeStringNone")
public func _bjs_OptionalReturnRoundtrip_makeStringNone(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalReturnRoundtrip.bridgeJSLiftParameter(_self).makeStringNone()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalReturnRoundtrip_deinit")
@_cdecl("bjs_OptionalReturnRoundtrip_deinit")
public func _bjs_OptionalReturnRoundtrip_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<OptionalReturnRoundtrip>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension OptionalReturnRoundtrip: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_OptionalReturnRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_OptionalReturnRoundtrip_wrap")
fileprivate func _bjs_OptionalReturnRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_OptionalReturnRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_StructRoundtrip_init")
@_cdecl("bjs_StructRoundtrip_init")
public func _bjs_StructRoundtrip_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = StructRoundtrip()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_takeSimple")
@_cdecl("bjs_StructRoundtrip_takeSimple")
public func _bjs_StructRoundtrip_takeSimple(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    StructRoundtrip.bridgeJSLiftParameter(_self).takeSimple(_: SimpleStruct.bridgeJSLiftParameter())
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_makeSimple")
@_cdecl("bjs_StructRoundtrip_makeSimple")
public func _bjs_StructRoundtrip_makeSimple(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StructRoundtrip.bridgeJSLiftParameter(_self).makeSimple()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_roundtripSimple")
@_cdecl("bjs_StructRoundtrip_roundtripSimple")
public func _bjs_StructRoundtrip_roundtripSimple(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StructRoundtrip.bridgeJSLiftParameter(_self).roundtripSimple(_: SimpleStruct.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_takeAddress")
@_cdecl("bjs_StructRoundtrip_takeAddress")
public func _bjs_StructRoundtrip_takeAddress(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    StructRoundtrip.bridgeJSLiftParameter(_self).takeAddress(_: Address.bridgeJSLiftParameter())
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_makeAddress")
@_cdecl("bjs_StructRoundtrip_makeAddress")
public func _bjs_StructRoundtrip_makeAddress(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StructRoundtrip.bridgeJSLiftParameter(_self).makeAddress()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_roundtripAddress")
@_cdecl("bjs_StructRoundtrip_roundtripAddress")
public func _bjs_StructRoundtrip_roundtripAddress(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StructRoundtrip.bridgeJSLiftParameter(_self).roundtripAddress(_: Address.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_takePerson")
@_cdecl("bjs_StructRoundtrip_takePerson")
public func _bjs_StructRoundtrip_takePerson(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    StructRoundtrip.bridgeJSLiftParameter(_self).takePerson(_: Person.bridgeJSLiftParameter())
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_makePerson")
@_cdecl("bjs_StructRoundtrip_makePerson")
public func _bjs_StructRoundtrip_makePerson(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StructRoundtrip.bridgeJSLiftParameter(_self).makePerson()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_roundtripPerson")
@_cdecl("bjs_StructRoundtrip_roundtripPerson")
public func _bjs_StructRoundtrip_roundtripPerson(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StructRoundtrip.bridgeJSLiftParameter(_self).roundtripPerson(_: Person.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_takeComplex")
@_cdecl("bjs_StructRoundtrip_takeComplex")
public func _bjs_StructRoundtrip_takeComplex(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    StructRoundtrip.bridgeJSLiftParameter(_self).takeComplex(_: ComplexStruct.bridgeJSLiftParameter())
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_makeComplex")
@_cdecl("bjs_StructRoundtrip_makeComplex")
public func _bjs_StructRoundtrip_makeComplex(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StructRoundtrip.bridgeJSLiftParameter(_self).makeComplex()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_roundtripComplex")
@_cdecl("bjs_StructRoundtrip_roundtripComplex")
public func _bjs_StructRoundtrip_roundtripComplex(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = StructRoundtrip.bridgeJSLiftParameter(_self).roundtripComplex(_: ComplexStruct.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StructRoundtrip_deinit")
@_cdecl("bjs_StructRoundtrip_deinit")
public func _bjs_StructRoundtrip_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<StructRoundtrip>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension StructRoundtrip: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_StructRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_StructRoundtrip_wrap")
fileprivate func _bjs_StructRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_StructRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_SimpleClass_init")
@_cdecl("bjs_SimpleClass_init")
public func _bjs_SimpleClass_init(_ nameBytes: Int32, _ nameLength: Int32, _ count: Int32, _ flag: Int32, _ rate: Float32, _ precise: Float64) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = SimpleClass(name: String.bridgeJSLiftParameter(nameBytes, nameLength), count: Int.bridgeJSLiftParameter(count), flag: Bool.bridgeJSLiftParameter(flag), rate: Float.bridgeJSLiftParameter(rate), precise: Double.bridgeJSLiftParameter(precise))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_name_get")
@_cdecl("bjs_SimpleClass_name_get")
public func _bjs_SimpleClass_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SimpleClass.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_name_set")
@_cdecl("bjs_SimpleClass_name_set")
public func _bjs_SimpleClass_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    SimpleClass.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_count_get")
@_cdecl("bjs_SimpleClass_count_get")
public func _bjs_SimpleClass_count_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SimpleClass.bridgeJSLiftParameter(_self).count
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_count_set")
@_cdecl("bjs_SimpleClass_count_set")
public func _bjs_SimpleClass_count_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    SimpleClass.bridgeJSLiftParameter(_self).count = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_flag_get")
@_cdecl("bjs_SimpleClass_flag_get")
public func _bjs_SimpleClass_flag_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SimpleClass.bridgeJSLiftParameter(_self).flag
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_flag_set")
@_cdecl("bjs_SimpleClass_flag_set")
public func _bjs_SimpleClass_flag_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    SimpleClass.bridgeJSLiftParameter(_self).flag = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_rate_get")
@_cdecl("bjs_SimpleClass_rate_get")
public func _bjs_SimpleClass_rate_get(_ _self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let ret = SimpleClass.bridgeJSLiftParameter(_self).rate
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_rate_set")
@_cdecl("bjs_SimpleClass_rate_set")
public func _bjs_SimpleClass_rate_set(_ _self: UnsafeMutableRawPointer, _ value: Float32) -> Void {
    #if arch(wasm32)
    SimpleClass.bridgeJSLiftParameter(_self).rate = Float.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_precise_get")
@_cdecl("bjs_SimpleClass_precise_get")
public func _bjs_SimpleClass_precise_get(_ _self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let ret = SimpleClass.bridgeJSLiftParameter(_self).precise
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_precise_set")
@_cdecl("bjs_SimpleClass_precise_set")
public func _bjs_SimpleClass_precise_set(_ _self: UnsafeMutableRawPointer, _ value: Float64) -> Void {
    #if arch(wasm32)
    SimpleClass.bridgeJSLiftParameter(_self).precise = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimpleClass_deinit")
@_cdecl("bjs_SimpleClass_deinit")
public func _bjs_SimpleClass_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<SimpleClass>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension SimpleClass: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_SimpleClass_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_SimpleClass_wrap")
fileprivate func _bjs_SimpleClass_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_SimpleClass_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_AddressClass_init")
@_cdecl("bjs_AddressClass_init")
public func _bjs_AddressClass_init(_ streetBytes: Int32, _ streetLength: Int32, _ cityBytes: Int32, _ cityLength: Int32, _ zipCode: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = AddressClass(street: String.bridgeJSLiftParameter(streetBytes, streetLength), city: String.bridgeJSLiftParameter(cityBytes, cityLength), zipCode: Int.bridgeJSLiftParameter(zipCode))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_AddressClass_street_get")
@_cdecl("bjs_AddressClass_street_get")
public func _bjs_AddressClass_street_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = AddressClass.bridgeJSLiftParameter(_self).street
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_AddressClass_street_set")
@_cdecl("bjs_AddressClass_street_set")
public func _bjs_AddressClass_street_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    AddressClass.bridgeJSLiftParameter(_self).street = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_AddressClass_city_get")
@_cdecl("bjs_AddressClass_city_get")
public func _bjs_AddressClass_city_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = AddressClass.bridgeJSLiftParameter(_self).city
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_AddressClass_city_set")
@_cdecl("bjs_AddressClass_city_set")
public func _bjs_AddressClass_city_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    AddressClass.bridgeJSLiftParameter(_self).city = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_AddressClass_zipCode_get")
@_cdecl("bjs_AddressClass_zipCode_get")
public func _bjs_AddressClass_zipCode_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = AddressClass.bridgeJSLiftParameter(_self).zipCode
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_AddressClass_zipCode_set")
@_cdecl("bjs_AddressClass_zipCode_set")
public func _bjs_AddressClass_zipCode_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    AddressClass.bridgeJSLiftParameter(_self).zipCode = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_AddressClass_deinit")
@_cdecl("bjs_AddressClass_deinit")
public func _bjs_AddressClass_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<AddressClass>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension AddressClass: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_AddressClass_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_AddressClass_wrap")
fileprivate func _bjs_AddressClass_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_AddressClass_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_ClassRoundtrip_init")
@_cdecl("bjs_ClassRoundtrip_init")
public func _bjs_ClassRoundtrip_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ClassRoundtrip()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassRoundtrip_takeSimpleClass")
@_cdecl("bjs_ClassRoundtrip_takeSimpleClass")
public func _bjs_ClassRoundtrip_takeSimpleClass(_ _self: UnsafeMutableRawPointer, _ value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    ClassRoundtrip.bridgeJSLiftParameter(_self).takeSimpleClass(_: SimpleClass.bridgeJSLiftParameter(value))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassRoundtrip_makeSimpleClass")
@_cdecl("bjs_ClassRoundtrip_makeSimpleClass")
public func _bjs_ClassRoundtrip_makeSimpleClass(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ClassRoundtrip.bridgeJSLiftParameter(_self).makeSimpleClass()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassRoundtrip_roundtripSimpleClass")
@_cdecl("bjs_ClassRoundtrip_roundtripSimpleClass")
public func _bjs_ClassRoundtrip_roundtripSimpleClass(_ _self: UnsafeMutableRawPointer, _ value: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ClassRoundtrip.bridgeJSLiftParameter(_self).roundtripSimpleClass(_: SimpleClass.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassRoundtrip_takeAddressClass")
@_cdecl("bjs_ClassRoundtrip_takeAddressClass")
public func _bjs_ClassRoundtrip_takeAddressClass(_ _self: UnsafeMutableRawPointer, _ value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    ClassRoundtrip.bridgeJSLiftParameter(_self).takeAddressClass(_: AddressClass.bridgeJSLiftParameter(value))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassRoundtrip_makeAddressClass")
@_cdecl("bjs_ClassRoundtrip_makeAddressClass")
public func _bjs_ClassRoundtrip_makeAddressClass(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ClassRoundtrip.bridgeJSLiftParameter(_self).makeAddressClass()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassRoundtrip_roundtripAddressClass")
@_cdecl("bjs_ClassRoundtrip_roundtripAddressClass")
public func _bjs_ClassRoundtrip_roundtripAddressClass(_ _self: UnsafeMutableRawPointer, _ value: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ClassRoundtrip.bridgeJSLiftParameter(_self).roundtripAddressClass(_: AddressClass.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassRoundtrip_deinit")
@_cdecl("bjs_ClassRoundtrip_deinit")
public func _bjs_ClassRoundtrip_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ClassRoundtrip>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ClassRoundtrip: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ClassRoundtrip_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_ClassRoundtrip_wrap")
fileprivate func _bjs_ClassRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ClassRoundtrip_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoop")
fileprivate func bjs_benchmarkHelperNoop() -> Void
#else
fileprivate func bjs_benchmarkHelperNoop() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$benchmarkHelperNoop() throws(JSException) -> Void {
    bjs_benchmarkHelperNoop()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoopWithNumber")
fileprivate func bjs_benchmarkHelperNoopWithNumber(_ n: Float64) -> Void
#else
fileprivate func bjs_benchmarkHelperNoopWithNumber(_ n: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$benchmarkHelperNoopWithNumber(_ n: Double) throws(JSException) -> Void {
    let nValue = n.bridgeJSLowerParameter()
    bjs_benchmarkHelperNoopWithNumber(nValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkRunner")
fileprivate func bjs_benchmarkRunner(_ name: Int32, _ body: Int32) -> Void
#else
fileprivate func bjs_benchmarkRunner(_ name: Int32, _ body: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$benchmarkRunner(_ name: String, _ body: JSObject) throws(JSException) -> Void {
    let nameValue = name.bridgeJSLowerParameter()
    let bodyValue = body.bridgeJSLowerParameter()
    bjs_benchmarkRunner(nameValue, bodyValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}