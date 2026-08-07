struct AnyObserver: Observer, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    func `if`(_ value: Int) -> Bool {
        let valueValue = value.bridgeJSLowerParameter()
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_if(jsObjectValue, valueValue)
        return Bool.bridgeJSLiftReturn(ret)
    }

    func `else`() -> String {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_else(jsObjectValue)
        return String.bridgeJSLiftReturn(ret)
    }

    var `do`: Int {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_Observer_do_get(jsObjectValue)
            return Int.bridgeJSLiftReturn(ret)
        }
        set {
            let newValueValue = newValue.bridgeJSLowerParameter()
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_Observer_do_set(jsObjectValue, newValueValue)
        }
    }

    var `for`: String {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_Observer_for_get(jsObjectValue)
            return String.bridgeJSLiftReturn(ret)
        }
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyObserver(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Observer_if")
fileprivate func _extern_if_extern(_ jsObject: Int32, _ value: Int32) -> Int32
#else
fileprivate func _extern_if_extern(_ jsObject: Int32, _ value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_if(_ jsObject: Int32, _ value: Int32) -> Int32 {
    return _extern_if_extern(jsObject, value)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Observer_else")
fileprivate func _extern_else_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func _extern_else_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_else(_ jsObject: Int32) -> Int32 {
    return _extern_else_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Observer_do_get")
fileprivate func bjs_Observer_do_get_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_Observer_do_get_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Observer_do_get(_ jsObject: Int32) -> Int32 {
    return bjs_Observer_do_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Observer_do_set")
fileprivate func bjs_Observer_do_set_extern(_ jsObject: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_Observer_do_set_extern(_ jsObject: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Observer_do_set(_ jsObject: Int32, _ newValue: Int32) -> Void {
    return bjs_Observer_do_set_extern(jsObject, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Observer_for_get")
fileprivate func bjs_Observer_for_get_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_Observer_for_get_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Observer_for_get(_ jsObject: Int32) -> Int32 {
    return bjs_Observer_for_get_extern(jsObject)
}

extension Token: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> Token {
        switch caseId {
        case 0:
            return .break
        case 1:
            return .return(String.bridgeJSStackPop())
        default:
            fatalError("Unknown Token case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .break:
            return Int32(0)
        case .return(let param0):
            param0.bridgeJSStackPush()
            return Int32(1)
        }
    }
}

@_expose(wasm, "bjs_Token_static_switch")
@_cdecl("bjs_Token_static_switch")
public func _bjs_Token_static_switch(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Token.switch(_: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Record: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Record {
        let `continue` = String.bridgeJSStackPop()
        let `case` = Int.bridgeJSStackPop()
        return Record(case: `case`, continue: `continue`)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.case.bridgeJSStackPush()
        self.continue.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Record(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Record()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Record")
fileprivate func _bjs_struct_lower_Record_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Record_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Record(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Record_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Record")
fileprivate func _bjs_struct_lift_Record_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Record_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Record() -> Int32 {
    return _bjs_struct_lift_Record_extern()
}

@_expose(wasm, "bjs_Record_init")
@_cdecl("bjs_Record_init")
public func _bjs_Record_init(_ case: Int32, _ continueBytes: Int32, _ continueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Record(case: Int.bridgeJSLiftParameter(`case`), continue: String.bridgeJSLiftParameter(continueBytes, continueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Record_as")
@_cdecl("bjs_Record_as")
public func _bjs_Record_as() -> Void {
    #if arch(wasm32)
    let ret = Record.bridgeJSLiftParameter().as()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_default")
@_cdecl("bjs_default")
public func _bjs_default() -> Void {
    #if arch(wasm32)
    `default`()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_delete")
@_cdecl("bjs_delete")
public func _bjs_delete(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = delete(_: Int32.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Parser_init")
@_cdecl("bjs_Parser_init")
public func _bjs_Parser_init(_ in: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Parser(in: Int.bridgeJSLiftParameter(`in`))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Parser_class")
@_cdecl("bjs_Parser_class")
public func _bjs_Parser_class(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Parser.bridgeJSLiftParameter(_self).class()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Parser_static_where")
@_cdecl("bjs_Parser_static_where")
public func _bjs_Parser_static_where(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Parser.where(_: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Parser_in_get")
@_cdecl("bjs_Parser_in_get")
public func _bjs_Parser_in_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Parser.bridgeJSLiftParameter(_self).in
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Parser_in_set")
@_cdecl("bjs_Parser_in_set")
public func _bjs_Parser_in_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    Parser.bridgeJSLiftParameter(_self).in = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Parser_static_self_get")
@_cdecl("bjs_Parser_static_self_get")
public func _bjs_Parser_static_self_get() -> Void {
    #if arch(wasm32)
    let ret = Parser.`self`
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Parser_deinit")
@_cdecl("bjs_Parser_deinit")
public func _bjs_Parser_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Parser>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Parser: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Parser_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Parser_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Parser_wrap")
fileprivate func _bjs_Parser_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Parser_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Parser_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Parser_wrap_extern(pointer)
}