extension GenericColor: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> GenericColor {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> GenericColor {
        return GenericColor(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) @usableFromInline init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .red
        case 1:
            self = .green
        default:
            return nil
        }
    }

    @_spi(BridgeJS) @usableFromInline var bridgeJSRawValue: Int32 {
        switch self {
        case .red:
            return 0
        case .green:
            return 1
        }
    }
}

extension GenericMode: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GenericTagged: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> GenericTagged {
        switch caseId {
        case 0:
            return .number(value: Int.bridgeJSStackPop())
        case 1:
            return .text(value: String.bridgeJSStackPop())
        default:
            fatalError("Unknown GenericTagged case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .number(let value):
            value.bridgeJSStackPush()
            return Int32(0)
        case .text(let value):
            value.bridgeJSStackPush()
            return Int32(1)
        }
    }
}

extension GenericPoint: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GenericPoint {
        let y = Int.bridgeJSStackPop()
        let x = Int.bridgeJSStackPop()
        return GenericPoint(x: x, y: y)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.y.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GenericPoint(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GenericPoint()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GenericPoint")
fileprivate func _bjs_struct_lower_GenericPoint_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GenericPoint_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GenericPoint(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GenericPoint_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GenericPoint")
fileprivate func _bjs_struct_lift_GenericPoint_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GenericPoint_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GenericPoint() -> Int32 {
    return _bjs_struct_lift_GenericPoint_extern()
}

@_expose(wasm, "bjs_GenericImportBox_init")
@_cdecl("bjs_GenericImportBox_init")
public func _bjs_GenericImportBox_init(_ value: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = GenericImportBox(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GenericImportBox_get")
@_cdecl("bjs_GenericImportBox_get")
public func _bjs_GenericImportBox_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = GenericImportBox.bridgeJSLiftParameter(_self).get()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GenericImportBox_value_get")
@_cdecl("bjs_GenericImportBox_value_get")
public func _bjs_GenericImportBox_value_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = GenericImportBox.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GenericImportBox_value_set")
@_cdecl("bjs_GenericImportBox_value_set")
public func _bjs_GenericImportBox_value_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    GenericImportBox.bridgeJSLiftParameter(_self).value = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GenericImportBox_deinit")
@_cdecl("bjs_GenericImportBox_deinit")
public func _bjs_GenericImportBox_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<GenericImportBox>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension GenericImportBox: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_GenericImportBox_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_GenericImportBox_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_GenericImportBox_wrap")
fileprivate func _bjs_GenericImportBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_GenericImportBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_GenericImportBox_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_GenericImportBox_wrap_extern(pointer)
}

extension GenericPoint: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = GenericPoint.bridgeJSMakeTypeHandle()
}

extension GenericImportBox: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = GenericImportBox.bridgeJSMakeTypeHandle()
}

extension GenericColor: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = GenericColor.bridgeJSMakeTypeHandle()
}

extension GenericMode: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = GenericMode.bridgeJSMakeTypeHandle()
}

extension GenericTagged: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = GenericTagged.bridgeJSMakeTypeHandle()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_genericRoundTrip")
fileprivate func bjs_genericRoundTrip_extern(_ _generic0TypeId: Int32) -> Void
#else
fileprivate func bjs_genericRoundTrip_extern(_ _generic0TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_genericRoundTrip(_ _generic0TypeId: Int32) -> Void {
    return bjs_genericRoundTrip_extern(_generic0TypeId)
}

func _$genericRoundTrip<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T {
    value.bridgeJSStackPush()
    bjs_genericRoundTrip(T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return T.bridgeJSStackPop()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_genericParse")
fileprivate func bjs_genericParse_extern(_ jsonBytes: Int32, _ jsonLength: Int32, _ _generic0TypeId: Int32) -> Void
#else
fileprivate func bjs_genericParse_extern(_ jsonBytes: Int32, _ jsonLength: Int32, _ _generic0TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_genericParse(_ jsonBytes: Int32, _ jsonLength: Int32, _ _generic0TypeId: Int32) -> Void {
    return bjs_genericParse_extern(jsonBytes, jsonLength, _generic0TypeId)
}

func _$genericParse<T: BridgedSwiftGenericBridgeable>(_ json: String) throws(JSException) -> T {
    json.bridgeJSWithLoweredParameter { (jsonBytes, jsonLength) in
        bjs_genericParse(jsonBytes, jsonLength, T.bridgeJSTypeID)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
    return T.bridgeJSStackPop()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importGenericCombine")
fileprivate func bjs_importGenericCombine_extern(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void
#else
fileprivate func bjs_importGenericCombine_extern(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_importGenericCombine(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    return bjs_importGenericCombine_extern(_generic0TypeId, _generic1TypeId)
}

func _$importGenericCombine<T: BridgedSwiftGenericBridgeable, U: BridgedSwiftGenericBridgeable>(_ a: T, _ b: U) throws(JSException) -> U {
    b.bridgeJSStackPush()
    a.bridgeJSStackPush()
    bjs_importGenericCombine(T.bridgeJSTypeID, U.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return U.bridgeJSStackPop()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importGenericCaseDistinct")
fileprivate func bjs_importGenericCaseDistinct_extern(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void
#else
fileprivate func bjs_importGenericCaseDistinct_extern(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_importGenericCaseDistinct(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    return bjs_importGenericCaseDistinct_extern(_generic0TypeId, _generic1TypeId)
}

func _$importGenericCaseDistinct<T: BridgedSwiftGenericBridgeable, t: BridgedSwiftGenericBridgeable>(_ a: T, _ b: t) throws(JSException) -> T {
    b.bridgeJSStackPush()
    a.bridgeJSStackPush()
    bjs_importGenericCaseDistinct(T.bridgeJSTypeID, t.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return T.bridgeJSStackPop()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importGenericArray")
fileprivate func bjs_importGenericArray_extern(_ _generic0TypeId: Int32) -> Void
#else
fileprivate func bjs_importGenericArray_extern(_ _generic0TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_importGenericArray(_ _generic0TypeId: Int32) -> Void {
    return bjs_importGenericArray_extern(_generic0TypeId)
}

func _$importGenericArray<T: BridgedSwiftGenericBridgeable>(_ values: [T]) throws(JSException) -> [T] {
    let _ = values.bridgeJSLowerParameter()
    bjs_importGenericArray(T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [T].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importGenericOptional")
fileprivate func bjs_importGenericOptional_extern(_ _generic0TypeId: Int32) -> Void
#else
fileprivate func bjs_importGenericOptional_extern(_ _generic0TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_importGenericOptional(_ _generic0TypeId: Int32) -> Void {
    return bjs_importGenericOptional_extern(_generic0TypeId)
}

func _$importGenericOptional<T: BridgedSwiftGenericBridgeable>(_ value: Optional<T>) throws(JSException) -> Optional<T> {
    value.bridgeJSStackPush()
    bjs_importGenericOptional(T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<T>.bridgeJSStackPop()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importGenericDictionary")
fileprivate func bjs_importGenericDictionary_extern(_ _generic0TypeId: Int32) -> Void
#else
fileprivate func bjs_importGenericDictionary_extern(_ _generic0TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_importGenericDictionary(_ _generic0TypeId: Int32) -> Void {
    return bjs_importGenericDictionary_extern(_generic0TypeId)
}

func _$importGenericDictionary<T: BridgedSwiftGenericBridgeable>(_ values: [String: T]) throws(JSException) -> [String: T] {
    let _ = values.bridgeJSLowerParameter()
    bjs_importGenericDictionary(T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: T].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importGenericAfterOptionalArray")
fileprivate func bjs_importGenericAfterOptionalArray_extern(_ values: Int32, _ _generic0TypeId: Int32) -> Void
#else
fileprivate func bjs_importGenericAfterOptionalArray_extern(_ values: Int32, _ _generic0TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_importGenericAfterOptionalArray(_ values: Int32, _ _generic0TypeId: Int32) -> Void {
    return bjs_importGenericAfterOptionalArray_extern(values, _generic0TypeId)
}

func _$importGenericAfterOptionalArray<T: BridgedSwiftGenericBridgeable>(_ values: Optional<[Int]>, _ value: T) throws(JSException) -> T {
    value.bridgeJSStackPush()
    let valuesIsSome = values.bridgeJSLowerParameter()
    bjs_importGenericAfterOptionalArray(valuesIsSome, T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return T.bridgeJSStackPop()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_GenericPairFactory_init")
fileprivate func bjs_GenericPairFactory_init_extern(_ tagBytes: Int32, _ tagLength: Int32, _ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Int32
#else
fileprivate func bjs_GenericPairFactory_init_extern(_ tagBytes: Int32, _ tagLength: Int32, _ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GenericPairFactory_init(_ tagBytes: Int32, _ tagLength: Int32, _ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Int32 {
    return bjs_GenericPairFactory_init_extern(tagBytes, tagLength, _generic0TypeId, _generic1TypeId)
}

func _$GenericPairFactory_init<T: BridgedSwiftGenericBridgeable, U: BridgedSwiftGenericBridgeable>(_ tag: String, _ first: T, _ second: U) throws(JSException) -> JSObject {
    let ret0 = tag.bridgeJSWithLoweredParameter { (tagBytes, tagLength) in
        second.bridgeJSStackPush()
        first.bridgeJSStackPush()
        let ret = bjs_GenericPairFactory_init(tagBytes, tagLength, T.bridgeJSTypeID, U.bridgeJSTypeID)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_GenericConsumer_init")
fileprivate func bjs_GenericConsumer_init_extern(_ _generic0TypeId: Int32) -> Int32
#else
fileprivate func bjs_GenericConsumer_init_extern(_ _generic0TypeId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GenericConsumer_init(_ _generic0TypeId: Int32) -> Int32 {
    return bjs_GenericConsumer_init_extern(_generic0TypeId)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_GenericConsumer_box_static")
fileprivate func bjs_GenericConsumer_box_static_extern(_ _generic0TypeId: Int32) -> Void
#else
fileprivate func bjs_GenericConsumer_box_static_extern(_ _generic0TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GenericConsumer_box_static(_ _generic0TypeId: Int32) -> Void {
    return bjs_GenericConsumer_box_static_extern(_generic0TypeId)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_GenericConsumer_accept")
fileprivate func bjs_GenericConsumer_accept_extern(_ self: Int32, _ _generic0TypeId: Int32) -> Void
#else
fileprivate func bjs_GenericConsumer_accept_extern(_ self: Int32, _ _generic0TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GenericConsumer_accept(_ self: Int32, _ _generic0TypeId: Int32) -> Void {
    return bjs_GenericConsumer_accept_extern(self, _generic0TypeId)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_GenericConsumer_identity")
fileprivate func bjs_GenericConsumer_identity_extern(_ self: Int32, _ _generic0TypeId: Int32) -> Void
#else
fileprivate func bjs_GenericConsumer_identity_extern(_ self: Int32, _ _generic0TypeId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GenericConsumer_identity(_ self: Int32, _ _generic0TypeId: Int32) -> Void {
    return bjs_GenericConsumer_identity_extern(self, _generic0TypeId)
}

func _$GenericConsumer_init<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> JSObject {
    value.bridgeJSStackPush()
    let ret = bjs_GenericConsumer_init(T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$GenericConsumer_box<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T {
    value.bridgeJSStackPush()
    bjs_GenericConsumer_box_static(T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return T.bridgeJSStackPop()
}

func _$GenericConsumer_accept<T: BridgedSwiftGenericBridgeable>(_ self: JSObject, _ value: T) throws(JSException) -> Void {
    value.bridgeJSStackPush()
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GenericConsumer_accept(selfValue, T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GenericConsumer_identity<T: BridgedSwiftGenericBridgeable>(_ self: JSObject, _ value: T) throws(JSException) -> T {
    value.bridgeJSStackPush()
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GenericConsumer_identity(selfValue, T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return T.bridgeJSStackPop()
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "bjs_TestModule_register_type_handles")
fileprivate func _bjs_TestModule_register_type_handles_extern(_ base: UnsafePointer<Int32>?, _ count: Int32)

@_expose(wasm, "bjs_TestModule_register_type_handles")
public func _bjs_TestModule_register_type_handles() {
    let typeIds: [Int32] = [
        GenericPoint.bridgeJSTypeID,
        GenericImportBox.bridgeJSTypeID,
        GenericColor.bridgeJSTypeID,
        GenericMode.bridgeJSTypeID,
        GenericTagged.bridgeJSTypeID,
    ]
    typeIds.withUnsafeBufferPointer { buffer in
        _bjs_TestModule_register_type_handles_extern(buffer.baseAddress, Int32(buffer.count))
    }
}
#endif