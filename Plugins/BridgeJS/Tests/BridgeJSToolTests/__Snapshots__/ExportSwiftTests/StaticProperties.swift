// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

extension PropertyEnum: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> PropertyEnum {
        return PropertyEnum(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> PropertyEnum {
        return PropertyEnum(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSRawValue
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .value1
        case 1:
            self = .value2
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .value1:
            return 0
        case .value2:
            return 1
        }
    }
}

@_expose(wasm, "bjs_PropertyEnum_static_enumProperty_get")
@_cdecl("bjs_PropertyEnum_static_enumProperty_get")
public func _bjs_PropertyEnum_static_enumProperty_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyEnum.enumProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyEnum_static_enumProperty_set")
@_cdecl("bjs_PropertyEnum_static_enumProperty_set")
public func _bjs_PropertyEnum_static_enumProperty_set(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyEnum.enumProperty = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyEnum_static_enumConstant_get")
@_cdecl("bjs_PropertyEnum_static_enumConstant_get")
public func _bjs_PropertyEnum_static_enumConstant_get() -> Int32 {
    #if arch(wasm32)
    let ret = PropertyEnum.enumConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyEnum_static_computedEnum_get")
@_cdecl("bjs_PropertyEnum_static_computedEnum_get")
public func _bjs_PropertyEnum_static_computedEnum_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyEnum.computedEnum
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyEnum_static_computedEnum_set")
@_cdecl("bjs_PropertyEnum_static_computedEnum_set")
public func _bjs_PropertyEnum_static_computedEnum_set(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyEnum.computedEnum = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_static_namespaceProperty_get")
@_cdecl("bjs_PropertyNamespace_static_namespaceProperty_get")
public func _bjs_PropertyNamespace_static_namespaceProperty_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyNamespace.namespaceProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_static_namespaceProperty_set")
@_cdecl("bjs_PropertyNamespace_static_namespaceProperty_set")
public func _bjs_PropertyNamespace_static_namespaceProperty_set(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyNamespace.namespaceProperty = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_static_namespaceConstant_get")
@_cdecl("bjs_PropertyNamespace_static_namespaceConstant_get")
public func _bjs_PropertyNamespace_static_namespaceConstant_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyNamespace.namespaceConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_Nested_static_nestedProperty_get")
@_cdecl("bjs_PropertyNamespace_Nested_static_nestedProperty_get")
public func _bjs_PropertyNamespace_Nested_static_nestedProperty_get() -> Int32 {
    #if arch(wasm32)
    let ret = PropertyNamespace.Nested.nestedProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_Nested_static_nestedProperty_set")
@_cdecl("bjs_PropertyNamespace_Nested_static_nestedProperty_set")
public func _bjs_PropertyNamespace_Nested_static_nestedProperty_set(value: Int32) -> Void {
    #if arch(wasm32)
    PropertyNamespace.Nested.nestedProperty = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_Nested_static_nestedConstant_get")
@_cdecl("bjs_PropertyNamespace_Nested_static_nestedConstant_get")
public func _bjs_PropertyNamespace_Nested_static_nestedConstant_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyNamespace.Nested.nestedConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_Nested_static_nestedDouble_get")
@_cdecl("bjs_PropertyNamespace_Nested_static_nestedDouble_get")
public func _bjs_PropertyNamespace_Nested_static_nestedDouble_get() -> Float64 {
    #if arch(wasm32)
    let ret = PropertyNamespace.Nested.nestedDouble
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_Nested_static_nestedDouble_set")
@_cdecl("bjs_PropertyNamespace_Nested_static_nestedDouble_set")
public func _bjs_PropertyNamespace_Nested_static_nestedDouble_set(value: Float64) -> Void {
    #if arch(wasm32)
    PropertyNamespace.Nested.nestedDouble = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

<<<<<<< HEAD
@_expose(wasm, "bjs_PropertyNamespace_static_namespaceProperty_get")
@_cdecl("bjs_PropertyNamespace_static_namespaceProperty_get")
public func _bjs_PropertyNamespace_static_namespaceProperty_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyNamespace.namespaceProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_static_namespaceProperty_set")
@_cdecl("bjs_PropertyNamespace_static_namespaceProperty_set")
public func _bjs_PropertyNamespace_static_namespaceProperty_set(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyNamespace.namespaceProperty = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyNamespace_static_namespaceConstant_get")
@_cdecl("bjs_PropertyNamespace_static_namespaceConstant_get")
public func _bjs_PropertyNamespace_static_namespaceConstant_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyNamespace.namespaceConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

=======
>>>>>>> 26a78490 (WIP: Enum handling and nesting simplifications (+1 squashed commit))
@_expose(wasm, "bjs_PropertyClass_init")
@_cdecl("bjs_PropertyClass_init")
public func _bjs_PropertyClass_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PropertyClass()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_staticConstant_get")
@_cdecl("bjs_PropertyClass_static_staticConstant_get")
public func _bjs_PropertyClass_static_staticConstant_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyClass.staticConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_staticVariable_get")
@_cdecl("bjs_PropertyClass_static_staticVariable_get")
public func _bjs_PropertyClass_static_staticVariable_get() -> Int32 {
    #if arch(wasm32)
    let ret = PropertyClass.staticVariable
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_staticVariable_set")
@_cdecl("bjs_PropertyClass_static_staticVariable_set")
public func _bjs_PropertyClass_static_staticVariable_set(value: Int32) -> Void {
    #if arch(wasm32)
    PropertyClass.staticVariable = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_jsObjectProperty_get")
@_cdecl("bjs_PropertyClass_static_jsObjectProperty_get")
public func _bjs_PropertyClass_static_jsObjectProperty_get() -> Int32 {
    #if arch(wasm32)
    let ret = PropertyClass.jsObjectProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_jsObjectProperty_set")
@_cdecl("bjs_PropertyClass_static_jsObjectProperty_set")
public func _bjs_PropertyClass_static_jsObjectProperty_set(value: Int32) -> Void {
    #if arch(wasm32)
    PropertyClass.jsObjectProperty = JSObject.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_classVariable_get")
@_cdecl("bjs_PropertyClass_static_classVariable_get")
public func _bjs_PropertyClass_static_classVariable_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyClass.classVariable
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_classVariable_set")
@_cdecl("bjs_PropertyClass_static_classVariable_set")
public func _bjs_PropertyClass_static_classVariable_set(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyClass.classVariable = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_computedProperty_get")
@_cdecl("bjs_PropertyClass_static_computedProperty_get")
public func _bjs_PropertyClass_static_computedProperty_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyClass.computedProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_computedProperty_set")
@_cdecl("bjs_PropertyClass_static_computedProperty_set")
public func _bjs_PropertyClass_static_computedProperty_set(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyClass.computedProperty = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_readOnlyComputed_get")
@_cdecl("bjs_PropertyClass_static_readOnlyComputed_get")
public func _bjs_PropertyClass_static_readOnlyComputed_get() -> Int32 {
    #if arch(wasm32)
    let ret = PropertyClass.readOnlyComputed
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_optionalProperty_get")
@_cdecl("bjs_PropertyClass_static_optionalProperty_get")
public func _bjs_PropertyClass_static_optionalProperty_get() -> Void {
    #if arch(wasm32)
    let ret = PropertyClass.optionalProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_static_optionalProperty_set")
@_cdecl("bjs_PropertyClass_static_optionalProperty_set")
public func _bjs_PropertyClass_static_optionalProperty_set(valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyClass.optionalProperty = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyClass_deinit")
@_cdecl("bjs_PropertyClass_deinit")
public func _bjs_PropertyClass_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PropertyClass>.fromOpaque(pointer).release()
}

extension PropertyClass: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_PropertyClass_wrap")
        func _bjs_PropertyClass_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_PropertyClass_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PropertyClass_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}