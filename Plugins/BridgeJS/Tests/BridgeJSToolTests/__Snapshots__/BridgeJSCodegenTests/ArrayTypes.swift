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

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .north
        case 1:
            self = .south
        case 2:
            self = .east
        case 3:
            self = .west
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .north:
            return 0
        case .south:
            return 1
        case .east:
            return 2
        case .west:
            return 3
        }
    }
}

extension Status: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension Point: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Point {
        let y = Double.bridgeJSLiftParameter()
        let x = Double.bridgeJSLiftParameter()
        return Point(x: x, y: y)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.x.bridgeJSLowerStackReturn()
        self.y.bridgeJSLowerStackReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Point(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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

@_expose(wasm, "bjs_processIntArray")
@_cdecl("bjs_processIntArray")
public func _bjs_processIntArray() -> Void {
    #if arch(wasm32)
    let ret = processIntArray(_: [Int].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processStringArray")
@_cdecl("bjs_processStringArray")
public func _bjs_processStringArray() -> Void {
    #if arch(wasm32)
    let ret = processStringArray(_: [String].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processDoubleArray")
@_cdecl("bjs_processDoubleArray")
public func _bjs_processDoubleArray() -> Void {
    #if arch(wasm32)
    let ret = processDoubleArray(_: [Double].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processBoolArray")
@_cdecl("bjs_processBoolArray")
public func _bjs_processBoolArray() -> Void {
    #if arch(wasm32)
    let ret = processBoolArray(_: [Bool].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processPointArray")
@_cdecl("bjs_processPointArray")
public func _bjs_processPointArray() -> Void {
    #if arch(wasm32)
    let ret = processPointArray(_: [Point].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processDirectionArray")
@_cdecl("bjs_processDirectionArray")
public func _bjs_processDirectionArray() -> Void {
    #if arch(wasm32)
    let ret = processDirectionArray(_: [Direction].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processStatusArray")
@_cdecl("bjs_processStatusArray")
public func _bjs_processStatusArray() -> Void {
    #if arch(wasm32)
    let ret = processStatusArray(_: [Status].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_sumIntArray")
@_cdecl("bjs_sumIntArray")
public func _bjs_sumIntArray() -> Int32 {
    #if arch(wasm32)
    let ret = sumIntArray(_: [Int].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_findFirstPoint")
@_cdecl("bjs_findFirstPoint")
public func _bjs_findFirstPoint(_ matchingBytes: Int32, _ matchingLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = findFirstPoint(_: [Point].bridgeJSLiftParameter(), matching: String.bridgeJSLiftParameter(matchingBytes, matchingLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processUnsafeRawPointerArray")
@_cdecl("bjs_processUnsafeRawPointerArray")
public func _bjs_processUnsafeRawPointerArray() -> Void {
    #if arch(wasm32)
    let ret = processUnsafeRawPointerArray(_: [UnsafeRawPointer].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processUnsafeMutableRawPointerArray")
@_cdecl("bjs_processUnsafeMutableRawPointerArray")
public func _bjs_processUnsafeMutableRawPointerArray() -> Void {
    #if arch(wasm32)
    let ret = processUnsafeMutableRawPointerArray(_: [UnsafeMutableRawPointer].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOpaquePointerArray")
@_cdecl("bjs_processOpaquePointerArray")
public func _bjs_processOpaquePointerArray() -> Void {
    #if arch(wasm32)
    let ret = processOpaquePointerArray(_: [OpaquePointer].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOptionalIntArray")
@_cdecl("bjs_processOptionalIntArray")
public func _bjs_processOptionalIntArray() -> Void {
    #if arch(wasm32)
    let ret = processOptionalIntArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<Int>] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append(Optional<Int>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()}
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOptionalStringArray")
@_cdecl("bjs_processOptionalStringArray")
public func _bjs_processOptionalStringArray() -> Void {
    #if arch(wasm32)
    let ret = processOptionalStringArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<String>] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append(Optional<String>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()}
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOptionalArray")
@_cdecl("bjs_processOptionalArray")
public func _bjs_processOptionalArray(_ values: Int32) -> Void {
    #if arch(wasm32)
    let ret = processOptionalArray(_: {
        if values == 0 {
            return Optional<[Int]>.none
        } else {
            return [Int].bridgeJSLiftParameter()
        }
        }())
    let __bjs_isSome_ret = ret != nil
    if let __bjs_unwrapped_ret = ret {
    __bjs_unwrapped_ret.bridgeJSLowerReturn()}
    _swift_js_push_i32(__bjs_isSome_ret ? 1 : 0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOptionalPointArray")
@_cdecl("bjs_processOptionalPointArray")
public func _bjs_processOptionalPointArray() -> Void {
    #if arch(wasm32)
    let ret = processOptionalPointArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<Point>] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append(Optional<Point>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerReturn()}
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOptionalDirectionArray")
@_cdecl("bjs_processOptionalDirectionArray")
public func _bjs_processOptionalDirectionArray() -> Void {
    #if arch(wasm32)
    let ret = processOptionalDirectionArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<Direction>] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append(Optional<Direction>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()}
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOptionalStatusArray")
@_cdecl("bjs_processOptionalStatusArray")
public func _bjs_processOptionalStatusArray() -> Void {
    #if arch(wasm32)
    let ret = processOptionalStatusArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<Status>] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append(Optional<Status>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()}
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processNestedIntArray")
@_cdecl("bjs_processNestedIntArray")
public func _bjs_processNestedIntArray() -> Void {
    #if arch(wasm32)
    let ret = processNestedIntArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [[Int]] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append([Int].bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    __bjs_elem_ret.bridgeJSLowerReturn()}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processNestedStringArray")
@_cdecl("bjs_processNestedStringArray")
public func _bjs_processNestedStringArray() -> Void {
    #if arch(wasm32)
    let ret = processNestedStringArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [[String]] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append([String].bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    __bjs_elem_ret.bridgeJSLowerReturn()}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processNestedPointArray")
@_cdecl("bjs_processNestedPointArray")
public func _bjs_processNestedPointArray() -> Void {
    #if arch(wasm32)
    let ret = processNestedPointArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [[Point]] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append([Point].bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    __bjs_elem_ret.bridgeJSLowerReturn()}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processItemArray")
@_cdecl("bjs_processItemArray")
public func _bjs_processItemArray() -> Void {
    #if arch(wasm32)
    let ret = processItemArray(_: [Item].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processNestedItemArray")
@_cdecl("bjs_processNestedItemArray")
public func _bjs_processNestedItemArray() -> Void {
    #if arch(wasm32)
    let ret = processNestedItemArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [[Item]] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append([Item].bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    __bjs_elem_ret.bridgeJSLowerReturn()}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processJSObjectArray")
@_cdecl("bjs_processJSObjectArray")
public func _bjs_processJSObjectArray() -> Void {
    #if arch(wasm32)
    let ret = processJSObjectArray(_: [JSObject].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOptionalJSObjectArray")
@_cdecl("bjs_processOptionalJSObjectArray")
public func _bjs_processOptionalJSObjectArray() -> Void {
    #if arch(wasm32)
    let ret = processOptionalJSObjectArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<JSObject>] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append(Optional<JSObject>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()}
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processNestedJSObjectArray")
@_cdecl("bjs_processNestedJSObjectArray")
public func _bjs_processNestedJSObjectArray() -> Void {
    #if arch(wasm32)
    let ret = processNestedJSObjectArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [[JSObject]] = []
        __result.reserveCapacity(__count)
        for _ in 0 ..< __count {
            __result.append([JSObject].bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
        }())
    for __bjs_elem_ret in ret {
    __bjs_elem_ret.bridgeJSLowerReturn()}
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Item_deinit")
@_cdecl("bjs_Item_deinit")
public func _bjs_Item_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Item>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Item: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Item_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Item_wrap")
fileprivate func _bjs_Item_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Item_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_checkArray")
fileprivate func bjs_checkArray(_ a: Int32) -> Void
#else
fileprivate func bjs_checkArray(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkArray(_ a: JSObject) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    bjs_checkArray(aValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_checkArrayWithLength")
fileprivate func bjs_checkArrayWithLength(_ a: Int32, _ b: Float64) -> Void
#else
fileprivate func bjs_checkArrayWithLength(_ a: Int32, _ b: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkArrayWithLength(_ a: JSObject, _ b: Double) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    let bValue = b.bridgeJSLowerParameter()
    bjs_checkArrayWithLength(aValue, bValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importProcessNumbers")
fileprivate func bjs_importProcessNumbers() -> Void
#else
fileprivate func bjs_importProcessNumbers() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$importProcessNumbers(_ values: [Double]) throws(JSException) -> Void {
    let _ = values.bridgeJSLowerParameter()
    bjs_importProcessNumbers()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importGetNumbers")
fileprivate func bjs_importGetNumbers() -> Void
#else
fileprivate func bjs_importGetNumbers() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$importGetNumbers() throws(JSException) -> [Double] {
    bjs_importGetNumbers()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Double].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importTransformNumbers")
fileprivate func bjs_importTransformNumbers() -> Void
#else
fileprivate func bjs_importTransformNumbers() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$importTransformNumbers(_ values: [Double]) throws(JSException) -> [Double] {
    let _ = values.bridgeJSLowerParameter()
    bjs_importTransformNumbers()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Double].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importProcessStrings")
fileprivate func bjs_importProcessStrings() -> Void
#else
fileprivate func bjs_importProcessStrings() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$importProcessStrings(_ values: [String]) throws(JSException) -> [String] {
    let _ = values.bridgeJSLowerParameter()
    bjs_importProcessStrings()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importProcessBooleans")
fileprivate func bjs_importProcessBooleans() -> Void
#else
fileprivate func bjs_importProcessBooleans() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$importProcessBooleans(_ values: [Bool]) throws(JSException) -> [Bool] {
    let _ = values.bridgeJSLowerParameter()
    bjs_importProcessBooleans()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Bool].bridgeJSLiftReturn()
}