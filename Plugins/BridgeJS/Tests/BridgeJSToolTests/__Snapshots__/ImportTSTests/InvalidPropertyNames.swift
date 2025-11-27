// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_createArrayBuffer")
func bjs_createArrayBuffer() -> Int32
#else
func bjs_createArrayBuffer() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func createArrayBuffer() throws(JSException) -> ArrayBufferLike {
    let ret = bjs_createArrayBuffer()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return ArrayBufferLike.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_createWeirdObject")
func bjs_createWeirdObject() -> Int32
#else
func bjs_createWeirdObject() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func createWeirdObject() throws(JSException) -> WeirdNaming {
    let ret = bjs_createWeirdObject()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return WeirdNaming.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_ArrayBufferLike_byteLength_get")
func bjs_ArrayBufferLike_byteLength_get(_ self: Int32) -> Float64
#else
func bjs_ArrayBufferLike_byteLength_get(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_ArrayBufferLike_slice")
func bjs_ArrayBufferLike_slice(_ self: Int32, _ begin: Float64, _ end: Float64) -> Int32
#else
func bjs_ArrayBufferLike_slice(_ self: Int32, _ begin: Float64, _ end: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

struct ArrayBufferLike: _JSBridgedClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    var byteLength: Double {
        get throws(JSException) {
            let ret = bjs_ArrayBufferLike_byteLength_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return Double.bridgeJSLiftReturn(ret)
        }
    }

    func slice(_ begin: Double, _ end: Double) throws(JSException) -> ArrayBufferLike {
        let ret = bjs_ArrayBufferLike_slice(self.bridgeJSLowerParameter(), begin.bridgeJSLowerParameter(), end.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return ArrayBufferLike.bridgeJSLiftReturn(ret)
    }

}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_normalProperty_get")
func bjs_WeirdNaming_normalProperty_get(_ self: Int32) -> Int32
#else
func bjs_WeirdNaming_normalProperty_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_normalProperty_set")
func bjs_WeirdNaming_normalProperty_set(_ self: Int32, _ newValue: Int32) -> Void
#else
func bjs_WeirdNaming_normalProperty_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_for_get")
func bjs_WeirdNaming_for_get(_ self: Int32) -> Int32
#else
func bjs_WeirdNaming_for_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_for_set")
func bjs_WeirdNaming_for_set(_ self: Int32, _ newValue: Int32) -> Void
#else
func bjs_WeirdNaming_for_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_Any_get")
func bjs_WeirdNaming_Any_get(_ self: Int32) -> Int32
#else
func bjs_WeirdNaming_Any_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_Any_set")
func bjs_WeirdNaming_Any_set(_ self: Int32, _ newValue: Int32) -> Void
#else
func bjs_WeirdNaming_Any_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_as")
func bjs_WeirdNaming_as(_ self: Int32) -> Void
#else
func bjs_WeirdNaming_as(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

struct WeirdNaming: _JSBridgedClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    var normalProperty: String {
        get throws(JSException) {
            let ret = bjs_WeirdNaming_normalProperty_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String.bridgeJSLiftReturn(ret)
        }
    }

    func setNormalProperty(_ newValue: String) throws(JSException) -> Void {
        bjs_WeirdNaming_normalProperty_set(self.bridgeJSLowerParameter(), newValue.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    var `for`: String {
        get throws(JSException) {
            let ret = bjs_WeirdNaming_for_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String.bridgeJSLiftReturn(ret)
        }
    }

    func setFor(_ newValue: String) throws(JSException) -> Void {
        bjs_WeirdNaming_for_set(self.bridgeJSLowerParameter(), newValue.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    var `Any`: String {
        get throws(JSException) {
            let ret = bjs_WeirdNaming_Any_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String.bridgeJSLiftReturn(ret)
        }
    }

    func setAny(_ newValue: String) throws(JSException) -> Void {
        bjs_WeirdNaming_Any_set(self.bridgeJSLowerParameter(), newValue.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    func `as`() throws(JSException) -> Void {
        bjs_WeirdNaming_as(self.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

}