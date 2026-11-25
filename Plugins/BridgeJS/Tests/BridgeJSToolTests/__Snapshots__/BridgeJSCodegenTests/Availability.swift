#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule5PointV5LevelO_9DirectionO")
fileprivate func invoke_js_callback_TestModule_10TestModule5PointV5LevelO_9DirectionO_extern(_ callback: Int32, _ param1Word0: Int32, _ param1Word1: Int32, _ param1Word2: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule5PointV5LevelO_9DirectionO_extern(_ callback: Int32, _ param1Word0: Int32, _ param1Word1: Int32, _ param1Word2: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule5PointV5LevelO_9DirectionO(_ callback: Int32, _ param1Word0: Int32, _ param1Word1: Int32, _ param1Word2: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModule5PointV5LevelO_9DirectionO_extern(callback, param1Word0, param1Word1, param1Word2)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule5PointV5LevelO_9DirectionO")
fileprivate func make_swift_closure_TestModule_10TestModule5PointV5LevelO_9DirectionO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule5PointV5LevelO_9DirectionO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule5PointV5LevelO_9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule5PointV5LevelO_9DirectionO_extern(boxPtr, file, line)
}

@available(macOS 14.0, *)
@available(macOS 15.0, *)
@available(macOS 14.0, iOS 17.0, *)
private enum _BJS_Closure_10TestModule5PointV5LevelO_9DirectionO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Point, Level) -> Direction {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0, param1) in
            #if arch(wasm32)
            let ret0 = param1.bridgeJSWithLoweredParameter { (param1Word0, param1Word1, param1Word2) in
                let _ = param0.bridgeJSLowerParameter()
                let callbackValue = callback.bridgeJSLowerParameter()
                let ret = invoke_js_callback_TestModule_10TestModule5PointV5LevelO_9DirectionO(callbackValue, param1Word0, param1Word1, param1Word2)
                return ret
            }
            let ret = ret0
            return Direction.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

@available(macOS 14.0, *)
@available(macOS 15.0, *)
@available(macOS 14.0, iOS 17.0, *)
extension JSTypedClosure where Signature == (Point, Level) -> Direction {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Point, Level) -> Direction) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule5PointV5LevelO_9DirectionO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule5PointV5LevelO_9DirectionO")
@_cdecl("invoke_swift_closure_TestModule_10TestModule5PointV5LevelO_9DirectionO")
public func _invoke_swift_closure_TestModule_10TestModule5PointV5LevelO_9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ param1Bytes: Int32, _ param1Length: Int32) -> Int32 {
    #if arch(wasm32)
    let param1 = Level.bridgeJSLiftParameter(param1Bytes, param1Length)
    let param0 = Point.bridgeJSLiftParameter()
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Point, Level) -> Direction>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let ret = closure(param0, param1)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if compiler(>=6.4)
#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si")
fileprivate func invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si_extern(_ callback: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si_extern(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si(_ callback: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si_extern(callback)
}
#endif

#if compiler(>=6.4)
#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si")
fileprivate func make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si_extern(boxPtr, file, line)
}
#endif

#if compiler(>=6.4)
@available(anyAppleOS 27.0, *)
@available(macOS 14.0, *)
private enum _BJS_Closure_10TestModuleSa17NoncopyableObjectV5PointV_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (borrowing UniqueArray<NoncopyableObject>, Point) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0, param1) in
            #if arch(wasm32)
            let _ = param1.bridgeJSLowerParameter()
            let _ = param0.bridgeJSLowerParameter()
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si(callbackValue)
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}
#endif

#if compiler(>=6.4)
@available(anyAppleOS 27.0, *)
@available(macOS 14.0, *)
extension JSTypedClosure where Signature == (borrowing UniqueArray<NoncopyableObject>, Point) -> Int {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (borrowing UniqueArray<NoncopyableObject>, Point) -> Int) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}
#endif

#if compiler(>=6.4)
@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si")
public func _invoke_swift_closure_TestModule_10TestModuleSa17NoncopyableObjectV5PointV_Si(_ boxPtr: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let param1 = Point.bridgeJSLiftParameter()
    let param0 = UniqueArray<NoncopyableObject>.bridgeJSStackPop()
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(borrowing UniqueArray<NoncopyableObject>, Point) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let ret = closure(param0, param1)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
#endif

@available(macOS 14.0, *)
extension Source where Self: _BridgedSwiftProtocolWrapper {
    func value() -> Int {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = bjs_Source_value(jsObjectValue)
        return Int.bridgeJSLiftReturn(ret)
    }
}

struct AnySource: Source, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnySource(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Source_value")
fileprivate func bjs_Source_value_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_Source_value_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Source_value(_ jsObject: Int32) -> Int32 {
    return bjs_Source_value_extern(jsObject)
}

extension PointSource where Self: _BridgedSwiftProtocolWrapper {
    @available(macOS 14.0, *)
    func point() -> Point {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        bjs_PointSource_point(jsObjectValue)
        return Point.bridgeJSLiftReturn()
    }

    @available(macOS 14.0, *)
    var origin: Point {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_PointSource_origin_get(jsObjectValue)
            return Point.bridgeJSLiftReturn()
        }
    }
}

struct AnyPointSource: PointSource, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyPointSource(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PointSource_point")
fileprivate func bjs_PointSource_point_extern(_ jsObject: Int32) -> Void
#else
fileprivate func bjs_PointSource_point_extern(_ jsObject: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_PointSource_point(_ jsObject: Int32) -> Void {
    return bjs_PointSource_point_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PointSource_origin_get")
fileprivate func bjs_PointSource_origin_get_extern(_ jsObject: Int32) -> Void
#else
fileprivate func bjs_PointSource_origin_get_extern(_ jsObject: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_PointSource_origin_get(_ jsObject: Int32) -> Void {
    return bjs_PointSource_origin_get_extern(jsObject)
}

@available(macOS 14.0, iOS 17.0, *)
extension Direction: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Direction {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Direction {
        return Direction(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) @usableFromInline init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .north
        case 1:
            self = .south
        default:
            return nil
        }
    }

    @_spi(BridgeJS) @usableFromInline var bridgeJSRawValue: Int32 {
        switch self {
        case .north:
            return 0
        case .south:
            return 1
        }
    }
}

@available(macOS 15.0, *)
extension Level: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

@available(macOS 14.0, *)
extension Shape: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> Shape {
        switch caseId {
        case 0:
            return .circle(Double.bridgeJSStackPop())
        case 1:
            return .square(Int.bridgeJSStackPop())
        default:
            fatalError("Unknown Shape case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .circle(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .square(let param0):
            param0.bridgeJSStackPush()
            return Int32(1)
        }
    }
}

@available(macOS 14.0, *)
extension Point: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Point {
        let x = Int.bridgeJSStackPop()
        return Point(x: x)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
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

@available(macOS 14.0, *)
extension Geometry.Box: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Geometry.Box {
        let side = Int.bridgeJSStackPop()
        return Geometry.Box(side: side)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.side.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Geometry_Box(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Geometry_Box()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Geometry_Box")
fileprivate func _bjs_struct_lower_Geometry_Box_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Geometry_Box_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Geometry_Box(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Geometry_Box_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Geometry_Box")
fileprivate func _bjs_struct_lift_Geometry_Box_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Geometry_Box_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Geometry_Box() -> Int32 {
    return _bjs_struct_lift_Geometry_Box_extern()
}

@available(macOS 14.0, *)
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

@_expose(wasm, "bjs_mix")
@_cdecl("bjs_mix")
public func _bjs_mix(_ body: Int32) -> Int32 {
    #if arch(wasm32)
    let body = _BJS_Closure_10TestModule5PointV5LevelO_9DirectionO.bridgeJSLift(body)
    let point = Point.bridgeJSLiftParameter()
    let ret = mix(_: point, _: body)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_loadPoint")
@_cdecl("bjs_loadPoint")
public func _bjs_loadPoint() -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_5PointV, reject: Promise_reject) {
        return await loadPoint()
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if compiler(>=6.4)
@_expose(wasm, "bjs_countObjects")
@_cdecl("bjs_countObjects")
public func _bjs_countObjects(_ body: Int32) -> Int32 {
    #if arch(wasm32)
    let body = _BJS_Closure_10TestModuleSa17NoncopyableObjectV5PointV_Si.bridgeJSLift(body)
    let ret = countObjects(_: body)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
#endif

@_expose(wasm, "bjs_Counter_init")
@_cdecl("bjs_Counter_init")
public func _bjs_Counter_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Counter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Counter_deinit")
@_cdecl("bjs_Counter_deinit")
public func _bjs_Counter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Counter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@available(macOS 14.0, *)
extension Counter: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Counter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Counter_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Counter_wrap")
fileprivate func _bjs_Counter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Counter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Counter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Counter_wrap_extern(pointer)
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

@_expose(wasm, "bjs_TagReference_init")
@_cdecl("bjs_TagReference_init")
public func _bjs_TagReference_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let name = String.bridgeJSLiftParameter(nameBytes, nameLength)
    let ret = TagReference(name: name)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TagReference_deinit")
@_cdecl("bjs_TagReference_deinit")
public func _bjs_TagReference_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<TagReference>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@available(macOS 14.0, *)
extension TagReference: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TagReference_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_TagReference_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_TagReference_wrap")
fileprivate func _bjs_TagReference_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TagReference_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_TagReference_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_TagReference_wrap_extern(pointer)
}

@available(macOS 14.0, *)
extension Point: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Point.bridgeJSMakeTypeHandle()
}

@available(macOS 14.0, *)
extension Geometry.Box: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Geometry.Box.bridgeJSMakeTypeHandle()
}

@available(macOS 14.0, *)
extension Library.Shelf: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Library.Shelf.bridgeJSMakeTypeHandle()
}

@available(macOS 14.0, *)
extension Counter: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Counter.bridgeJSMakeTypeHandle()
}

@available(macOS 14.0, *)
extension TagReference: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = TagReference.bridgeJSMakeTypeHandle()
}

@available(macOS 14.0, iOS 17.0, *)
extension Direction: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Direction.bridgeJSMakeTypeHandle()
}

@available(macOS 15.0, *)
extension Level: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Level.bridgeJSMakeTypeHandle()
}

@available(macOS 14.0, *)
extension Shape: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeHandle = Shape.bridgeJSMakeTypeHandle()
}

@JSFunction func Promise_reject(_ promise: JSObject, _ value: JSValue) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_reject_TestModule")
fileprivate func promise_reject_TestModule_extern(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void
#else
fileprivate func promise_reject_TestModule_extern(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_reject_TestModule(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    return promise_reject_TestModule_extern(promise, valueKind, valuePayload1, valuePayload2)
}

func _$Promise_reject(_ promise: JSObject, _ value: JSValue) throws(JSException) -> Void {
    let (valueKind, valuePayload1, valuePayload2) = value.bridgeJSLowerParameter()
    let promiseValue = promise.bridgeJSLowerParameter()
    promise_reject_TestModule(promiseValue, valueKind, valuePayload1, valuePayload2)
    if let error = _swift_js_take_exception() { throw error }
}

@available(macOS 14.0, *)
@JSFunction func Promise_resolve_5PointV(_ promise: JSObject, _ value: Point) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_5PointV")
fileprivate func promise_resolve_TestModule_5PointV_extern(_ promise: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_5PointV_extern(_ promise: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_5PointV(_ promise: Int32) -> Void {
    return promise_resolve_TestModule_5PointV_extern(promise)
}

@available(macOS 14.0, *)
func _$Promise_resolve_5PointV(_ promise: JSObject, _ value: Point) throws(JSException) -> Void {
    let _ = value.bridgeJSLowerParameter()
    let promiseValue = promise.bridgeJSLowerParameter()
    promise_resolve_TestModule_5PointV(promiseValue)
    if let error = _swift_js_take_exception() { throw error }
}

@available(macOS 14.0, *)
extension Tag: _BridgedSwiftAlias, _BridgedSwiftStackType {}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Element_id")
fileprivate func bjs_Element_id_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Element_id_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Element_id(_ self: Int32) -> Int32 {
    return bjs_Element_id_extern(self)
}

func _$Element_id(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Element_id(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Canvas_element")
fileprivate func bjs_Canvas_element_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Canvas_element_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Canvas_element(_ self: Int32) -> Int32 {
    return bjs_Canvas_element_extern(self)
}

@available(macOS 14.0, *)
func _$Canvas_element(_ self: JSObject) throws(JSException) -> Element {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Canvas_element(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Element.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_NoncopyableObject_id")
fileprivate func bjs_NoncopyableObject_id_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_NoncopyableObject_id_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_NoncopyableObject_id(_ self: Int32) -> Int32 {
    return bjs_NoncopyableObject_id_extern(self)
}

func _$NoncopyableObject_id(_ self: borrowing JSUniqueRef) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_NoncopyableObject_id(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "bjs_TestModule_register_type_handles")
fileprivate func _bjs_TestModule_register_type_handles_extern(_ base: UnsafePointer<Int32>?, _ count: Int32)

@_expose(wasm, "bjs_TestModule_register_type_handles")
public func _bjs_TestModule_register_type_handles() {
    let typeIds: [Int32] = [
        Point.bridgeJSTypeID,
        Geometry.Box.bridgeJSTypeID,
        Library.Shelf.bridgeJSTypeID,
        Counter.bridgeJSTypeID,
        TagReference.bridgeJSTypeID,
        Direction.bridgeJSTypeID,
        Level.bridgeJSTypeID,
        Shape.bridgeJSTypeID,
    ]
    typeIds.withUnsafeBufferPointer { buffer in
        _bjs_TestModule_register_type_handles_extern(buffer.baseAddress, Int32(buffer.count))
    }
}
#endif