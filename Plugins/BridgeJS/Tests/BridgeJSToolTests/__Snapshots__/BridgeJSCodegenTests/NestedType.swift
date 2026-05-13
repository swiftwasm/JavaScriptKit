extension User.Stats: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> User.Stats {
        let score = Double.bridgeJSStackPop()
        let health = Int.bridgeJSStackPop()
        return User.Stats(health: health, score: score)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.health.bridgeJSStackPush()
        self.score.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_User_Stats(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_User_Stats()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_User_Stats")
fileprivate func _bjs_struct_lower_User_Stats_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_User_Stats_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_User_Stats(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_User_Stats_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_User_Stats")
fileprivate func _bjs_struct_lift_User_Stats_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_User_Stats_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_User_Stats() -> Int32 {
    return _bjs_struct_lift_User_Stats_extern()
}

extension Player.Stats: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Player.Stats {
        let rating = String.bridgeJSStackPop()
        let level = Int.bridgeJSStackPop()
        return Player.Stats(level: level, rating: rating)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.level.bridgeJSStackPush()
        self.rating.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Player_Stats(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Player_Stats()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Player_Stats")
fileprivate func _bjs_struct_lower_Player_Stats_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Player_Stats_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Player_Stats(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Player_Stats_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Player_Stats")
fileprivate func _bjs_struct_lift_Player_Stats_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Player_Stats_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Player_Stats() -> Int32 {
    return _bjs_struct_lift_Player_Stats_extern()
}

@_expose(wasm, "bjs_User_getName")
@_cdecl("bjs_User_getName")
public func _bjs_User_getName(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = User.bridgeJSLiftParameter(_self).getName()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_User_deinit")
@_cdecl("bjs_User_deinit")
public func _bjs_User_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<User>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension User: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_User_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_User_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_User_wrap")
fileprivate func _bjs_User_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_User_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_User_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_User_wrap_extern(pointer)
}

@_expose(wasm, "bjs_Player_getTag")
@_cdecl("bjs_Player_getTag")
public func _bjs_Player_getTag(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Player.bridgeJSLiftParameter(_self).getTag()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Player_deinit")
@_cdecl("bjs_Player_deinit")
public func _bjs_Player_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Player>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Player: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Player_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Player_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Player_wrap")
fileprivate func _bjs_Player_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Player_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Player_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Player_wrap_extern(pointer)
}