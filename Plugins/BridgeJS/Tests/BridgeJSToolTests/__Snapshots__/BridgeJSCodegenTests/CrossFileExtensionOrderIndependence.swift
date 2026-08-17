extension Archive.Record: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Archive.Record {
        let label = String.bridgeJSStackPop()
        return Archive.Record(label: label)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.label.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Archive_Record(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Archive_Record()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Archive_Record")
fileprivate func _bjs_struct_lower_Archive_Record_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Archive_Record_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Archive_Record(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Archive_Record_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Archive_Record")
fileprivate func _bjs_struct_lift_Archive_Record_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Archive_Record_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Archive_Record() -> Int32 {
    return _bjs_struct_lift_Archive_Record_extern()
}

@_expose(wasm, "bjs_Archive_Record_init")
@_cdecl("bjs_Archive_Record_init")
public func _bjs_Archive_Record_init(_ labelBytes: Int32, _ labelLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Archive.Record(label: String.bridgeJSLiftParameter(labelBytes, labelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Archive_Record_describeRecord")
@_cdecl("bjs_Archive_Record_describeRecord")
public func _bjs_Archive_Record_describeRecord() -> Void {
    #if arch(wasm32)
    let ret = Archive.Record.bridgeJSLiftParameter().describeRecord()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Archive_init")
@_cdecl("bjs_Archive_init")
public func _bjs_Archive_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Archive()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Archive_deinit")
@_cdecl("bjs_Archive_deinit")
public func _bjs_Archive_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Archive>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Archive: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Archive_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Archive_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Archive_wrap")
fileprivate func _bjs_Archive_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Archive_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Archive_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Archive_wrap_extern(pointer)
}

extension Archive.Record: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Archive.Record.bridgeJSMakeTypeHandle()
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "bjs_TestModule_register_type_handles")
fileprivate func _bjs_TestModule_register_type_handles_extern(_ base: UnsafePointer<Int32>?, _ count: Int32)

@_expose(wasm, "bjs_TestModule_register_type_handles")
public func _bjs_TestModule_register_type_handles() {
    let typeIds: [Int32] = [
        Archive.Record.bridgeJSTypeID,
    ]
    typeIds.withUnsafeBufferPointer { buffer in
        _bjs_TestModule_register_type_handles_extern(buffer.baseAddress, Int32(buffer.count))
    }
}
#endif