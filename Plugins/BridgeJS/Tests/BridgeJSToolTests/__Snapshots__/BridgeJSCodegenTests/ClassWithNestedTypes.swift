extension Account.Role: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension Account.Credentials: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Account.Credentials {
        let token = String.bridgeJSStackPop()
        return Account.Credentials(token: token)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.token.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Account_Credentials(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Account_Credentials()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Account_Credentials")
fileprivate func _bjs_struct_lower_Account_Credentials_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Account_Credentials_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Account_Credentials(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Account_Credentials_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Account_Credentials")
fileprivate func _bjs_struct_lift_Account_Credentials_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Account_Credentials_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Account_Credentials() -> Int32 {
    return _bjs_struct_lift_Account_Credentials_extern()
}

@_expose(wasm, "bjs_Account_Credentials_init")
@_cdecl("bjs_Account_Credentials_init")
public func _bjs_Account_Credentials_init(_ tokenBytes: Int32, _ tokenLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Account.Credentials(token: String.bridgeJSLiftParameter(tokenBytes, tokenLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Account_Credentials_static_maxLength_get")
@_cdecl("bjs_Account_Credentials_static_maxLength_get")
public func _bjs_Account_Credentials_static_maxLength_get() -> Int32 {
    #if arch(wasm32)
    let ret = Account_Credentials.maxLength
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Account_Credentials_static_empty")
@_cdecl("bjs_Account_Credentials_static_empty")
public func _bjs_Account_Credentials_static_empty() -> Void {
    #if arch(wasm32)
    let ret = Account.Credentials.empty()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Account_init")
@_cdecl("bjs_Account_init")
public func _bjs_Account_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Account(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Account_describe")
@_cdecl("bjs_Account_describe")
public func _bjs_Account_describe(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Account.bridgeJSLiftParameter(_self).describe()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Account_name_get")
@_cdecl("bjs_Account_name_get")
public func _bjs_Account_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Account.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Account_name_set")
@_cdecl("bjs_Account_name_set")
public func _bjs_Account_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    Account.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Account_role_get")
@_cdecl("bjs_Account_role_get")
public func _bjs_Account_role_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Account.bridgeJSLiftParameter(_self).role
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Account_static_defaultRole_get")
@_cdecl("bjs_Account_static_defaultRole_get")
public func _bjs_Account_static_defaultRole_get() -> Void {
    #if arch(wasm32)
    let ret = Account.defaultRole
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Account_deinit")
@_cdecl("bjs_Account_deinit")
public func _bjs_Account_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Account>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Account: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Account_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Account_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Account_wrap")
fileprivate func _bjs_Account_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Account_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Account_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Account_wrap_extern(pointer)
}