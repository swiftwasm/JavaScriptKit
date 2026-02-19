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
fileprivate func _bjs_Greeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Greeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Greeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Greeter_wrap_extern(pointer)
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
fileprivate func _bjs_OptionalPropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_OptionalPropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_OptionalPropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_OptionalPropertyHolder_wrap_extern(pointer)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_init")
fileprivate func bjs_WithOptionalJSClass_init_extern(_ valueOrNullIsSome: Int32, _ valueOrNullValue: Int32, _ valueOrUndefinedIsSome: Int32, _ valueOrUndefinedValue: Int32) -> Int32
#else
fileprivate func bjs_WithOptionalJSClass_init_extern(_ valueOrNullIsSome: Int32, _ valueOrNullValue: Int32, _ valueOrUndefinedIsSome: Int32, _ valueOrUndefinedValue: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_init(_ valueOrNullIsSome: Int32, _ valueOrNullValue: Int32, _ valueOrUndefinedIsSome: Int32, _ valueOrUndefinedValue: Int32) -> Int32 {
    return bjs_WithOptionalJSClass_init_extern(valueOrNullIsSome, valueOrNullValue, valueOrUndefinedIsSome, valueOrUndefinedValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_stringOrNull_get")
fileprivate func bjs_WithOptionalJSClass_stringOrNull_get_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_stringOrNull_get_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_stringOrNull_get(_ self: Int32) -> Void {
    return bjs_WithOptionalJSClass_stringOrNull_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_stringOrUndefined_get")
fileprivate func bjs_WithOptionalJSClass_stringOrUndefined_get_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_stringOrUndefined_get_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_stringOrUndefined_get(_ self: Int32) -> Void {
    return bjs_WithOptionalJSClass_stringOrUndefined_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_doubleOrNull_get")
fileprivate func bjs_WithOptionalJSClass_doubleOrNull_get_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_doubleOrNull_get_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_doubleOrNull_get(_ self: Int32) -> Void {
    return bjs_WithOptionalJSClass_doubleOrNull_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_doubleOrUndefined_get")
fileprivate func bjs_WithOptionalJSClass_doubleOrUndefined_get_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_doubleOrUndefined_get_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_doubleOrUndefined_get(_ self: Int32) -> Void {
    return bjs_WithOptionalJSClass_doubleOrUndefined_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_boolOrNull_get")
fileprivate func bjs_WithOptionalJSClass_boolOrNull_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_WithOptionalJSClass_boolOrNull_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_boolOrNull_get(_ self: Int32) -> Int32 {
    return bjs_WithOptionalJSClass_boolOrNull_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_boolOrUndefined_get")
fileprivate func bjs_WithOptionalJSClass_boolOrUndefined_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_WithOptionalJSClass_boolOrUndefined_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_boolOrUndefined_get(_ self: Int32) -> Int32 {
    return bjs_WithOptionalJSClass_boolOrUndefined_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_intOrNull_get")
fileprivate func bjs_WithOptionalJSClass_intOrNull_get_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_intOrNull_get_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_intOrNull_get(_ self: Int32) -> Void {
    return bjs_WithOptionalJSClass_intOrNull_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_intOrUndefined_get")
fileprivate func bjs_WithOptionalJSClass_intOrUndefined_get_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_intOrUndefined_get_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_intOrUndefined_get(_ self: Int32) -> Void {
    return bjs_WithOptionalJSClass_intOrUndefined_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_stringOrNull_set")
fileprivate func bjs_WithOptionalJSClass_stringOrNull_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_stringOrNull_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_stringOrNull_set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_stringOrNull_set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_stringOrUndefined_set")
fileprivate func bjs_WithOptionalJSClass_stringOrUndefined_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_stringOrUndefined_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_stringOrUndefined_set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_stringOrUndefined_set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_doubleOrNull_set")
fileprivate func bjs_WithOptionalJSClass_doubleOrNull_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Float64) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_doubleOrNull_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_doubleOrNull_set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Float64) -> Void {
    return bjs_WithOptionalJSClass_doubleOrNull_set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_doubleOrUndefined_set")
fileprivate func bjs_WithOptionalJSClass_doubleOrUndefined_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Float64) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_doubleOrUndefined_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_doubleOrUndefined_set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Float64) -> Void {
    return bjs_WithOptionalJSClass_doubleOrUndefined_set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_boolOrNull_set")
fileprivate func bjs_WithOptionalJSClass_boolOrNull_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_boolOrNull_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_boolOrNull_set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_boolOrNull_set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_boolOrUndefined_set")
fileprivate func bjs_WithOptionalJSClass_boolOrUndefined_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_boolOrUndefined_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_boolOrUndefined_set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_boolOrUndefined_set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_intOrNull_set")
fileprivate func bjs_WithOptionalJSClass_intOrNull_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_intOrNull_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_intOrNull_set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_intOrNull_set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_intOrUndefined_set")
fileprivate func bjs_WithOptionalJSClass_intOrUndefined_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_intOrUndefined_set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_intOrUndefined_set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_intOrUndefined_set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_roundTripStringOrNull")
fileprivate func bjs_WithOptionalJSClass_roundTripStringOrNull_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_roundTripStringOrNull_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_roundTripStringOrNull(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_roundTripStringOrNull_extern(self, valueIsSome, valueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_roundTripStringOrUndefined")
fileprivate func bjs_WithOptionalJSClass_roundTripStringOrUndefined_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_roundTripStringOrUndefined_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_roundTripStringOrUndefined(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_roundTripStringOrUndefined_extern(self, valueIsSome, valueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_roundTripDoubleOrNull")
fileprivate func bjs_WithOptionalJSClass_roundTripDoubleOrNull_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Float64) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_roundTripDoubleOrNull_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_roundTripDoubleOrNull(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Float64) -> Void {
    return bjs_WithOptionalJSClass_roundTripDoubleOrNull_extern(self, valueIsSome, valueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_roundTripDoubleOrUndefined")
fileprivate func bjs_WithOptionalJSClass_roundTripDoubleOrUndefined_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Float64) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_roundTripDoubleOrUndefined_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_roundTripDoubleOrUndefined(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Float64) -> Void {
    return bjs_WithOptionalJSClass_roundTripDoubleOrUndefined_extern(self, valueIsSome, valueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_roundTripBoolOrNull")
fileprivate func bjs_WithOptionalJSClass_roundTripBoolOrNull_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Int32
#else
fileprivate func bjs_WithOptionalJSClass_roundTripBoolOrNull_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_roundTripBoolOrNull(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Int32 {
    return bjs_WithOptionalJSClass_roundTripBoolOrNull_extern(self, valueIsSome, valueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_roundTripBoolOrUndefined")
fileprivate func bjs_WithOptionalJSClass_roundTripBoolOrUndefined_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Int32
#else
fileprivate func bjs_WithOptionalJSClass_roundTripBoolOrUndefined_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_roundTripBoolOrUndefined(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Int32 {
    return bjs_WithOptionalJSClass_roundTripBoolOrUndefined_extern(self, valueIsSome, valueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_roundTripIntOrNull")
fileprivate func bjs_WithOptionalJSClass_roundTripIntOrNull_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_roundTripIntOrNull_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_roundTripIntOrNull(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_roundTripIntOrNull_extern(self, valueIsSome, valueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithOptionalJSClass_roundTripIntOrUndefined")
fileprivate func bjs_WithOptionalJSClass_roundTripIntOrUndefined_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void
#else
fileprivate func bjs_WithOptionalJSClass_roundTripIntOrUndefined_extern(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithOptionalJSClass_roundTripIntOrUndefined(_ self: Int32, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    return bjs_WithOptionalJSClass_roundTripIntOrUndefined_extern(self, valueIsSome, valueValue)
}

func _$WithOptionalJSClass_init(_ valueOrNull: Optional<String>, _ valueOrUndefined: JSUndefinedOr<String>) throws(JSException) -> JSObject {
    let (valueOrNullIsSome, valueOrNullValue) = valueOrNull.bridgeJSLowerParameter()
    let (valueOrUndefinedIsSome, valueOrUndefinedValue) = valueOrUndefined.bridgeJSLowerParameter()
    let ret = bjs_WithOptionalJSClass_init(valueOrNullIsSome, valueOrNullValue, valueOrUndefinedIsSome, valueOrUndefinedValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$WithOptionalJSClass_stringOrNull_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_stringOrNull_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_stringOrUndefined_get(_ self: JSObject) throws(JSException) -> JSUndefinedOr<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_stringOrUndefined_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_doubleOrNull_get(_ self: JSObject) throws(JSException) -> Optional<Double> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_doubleOrNull_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Double>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_doubleOrUndefined_get(_ self: JSObject) throws(JSException) -> JSUndefinedOr<Double> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_doubleOrUndefined_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<Double>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_boolOrNull_get(_ self: JSObject) throws(JSException) -> Optional<Bool> {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WithOptionalJSClass_boolOrNull_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Bool>.bridgeJSLiftReturn(ret)
}

func _$WithOptionalJSClass_boolOrUndefined_get(_ self: JSObject) throws(JSException) -> JSUndefinedOr<Bool> {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WithOptionalJSClass_boolOrUndefined_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<Bool>.bridgeJSLiftReturn(ret)
}

func _$WithOptionalJSClass_intOrNull_get(_ self: JSObject) throws(JSException) -> Optional<Int> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_intOrNull_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Int>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_intOrUndefined_get(_ self: JSObject) throws(JSException) -> JSUndefinedOr<Int> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_intOrUndefined_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<Int>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_stringOrNull_set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_stringOrNull_set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WithOptionalJSClass_stringOrUndefined_set(_ self: JSObject, _ newValue: JSUndefinedOr<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_stringOrUndefined_set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WithOptionalJSClass_doubleOrNull_set(_ self: JSObject, _ newValue: Optional<Double>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_doubleOrNull_set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WithOptionalJSClass_doubleOrUndefined_set(_ self: JSObject, _ newValue: JSUndefinedOr<Double>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_doubleOrUndefined_set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WithOptionalJSClass_boolOrNull_set(_ self: JSObject, _ newValue: Optional<Bool>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_boolOrNull_set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WithOptionalJSClass_boolOrUndefined_set(_ self: JSObject, _ newValue: JSUndefinedOr<Bool>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_boolOrUndefined_set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WithOptionalJSClass_intOrNull_set(_ self: JSObject, _ newValue: Optional<Int>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_intOrNull_set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WithOptionalJSClass_intOrUndefined_set(_ self: JSObject, _ newValue: JSUndefinedOr<Int>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_intOrUndefined_set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WithOptionalJSClass_roundTripStringOrNull(_ self: JSObject, _ value: Optional<String>) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_roundTripStringOrNull(selfValue, valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_roundTripStringOrUndefined(_ self: JSObject, _ value: JSUndefinedOr<String>) throws(JSException) -> JSUndefinedOr<String> {
    let selfValue = self.bridgeJSLowerParameter()
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_roundTripStringOrUndefined(selfValue, valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_roundTripDoubleOrNull(_ self: JSObject, _ value: Optional<Double>) throws(JSException) -> Optional<Double> {
    let selfValue = self.bridgeJSLowerParameter()
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_roundTripDoubleOrNull(selfValue, valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Double>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_roundTripDoubleOrUndefined(_ self: JSObject, _ value: JSUndefinedOr<Double>) throws(JSException) -> JSUndefinedOr<Double> {
    let selfValue = self.bridgeJSLowerParameter()
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_roundTripDoubleOrUndefined(selfValue, valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<Double>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_roundTripBoolOrNull(_ self: JSObject, _ value: Optional<Bool>) throws(JSException) -> Optional<Bool> {
    let selfValue = self.bridgeJSLowerParameter()
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    let ret = bjs_WithOptionalJSClass_roundTripBoolOrNull(selfValue, valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Bool>.bridgeJSLiftReturn(ret)
}

func _$WithOptionalJSClass_roundTripBoolOrUndefined(_ self: JSObject, _ value: JSUndefinedOr<Bool>) throws(JSException) -> JSUndefinedOr<Bool> {
    let selfValue = self.bridgeJSLowerParameter()
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    let ret = bjs_WithOptionalJSClass_roundTripBoolOrUndefined(selfValue, valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<Bool>.bridgeJSLiftReturn(ret)
}

func _$WithOptionalJSClass_roundTripIntOrNull(_ self: JSObject, _ value: Optional<Int>) throws(JSException) -> Optional<Int> {
    let selfValue = self.bridgeJSLowerParameter()
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_roundTripIntOrNull(selfValue, valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Int>.bridgeJSLiftReturnFromSideChannel()
}

func _$WithOptionalJSClass_roundTripIntOrUndefined(_ self: JSObject, _ value: JSUndefinedOr<Int>) throws(JSException) -> JSUndefinedOr<Int> {
    let selfValue = self.bridgeJSLowerParameter()
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_WithOptionalJSClass_roundTripIntOrUndefined(selfValue, valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<Int>.bridgeJSLiftReturnFromSideChannel()
}