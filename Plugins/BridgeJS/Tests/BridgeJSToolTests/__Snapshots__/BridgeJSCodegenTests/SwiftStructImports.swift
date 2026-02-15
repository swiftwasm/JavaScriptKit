extension Point: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Point {
        let y = Int.bridgeJSStackPop()
        let x = Int.bridgeJSStackPop()
        return Point(x: x, y: y)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.y.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Point(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Point()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Point")
fileprivate func _bjs_struct_lower_Point(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Point(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Point")
fileprivate func _bjs_struct_lift_Point() -> Int32
#else
fileprivate func _bjs_struct_lift_Point() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_translate")
fileprivate func bjs_translate(_ point: Int32, _ dx: Int32, _ dy: Int32) -> Int32
#else
fileprivate func bjs_translate(_ point: Int32, _ dx: Int32, _ dy: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$translate(_ point: Point, _ dx: Int, _ dy: Int) throws(JSException) -> Point {
    let pointObjectId = point.bridgeJSLowerParameter()
    let dxValue = dx.bridgeJSLowerParameter()
    let dyValue = dy.bridgeJSLowerParameter()
    let ret = bjs_translate(pointObjectId, dxValue, dyValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Point.bridgeJSLiftReturn(ret)
}