extension Counter: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Counter {
        let number = Int.bridgeJSStackPop()
        return Counter(number: number)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.number.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Counter(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Counter()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Counter")
fileprivate func _bjs_struct_lower_Counter_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Counter_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Counter(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Counter_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Counter")
fileprivate func _bjs_struct_lift_Counter_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Counter_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Counter() -> Int32 {
    return _bjs_struct_lift_Counter_extern()
}