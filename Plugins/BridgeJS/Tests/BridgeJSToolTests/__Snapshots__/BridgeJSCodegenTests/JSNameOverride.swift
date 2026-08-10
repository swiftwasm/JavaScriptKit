extension RenamedEnumMembers: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> RenamedEnumMembers {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> RenamedEnumMembers {
        return RenamedEnumMembers(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) @usableFromInline init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .active
        case 1:
            self = .inactive
        default:
            return nil
        }
    }

    @_spi(BridgeJS) @usableFromInline var bridgeJSRawValue: Int32 {
        switch self {
        case .active:
            return 0
        case .inactive:
            return 1
        }
    }
}

@_expose(wasm, "bjs_RenamedEnumMembers_static_describeCase")
@_cdecl("bjs_RenamedEnumMembers_static_describeCase")
public func _bjs_RenamedEnumMembers_static_describeCase() -> Void {
    #if arch(wasm32)
    let ret = RenamedEnumMembers.describe()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedEnumMembers_static_defaultValue_get")
@_cdecl("bjs_RenamedEnumMembers_static_defaultValue_get")
public func _bjs_RenamedEnumMembers_static_defaultValue_get() -> Void {
    #if arch(wasm32)
    let ret = RenamedEnumMembers.defaultValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedEnumMembers_static_defaultValue_set")
@_cdecl("bjs_RenamedEnumMembers_static_defaultValue_set")
public func _bjs_RenamedEnumMembers_static_defaultValue_set(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    RenamedEnumMembers.defaultValue = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedNamespaceMembers_static_plus")
@_cdecl("bjs_RenamedNamespaceMembers_static_plus")
public func _bjs_RenamedNamespaceMembers_static_plus(_ a: Int32, _ b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = RenamedNamespaceMembers.add(_: Int.bridgeJSLiftParameter(a), _: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedNamespaceMembers_static_answer_get")
@_cdecl("bjs_RenamedNamespaceMembers_static_answer_get")
public func _bjs_RenamedNamespaceMembers_static_answer_get() -> Int32 {
    #if arch(wasm32)
    let ret = RenamedNamespaceMembers.answer
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedNamespaceMembers_static_answer_set")
@_cdecl("bjs_RenamedNamespaceMembers_static_answer_set")
public func _bjs_RenamedNamespaceMembers_static_answer_set(_ value: Int32) -> Void {
    #if arch(wasm32)
    RenamedNamespaceMembers.answer = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension RenamedVector: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> RenamedVector {
        let dy = Double.bridgeJSStackPop()
        let dx = Double.bridgeJSStackPop()
        return RenamedVector(dx: dx, dy: dy)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.dx.bridgeJSStackPush()
        self.dy.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_RenamedVector(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_RenamedVector()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_RenamedVector")
fileprivate func _bjs_struct_lower_RenamedVector_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_RenamedVector_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_RenamedVector(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_RenamedVector_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_RenamedVector")
fileprivate func _bjs_struct_lift_RenamedVector_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_RenamedVector_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_RenamedVector() -> Int32 {
    return _bjs_struct_lift_RenamedVector_extern()
}

@_expose(wasm, "bjs_RenamedVector_static_origin_get")
@_cdecl("bjs_RenamedVector_static_origin_get")
public func _bjs_RenamedVector_static_origin_get() -> Void {
    #if arch(wasm32)
    let ret = RenamedVector.origin
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedVector_magnitude")
@_cdecl("bjs_RenamedVector_magnitude")
public func _bjs_RenamedVector_magnitude() -> Float64 {
    #if arch(wasm32)
    let ret = RenamedVector.bridgeJSLiftParameter().length()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedVector_static_fromPolar")
@_cdecl("bjs_RenamedVector_static_fromPolar")
public func _bjs_RenamedVector_static_fromPolar(_ radius: Float64, _ angle: Float64) -> Void {
    #if arch(wasm32)
    let ret = RenamedVector.polar(radius: Double.bridgeJSLiftParameter(radius), angle: Double.bridgeJSLiftParameter(angle))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeGreeting")
@_cdecl("bjs_makeGreeting")
public func _bjs_makeGreeting(_ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = renderGreeting(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_greetName")
@_cdecl("bjs_greetName")
public func _bjs_greetName(_ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = greet(_: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_greetCount")
@_cdecl("bjs_greetCount")
public func _bjs_greetCount(_ count: Int32) -> Void {
    #if arch(wasm32)
    let ret = greet(_: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Utils_Text_namespacedRenamed")
@_cdecl("bjs_Utils_Text_namespacedRenamed")
public func _bjs_Utils_Text_namespacedRenamed() -> Int32 {
    #if arch(wasm32)
    let ret = namespacedFunction()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_init")
@_cdecl("bjs_RenamedMembers_init")
public func _bjs_RenamedMembers_init(_ titleBytes: Int32, _ titleLength: Int32, _ count: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = RenamedMembers(title: String.bridgeJSLiftParameter(titleBytes, titleLength), count: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_makeGreeting")
@_cdecl("bjs_RenamedMembers_makeGreeting")
public func _bjs_RenamedMembers_makeGreeting(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = RenamedMembers.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_static_makeDefault")
@_cdecl("bjs_RenamedMembers_static_makeDefault")
public func _bjs_RenamedMembers_static_makeDefault() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = RenamedMembers.createDefault()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_title_get")
@_cdecl("bjs_RenamedMembers_title_get")
public func _bjs_RenamedMembers_title_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = RenamedMembers.bridgeJSLiftParameter(_self).title
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_title_set")
@_cdecl("bjs_RenamedMembers_title_set")
public func _bjs_RenamedMembers_title_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    RenamedMembers.bridgeJSLiftParameter(_self).title = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_count_get")
@_cdecl("bjs_RenamedMembers_count_get")
public func _bjs_RenamedMembers_count_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = RenamedMembers.bridgeJSLiftParameter(_self).count
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_static_sharedCount_get")
@_cdecl("bjs_RenamedMembers_static_sharedCount_get")
public func _bjs_RenamedMembers_static_sharedCount_get() -> Int32 {
    #if arch(wasm32)
    let ret = RenamedMembers.sharedCount
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_static_sharedCount_set")
@_cdecl("bjs_RenamedMembers_static_sharedCount_set")
public func _bjs_RenamedMembers_static_sharedCount_set(_ value: Int32) -> Void {
    #if arch(wasm32)
    RenamedMembers.sharedCount = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_static_limit_get")
@_cdecl("bjs_RenamedMembers_static_limit_get")
public func _bjs_RenamedMembers_static_limit_get() -> Int32 {
    #if arch(wasm32)
    let ret = RenamedMembers.limit
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_RenamedMembers_deinit")
@_cdecl("bjs_RenamedMembers_deinit")
public func _bjs_RenamedMembers_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<RenamedMembers>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension RenamedMembers: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_RenamedMembers_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_RenamedMembers_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_RenamedMembers_wrap")
fileprivate func _bjs_RenamedMembers_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_RenamedMembers_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_RenamedMembers_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_RenamedMembers_wrap_extern(pointer)
}

extension RenamedVector: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = RenamedVector.bridgeJSMakeTypeHandle()
}

extension RenamedEnumMembers: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = RenamedEnumMembers.bridgeJSMakeTypeHandle()
}