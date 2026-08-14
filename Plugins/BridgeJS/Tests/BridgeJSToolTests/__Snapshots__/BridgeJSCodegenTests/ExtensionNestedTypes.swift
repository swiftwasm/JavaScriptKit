extension Message: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> Message {
        switch caseId {
        case 0:
            return .update(Message.Update.bridgeJSStackPop())
        case 1:
            return .delete
        default:
            fatalError("Unknown Message case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .update(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .delete:
            return Int32(1)
        }
    }
}

extension Library.Genre: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension Message.Update: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Message.Update {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Message.Update {
        return Message.Update(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) @usableFromInline init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .flip
        case 1:
            self = .rotate
        default:
            return nil
        }
    }

    @_spi(BridgeJS) @usableFromInline var bridgeJSRawValue: Int32 {
        switch self {
        case .flip:
            return 0
        case .rotate:
            return 1
        }
    }
}

extension Library.Shelf: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Library.Shelf {
        let label = String.bridgeJSStackPop()
        return Library.Shelf(label: label)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.label.bridgeJSStackPush()
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

@_expose(wasm, "bjs_Library_Shelf_init")
@_cdecl("bjs_Library_Shelf_init")
public func _bjs_Library_Shelf_init(_ labelBytes: Int32, _ labelLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Library.Shelf(label: String.bridgeJSLiftParameter(labelBytes, labelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_Shelf_static_capacity_get")
@_cdecl("bjs_Library_Shelf_static_capacity_get")
public func _bjs_Library_Shelf_static_capacity_get() -> Int32 {
    #if arch(wasm32)
    let ret = Library.Shelf.capacity
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_Shelf_describeShelf")
@_cdecl("bjs_Library_Shelf_describeShelf")
public func _bjs_Library_Shelf_describeShelf() -> Void {
    #if arch(wasm32)
    let ret = Library.Shelf.bridgeJSLiftParameter().describeShelf()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
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

@_expose(wasm, "bjs_roundTripMessage")
@_cdecl("bjs_roundTripMessage")
public func _bjs_roundTripMessage(_ message: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripMessage(_: Message.bridgeJSLiftParameter(message))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_init")
@_cdecl("bjs_Library_init")
public func _bjs_Library_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Library(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_describe")
@_cdecl("bjs_Library_describe")
public func _bjs_Library_describe(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Library.bridgeJSLiftParameter(_self).describe()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_rename")
@_cdecl("bjs_Library_rename")
public func _bjs_Library_rename(_ _self: UnsafeMutableRawPointer, _ titleBytes: Int32, _ titleLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Library.bridgeJSLiftParameter(_self).rename(_: String.bridgeJSLiftParameter(titleBytes, titleLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_shelf")
@_cdecl("bjs_Library_shelf")
public func _bjs_Library_shelf(_ _self: UnsafeMutableRawPointer, _ labelBytes: Int32, _ labelLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Library.bridgeJSLiftParameter(_self).shelf(label: String.bridgeJSLiftParameter(labelBytes, labelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_name_get")
@_cdecl("bjs_Library_name_get")
public func _bjs_Library_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Library.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Library_name_set")
@_cdecl("bjs_Library_name_set")
public func _bjs_Library_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    Library.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
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

extension Library.Shelf: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Library.Shelf.bridgeJSMakeTypeHandle()
}

extension Library.Shelf.Divider: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Library.Shelf.Divider.bridgeJSMakeTypeHandle()
}

extension Message: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Message.bridgeJSMakeTypeHandle()
}

extension Library.Genre: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Library.Genre.bridgeJSMakeTypeHandle()
}

extension Message.Update: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Message.Update.bridgeJSMakeTypeHandle()
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "bjs_TestModule_register_type_handles")
fileprivate func _bjs_TestModule_register_type_handles_extern(_ base: UnsafePointer<Int32>?, _ count: Int32)

@_expose(wasm, "bjs_TestModule_register_type_handles")
public func _bjs_TestModule_register_type_handles() {
    let typeIds: [Int32] = [
        Library.Shelf.bridgeJSTypeID,
        Library.Shelf.Divider.bridgeJSTypeID,
        Message.bridgeJSTypeID,
        Library.Genre.bridgeJSTypeID,
        Message.Update.bridgeJSTypeID,
    ]
    typeIds.withUnsafeBufferPointer { buffer in
        _bjs_TestModule_register_type_handles_extern(buffer.baseAddress, Int32(buffer.count))
    }
}
#endif