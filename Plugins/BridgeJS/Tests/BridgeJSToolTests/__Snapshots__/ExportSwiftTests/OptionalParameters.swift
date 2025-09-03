// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_roundTripOptionalClass")
@_cdecl("bjs_roundTripOptionalClass")
public func _bjs_roundTripOptionalClass(valueIsSome: Int32, valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalClass(value: Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalPropertyRoundtrip")
@_cdecl("bjs_testOptionalPropertyRoundtrip")
public func _bjs_testOptionalPropertyRoundtrip(holderIsSome: Int32, holderValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = testOptionalPropertyRoundtrip(_: Optional<OptionalPropertyHolder>.bridgeJSLiftParameter(holderIsSome, holderValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripString")
@_cdecl("bjs_roundTripString")
public func _bjs_roundTripString(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripString(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripInt")
@_cdecl("bjs_roundTripInt")
public func _bjs_roundTripInt(valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripInt(value: Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripBool")
@_cdecl("bjs_roundTripBool")
public func _bjs_roundTripBool(flagIsSome: Int32, flagValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripBool(flag: Optional<Bool>.bridgeJSLiftParameter(flagIsSome, flagValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripFloat")
@_cdecl("bjs_roundTripFloat")
public func _bjs_roundTripFloat(numberIsSome: Int32, numberValue: Float32) -> Void {
    #if arch(wasm32)
    let ret = roundTripFloat(number: Optional<Float>.bridgeJSLiftParameter(numberIsSome, numberValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDouble")
@_cdecl("bjs_roundTripDouble")
public func _bjs_roundTripDouble(precisionIsSome: Int32, precisionValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripDouble(precision: Optional<Double>.bridgeJSLiftParameter(precisionIsSome, precisionValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSyntax")
@_cdecl("bjs_roundTripSyntax")
public func _bjs_roundTripSyntax(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripMixSyntax")
@_cdecl("bjs_roundTripMixSyntax")
public func _bjs_roundTripMixSyntax(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripMixSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSwiftSyntax")
@_cdecl("bjs_roundTripSwiftSyntax")
public func _bjs_roundTripSwiftSyntax(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripSwiftSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripMixedSwiftSyntax")
@_cdecl("bjs_roundTripMixedSwiftSyntax")
public func _bjs_roundTripMixedSwiftSyntax(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripMixedSwiftSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripWithSpaces")
@_cdecl("bjs_roundTripWithSpaces")
public func _bjs_roundTripWithSpaces(valueIsSome: Int32, valueValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripWithSpaces(value: Optional<Double>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripAlias")
@_cdecl("bjs_roundTripAlias")
public func _bjs_roundTripAlias(ageIsSome: Int32, ageValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripAlias(age: Optional<Int>.bridgeJSLiftParameter(ageIsSome, ageValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testMixedOptionals")
@_cdecl("bjs_testMixedOptionals")
public func _bjs_testMixedOptionals(firstNameIsSome: Int32, firstNameBytes: Int32, firstNameLength: Int32, lastNameIsSome: Int32, lastNameBytes: Int32, lastNameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testMixedOptionals(firstName: Optional<String>.bridgeJSLiftParameter(firstNameIsSome, firstNameBytes, firstNameLength), lastName: Optional<String>.bridgeJSLiftParameter(lastNameIsSome, lastNameBytes, lastNameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(nameBytes: Int32, nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_changeName")
@_cdecl("bjs_Greeter_changeName")
public func _bjs_Greeter_changeName(_self: UnsafeMutableRawPointer, nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).changeName(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_get")
@_cdecl("bjs_Greeter_name_get")
public func _bjs_Greeter_name_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_set")
@_cdecl("bjs_Greeter_name_set")
public func _bjs_Greeter_name_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).name = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Greeter>.fromOpaque(pointer).release()
}

extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_Greeter_wrap")
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_OptionalPropertyHolder_init")
@_cdecl("bjs_OptionalPropertyHolder_init")
public func _bjs_OptionalPropertyHolder_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalName_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalName_get")
public func _bjs_OptionalPropertyHolder_optionalName_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalName
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalName_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalName_set")
public func _bjs_OptionalPropertyHolder_optionalName_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalName = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalAge_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalAge_get")
public func _bjs_OptionalPropertyHolder_optionalAge_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalAge
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalAge_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalAge_set")
public func _bjs_OptionalPropertyHolder_optionalAge_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalAge = Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalGreeter_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalGreeter_get")
public func _bjs_OptionalPropertyHolder_optionalGreeter_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalGreeter
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalGreeter_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalGreeter_set")
public func _bjs_OptionalPropertyHolder_optionalGreeter_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalGreeter = Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_deinit")
@_cdecl("bjs_OptionalPropertyHolder_deinit")
public func _bjs_OptionalPropertyHolder_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<OptionalPropertyHolder>.fromOpaque(pointer).release()
}

extension OptionalPropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_OptionalPropertyHolder_wrap")
        func _bjs_OptionalPropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_OptionalPropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_OptionalPropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}