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

@_extern(wasm, module: "bjs", name: "free_jsobject")
private func _free_jsobject(_ ptr: Int32) -> Void

struct Greeter {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
    }

    init(_ name: String) {
        @_extern(wasm, module: "Check", name: "bjs_Greeter_init")
        func bjs_Greeter_init(_ name: Int32) -> Int32
        var name = name
        let nameId = name.withUTF8 { b in
            _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        let ret = bjs_Greeter_init(nameId)
        self.this = ret
    }

    func greet() -> String {
        @_extern(wasm, module: "Check", name: "bjs_Greeter_greet")
        func bjs_Greeter_greet(_ self: Int32) -> Int32
        let ret = bjs_Greeter_greet(Int32(bitPattern: self.this.id))
        return String(unsafeUninitializedCapacity: Int(ret)) { b in
            _init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
            return Int(ret)
        }
    }

    func changeName(_ name: String) -> Void {
        @_extern(wasm, module: "Check", name: "bjs_Greeter_changeName")
        func bjs_Greeter_changeName(_ self: Int32, _ name: Int32) -> Void
        var name = name
        let nameId = name.withUTF8 { b in
            _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        bjs_Greeter_changeName(Int32(bitPattern: self.this.id), nameId)
    }

}