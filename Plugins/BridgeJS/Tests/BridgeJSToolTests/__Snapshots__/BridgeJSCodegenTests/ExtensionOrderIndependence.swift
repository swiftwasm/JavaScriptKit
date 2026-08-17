extension Depot.Crate: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Depot.Crate {
        let label = String.bridgeJSStackPop()
        return Depot.Crate(label: label)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.label.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Depot_Crate(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Depot_Crate()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Depot_Crate")
fileprivate func _bjs_struct_lower_Depot_Crate_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Depot_Crate_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Depot_Crate(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Depot_Crate_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Depot_Crate")
fileprivate func _bjs_struct_lift_Depot_Crate_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Depot_Crate_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Depot_Crate() -> Int32 {
    return _bjs_struct_lift_Depot_Crate_extern()
}

@_expose(wasm, "bjs_Depot_Crate_init")
@_cdecl("bjs_Depot_Crate_init")
public func _bjs_Depot_Crate_init(_ labelBytes: Int32, _ labelLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Depot.Crate(label: String.bridgeJSLiftParameter(labelBytes, labelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Depot_Crate_describeCrate")
@_cdecl("bjs_Depot_Crate_describeCrate")
public func _bjs_Depot_Crate_describeCrate() -> Void {
    #if arch(wasm32)
    let ret = Depot.Crate.bridgeJSLiftParameter().describeCrate()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Depot_init")
@_cdecl("bjs_Depot_init")
public func _bjs_Depot_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Depot()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Depot_deinit")
@_cdecl("bjs_Depot_deinit")
public func _bjs_Depot_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Depot>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Depot: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Depot_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Depot_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Depot_wrap")
fileprivate func _bjs_Depot_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Depot_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Depot_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Depot_wrap_extern(pointer)
}

extension Depot.Crate: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Depot.Crate.bridgeJSMakeTypeHandle()
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "bjs_TestModule_register_type_handles")
fileprivate func _bjs_TestModule_register_type_handles_extern(_ base: UnsafePointer<Int32>?, _ count: Int32)

@_expose(wasm, "bjs_TestModule_register_type_handles")
public func _bjs_TestModule_register_type_handles() {
    let typeIds: [Int32] = [
        Depot.Crate.bridgeJSTypeID,
    ]
    typeIds.withUnsafeBufferPointer { buffer in
        _bjs_TestModule_register_type_handles_extern(buffer.baseAddress, Int32(buffer.count))
    }
}
#endif