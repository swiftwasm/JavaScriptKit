extension Library.Shelf: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Library.Shelf {
        return Library.Shelf()
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Library_Shelf(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Library_Shelf()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Library_Shelf")
fileprivate func _bjs_struct_lower_Library_Shelf_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Library_Shelf_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Library_Shelf(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Library_Shelf_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Library_Shelf")
fileprivate func _bjs_struct_lift_Library_Shelf_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Library_Shelf_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Library_Shelf() -> Int32 {
    return _bjs_struct_lift_Library_Shelf_extern()
}

extension Library.Shelf.Divider: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Library.Shelf.Divider {
        let slot = Int.bridgeJSStackPop()
        return Library.Shelf.Divider(slot: slot)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.slot.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Library_Shelf_Divider(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Library_Shelf_Divider()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Library_Shelf_Divider")
fileprivate func _bjs_struct_lower_Library_Shelf_Divider_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Library_Shelf_Divider_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Library_Shelf_Divider(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Library_Shelf_Divider_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Library_Shelf_Divider")
fileprivate func _bjs_struct_lift_Library_Shelf_Divider_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Library_Shelf_Divider_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Library_Shelf_Divider() -> Int32 {
    return _bjs_struct_lift_Library_Shelf_Divider_extern()
}

@_expose(wasm, "bjs_Library_Shelf_Divider_init")
@_cdecl("bjs_Library_Shelf_Divider_init")
public func _bjs_Library_Shelf_Divider_init(_ slot: Int32) -> Void {
    #if arch(wasm32)
    let ret = Library.Shelf.Divider(slot: Int.bridgeJSLiftParameter(slot))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Outer.Inner: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Outer.Inner {
        return Outer.Inner()
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Outer_Inner(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Outer_Inner()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Outer_Inner")
fileprivate func _bjs_struct_lower_Outer_Inner_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Outer_Inner_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Outer_Inner(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Outer_Inner_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Outer_Inner")
fileprivate func _bjs_struct_lift_Outer_Inner_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Outer_Inner_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Outer_Inner() -> Int32 {
    return _bjs_struct_lift_Outer_Inner_extern()
}

@_expose(wasm, "bjs_Outer_Inner_init")
@_cdecl("bjs_Outer_Inner_init")
public func _bjs_Outer_Inner_init() -> Void {
    #if arch(wasm32)
    let ret = Outer.Inner()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Outer_Inner_marker")
@_cdecl("bjs_Outer_Inner_marker")
public func _bjs_Outer_Inner_marker() -> Int32 {
    #if arch(wasm32)
    let ret = Outer.Inner.bridgeJSLiftParameter().marker()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Outer.Inner.Outer: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Outer.Inner.Outer {
        return Outer.Inner.Outer()
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Outer_Inner_Outer(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Outer_Inner_Outer()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Outer_Inner_Outer")
fileprivate func _bjs_struct_lower_Outer_Inner_Outer_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Outer_Inner_Outer_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Outer_Inner_Outer(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Outer_Inner_Outer_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Outer_Inner_Outer")
fileprivate func _bjs_struct_lift_Outer_Inner_Outer_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Outer_Inner_Outer_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Outer_Inner_Outer() -> Int32 {
    return _bjs_struct_lift_Outer_Inner_Outer_extern()
}

extension Outer.Inner.Outer.Inner: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Outer.Inner.Outer.Inner {
        return Outer.Inner.Outer.Inner()
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Outer_Inner_Outer_Inner(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Outer_Inner_Outer_Inner()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Outer_Inner_Outer_Inner")
fileprivate func _bjs_struct_lower_Outer_Inner_Outer_Inner_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Outer_Inner_Outer_Inner_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Outer_Inner_Outer_Inner(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Outer_Inner_Outer_Inner_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Outer_Inner_Outer_Inner")
fileprivate func _bjs_struct_lift_Outer_Inner_Outer_Inner_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Outer_Inner_Outer_Inner_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Outer_Inner_Outer_Inner() -> Int32 {
    return _bjs_struct_lift_Outer_Inner_Outer_Inner_extern()
}

@_expose(wasm, "bjs_Outer_Inner_Outer_Inner_init")
@_cdecl("bjs_Outer_Inner_Outer_Inner_init")
public func _bjs_Outer_Inner_Outer_Inner_init() -> Void {
    #if arch(wasm32)
    let ret = Outer.Inner.Outer.Inner()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_init")
@_cdecl("bjs_Library_init")
public func _bjs_Library_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Library()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_divider")
@_cdecl("bjs_Library_divider")
public func _bjs_Library_divider(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Library.bridgeJSLiftParameter(_self).divider(_: Library.Shelf.Divider.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_deinit")
@_cdecl("bjs_Library_deinit")
public func _bjs_Library_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Library>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Library: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Library_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Library_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Library_wrap")
fileprivate func _bjs_Library_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Library_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Library_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Library_wrap_extern(pointer)
}

@_expose(wasm, "bjs_Outer_init")
@_cdecl("bjs_Outer_init")
public func _bjs_Outer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Outer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Outer_deinit")
@_cdecl("bjs_Outer_deinit")
public func _bjs_Outer_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Outer>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Outer: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Outer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Outer_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Outer_wrap")
fileprivate func _bjs_Outer_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Outer_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Outer_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Outer_wrap_extern(pointer)
}

extension Library.Shelf: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Library.Shelf.bridgeJSMakeTypeHandle()
}

extension Library.Shelf.Divider: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Library.Shelf.Divider.bridgeJSMakeTypeHandle()
}

extension Outer.Inner: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Outer.Inner.bridgeJSMakeTypeHandle()
}

extension Outer.Inner.Outer: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Outer.Inner.Outer.bridgeJSMakeTypeHandle()
}

extension Outer.Inner.Outer.Inner: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Outer.Inner.Outer.Inner.bridgeJSMakeTypeHandle()
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "bjs_TestModule_register_type_handles")
fileprivate func _bjs_TestModule_register_type_handles_extern(_ base: UnsafePointer<Int32>?, _ count: Int32)

@_expose(wasm, "bjs_TestModule_register_type_handles")
public func _bjs_TestModule_register_type_handles() {
    let typeIds: [Int32] = [
        Library.Shelf.bridgeJSTypeID,
        Library.Shelf.Divider.bridgeJSTypeID,
        Outer.Inner.bridgeJSTypeID,
        Outer.Inner.Outer.bridgeJSTypeID,
        Outer.Inner.Outer.Inner.bridgeJSTypeID,
    ]
    typeIds.withUnsafeBufferPointer { buffer in
        _bjs_TestModule_register_type_handles_extern(buffer.baseAddress, Int32(buffer.count))
    }
}
#endif