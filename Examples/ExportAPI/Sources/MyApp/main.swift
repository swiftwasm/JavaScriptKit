@_spi(JSObject_id) import JavaScriptKit

@JS public func hello() -> String {
    "Hello, world!"
}

@JS public func twice(x: Int) -> Int {
    x * 2
}

JSObject.global.helloClosure = .object(
    JSClosure { _ in
        return "Hello, world!"
    }
)

JSObject.global.twiceClosure = .object(
    JSClosure { args in
        let x = Int(args[0].number!)
        return .number(Double(x * 2))
    }
)

@_extern(wasm, module: "MyApp", name: "Greeter_init")
func _bjs_MyApp_Greeter_init(
    _ name: UnsafePointer<UInt8>?,
    _ nameLength: Int32
) -> Int32

@_extern(wasm, module: "MyApp", name: "Greeter_greet")
func _bjs_MyApp_Greeter_greet(
    _ this: UInt32,
    _ bytesId: UnsafeMutablePointer<Int32>
) -> Int32

@_extern(wasm, module: "MyApp", name: "Greeter_changeName")
func _bjs_MyApp_Greeter_changeName(
    _ this: UInt32,
    _ name: UnsafePointer<UInt8>?,
    _ nameLength: Int32
) -> Void

@_extern(wasm, module: "bjs", name: "init_memory")
private func _init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?)

class Greeter {
    let object: JSObject

    init(_ object: JSObject) {
        self.object = object
    }

    init(name: String) {
        var name = name
        let id = name.withUTF8 { ptr in
            _bjs_MyApp_Greeter_init(ptr.baseAddress, Int32(ptr.count))
        }
        self.object = JSObject(id: UInt32(id))
    }

    func greet(nTimes: Int) -> String {
        var bytesId: Int32 = 0
        let length = _bjs_MyApp_Greeter_greet(object.id, &bytesId)
        return String(unsafeUninitializedCapacity: Int(length)) { buffer in
            _init_memory(bytesId, buffer.baseAddress)
            return Int(length)
        }
    }

    func changeName(name: String) {
        var name = name
        name.withUTF8 { ptr in
            _bjs_MyApp_Greeter_changeName(object.id, ptr.baseAddress, Int32(ptr.count))
        }
    }
}
