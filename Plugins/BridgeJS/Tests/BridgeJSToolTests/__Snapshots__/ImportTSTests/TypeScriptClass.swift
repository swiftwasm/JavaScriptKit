// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

struct Greeter {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
    }

    init(_ name: String) {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_Greeter_init")
        func bjs_Greeter_init(_ name: Int32) throws -> Int32
        #else
        func bjs_Greeter_init(_ name: Int32) throws -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        var name = name
        let nameId = name.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        let ret = bjs_Greeter_init(nameId)
        self.this = JSObject(id: UInt32(bitPattern: ret))
    }

    var name: String {
        get {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_Greeter_name_get")
            func bjs_Greeter_name_get(_ self: Int32) throws -> Int32
            #else
            func bjs_Greeter_name_get(_ self: Int32) throws -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_Greeter_name_get(Int32(bitPattern: self.this.id))
            return String(unsafeUninitializedCapacity: Int(ret)) { b in
                _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
                return Int(ret)
            }
        }
        nonmutating set {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_Greeter_name_set")
            func bjs_Greeter_name_set(_ self: Int32, _ newValue: Int32) throws -> Void
            #else
            func bjs_Greeter_name_set(_ self: Int32, _ newValue: Int32) throws -> Void {
                fatalError("Only available on WebAssembly")
            }
            #endif
            var newValue = newValue
            let newValueId = newValue.withUTF8 { b in
                _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
            }
            bjs_Greeter_name_set(Int32(bitPattern: self.this.id), newValueId)
        }
    }

    var age: Double {
        get {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_Greeter_age_get")
            func bjs_Greeter_age_get(_ self: Int32) throws -> Float64
            #else
            func bjs_Greeter_age_get(_ self: Int32) throws -> Float64 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_Greeter_age_get(Int32(bitPattern: self.this.id))
            return Double(ret)
        }
    }

    func greet() -> String {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_Greeter_greet")
        func bjs_Greeter_greet(_ self: Int32) throws -> Int32
        #else
        func bjs_Greeter_greet(_ self: Int32) throws -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_Greeter_greet(Int32(bitPattern: self.this.id))
        return String(unsafeUninitializedCapacity: Int(ret)) { b in
            _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
            return Int(ret)
        }
    }

    func changeName(_ name: String) -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_Greeter_changeName")
        func bjs_Greeter_changeName(_ self: Int32, _ name: Int32) throws -> Void
        #else
        func bjs_Greeter_changeName(_ self: Int32, _ name: Int32) throws -> Void {
            fatalError("Only available on WebAssembly")
        }
        #endif
        var name = name
        let nameId = name.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        bjs_Greeter_changeName(Int32(bitPattern: self.this.id), nameId)
    }

}