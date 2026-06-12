struct AnyHasOptionalUserId: HasOptionalUserId, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    var userId: Optional<UserId> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_HasOptionalUserId_userId_get(jsObjectValue)
            return Optional<UserId>.bridgeJSLiftReturnFromSideChannel()
        }
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyHasOptionalUserId(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_HasOptionalUserId_userId_get")
fileprivate func bjs_HasOptionalUserId_userId_get_extern(_ jsObject: Int32) -> Void
#else
fileprivate func bjs_HasOptionalUserId_userId_get_extern(_ jsObject: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_HasOptionalUserId_userId_get(_ jsObject: Int32) -> Void {
    return bjs_HasOptionalUserId_userId_get_extern(jsObject)
}

extension InnerTag: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> InnerTag {
        switch caseId {
        case 0:
            return .payload(Int.bridgeJSStackPop())
        case 1:
            return .empty
        default:
            fatalError("Unknown InnerTag case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .payload(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .empty:
            return Int32(1)
        }
    }
}

@_expose(wasm, "bjs_roundtripPolygon")
@_cdecl("bjs_roundtripPolygon")
public func _bjs_roundtripPolygon(_ polygon: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundtripPolygon(_: Polygon.bridgeJSLiftParameter(polygon))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_optionalPolygon")
@_cdecl("bjs_optionalPolygon")
public func _bjs_optionalPolygon(_ polygonIsSome: Int32, _ polygonValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = optionalPolygon(_: Optional<Polygon>.bridgeJSLiftParameter(polygonIsSome, polygonValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_polygonArray")
@_cdecl("bjs_polygonArray")
public func _bjs_polygonArray() -> Void {
    #if arch(wasm32)
    let ret = polygonArray(_: [Polygon].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_validatePolygon")
@_cdecl("bjs_validatePolygon")
public func _bjs_validatePolygon(_ polygon: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    do {
        let ret = try validatePolygon(_: Polygon.bridgeJSLiftParameter(polygon))
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: error.description)
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

@_expose(wasm, "bjs_makeTag")
@_cdecl("bjs_makeTag")
public func _bjs_makeTag(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = makeTag(_: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripTags")
@_cdecl("bjs_roundtripTags")
public func _bjs_roundtripTags() -> Void {
    #if arch(wasm32)
    let ret = roundtripTags(_: [Optional<AliasedTag>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_describeUser")
@_cdecl("bjs_describeUser")
public func _bjs_describeUser(_ owner: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = describeUser(_: AnyHasOptionalUserId.bridgeJSLiftParameter(owner)) as! _BridgedSwiftProtocolExportable
    return ret.bridgeJSLowerAsProtocolReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PolygonReference_init")
@_cdecl("bjs_PolygonReference_init")
public func _bjs_PolygonReference_init(_ underlying: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PolygonReference(underlying: Polygon.bridgeJSLiftParameter(underlying))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PolygonReference_snapshot")
@_cdecl("bjs_PolygonReference_snapshot")
public func _bjs_PolygonReference_snapshot(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PolygonReference.bridgeJSLiftParameter(_self).snapshot()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PolygonReference_merge")
@_cdecl("bjs_PolygonReference_merge")
public func _bjs_PolygonReference_merge(_ _self: UnsafeMutableRawPointer, _ other: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PolygonReference.bridgeJSLiftParameter(_self).merge(_: Polygon.bridgeJSLiftParameter(other))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PolygonReference_static_origin")
@_cdecl("bjs_PolygonReference_static_origin")
public func _bjs_PolygonReference_static_origin() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PolygonReference.origin()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PolygonReference_deinit")
@_cdecl("bjs_PolygonReference_deinit")
public func _bjs_PolygonReference_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PolygonReference>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PolygonReference: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PolygonReference_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_PolygonReference_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PolygonReference_wrap")
fileprivate func _bjs_PolygonReference_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PolygonReference_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_PolygonReference_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_PolygonReference_wrap_extern(pointer)
}

@_expose(wasm, "bjs_TagReference_init")
@_cdecl("bjs_TagReference_init")
public func _bjs_TagReference_init(_ underlying: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TagReference(underlying: Tag.bridgeJSLiftParameter(underlying))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TagReference_deinit")
@_cdecl("bjs_TagReference_deinit")
public func _bjs_TagReference_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<TagReference>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension TagReference: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TagReference_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_TagReference_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_TagReference_wrap")
fileprivate func _bjs_TagReference_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TagReference_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_TagReference_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_TagReference_wrap_extern(pointer)
}

extension Polygon: _BridgedSwiftAlias, _BridgedSwiftStackType {}

extension Tag: _BridgedSwiftAlias, _BridgedSwiftStackType {}

extension Tagged: _BridgedSwiftAlias, _BridgedSwiftStackType {}

extension Canvas: _BridgedSwiftAlias, _BridgedSwiftStackType {}

extension AliasedTag: _BridgedSwiftAlias, _BridgedSwiftAssociatedValueEnum {}

extension UserId: _BridgedSwiftAlias, _BridgedSwiftStackType {}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_acceptTagged")
fileprivate func bjs_acceptTagged_extern(_ taggedBytes: Int32, _ taggedLength: Int32) -> Void
#else
fileprivate func bjs_acceptTagged_extern(_ taggedBytes: Int32, _ taggedLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_acceptTagged(_ taggedBytes: Int32, _ taggedLength: Int32) -> Void {
    return bjs_acceptTagged_extern(taggedBytes, taggedLength)
}

func _$acceptTagged(_ tagged: Tagged) throws(JSException) -> Void {
    tagged.bridgeJSWithLoweredParameter { (taggedBytes, taggedLength) in
        bjs_acceptTagged(taggedBytes, taggedLength)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_acceptOptionalTagged")
fileprivate func bjs_acceptOptionalTagged_extern(_ taggedIsSome: Int32, _ taggedBytes: Int32, _ taggedLength: Int32) -> Void
#else
fileprivate func bjs_acceptOptionalTagged_extern(_ taggedIsSome: Int32, _ taggedBytes: Int32, _ taggedLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_acceptOptionalTagged(_ taggedIsSome: Int32, _ taggedBytes: Int32, _ taggedLength: Int32) -> Void {
    return bjs_acceptOptionalTagged_extern(taggedIsSome, taggedBytes, taggedLength)
}

func _$acceptOptionalTagged(_ tagged: Optional<Tagged>) throws(JSException) -> Void {
    tagged.bridgeJSWithLoweredParameter { (taggedIsSome, taggedBytes, taggedLength) in
        bjs_acceptOptionalTagged(taggedIsSome, taggedBytes, taggedLength)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundtripTagged")
fileprivate func bjs_roundtripTagged_extern(_ taggedBytes: Int32, _ taggedLength: Int32) -> Int32
#else
fileprivate func bjs_roundtripTagged_extern(_ taggedBytes: Int32, _ taggedLength: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundtripTagged(_ taggedBytes: Int32, _ taggedLength: Int32) -> Int32 {
    return bjs_roundtripTagged_extern(taggedBytes, taggedLength)
}

func _$roundtripTagged(_ tagged: Tagged) throws(JSException) -> Tagged {
    let ret0 = tagged.bridgeJSWithLoweredParameter { (taggedBytes, taggedLength) in
        let ret = bjs_roundtripTagged(taggedBytes, taggedLength)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Tagged.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_produceOptionalCanvas")
fileprivate func bjs_produceOptionalCanvas_extern() -> Void
#else
fileprivate func bjs_produceOptionalCanvas_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_produceOptionalCanvas() -> Void {
    return bjs_produceOptionalCanvas_extern()
}

func _$produceOptionalCanvas() throws(JSException) -> Optional<Canvas> {
    bjs_produceOptionalCanvas()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Canvas>.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Surface_init")
fileprivate func bjs_Surface_init_extern() -> Int32
#else
fileprivate func bjs_Surface_init_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Surface_init() -> Int32 {
    return bjs_Surface_init_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Surface_label_get")
fileprivate func bjs_Surface_label_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Surface_label_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Surface_label_get(_ self: Int32) -> Int32 {
    return bjs_Surface_label_get_extern(self)
}

func _$Surface_init() throws(JSException) -> JSObject {
    let ret = bjs_Surface_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$Surface_label_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Surface_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}