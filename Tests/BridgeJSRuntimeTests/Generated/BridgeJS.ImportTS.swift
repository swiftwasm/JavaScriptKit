// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func jsRoundTripVoid() throws(JSException) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripVoid")
    func bjs_jsRoundTripVoid() -> Void
    #else
    func bjs_jsRoundTripVoid() -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_jsRoundTripVoid()
}

func jsRoundTripNumber(_ v: Double) throws(JSException) -> Double {
    #if arch(wasm32)
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripNumber")
    func bjs_jsRoundTripNumber(_ v: Float64) -> Float64
    #else
    func bjs_jsRoundTripNumber(_ v: Float64) -> Float64 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_jsRoundTripNumber(v)
    return Double(ret)
}

func jsRoundTripBool(_ v: Bool) throws(JSException) -> Bool {
    #if arch(wasm32)
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripBool")
    func bjs_jsRoundTripBool(_ v: Int32) -> Int32
    #else
    func bjs_jsRoundTripBool(_ v: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_jsRoundTripBool(Int32(v ? 1 : 0))
    return ret == 1
}

func jsRoundTripString(_ v: String) throws(JSException) -> String {
    #if arch(wasm32)
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripString")
    func bjs_jsRoundTripString(_ v: Int32) -> Int32
    #else
    func bjs_jsRoundTripString(_ v: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    var v = v
    let vId = v.withUTF8 { b in
        _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    let ret = bjs_jsRoundTripString(vId)
    return String(unsafeUninitializedCapacity: Int(ret)) { b in
        _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
        return Int(ret)
    }
}

struct JsGreeter {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
    }

    init(_ name: String, _ prefix: String) {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_init")
        func bjs_JsGreeter_init(_ name: Int32, _ prefix: Int32) -> Int32
        #else
        func bjs_JsGreeter_init(_ name: Int32, _ prefix: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        var name = name
        let nameId = name.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        var prefix = prefix
        let prefixId = prefix.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        let ret = bjs_JsGreeter_init(nameId, prefixId)
        self.this = JSObject(id: UInt32(bitPattern: ret))
    }

    var name: String {
        get {
            #if arch(wasm32)
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_name_get")
            func bjs_JsGreeter_name_get(_ self: Int32) -> Int32
            #else
            func bjs_JsGreeter_name_get(_ self: Int32) -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_JsGreeter_name_get(Int32(bitPattern: self.this.id))
            return String(unsafeUninitializedCapacity: Int(ret)) { b in
                _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
                return Int(ret)
            }
        }
        nonmutating set {
            #if arch(wasm32)
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_name_set")
            func bjs_JsGreeter_name_set(_ self: Int32, _ newValue: Int32) -> Void
            #else
            func bjs_JsGreeter_name_set(_ self: Int32, _ newValue: Int32) -> Void {
                fatalError("Only available on WebAssembly")
            }
            #endif
            var newValue = newValue
            let newValueId = newValue.withUTF8 { b in
                _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
            }
            bjs_JsGreeter_name_set(Int32(bitPattern: self.this.id), newValueId)
        }
    }

    var prefix: String {
        get {
            #if arch(wasm32)
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_prefix_get")
            func bjs_JsGreeter_prefix_get(_ self: Int32) -> Int32
            #else
            func bjs_JsGreeter_prefix_get(_ self: Int32) -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_JsGreeter_prefix_get(Int32(bitPattern: self.this.id))
            return String(unsafeUninitializedCapacity: Int(ret)) { b in
                _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
                return Int(ret)
            }
        }
    }

    func greet() throws(JSException) -> String {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_greet")
        func bjs_JsGreeter_greet(_ self: Int32) -> Int32
        #else
        func bjs_JsGreeter_greet(_ self: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_JsGreeter_greet(Int32(bitPattern: self.this.id))
        return String(unsafeUninitializedCapacity: Int(ret)) { b in
            _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
            return Int(ret)
        }
    }

    func changeName(_ name: String) throws(JSException) -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_changeName")
        func bjs_JsGreeter_changeName(_ self: Int32, _ name: Int32) -> Void
        #else
        func bjs_JsGreeter_changeName(_ self: Int32, _ name: Int32) -> Void {
            fatalError("Only available on WebAssembly")
        }
        #endif
        var name = name
        let nameId = name.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        bjs_JsGreeter_changeName(Int32(bitPattern: self.this.id), nameId)
    }

}