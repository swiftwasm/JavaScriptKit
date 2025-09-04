// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func roundTripOptionalNumber(_ value: JSObject) throws(JSException) -> JSObject {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_roundTripOptionalNumber")
    func bjs_roundTripOptionalNumber(_ value: Int32) -> Int32
    #else
    func bjs_roundTripOptionalNumber(_ value: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_roundTripOptionalNumber(value.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func roundTripOptionalString(_ value: JSObject) throws(JSException) -> JSObject {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_roundTripOptionalString")
    func bjs_roundTripOptionalString(_ value: Int32) -> Int32
    #else
    func bjs_roundTripOptionalString(_ value: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_roundTripOptionalString(value.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func roundTripOptionalBool(_ value: JSObject) throws(JSException) -> JSObject {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_roundTripOptionalBool")
    func bjs_roundTripOptionalBool(_ value: Int32) -> Int32
    #else
    func bjs_roundTripOptionalBool(_ value: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_roundTripOptionalBool(value.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func roundTripOptionalClass(_ value: JSObject) throws(JSException) -> JSObject {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_roundTripOptionalClass")
    func bjs_roundTripOptionalClass(_ value: Int32) -> Int32
    #else
    func bjs_roundTripOptionalClass(_ value: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_roundTripOptionalClass(value.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func testMixedOptionals(_ required: String, _ optional: JSObject) throws(JSException) -> JSObject {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_testMixedOptionals")
    func bjs_testMixedOptionals(_ required: Int32, _ optional: Int32) -> Int32
    #else
    func bjs_testMixedOptionals(_ required: Int32, _ optional: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_testMixedOptionals(required.bridgeJSLowerParameter(), optional.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

struct TestClass: _JSBridgedClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    init(_ param: JSObject) throws(JSException) {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_TestClass_init")
        func bjs_TestClass_init(_ param: Int32) -> Int32
        #else
        func bjs_TestClass_init(_ param: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_TestClass_init(param.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        self.jsObject = JSObject(id: UInt32(bitPattern: ret))
    }

    var optionalProperty: JSObject {
        get throws(JSException) {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_TestClass_optionalProperty_get")
            func bjs_TestClass_optionalProperty_get(_ self: Int32) -> Int32
            #else
            func bjs_TestClass_optionalProperty_get(_ self: Int32) -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_TestClass_optionalProperty_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return JSObject.bridgeJSLiftReturn(ret)
        }
    }

    func setOptionalProperty(_ newValue: JSObject) throws(JSException) -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_TestClass_optionalProperty_set")
        func bjs_TestClass_optionalProperty_set(_ self: Int32, _ newValue: Int32) -> Void
        #else
        func bjs_TestClass_optionalProperty_set(_ self: Int32, _ newValue: Int32) -> Void {
            fatalError("Only available on WebAssembly")
        }
        #endif
        bjs_TestClass_optionalProperty_set(self.bridgeJSLowerParameter(), newValue.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    func methodWithOptional(_ value: JSObject) throws(JSException) -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_TestClass_methodWithOptional")
        func bjs_TestClass_methodWithOptional(_ self: Int32, _ value: Int32) -> Void
        #else
        func bjs_TestClass_methodWithOptional(_ self: Int32, _ value: Int32) -> Void {
            fatalError("Only available on WebAssembly")
        }
        #endif
        bjs_TestClass_methodWithOptional(self.bridgeJSLowerParameter(), value.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    func methodReturningOptional() throws(JSException) -> JSObject {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_TestClass_methodReturningOptional")
        func bjs_TestClass_methodReturningOptional(_ self: Int32) -> Int32
        #else
        func bjs_TestClass_methodReturningOptional(_ self: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_TestClass_methodReturningOptional(self.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject.bridgeJSLiftReturn(ret)
    }

}