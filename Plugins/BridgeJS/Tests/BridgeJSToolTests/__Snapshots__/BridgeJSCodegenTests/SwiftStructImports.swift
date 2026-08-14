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
        _bjs_struct_lower_Point(jsObject.bridgeJSLowerParameter())
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
fileprivate func _bjs_struct_lower_Point_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Point_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Point(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Point_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Point")
fileprivate func _bjs_struct_lift_Point_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Point_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Point() -> Int32 {
    return _bjs_struct_lift_Point_extern()
}

extension Point: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Point.bridgeJSMakeTypeHandle()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_translate")
fileprivate func bjs_translate_extern(_ dx: Int32, _ dy: Int32) -> Void
#else
fileprivate func bjs_translate_extern(_ dx: Int32, _ dy: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_translate(_ dx: Int32, _ dy: Int32) -> Void {
    return bjs_translate_extern(dx, dy)
}

func _$translate(_ point: Point, _ dx: Int, _ dy: Int) throws(JSException) -> Point {
    let dyValue = dy.bridgeJSLowerParameter()
    let dxValue = dx.bridgeJSLowerParameter()
    let _ = point.bridgeJSLowerParameter()
    bjs_translate(dxValue, dyValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Point.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundTripOptional")
fileprivate func bjs_roundTripOptional_extern() -> Void
#else
fileprivate func bjs_roundTripOptional_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundTripOptional() -> Void {
    return bjs_roundTripOptional_extern()
}

func _$roundTripOptional(_ point: Optional<Point>) throws(JSException) -> Optional<Point> {
    let _ = point.bridgeJSLowerParameter()
    bjs_roundTripOptional()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Point>.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "bjs_TestModule_register_type_handles")
fileprivate func _bjs_TestModule_register_type_handles_extern(_ base: UnsafePointer<Int32>?, _ count: Int32)

@_expose(wasm, "bjs_TestModule_register_type_handles")
public func _bjs_TestModule_register_type_handles() {
    let typeIds: [Int32] = [
        Point.bridgeJSTypeID,
    ]
    typeIds.withUnsafeBufferPointer { buffer in
        _bjs_TestModule_register_type_handles_extern(buffer.baseAddress, Int32(buffer.count))
    }
}
#endif