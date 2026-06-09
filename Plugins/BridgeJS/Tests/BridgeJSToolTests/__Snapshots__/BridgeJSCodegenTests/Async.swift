extension AsyncDirection: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> AsyncDirection {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> AsyncDirection {
        return AsyncDirection(bridgeJSRawValue: value)!
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

extension AsyncTheme: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension AsyncPoint: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> AsyncPoint {
        let y = Int.bridgeJSStackPop()
        let x = Int.bridgeJSStackPop()
        return AsyncPoint(x: x, y: y)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.y.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_AsyncPoint(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_AsyncPoint()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_AsyncPoint")
fileprivate func _bjs_struct_lower_AsyncPoint_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_AsyncPoint_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_AsyncPoint(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_AsyncPoint_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_AsyncPoint")
fileprivate func _bjs_struct_lift_AsyncPoint_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_AsyncPoint_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_AsyncPoint() -> Int32 {
    return _bjs_struct_lift_AsyncPoint_extern()
}

@_expose(wasm, "bjs_asyncReturnVoid")
@_cdecl("bjs_asyncReturnVoid")
public func _bjs_asyncReturnVoid() -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_y, reject: Promise_reject) {
        await asyncReturnVoid()
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripInt")
@_cdecl("bjs_asyncRoundTripInt")
public func _bjs_asyncRoundTripInt(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_Si, reject: Promise_reject) {
        return await asyncRoundTripInt(_: Int.bridgeJSLiftParameter(v))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripString")
@_cdecl("bjs_asyncRoundTripString")
public func _bjs_asyncRoundTripString(_ vBytes: Int32, _ vLength: Int32) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_SS, reject: Promise_reject) {
        return await asyncRoundTripString(_: String.bridgeJSLiftParameter(vBytes, vLength))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripBool")
@_cdecl("bjs_asyncRoundTripBool")
public func _bjs_asyncRoundTripBool(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_Sb, reject: Promise_reject) {
        return await asyncRoundTripBool(_: Bool.bridgeJSLiftParameter(v))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripFloat")
@_cdecl("bjs_asyncRoundTripFloat")
public func _bjs_asyncRoundTripFloat(_ v: Float32) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_Sf, reject: Promise_reject) {
        return await asyncRoundTripFloat(_: Float.bridgeJSLiftParameter(v))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripDouble")
@_cdecl("bjs_asyncRoundTripDouble")
public func _bjs_asyncRoundTripDouble(_ v: Float64) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_Sd, reject: Promise_reject) {
        return await asyncRoundTripDouble(_: Double.bridgeJSLiftParameter(v))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripJSObject")
@_cdecl("bjs_asyncRoundTripJSObject")
public func _bjs_asyncRoundTripJSObject(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_8JSObjectC, reject: Promise_reject) {
        return await asyncRoundTripJSObject(_: JSObject.bridgeJSLiftParameter(v))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripStruct")
@_cdecl("bjs_asyncRoundTripStruct")
public func _bjs_asyncRoundTripStruct() -> Int32 {
    #if arch(wasm32)
    let _tmp_v = AsyncPoint.bridgeJSLiftParameter()
    return _bjs_makePromise(resolve: Promise_resolve_10AsyncPointV, reject: Promise_reject) {
        return await asyncRoundTripStruct(_: _tmp_v)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripStructThrows")
@_cdecl("bjs_asyncRoundTripStructThrows")
public func _bjs_asyncRoundTripStructThrows() -> Int32 {
    #if arch(wasm32)
    let _tmp_v = AsyncPoint.bridgeJSLiftParameter()
    return _bjs_makePromise(resolve: Promise_resolve_10AsyncPointV, reject: Promise_reject) { () async throws(JSException) -> AsyncPoint in
        return try await asyncRoundTripStructThrows(_: _tmp_v)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncCombineStructs")
@_cdecl("bjs_asyncCombineStructs")
public func _bjs_asyncCombineStructs() -> Int32 {
    #if arch(wasm32)
    let _tmp_b = AsyncPoint.bridgeJSLiftParameter()
    let _tmp_a = AsyncPoint.bridgeJSLiftParameter()
    return _bjs_makePromise(resolve: Promise_resolve_10AsyncPointV, reject: Promise_reject) {
        return await asyncCombineStructs(_: _tmp_a, _: _tmp_b)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripEnum")
@_cdecl("bjs_asyncRoundTripEnum")
public func _bjs_asyncRoundTripEnum(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_14AsyncDirectionO, reject: Promise_reject) {
        return await asyncRoundTripEnum(_: AsyncDirection.bridgeJSLiftParameter(v))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripRawEnum")
@_cdecl("bjs_asyncRoundTripRawEnum")
public func _bjs_asyncRoundTripRawEnum(_ vBytes: Int32, _ vLength: Int32) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_10AsyncThemeO, reject: Promise_reject) {
        return await asyncRoundTripRawEnum(_: AsyncTheme.bridgeJSLiftParameter(vBytes, vLength))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripOptionalEnum")
@_cdecl("bjs_asyncRoundTripOptionalEnum")
public func _bjs_asyncRoundTripOptionalEnum(_ vIsSome: Int32, _ vValue: Int32) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_Sq14AsyncDirectionO, reject: Promise_reject) {
        return await asyncRoundTripOptionalEnum(_: Optional<AsyncDirection>.bridgeJSLiftParameter(vIsSome, vValue))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripOptionalRawEnum")
@_cdecl("bjs_asyncRoundTripOptionalRawEnum")
public func _bjs_asyncRoundTripOptionalRawEnum(_ vIsSome: Int32, _ vBytes: Int32, _ vLength: Int32) -> Int32 {
    #if arch(wasm32)
    return _bjs_makePromise(resolve: Promise_resolve_Sq10AsyncThemeO, reject: Promise_reject) {
        return await asyncRoundTripOptionalRawEnum(_: Optional<AsyncTheme>.bridgeJSLiftParameter(vIsSome, vBytes, vLength))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripOptionalStruct")
@_cdecl("bjs_asyncRoundTripOptionalStruct")
public func _bjs_asyncRoundTripOptionalStruct() -> Int32 {
    #if arch(wasm32)
    let _tmp_v = Optional<AsyncPoint>.bridgeJSLiftParameter()
    return _bjs_makePromise(resolve: Promise_resolve_Sq10AsyncPointV, reject: Promise_reject) {
        return await asyncRoundTripOptionalStruct(_: _tmp_v)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripStructArray")
@_cdecl("bjs_asyncRoundTripStructArray")
public func _bjs_asyncRoundTripStructArray() -> Int32 {
    #if arch(wasm32)
    let _tmp_v = [AsyncPoint].bridgeJSStackPop()
    return _bjs_makePromise(resolve: Promise_resolve_Sa10AsyncPointV, reject: Promise_reject) {
        return await asyncRoundTripStructArray(_: _tmp_v)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripEnumArray")
@_cdecl("bjs_asyncRoundTripEnumArray")
public func _bjs_asyncRoundTripEnumArray() -> Int32 {
    #if arch(wasm32)
    let _tmp_v = [AsyncDirection].bridgeJSStackPop()
    return _bjs_makePromise(resolve: Promise_resolve_Sa14AsyncDirectionO, reject: Promise_reject) {
        return await asyncRoundTripEnumArray(_: _tmp_v)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripStructDictionary")
@_cdecl("bjs_asyncRoundTripStructDictionary")
public func _bjs_asyncRoundTripStructDictionary() -> Int32 {
    #if arch(wasm32)
    let _tmp_v = [String: AsyncPoint].bridgeJSLiftParameter()
    return _bjs_makePromise(resolve: Promise_resolve_SD10AsyncPointV, reject: Promise_reject) {
        return await asyncRoundTripStructDictionary(_: _tmp_v)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripEnumDictionary")
@_cdecl("bjs_asyncRoundTripEnumDictionary")
public func _bjs_asyncRoundTripEnumDictionary() -> Int32 {
    #if arch(wasm32)
    let _tmp_v = [String: AsyncDirection].bridgeJSLiftParameter()
    return _bjs_makePromise(resolve: Promise_resolve_SD14AsyncDirectionO, reject: Promise_reject) {
        return await asyncRoundTripEnumDictionary(_: _tmp_v)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
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
    let promiseValue = promise.bridgeJSLowerParameter()
    let (valueKind, valuePayload1, valuePayload2) = value.bridgeJSLowerParameter()
    promise_reject_TestModule(promiseValue, valueKind, valuePayload1, valuePayload2)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_y(_ promise: JSObject) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_y")
fileprivate func promise_resolve_TestModule_y_extern(_ promise: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_y_extern(_ promise: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_y(_ promise: Int32) -> Void {
    return promise_resolve_TestModule_y_extern(promise)
}

func _$Promise_resolve_y(_ promise: JSObject) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    promise_resolve_TestModule_y(promiseValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Si(_ promise: JSObject, _ value: Int) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Si")
fileprivate func promise_resolve_TestModule_Si_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_Si_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Si(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_Si_extern(promise, value)
}

func _$Promise_resolve_Si(_ promise: JSObject, _ value: Int) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueValue = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_Si(promiseValue, valueValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_SS(_ promise: JSObject, _ value: String) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_SS")
fileprivate func promise_resolve_TestModule_SS_extern(_ promise: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_SS_extern(_ promise: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_SS(_ promise: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    return promise_resolve_TestModule_SS_extern(promise, valueBytes, valueLength)
}

func _$Promise_resolve_SS(_ promise: JSObject, _ value: String) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    value.bridgeJSWithLoweredParameter { (valueBytes, valueLength) in
        promise_resolve_TestModule_SS(promiseValue, valueBytes, valueLength)
    }
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Sb(_ promise: JSObject, _ value: Bool) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sb")
fileprivate func promise_resolve_TestModule_Sb_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_Sb_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sb(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_Sb_extern(promise, value)
}

func _$Promise_resolve_Sb(_ promise: JSObject, _ value: Bool) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueValue = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_Sb(promiseValue, valueValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Sf(_ promise: JSObject, _ value: Float) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sf")
fileprivate func promise_resolve_TestModule_Sf_extern(_ promise: Int32, _ value: Float32) -> Void
#else
fileprivate func promise_resolve_TestModule_Sf_extern(_ promise: Int32, _ value: Float32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sf(_ promise: Int32, _ value: Float32) -> Void {
    return promise_resolve_TestModule_Sf_extern(promise, value)
}

func _$Promise_resolve_Sf(_ promise: JSObject, _ value: Float) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueValue = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_Sf(promiseValue, valueValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Sd(_ promise: JSObject, _ value: Double) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sd")
fileprivate func promise_resolve_TestModule_Sd_extern(_ promise: Int32, _ value: Float64) -> Void
#else
fileprivate func promise_resolve_TestModule_Sd_extern(_ promise: Int32, _ value: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sd(_ promise: Int32, _ value: Float64) -> Void {
    return promise_resolve_TestModule_Sd_extern(promise, value)
}

func _$Promise_resolve_Sd(_ promise: JSObject, _ value: Double) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueValue = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_Sd(promiseValue, valueValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_8JSObjectC(_ promise: JSObject, _ value: JSObject) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_8JSObjectC")
fileprivate func promise_resolve_TestModule_8JSObjectC_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_8JSObjectC_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_8JSObjectC(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_8JSObjectC_extern(promise, value)
}

func _$Promise_resolve_8JSObjectC(_ promise: JSObject, _ value: JSObject) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueValue = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_8JSObjectC(promiseValue, valueValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_10AsyncPointV(_ promise: JSObject, _ value: AsyncPoint) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_10AsyncPointV")
fileprivate func promise_resolve_TestModule_10AsyncPointV_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_10AsyncPointV_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_10AsyncPointV(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_10AsyncPointV_extern(promise, value)
}

func _$Promise_resolve_10AsyncPointV(_ promise: JSObject, _ value: AsyncPoint) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueObjectId = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_10AsyncPointV(promiseValue, valueObjectId)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_14AsyncDirectionO(_ promise: JSObject, _ value: AsyncDirection) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_14AsyncDirectionO")
fileprivate func promise_resolve_TestModule_14AsyncDirectionO_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_14AsyncDirectionO_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_14AsyncDirectionO(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_14AsyncDirectionO_extern(promise, value)
}

func _$Promise_resolve_14AsyncDirectionO(_ promise: JSObject, _ value: AsyncDirection) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueValue = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_14AsyncDirectionO(promiseValue, valueValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_10AsyncThemeO(_ promise: JSObject, _ value: AsyncTheme) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_10AsyncThemeO")
fileprivate func promise_resolve_TestModule_10AsyncThemeO_extern(_ promise: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_10AsyncThemeO_extern(_ promise: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_10AsyncThemeO(_ promise: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    return promise_resolve_TestModule_10AsyncThemeO_extern(promise, valueBytes, valueLength)
}

func _$Promise_resolve_10AsyncThemeO(_ promise: JSObject, _ value: AsyncTheme) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    value.bridgeJSWithLoweredParameter { (valueBytes, valueLength) in
        promise_resolve_TestModule_10AsyncThemeO(promiseValue, valueBytes, valueLength)
    }
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Sq14AsyncDirectionO(_ promise: JSObject, _ value: Optional<AsyncDirection>) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sq14AsyncDirectionO")
fileprivate func promise_resolve_TestModule_Sq14AsyncDirectionO_extern(_ promise: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_Sq14AsyncDirectionO_extern(_ promise: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sq14AsyncDirectionO(_ promise: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    return promise_resolve_TestModule_Sq14AsyncDirectionO_extern(promise, valueIsSome, valueValue)
}

func _$Promise_resolve_Sq14AsyncDirectionO(_ promise: JSObject, _ value: Optional<AsyncDirection>) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_Sq14AsyncDirectionO(promiseValue, valueIsSome, valueValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Sq10AsyncThemeO(_ promise: JSObject, _ value: Optional<AsyncTheme>) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sq10AsyncThemeO")
fileprivate func promise_resolve_TestModule_Sq10AsyncThemeO_extern(_ promise: Int32, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_Sq10AsyncThemeO_extern(_ promise: Int32, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sq10AsyncThemeO(_ promise: Int32, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    return promise_resolve_TestModule_Sq10AsyncThemeO_extern(promise, valueIsSome, valueBytes, valueLength)
}

func _$Promise_resolve_Sq10AsyncThemeO(_ promise: JSObject, _ value: Optional<AsyncTheme>) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    value.bridgeJSWithLoweredParameter { (valueIsSome, valueBytes, valueLength) in
        promise_resolve_TestModule_Sq10AsyncThemeO(promiseValue, valueIsSome, valueBytes, valueLength)
    }
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Sq10AsyncPointV(_ promise: JSObject, _ value: Optional<AsyncPoint>) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sq10AsyncPointV")
fileprivate func promise_resolve_TestModule_Sq10AsyncPointV_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_Sq10AsyncPointV_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sq10AsyncPointV(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_Sq10AsyncPointV_extern(promise, value)
}

func _$Promise_resolve_Sq10AsyncPointV(_ promise: JSObject, _ value: Optional<AsyncPoint>) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueIsSome = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_Sq10AsyncPointV(promiseValue, valueIsSome)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Sa10AsyncPointV(_ promise: JSObject, _ value: [AsyncPoint]) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sa10AsyncPointV")
fileprivate func promise_resolve_TestModule_Sa10AsyncPointV_extern(_ promise: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_Sa10AsyncPointV_extern(_ promise: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sa10AsyncPointV(_ promise: Int32) -> Void {
    return promise_resolve_TestModule_Sa10AsyncPointV_extern(promise)
}

func _$Promise_resolve_Sa10AsyncPointV(_ promise: JSObject, _ value: [AsyncPoint]) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let _ = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_Sa10AsyncPointV(promiseValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Sa14AsyncDirectionO(_ promise: JSObject, _ value: [AsyncDirection]) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sa14AsyncDirectionO")
fileprivate func promise_resolve_TestModule_Sa14AsyncDirectionO_extern(_ promise: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_Sa14AsyncDirectionO_extern(_ promise: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sa14AsyncDirectionO(_ promise: Int32) -> Void {
    return promise_resolve_TestModule_Sa14AsyncDirectionO_extern(promise)
}

func _$Promise_resolve_Sa14AsyncDirectionO(_ promise: JSObject, _ value: [AsyncDirection]) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let _ = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_Sa14AsyncDirectionO(promiseValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_SD10AsyncPointV(_ promise: JSObject, _ value: [String: AsyncPoint]) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_SD10AsyncPointV")
fileprivate func promise_resolve_TestModule_SD10AsyncPointV_extern(_ promise: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_SD10AsyncPointV_extern(_ promise: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_SD10AsyncPointV(_ promise: Int32) -> Void {
    return promise_resolve_TestModule_SD10AsyncPointV_extern(promise)
}

func _$Promise_resolve_SD10AsyncPointV(_ promise: JSObject, _ value: [String: AsyncPoint]) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let _ = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_SD10AsyncPointV(promiseValue)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_SD14AsyncDirectionO(_ promise: JSObject, _ value: [String: AsyncDirection]) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_SD14AsyncDirectionO")
fileprivate func promise_resolve_TestModule_SD14AsyncDirectionO_extern(_ promise: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_SD14AsyncDirectionO_extern(_ promise: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_SD14AsyncDirectionO(_ promise: Int32) -> Void {
    return promise_resolve_TestModule_SD14AsyncDirectionO_extern(promise)
}

func _$Promise_resolve_SD14AsyncDirectionO(_ promise: JSObject, _ value: [String: AsyncDirection]) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let _ = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_SD14AsyncDirectionO(promiseValue)
    if let error = _swift_js_take_exception() { throw error }
}