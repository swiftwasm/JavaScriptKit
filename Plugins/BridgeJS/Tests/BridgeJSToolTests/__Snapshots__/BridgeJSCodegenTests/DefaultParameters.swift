extension Status: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Status {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Status {
        return Status(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .active
        case 1:
            self = .inactive
        case 2:
            self = .pending
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .active:
            return 0
        case .inactive:
            return 1
        case .pending:
            return 2
        }
    }
}

extension Config: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Config {
        let enabled = Bool.bridgeJSStackPop()
        let value = Int.bridgeJSStackPop()
        let name = String.bridgeJSStackPop()
        return Config(name: name, value: value, enabled: enabled)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.name.bridgeJSStackPush()
        self.value.bridgeJSStackPush()
        self.enabled.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Config(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Config()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Config")
fileprivate func _bjs_struct_lower_Config(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Config(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Config")
fileprivate func _bjs_struct_lift_Config() -> Int32
#else
fileprivate func _bjs_struct_lift_Config() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension MathOperations: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> MathOperations {
        let baseValue = Double.bridgeJSStackPop()
        return MathOperations(baseValue: baseValue)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.baseValue.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_MathOperations(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_MathOperations()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_MathOperations")
fileprivate func _bjs_struct_lower_MathOperations(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_MathOperations(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_MathOperations")
fileprivate func _bjs_struct_lift_MathOperations() -> Int32
#else
fileprivate func _bjs_struct_lift_MathOperations() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_MathOperations_init")
@_cdecl("bjs_MathOperations_init")
public func _bjs_MathOperations_init(_ baseValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = MathOperations(baseValue: Double.bridgeJSLiftParameter(baseValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathOperations_add")
@_cdecl("bjs_MathOperations_add")
public func _bjs_MathOperations_add(_ a: Float64, _ b: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = MathOperations.bridgeJSLiftParameter().add(a: Double.bridgeJSLiftParameter(a), b: Double.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathOperations_multiply")
@_cdecl("bjs_MathOperations_multiply")
public func _bjs_MathOperations_multiply(_ a: Float64, _ b: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = MathOperations.bridgeJSLiftParameter().multiply(a: Double.bridgeJSLiftParameter(a), b: Double.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathOperations_static_subtract")
@_cdecl("bjs_MathOperations_static_subtract")
public func _bjs_MathOperations_static_subtract(_ a: Float64, _ b: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = MathOperations.subtract(a: Double.bridgeJSLiftParameter(a), b: Double.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testStringDefault")
@_cdecl("bjs_testStringDefault")
public func _bjs_testStringDefault(_ messageBytes: Int32, _ messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testStringDefault(message: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testNegativeIntDefault")
@_cdecl("bjs_testNegativeIntDefault")
public func _bjs_testNegativeIntDefault(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testNegativeIntDefault(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testBoolDefault")
@_cdecl("bjs_testBoolDefault")
public func _bjs_testBoolDefault(_ flag: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testBoolDefault(flag: Bool.bridgeJSLiftParameter(flag))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testNegativeFloatDefault")
@_cdecl("bjs_testNegativeFloatDefault")
public func _bjs_testNegativeFloatDefault(_ temp: Float32) -> Float32 {
    #if arch(wasm32)
    let ret = testNegativeFloatDefault(temp: Float.bridgeJSLiftParameter(temp))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testDoubleDefault")
@_cdecl("bjs_testDoubleDefault")
public func _bjs_testDoubleDefault(_ precision: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = testDoubleDefault(precision: Double.bridgeJSLiftParameter(precision))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalDefault")
@_cdecl("bjs_testOptionalDefault")
public func _bjs_testOptionalDefault(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testOptionalDefault(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalStringDefault")
@_cdecl("bjs_testOptionalStringDefault")
public func _bjs_testOptionalStringDefault(_ greetingIsSome: Int32, _ greetingBytes: Int32, _ greetingLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testOptionalStringDefault(greeting: Optional<String>.bridgeJSLiftParameter(greetingIsSome, greetingBytes, greetingLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testMultipleDefaults")
@_cdecl("bjs_testMultipleDefaults")
public func _bjs_testMultipleDefaults(_ titleBytes: Int32, _ titleLength: Int32, _ count: Int32, _ enabled: Int32) -> Void {
    #if arch(wasm32)
    let ret = testMultipleDefaults(title: String.bridgeJSLiftParameter(titleBytes, titleLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testEnumDefault")
@_cdecl("bjs_testEnumDefault")
public func _bjs_testEnumDefault(_ status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testEnumDefault(status: Status.bridgeJSLiftParameter(status))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testComplexInit")
@_cdecl("bjs_testComplexInit")
public func _bjs_testComplexInit(_ greeter: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = testComplexInit(greeter: DefaultGreeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testEmptyInit")
@_cdecl("bjs_testEmptyInit")
public func _bjs_testEmptyInit(_ greeter: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = testEmptyInit(greeter: EmptyGreeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalStructDefault")
@_cdecl("bjs_testOptionalStructDefault")
public func _bjs_testOptionalStructDefault() -> Void {
    #if arch(wasm32)
    let ret = testOptionalStructDefault(point: Optional<Config>.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalStructWithValueDefault")
@_cdecl("bjs_testOptionalStructWithValueDefault")
public func _bjs_testOptionalStructWithValueDefault() -> Void {
    #if arch(wasm32)
    let ret = testOptionalStructWithValueDefault(point: Optional<Config>.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testIntArrayDefault")
@_cdecl("bjs_testIntArrayDefault")
public func _bjs_testIntArrayDefault() -> Void {
    #if arch(wasm32)
    let ret = testIntArrayDefault(values: [Int].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testStringArrayDefault")
@_cdecl("bjs_testStringArrayDefault")
public func _bjs_testStringArrayDefault() -> Void {
    #if arch(wasm32)
    let ret = testStringArrayDefault(names: [String].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testDoubleArrayDefault")
@_cdecl("bjs_testDoubleArrayDefault")
public func _bjs_testDoubleArrayDefault() -> Void {
    #if arch(wasm32)
    let ret = testDoubleArrayDefault(values: [Double].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testBoolArrayDefault")
@_cdecl("bjs_testBoolArrayDefault")
public func _bjs_testBoolArrayDefault() -> Void {
    #if arch(wasm32)
    let ret = testBoolArrayDefault(flags: [Bool].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testEmptyArrayDefault")
@_cdecl("bjs_testEmptyArrayDefault")
public func _bjs_testEmptyArrayDefault() -> Void {
    #if arch(wasm32)
    let ret = testEmptyArrayDefault(items: [Int].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testMixedWithArrayDefault")
@_cdecl("bjs_testMixedWithArrayDefault")
public func _bjs_testMixedWithArrayDefault(_ nameBytes: Int32, _ nameLength: Int32, _ enabled: Int32) -> Void {
    #if arch(wasm32)
    let ret = testMixedWithArrayDefault(name: String.bridgeJSLiftParameter(nameBytes, nameLength), values: [Int].bridgeJSStackPop(), enabled: Bool.bridgeJSLiftParameter(enabled))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultGreeter_init")
@_cdecl("bjs_DefaultGreeter_init")
public func _bjs_DefaultGreeter_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = DefaultGreeter(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultGreeter_name_get")
@_cdecl("bjs_DefaultGreeter_name_get")
public func _bjs_DefaultGreeter_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DefaultGreeter.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultGreeter_name_set")
@_cdecl("bjs_DefaultGreeter_name_set")
public func _bjs_DefaultGreeter_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    DefaultGreeter.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultGreeter_deinit")
@_cdecl("bjs_DefaultGreeter_deinit")
public func _bjs_DefaultGreeter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<DefaultGreeter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension DefaultGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_DefaultGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_DefaultGreeter_wrap")
fileprivate func _bjs_DefaultGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_DefaultGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_EmptyGreeter_init")
@_cdecl("bjs_EmptyGreeter_init")
public func _bjs_EmptyGreeter_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = EmptyGreeter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EmptyGreeter_deinit")
@_cdecl("bjs_EmptyGreeter_deinit")
public func _bjs_EmptyGreeter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<EmptyGreeter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension EmptyGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_EmptyGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_EmptyGreeter_wrap")
fileprivate func _bjs_EmptyGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_EmptyGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_ConstructorDefaults_init")
@_cdecl("bjs_ConstructorDefaults_init")
public func _bjs_ConstructorDefaults_init(_ nameBytes: Int32, _ nameLength: Int32, _ count: Int32, _ enabled: Int32, _ status: Int32, _ tagIsSome: Int32, _ tagBytes: Int32, _ tagLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ConstructorDefaults(name: String.bridgeJSLiftParameter(nameBytes, nameLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled), status: Status.bridgeJSLiftParameter(status), tag: Optional<String>.bridgeJSLiftParameter(tagIsSome, tagBytes, tagLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_name_get")
@_cdecl("bjs_ConstructorDefaults_name_get")
public func _bjs_ConstructorDefaults_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_name_set")
@_cdecl("bjs_ConstructorDefaults_name_set")
public func _bjs_ConstructorDefaults_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_count_get")
@_cdecl("bjs_ConstructorDefaults_count_get")
public func _bjs_ConstructorDefaults_count_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).count
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_count_set")
@_cdecl("bjs_ConstructorDefaults_count_set")
public func _bjs_ConstructorDefaults_count_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).count = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_enabled_get")
@_cdecl("bjs_ConstructorDefaults_enabled_get")
public func _bjs_ConstructorDefaults_enabled_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).enabled
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_enabled_set")
@_cdecl("bjs_ConstructorDefaults_enabled_set")
public func _bjs_ConstructorDefaults_enabled_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).enabled = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_status_get")
@_cdecl("bjs_ConstructorDefaults_status_get")
public func _bjs_ConstructorDefaults_status_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).status
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_status_set")
@_cdecl("bjs_ConstructorDefaults_status_set")
public func _bjs_ConstructorDefaults_status_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).status = Status.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_tag_get")
@_cdecl("bjs_ConstructorDefaults_tag_get")
public func _bjs_ConstructorDefaults_tag_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).tag
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_tag_set")
@_cdecl("bjs_ConstructorDefaults_tag_set")
public func _bjs_ConstructorDefaults_tag_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).tag = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_deinit")
@_cdecl("bjs_ConstructorDefaults_deinit")
public func _bjs_ConstructorDefaults_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ConstructorDefaults>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ConstructorDefaults: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ConstructorDefaults_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ConstructorDefaults_wrap")
fileprivate func _bjs_ConstructorDefaults_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ConstructorDefaults_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif