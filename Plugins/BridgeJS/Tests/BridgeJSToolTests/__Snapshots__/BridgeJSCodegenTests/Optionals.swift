@_expose(wasm, "bjs_roundTripOptionalClass")
@_cdecl("bjs_roundTripOptionalClass")
public func _bjs_roundTripOptionalClass(_ valueIsSome: Int32, _ valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalClass(value: Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalPropertyRoundtrip")
@_cdecl("bjs_testOptionalPropertyRoundtrip")
public func _bjs_testOptionalPropertyRoundtrip(_ holderIsSome: Int32, _ holderValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = testOptionalPropertyRoundtrip(_: Optional<OptionalPropertyHolder>.bridgeJSLiftParameter(holderIsSome, holderValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripString")
@_cdecl("bjs_roundTripString")
public func _bjs_roundTripString(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripString(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripInt")
@_cdecl("bjs_roundTripInt")
public func _bjs_roundTripInt(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripInt(value: Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripBool")
@_cdecl("bjs_roundTripBool")
public func _bjs_roundTripBool(_ flagIsSome: Int32, _ flagValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripBool(flag: Optional<Bool>.bridgeJSLiftParameter(flagIsSome, flagValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripFloat")
@_cdecl("bjs_roundTripFloat")
public func _bjs_roundTripFloat(_ numberIsSome: Int32, _ numberValue: Float32) -> Void {
    #if arch(wasm32)
    let ret = roundTripFloat(number: Optional<Float>.bridgeJSLiftParameter(numberIsSome, numberValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDouble")
@_cdecl("bjs_roundTripDouble")
public func _bjs_roundTripDouble(_ precisionIsSome: Int32, _ precisionValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripDouble(precision: Optional<Double>.bridgeJSLiftParameter(precisionIsSome, precisionValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSyntax")
@_cdecl("bjs_roundTripSyntax")
public func _bjs_roundTripSyntax(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripMixSyntax")
@_cdecl("bjs_roundTripMixSyntax")
public func _bjs_roundTripMixSyntax(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripMixSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSwiftSyntax")
@_cdecl("bjs_roundTripSwiftSyntax")
public func _bjs_roundTripSwiftSyntax(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripSwiftSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripMixedSwiftSyntax")
@_cdecl("bjs_roundTripMixedSwiftSyntax")
public func _bjs_roundTripMixedSwiftSyntax(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripMixedSwiftSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripWithSpaces")
@_cdecl("bjs_roundTripWithSpaces")
public func _bjs_roundTripWithSpaces(_ valueIsSome: Int32, _ valueValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripWithSpaces(value: Optional<Double>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripAlias")
@_cdecl("bjs_roundTripAlias")
public func _bjs_roundTripAlias(_ ageIsSome: Int32, _ ageValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripAlias(age: Optional<Int>.bridgeJSLiftParameter(ageIsSome, ageValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalAlias")
@_cdecl("bjs_roundTripOptionalAlias")
public func _bjs_roundTripOptionalAlias(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalAlias(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testMixedOptionals")
@_cdecl("bjs_testMixedOptionals")
public func _bjs_testMixedOptionals(_ firstNameIsSome: Int32, _ firstNameBytes: Int32, _ firstNameLength: Int32, _ lastNameIsSome: Int32, _ lastNameBytes: Int32, _ lastNameLength: Int32, _ ageIsSome: Int32, _ ageValue: Int32, _ active: Int32) -> Void {
    #if arch(wasm32)
    let ret = testMixedOptionals(firstName: Optional<String>.bridgeJSLiftParameter(firstNameIsSome, firstNameBytes, firstNameLength), lastName: Optional<String>.bridgeJSLiftParameter(lastNameIsSome, lastNameBytes, lastNameLength), age: Optional<Int>.bridgeJSLiftParameter(ageIsSome, ageValue), active: Bool.bridgeJSLiftParameter(active))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_changeName")
@_cdecl("bjs_Greeter_changeName")
public func _bjs_Greeter_changeName(_ _self: UnsafeMutableRawPointer, _ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).changeName(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_get")
@_cdecl("bjs_Greeter_name_get")
public func _bjs_Greeter_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_set")
@_cdecl("bjs_Greeter_name_set")
public func _bjs_Greeter_name_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).name = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Greeter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_wrap")
fileprivate func _bjs_Greeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Greeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
public func _bjs_OptionalPropertyHolder_optionalName_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalName
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalName_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalName_set")
public func _bjs_OptionalPropertyHolder_optionalName_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalName = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalAge_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalAge_get")
public func _bjs_OptionalPropertyHolder_optionalAge_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalAge
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalAge_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalAge_set")
public func _bjs_OptionalPropertyHolder_optionalAge_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalAge = Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalGreeter_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalGreeter_get")
public func _bjs_OptionalPropertyHolder_optionalGreeter_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalGreeter
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalGreeter_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalGreeter_set")
public func _bjs_OptionalPropertyHolder_optionalGreeter_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalGreeter = Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_deinit")
@_cdecl("bjs_OptionalPropertyHolder_deinit")
public func _bjs_OptionalPropertyHolder_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<OptionalPropertyHolder>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension OptionalPropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_OptionalPropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_OptionalPropertyHolder_wrap")
fileprivate func _bjs_OptionalPropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_OptionalPropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif