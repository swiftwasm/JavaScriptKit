extension Precision: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension DataPoint: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> DataPoint {
        let optFlag = Optional<Bool>.bridgeJSStackPop()
        let optCount = Optional<Int>.bridgeJSStackPop()
        let label = String.bridgeJSStackPop()
        let y = Double.bridgeJSStackPop()
        let x = Double.bridgeJSStackPop()
        return DataPoint(x: x, y: y, label: label, optCount: optCount, optFlag: optFlag)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.y.bridgeJSStackPush()
        self.label.bridgeJSStackPush()
        let __bjs_isSome_optCount = self.optCount != nil
        if let __bjs_unwrapped_optCount = self.optCount {
        __bjs_unwrapped_optCount.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_optCount ? 1 : 0)
        let __bjs_isSome_optFlag = self.optFlag != nil
        if let __bjs_unwrapped_optFlag = self.optFlag {
        __bjs_unwrapped_optFlag.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_optFlag ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_DataPoint(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Address {
        let zipCode = Optional<Int>.bridgeJSStackPop()
        let city = String.bridgeJSStackPop()
        let street = String.bridgeJSStackPop()
        return Address(street: street, city: city, zipCode: zipCode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.street.bridgeJSStackPush()
        self.city.bridgeJSStackPush()
        let __bjs_isSome_zipCode = self.zipCode != nil
        if let __bjs_unwrapped_zipCode = self.zipCode {
        __bjs_unwrapped_zipCode.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_zipCode ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Address(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Person {
        let email = Optional<String>.bridgeJSStackPop()
        let address = Address.bridgeJSStackPop()
        let age = Int.bridgeJSStackPop()
        let name = String.bridgeJSStackPop()
        return Person(name: name, age: age, address: address, email: email)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.name.bridgeJSStackPush()
        self.age.bridgeJSStackPush()
        self.address.bridgeJSStackPush()
        let __bjs_isSome_email = self.email != nil
        if let __bjs_unwrapped_email = self.email {
        __bjs_unwrapped_email.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_email ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Person(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Session {
        let owner = Greeter.bridgeJSStackPop()
        let id = Int.bridgeJSStackPop()
        return Session(id: id, owner: owner)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.id.bridgeJSStackPush()
        self.owner.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Session(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Measurement {
        let optionalPrecision = Optional<Precision>.bridgeJSStackPop()
        let precision = Precision.bridgeJSStackPop()
        let value = Double.bridgeJSStackPop()
        return Measurement(value: value, precision: precision, optionalPrecision: optionalPrecision)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.value.bridgeJSStackPush()
        self.precision.bridgeJSStackPush()
        let __bjs_isSome_optionalPrecision = self.optionalPrecision != nil
        if let __bjs_unwrapped_optionalPrecision = self.optionalPrecision {
        __bjs_unwrapped_optionalPrecision.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_optionalPrecision ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Measurement(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> ConfigStruct {
        return ConfigStruct()
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_ConfigStruct(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
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

extension Container: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Container {
        let optionalObject = Optional<JSObject>.bridgeJSStackPop()
        let object = JSObject.bridgeJSStackPop()
        return Container(object: object, optionalObject: optionalObject)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.object.bridgeJSStackPush()
        let __bjs_isSome_optionalObject = self.optionalObject != nil
        if let __bjs_unwrapped_optionalObject = self.optionalObject {
        __bjs_unwrapped_optionalObject.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_optionalObject ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Container(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Container()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Container")
fileprivate func _bjs_struct_lower_Container(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Container(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Container")
fileprivate func _bjs_struct_lift_Container() -> Int32
#else
fileprivate func _bjs_struct_lift_Container() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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

@_expose(wasm, "bjs_roundtripContainer")
@_cdecl("bjs_roundtripContainer")
public func _bjs_roundtripContainer() -> Void {
    #if arch(wasm32)
    let ret = roundtripContainer(_: Container.bridgeJSLiftParameter())
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