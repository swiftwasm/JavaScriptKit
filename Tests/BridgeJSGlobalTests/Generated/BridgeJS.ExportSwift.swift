// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

extension GlobalNetworking.API.CallMethod: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> GlobalNetworking.API.CallMethod {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> GlobalNetworking.API.CallMethod {
        return GlobalNetworking.API.CallMethod(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .get
        case 1:
            self = .post
        case 2:
            self = .put
        case 3:
            self = .delete
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .get:
            return 0
        case .post:
            return 1
        case .put:
            return 2
        case .delete:
            return 3
        }
    }
}

extension GlobalConfiguration.PublicLogLevel: _BridgedSwiftEnumNoPayload {
}

extension GlobalConfiguration.AvailablePort: _BridgedSwiftEnumNoPayload {
}

extension Internal.SupportedServerMethod: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Internal.SupportedServerMethod {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Internal.SupportedServerMethod {
        return Internal.SupportedServerMethod(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .get
        case 1:
            self = .post
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .get:
            return 0
        case .post:
            return 1
        }
    }
}

@_expose(wasm, "bjs_GlobalStaticPropertyNamespace_static_namespaceProperty_get")
@_cdecl("bjs_GlobalStaticPropertyNamespace_static_namespaceProperty_get")
public func _bjs_GlobalStaticPropertyNamespace_static_namespaceProperty_get() -> Void {
    #if arch(wasm32)
    let ret = GlobalStaticPropertyNamespace.namespaceProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalStaticPropertyNamespace_static_namespaceProperty_set")
@_cdecl("bjs_GlobalStaticPropertyNamespace_static_namespaceProperty_set")
public func _bjs_GlobalStaticPropertyNamespace_static_namespaceProperty_set(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    GlobalStaticPropertyNamespace.namespaceProperty = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalStaticPropertyNamespace_static_namespaceConstant_get")
@_cdecl("bjs_GlobalStaticPropertyNamespace_static_namespaceConstant_get")
public func _bjs_GlobalStaticPropertyNamespace_static_namespaceConstant_get() -> Void {
    #if arch(wasm32)
    let ret = GlobalStaticPropertyNamespace.namespaceConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedProperty_get")
@_cdecl("bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedProperty_get")
public func _bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedProperty_get() -> Int32 {
    #if arch(wasm32)
    let ret = GlobalStaticPropertyNamespace.NestedProperties.nestedProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedProperty_set")
@_cdecl("bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedProperty_set")
public func _bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedProperty_set(value: Int32) -> Void {
    #if arch(wasm32)
    GlobalStaticPropertyNamespace.NestedProperties.nestedProperty = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedConstant_get")
@_cdecl("bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedConstant_get")
public func _bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedConstant_get() -> Void {
    #if arch(wasm32)
    let ret = GlobalStaticPropertyNamespace.NestedProperties.nestedConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedDouble_get")
@_cdecl("bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedDouble_get")
public func _bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedDouble_get() -> Float64 {
    #if arch(wasm32)
    let ret = GlobalStaticPropertyNamespace.NestedProperties.nestedDouble
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedDouble_set")
@_cdecl("bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedDouble_set")
public func _bjs_GlobalStaticPropertyNamespace_NestedProperties_static_nestedDouble_set(value: Float64) -> Void {
    #if arch(wasm32)
    GlobalStaticPropertyNamespace.NestedProperties.nestedDouble = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestHTTPServer_init")
@_cdecl("bjs_TestHTTPServer_init")
public func _bjs_TestHTTPServer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = GlobalNetworking.API.TestHTTPServer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestHTTPServer_call")
@_cdecl("bjs_TestHTTPServer_call")
public func _bjs_TestHTTPServer_call(_self: UnsafeMutableRawPointer, method: Int32) -> Void {
    #if arch(wasm32)
    GlobalNetworking.API.TestHTTPServer.bridgeJSLiftParameter(_self).call(_: GlobalNetworking.API.CallMethod.bridgeJSLiftParameter(method))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestHTTPServer_deinit")
@_cdecl("bjs_TestHTTPServer_deinit")
public func _bjs_TestHTTPServer_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<GlobalNetworking.API.TestHTTPServer>.fromOpaque(pointer).release()
}

extension GlobalNetworking.API.TestHTTPServer: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TestHTTPServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSGlobalTests", name: "bjs_TestHTTPServer_wrap")
fileprivate func _bjs_TestHTTPServer_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TestHTTPServer_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_TestInternalServer_init")
@_cdecl("bjs_TestInternalServer_init")
public func _bjs_TestInternalServer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Internal.TestInternalServer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestInternalServer_call")
@_cdecl("bjs_TestInternalServer_call")
public func _bjs_TestInternalServer_call(_self: UnsafeMutableRawPointer, method: Int32) -> Void {
    #if arch(wasm32)
    Internal.TestInternalServer.bridgeJSLiftParameter(_self).call(_: Internal.SupportedServerMethod.bridgeJSLiftParameter(method))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestInternalServer_deinit")
@_cdecl("bjs_TestInternalServer_deinit")
public func _bjs_TestInternalServer_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Internal.TestInternalServer>.fromOpaque(pointer).release()
}

extension Internal.TestInternalServer: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TestInternalServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSGlobalTests", name: "bjs_TestInternalServer_wrap")
fileprivate func _bjs_TestInternalServer_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TestInternalServer_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_PublicConverter_init")
@_cdecl("bjs_PublicConverter_init")
public func _bjs_PublicConverter_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = GlobalUtils.PublicConverter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PublicConverter_toString")
@_cdecl("bjs_PublicConverter_toString")
public func _bjs_PublicConverter_toString(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    let ret = GlobalUtils.PublicConverter.bridgeJSLiftParameter(_self).toString(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PublicConverter_deinit")
@_cdecl("bjs_PublicConverter_deinit")
public func _bjs_PublicConverter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<GlobalUtils.PublicConverter>.fromOpaque(pointer).release()
}

extension GlobalUtils.PublicConverter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PublicConverter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSGlobalTests", name: "bjs_PublicConverter_wrap")
fileprivate func _bjs_PublicConverter_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PublicConverter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif