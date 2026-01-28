extension Precision: _BridgedSwiftEnumNoPayload {
}

extension DataPoint: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> DataPoint {
        let optFlag = Optional<Bool>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let optCount = Optional<Int>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let label = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let y = Double.bridgeJSLiftParameter(_swift_js_pop_param_f64())
        let x = Double.bridgeJSLiftParameter(_swift_js_pop_param_f64())
        return DataPoint(x: x, y: y, label: label, optCount: optCount, optFlag: optFlag)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_f64(self.x)
        _swift_js_push_f64(self.y)
        var __bjs_label = self.label
        __bjs_label.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        let __bjs_isSome_optCount = self.optCount != nil
        if let __bjs_unwrapped_optCount = self.optCount {
            _swift_js_push_int(Int32(__bjs_unwrapped_optCount))
        }
        _swift_js_push_int(__bjs_isSome_optCount ? 1 : 0)
        let __bjs_isSome_optFlag = self.optFlag != nil
        if let __bjs_unwrapped_optFlag = self.optFlag {
            _swift_js_push_int(__bjs_unwrapped_optFlag ? 1 : 0)
        }
        _swift_js_push_int(__bjs_isSome_optFlag ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_DataPoint(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_DataPoint()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_DataPoint")
fileprivate func _bjs_struct_lower_DataPoint(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_DataPoint(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_DataPoint")
fileprivate func _bjs_struct_lift_DataPoint() -> Int32
#else
fileprivate func _bjs_struct_lift_DataPoint() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_DataPoint_init")
@_cdecl("bjs_DataPoint_init")
public func _bjs_DataPoint_init(_ x: Float64, _ y: Float64, _ labelBytes: Int32, _ labelLength: Int32, _ optCountIsSome: Int32, _ optCountValue: Int32, _ optFlagIsSome: Int32, _ optFlagValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = DataPoint(x: Double.bridgeJSLiftParameter(x), y: Double.bridgeJSLiftParameter(y), label: String.bridgeJSLiftParameter(labelBytes, labelLength), optCount: Optional<Int>.bridgeJSLiftParameter(optCountIsSome, optCountValue), optFlag: Optional<Bool>.bridgeJSLiftParameter(optFlagIsSome, optFlagValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Address: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Address {
        let zipCode = Optional<Int>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
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
        let __bjs_isSome_zipCode = self.zipCode != nil
        if let __bjs_unwrapped_zipCode = self.zipCode {
            _swift_js_push_int(Int32(__bjs_unwrapped_zipCode))
        }
        _swift_js_push_int(__bjs_isSome_zipCode ? 1 : 0)
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
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Address()))
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
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Address")
fileprivate func _bjs_struct_lift_Address() -> Int32
#else
fileprivate func _bjs_struct_lift_Address() -> Int32 {
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
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Person()))
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
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Person")
fileprivate func _bjs_struct_lift_Person() -> Int32
#else
fileprivate func _bjs_struct_lift_Person() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension Session: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Session {
        let owner = Greeter.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        let id = Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        return Session(id: id, owner: owner)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_int(Int32(self.id))
        _swift_js_push_pointer(self.owner.bridgeJSLowerReturn())
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Session(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Session()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Session")
fileprivate func _bjs_struct_lower_Session(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Session(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Session")
fileprivate func _bjs_struct_lift_Session() -> Int32
#else
fileprivate func _bjs_struct_lift_Session() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension Measurement: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Measurement {
        let optionalPrecision = Optional<Precision>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_f32())
        let precision = Precision.bridgeJSLiftParameter(_swift_js_pop_param_f32())
        let value = Double.bridgeJSLiftParameter(_swift_js_pop_param_f64())
        return Measurement(value: value, precision: precision, optionalPrecision: optionalPrecision)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_f64(self.value)
        _swift_js_push_f32(self.precision.bridgeJSLowerParameter())
        let __bjs_isSome_optionalPrecision = self.optionalPrecision != nil
        if let __bjs_unwrapped_optionalPrecision = self.optionalPrecision {
            _swift_js_push_f32(__bjs_unwrapped_optionalPrecision.bridgeJSLowerParameter())
        }
        _swift_js_push_int(__bjs_isSome_optionalPrecision ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Measurement(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Measurement()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Measurement")
fileprivate func _bjs_struct_lower_Measurement(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Measurement(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Measurement")
fileprivate func _bjs_struct_lift_Measurement() -> Int32
#else
fileprivate func _bjs_struct_lift_Measurement() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension ConfigStruct: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> ConfigStruct {
        return ConfigStruct()
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {

    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_ConfigStruct(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ConfigStruct()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ConfigStruct")
fileprivate func _bjs_struct_lower_ConfigStruct(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_ConfigStruct(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ConfigStruct")
fileprivate func _bjs_struct_lift_ConfigStruct() -> Int32
#else
fileprivate func _bjs_struct_lift_ConfigStruct() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_ConfigStruct_static_maxRetries_get")
@_cdecl("bjs_ConfigStruct_static_maxRetries_get")
public func _bjs_ConfigStruct_static_maxRetries_get() -> Int32 {
    #if arch(wasm32)
    let ret = ConfigStruct.maxRetries
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_defaultConfig_get")
@_cdecl("bjs_ConfigStruct_static_defaultConfig_get")
public func _bjs_ConfigStruct_static_defaultConfig_get() -> Void {
    #if arch(wasm32)
    let ret = ConfigStruct.defaultConfig
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_defaultConfig_set")
@_cdecl("bjs_ConfigStruct_static_defaultConfig_set")
public func _bjs_ConfigStruct_static_defaultConfig_set(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    ConfigStruct.defaultConfig = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_timeout_get")
@_cdecl("bjs_ConfigStruct_static_timeout_get")
public func _bjs_ConfigStruct_static_timeout_get() -> Float64 {
    #if arch(wasm32)
    let ret = ConfigStruct.timeout
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_timeout_set")
@_cdecl("bjs_ConfigStruct_static_timeout_set")
public func _bjs_ConfigStruct_static_timeout_set(_ value: Float64) -> Void {
    #if arch(wasm32)
    ConfigStruct.timeout = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_computedSetting_get")
@_cdecl("bjs_ConfigStruct_static_computedSetting_get")
public func _bjs_ConfigStruct_static_computedSetting_get() -> Void {
    #if arch(wasm32)
    let ret = ConfigStruct.computedSetting
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_update")
@_cdecl("bjs_ConfigStruct_static_update")
public func _bjs_ConfigStruct_static_update(_ timeout: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = ConfigStruct.update(_: Double.bridgeJSLiftParameter(timeout))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtrip")
@_cdecl("bjs_roundtrip")
public func _bjs_roundtrip() -> Void {
    #if arch(wasm32)
    let ret = roundtrip(_: Person.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_get")
@_cdecl("bjs_Greeter_name_get")
public func _bjs_Greeter_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_set")
@_cdecl("bjs_Greeter_name_set")
public func _bjs_Greeter_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Greeter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_wrap")
fileprivate func _bjs_Greeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Greeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif