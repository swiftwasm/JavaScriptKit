extension Catalog.Entry: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Catalog.Entry {
        let title = String.bridgeJSStackPop()
        return Catalog.Entry(title: title)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.title.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Catalog_Entry(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Catalog_Entry()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Catalog_Entry")
fileprivate func _bjs_struct_lower_Catalog_Entry_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Catalog_Entry_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Catalog_Entry(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Catalog_Entry_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Catalog_Entry")
fileprivate func _bjs_struct_lift_Catalog_Entry_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Catalog_Entry_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Catalog_Entry() -> Int32 {
    return _bjs_struct_lift_Catalog_Entry_extern()
}

@_expose(wasm, "bjs_Catalog_Entry_init")
@_cdecl("bjs_Catalog_Entry_init")
public func _bjs_Catalog_Entry_init(_ titleBytes: Int32, _ titleLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Catalog.Entry(title: String.bridgeJSLiftParameter(titleBytes, titleLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Entry: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Entry {
        let identifier = Int.bridgeJSStackPop()
        return Entry(identifier: identifier)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.identifier.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Entry(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Entry()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Entry")
fileprivate func _bjs_struct_lower_Entry_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Entry_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Entry(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Entry_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Entry")
fileprivate func _bjs_struct_lift_Entry_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Entry_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Entry() -> Int32 {
    return _bjs_struct_lift_Entry_extern()
}

@_expose(wasm, "bjs_Entry_init")
@_cdecl("bjs_Entry_init")
public func _bjs_Entry_init(_ identifier: Int32) -> Void {
    #if arch(wasm32)
    let ret = Entry(identifier: Int.bridgeJSLiftParameter(identifier))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeEntry")
@_cdecl("bjs_takeEntry")
public func _bjs_takeEntry() -> Void {
    #if arch(wasm32)
    let ret = takeEntry(_: Entry.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeCatalogEntry")
@_cdecl("bjs_takeCatalogEntry")
public func _bjs_takeCatalogEntry() -> Void {
    #if arch(wasm32)
    let ret = takeCatalogEntry(_: Catalog.Entry.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Catalog.Entry: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Catalog.Entry.bridgeJSMakeTypeHandle()
}

extension Entry: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Entry.bridgeJSMakeTypeHandle()
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "bjs_TestModule_register_type_handles")
fileprivate func _bjs_TestModule_register_type_handles_extern(_ base: UnsafePointer<Int32>?, _ count: Int32)

@_expose(wasm, "bjs_TestModule_register_type_handles")
public func _bjs_TestModule_register_type_handles() {
    let typeIds: [Int32] = [
        Catalog.Entry.bridgeJSTypeID,
        Entry.bridgeJSTypeID,
    ]
    typeIds.withUnsafeBufferPointer { buffer in
        _bjs_TestModule_register_type_handles_extern(buffer.baseAddress, Int32(buffer.count))
    }
}
#endif