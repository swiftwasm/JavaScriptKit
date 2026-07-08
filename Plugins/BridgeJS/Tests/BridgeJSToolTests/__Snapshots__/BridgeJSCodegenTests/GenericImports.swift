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

extension GenericColor: _BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("GenericColor")
}

extension GenericMode: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GenericMode: _BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("GenericMode")
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

extension GenericTagged: _BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("GenericTagged")
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

extension GenericPoint: _BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("GenericPoint")
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

extension GenericImportBox: _BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("GenericImportBox")
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

func _$genericRoundTrip<T: _BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T {
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

func _$genericParse<T: _BridgedSwiftGenericBridgeable>(_ json: String) throws(JSException) -> T {
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

func _$importGenericCombine<T: _BridgedSwiftGenericBridgeable, U: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: U) throws(JSException) -> U {
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

func _$importGenericCaseDistinct<T: _BridgedSwiftGenericBridgeable, t: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: t) throws(JSException) -> T {
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

func _$importGenericArray<T: _BridgedSwiftGenericBridgeable>(_ values: [T]) throws(JSException) -> [T] {
    values.bridgeJSStackPush()
    bjs_importGenericArray(T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Array<T>.bridgeJSStackPop()
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

func _$importGenericOptional<T: _BridgedSwiftGenericBridgeable>(_ value: Optional<T>) throws(JSException) -> Optional<T> {
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

func _$importGenericDictionary<T: _BridgedSwiftGenericBridgeable>(_ values: [String: T]) throws(JSException) -> [String: T] {
    values.bridgeJSStackPush()
    bjs_importGenericDictionary(T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Dictionary<String, T>.bridgeJSStackPop()
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

func _$GenericConsumer_box<T: _BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T {
    value.bridgeJSStackPush()
    bjs_GenericConsumer_box_static(T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return T.bridgeJSStackPop()
}

func _$GenericConsumer_accept<T: _BridgedSwiftGenericBridgeable>(_ self: JSObject, _ value: T) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    value.bridgeJSStackPush()
    bjs_GenericConsumer_accept(selfValue, T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GenericConsumer_identity<T: _BridgedSwiftGenericBridgeable>(_ self: JSObject, _ value: T) throws(JSException) -> T {
    let selfValue = self.bridgeJSLowerParameter()
    value.bridgeJSStackPush()
    bjs_GenericConsumer_identity(selfValue, T.bridgeJSTypeID)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return T.bridgeJSStackPop()
}