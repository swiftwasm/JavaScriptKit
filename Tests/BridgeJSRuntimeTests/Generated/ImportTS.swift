// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(JSObject_id) import JavaScriptKit

@_extern(wasm, module: "bjs", name: "make_jsstring")
private func _make_jsstring(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32

@_extern(wasm, module: "bjs", name: "init_memory_with_result")
private func _init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)

func jsRoundTripVoid() -> Void {
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripVoid")
    func bjs_jsRoundTripVoid() -> Void
    bjs_jsRoundTripVoid()
}

func jsRoundTripNumber(_ v: Double) -> Double {
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripNumber")
    func bjs_jsRoundTripNumber(_ v: Float64) -> Float64
    let ret = bjs_jsRoundTripNumber(v)
    return Double(ret)
}

func jsRoundTripBool(_ v: Bool) -> Bool {
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripBool")
    func bjs_jsRoundTripBool(_ v: Int32) -> Int32
    let ret = bjs_jsRoundTripBool(Int32(v ? 1 : 0))
    return ret == 1
}

func jsRoundTripString(_ v: String) -> String {
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripString")
    func bjs_jsRoundTripString(_ v: Int32) -> Int32
    var v = v
    let vId = v.withUTF8 { b in
        _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    let ret = bjs_jsRoundTripString(vId)
    return String(unsafeUninitializedCapacity: Int(ret)) { b in
        _init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
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
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_init")
        func bjs_JsGreeter_init(_ name: Int32, _ prefix: Int32) -> Int32
        var name = name
        let nameId = name.withUTF8 { b in
            _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        var prefix = prefix
        let prefixId = prefix.withUTF8 { b in
            _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        let ret = bjs_JsGreeter_init(nameId, prefixId)
        self.this = JSObject(id: UInt32(bitPattern: ret))
    }

    var name: String {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_name_get")
            func bjs_JsGreeter_name_get(_ self: Int32) -> Int32
            let ret = bjs_JsGreeter_name_get(Int32(bitPattern: self.this.id))
            return String(unsafeUninitializedCapacity: Int(ret)) { b in
                _init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
                return Int(ret)
            }
        }
        nonmutating set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_name_set")
            func bjs_JsGreeter_name_set(_ self: Int32, _ newValue: Int32) -> Void
            var newValue = newValue
            let newValueId = newValue.withUTF8 { b in
                _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
            }
            bjs_JsGreeter_name_set(Int32(bitPattern: self.this.id), newValueId)
        }
    }

    var prefix: String {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_prefix_get")
            func bjs_JsGreeter_prefix_get(_ self: Int32) -> Int32
            let ret = bjs_JsGreeter_prefix_get(Int32(bitPattern: self.this.id))
            return String(unsafeUninitializedCapacity: Int(ret)) { b in
                _init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
                return Int(ret)
            }
        }
    }

    func greet() -> String {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_greet")
        func bjs_JsGreeter_greet(_ self: Int32) -> Int32
        let ret = bjs_JsGreeter_greet(Int32(bitPattern: self.this.id))
        return String(unsafeUninitializedCapacity: Int(ret)) { b in
            _init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
            return Int(ret)
        }
    }

    func changeName(_ name: String) -> Void {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_changeName")
        func bjs_JsGreeter_changeName(_ self: Int32, _ name: Int32) -> Void
        var name = name
        let nameId = name.withUTF8 { b in
            _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        bjs_JsGreeter_changeName(Int32(bitPattern: self.this.id), nameId)
    }

}