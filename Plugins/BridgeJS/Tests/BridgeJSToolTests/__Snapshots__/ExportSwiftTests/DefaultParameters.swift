// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

extension Status: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Status {
        return Status(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Status {
        return Status(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSRawValue
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .active
        case 1:
            self = .inactive
        case 2:
            self = .pending
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .active:
            return 0
        case .inactive:
            return 1
        case .pending:
            return 2
        }
    }
}

@_expose(wasm, "bjs_testStringDefault")
@_cdecl("bjs_testStringDefault")
public func _bjs_testStringDefault(messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testStringDefault(message: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testIntDefault")
@_cdecl("bjs_testIntDefault")
public func _bjs_testIntDefault(count: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testIntDefault(count: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testBoolDefault")
@_cdecl("bjs_testBoolDefault")
public func _bjs_testBoolDefault(flag: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testBoolDefault(flag: Bool.bridgeJSLiftParameter(flag))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testFloatDefault")
@_cdecl("bjs_testFloatDefault")
public func _bjs_testFloatDefault(value: Float32) -> Float32 {
    #if arch(wasm32)
    let ret = testFloatDefault(value: Float.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testDoubleDefault")
@_cdecl("bjs_testDoubleDefault")
public func _bjs_testDoubleDefault(precision: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = testDoubleDefault(precision: Double.bridgeJSLiftParameter(precision))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalDefault")
@_cdecl("bjs_testOptionalDefault")
public func _bjs_testOptionalDefault(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testOptionalDefault(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalStringDefault")
@_cdecl("bjs_testOptionalStringDefault")
public func _bjs_testOptionalStringDefault(greetingIsSome: Int32, greetingBytes: Int32, greetingLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testOptionalStringDefault(greeting: Optional<String>.bridgeJSLiftParameter(greetingIsSome, greetingBytes, greetingLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testMultipleDefaults")
@_cdecl("bjs_testMultipleDefaults")
public func _bjs_testMultipleDefaults(titleBytes: Int32, titleLength: Int32, count: Int32, enabled: Int32) -> Void {
    #if arch(wasm32)
    let ret = testMultipleDefaults(title: String.bridgeJSLiftParameter(titleBytes, titleLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testEnumDefault")
@_cdecl("bjs_testEnumDefault")
public func _bjs_testEnumDefault(status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testEnumDefault(status: Status.bridgeJSLiftParameter(status))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testComplexInit")
@_cdecl("bjs_testComplexInit")
public func _bjs_testComplexInit(greeter: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = testComplexInit(greeter: DefaultGreeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testEmptyInit")
@_cdecl("bjs_testEmptyInit")
public func _bjs_testEmptyInit(greeter: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = testEmptyInit(greeter: EmptyGreeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultGreeter_init")
@_cdecl("bjs_DefaultGreeter_init")
public func _bjs_DefaultGreeter_init(nameBytes: Int32, nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = DefaultGreeter(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultGreeter_name_get")
@_cdecl("bjs_DefaultGreeter_name_get")
public func _bjs_DefaultGreeter_name_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DefaultGreeter.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultGreeter_name_set")
@_cdecl("bjs_DefaultGreeter_name_set")
public func _bjs_DefaultGreeter_name_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    DefaultGreeter.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultGreeter_deinit")
@_cdecl("bjs_DefaultGreeter_deinit")
public func _bjs_DefaultGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<DefaultGreeter>.fromOpaque(pointer).release()
}

extension DefaultGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_DefaultGreeter_wrap")
        func _bjs_DefaultGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_DefaultGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_DefaultGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_EmptyGreeter_init")
@_cdecl("bjs_EmptyGreeter_init")
public func _bjs_EmptyGreeter_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = EmptyGreeter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_EmptyGreeter_deinit")
@_cdecl("bjs_EmptyGreeter_deinit")
public func _bjs_EmptyGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<EmptyGreeter>.fromOpaque(pointer).release()
}

extension EmptyGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_EmptyGreeter_wrap")
        func _bjs_EmptyGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_EmptyGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_EmptyGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}