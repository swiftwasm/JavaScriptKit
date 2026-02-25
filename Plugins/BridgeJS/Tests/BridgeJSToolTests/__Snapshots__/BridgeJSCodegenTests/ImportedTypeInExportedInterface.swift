extension FooContainer: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> FooContainer {
        let optionalFoo = Optional<JSObject>.bridgeJSStackPop().map { Foo(unsafelyWrapping: $0) }
        let foo = Foo(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return FooContainer(foo: foo, optionalFoo: optionalFoo)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.foo.jsObject.bridgeJSStackPush()
        self.optionalFoo.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_FooContainer(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_FooContainer()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_FooContainer")
fileprivate func _bjs_struct_lower_FooContainer_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_FooContainer_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_FooContainer(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_FooContainer_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_FooContainer")
fileprivate func _bjs_struct_lift_FooContainer_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_FooContainer_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_FooContainer() -> Int32 {
    return _bjs_struct_lift_FooContainer_extern()
}

@_expose(wasm, "bjs_makeFoo")
@_cdecl("bjs_makeFoo")
public func _bjs_makeFoo() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try makeFoo()
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processFooArray")
@_cdecl("bjs_processFooArray")
public func _bjs_processFooArray() -> Void {
    #if arch(wasm32)
    let ret = processFooArray(_: [Foo].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processOptionalFooArray")
@_cdecl("bjs_processOptionalFooArray")
public func _bjs_processOptionalFooArray() -> Void {
    #if arch(wasm32)
    let ret = processOptionalFooArray(_: [Optional<Foo>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripFooContainer")
@_cdecl("bjs_roundtripFooContainer")
public func _bjs_roundtripFooContainer() -> Void {
    #if arch(wasm32)
    let ret = roundtripFooContainer(_: FooContainer.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Foo_init")
fileprivate func bjs_Foo_init_extern() -> Int32
#else
fileprivate func bjs_Foo_init_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Foo_init() -> Int32 {
    return bjs_Foo_init_extern()
}

func _$Foo_init() throws(JSException) -> JSObject {
    let ret = bjs_Foo_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}