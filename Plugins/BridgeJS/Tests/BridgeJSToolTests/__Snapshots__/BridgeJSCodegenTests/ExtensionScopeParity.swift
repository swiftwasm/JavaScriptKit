extension Signal: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension Signal.Meta: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Signal.Meta {
        let note = String.bridgeJSStackPop()
        return Signal.Meta(note: note)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.note.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Meta(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Meta()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Meta")
fileprivate func _bjs_struct_lower_Meta_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Meta_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Meta(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Meta_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Meta")
fileprivate func _bjs_struct_lift_Meta_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Meta_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Meta() -> Int32 {
    return _bjs_struct_lift_Meta_extern()
}

@_expose(wasm, "bjs_Meta_init")
@_cdecl("bjs_Meta_init")
public func _bjs_Meta_init(_ noteBytes: Int32, _ noteLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Signal.Meta(note: String.bridgeJSLiftParameter(noteBytes, noteLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_app_Toolbox_Mallet_init")
@_cdecl("bjs_app_Toolbox_Mallet_init")
public func _bjs_app_Toolbox_Mallet_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Toolbox.Mallet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_app_Toolbox_Mallet_deinit")
@_cdecl("bjs_app_Toolbox_Mallet_deinit")
public func _bjs_app_Toolbox_Mallet_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Toolbox.Mallet>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Toolbox.Mallet: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_app_Toolbox_Mallet_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_app_Toolbox_Mallet_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_app_Toolbox_Mallet_wrap")
fileprivate func _bjs_app_Toolbox_Mallet_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_app_Toolbox_Mallet_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_app_Toolbox_Mallet_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_app_Toolbox_Mallet_wrap_extern(pointer)
}

@_expose(wasm, "bjs_app_Toolbox_Hammer_init")
@_cdecl("bjs_app_Toolbox_Hammer_init")
public func _bjs_app_Toolbox_Hammer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Toolbox.Hammer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_app_Toolbox_Hammer_deinit")
@_cdecl("bjs_app_Toolbox_Hammer_deinit")
public func _bjs_app_Toolbox_Hammer_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Toolbox.Hammer>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Toolbox.Hammer: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_app_Toolbox_Hammer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_app_Toolbox_Hammer_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_app_Toolbox_Hammer_wrap")
fileprivate func _bjs_app_Toolbox_Hammer_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_app_Toolbox_Hammer_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_app_Toolbox_Hammer_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_app_Toolbox_Hammer_wrap_extern(pointer)
}

extension Signal.Meta: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Signal.Meta.bridgeJSMakeTypeHandle()
}

extension Signal: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Signal.bridgeJSMakeTypeHandle()
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "bjs_TestModule_register_type_handles")
fileprivate func _bjs_TestModule_register_type_handles_extern(_ base: UnsafePointer<Int32>?, _ count: Int32)

@_expose(wasm, "bjs_TestModule_register_type_handles")
public func _bjs_TestModule_register_type_handles() {
    let typeIds: [Int32] = [
        Signal.Meta.bridgeJSTypeID,
        Signal.bridgeJSTypeID,
    ]
    typeIds.withUnsafeBufferPointer { buffer in
        _bjs_TestModule_register_type_handles_extern(buffer.baseAddress, Int32(buffer.count))
    }
}
#endif