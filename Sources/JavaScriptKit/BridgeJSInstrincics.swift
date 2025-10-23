/// BridgeJS Intrinsics
///
/// This file contains low-level intrinsic functions that are used by code generated
/// by the BridgeJS system.

import _CJavaScriptKit

#if !arch(wasm32)
@usableFromInline func _onlyAvailableOnWasm() -> Never {
    fatalError("Only available on WebAssembly")
}
#endif

// MARK: Exception Handling

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_throw")
@_spi(BridgeJS) public func _swift_js_throw(_ id: Int32)
#else
/// Throws a JavaScript exception from Swift code.
///
/// This function is called by the BridgeJS code generator when a Swift function throws
/// an error. The exception object is retained and stored for later retrieval by the
/// JavaScript-side runtime code.
///
/// - Parameter id: The ID of the JavaScript exception object to throw
@_spi(BridgeJS) public func _swift_js_throw(_ id: Int32) {
    _onlyAvailableOnWasm()
}
#endif

/// Retrieves and clears any pending JavaScript exception.
///
/// This function checks for any JavaScript exceptions that were thrown during
/// the execution of imported JavaScript functions. If an exception exists, it
/// is retrieved, cleared from the global storage, and returned as a `JSException`.
///
/// - Returns: A `JSException` if an exception was pending, `nil` otherwise
@_spi(BridgeJS) @_transparent public func _swift_js_take_exception() -> JSException? {
    #if arch(wasm32)
    let value = _swift_js_exception_get()
    if _fastPath(value == 0) {
        return nil
    }
    _swift_js_exception_set(0)
    return JSException(JSObject(id: UInt32(bitPattern: value)).jsValue)
    #else
    _onlyAvailableOnWasm()
    #endif
}

// MARK: Type lowering/lifting
//
// The following part defines the parameter and return value lowering/lifting
// for a given type. They follow the following pattern:
//
// ```swift
// extension <#TargetType#> {
//     // MARK: ImportTS
//     @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> <#WasmCoreType#> {
//     }
//     @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ ...) -> <#Self#> {
//     }
//     // MARK: ExportSwift
//     @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ ...) -> <#Self#> {
//     }
//     @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> <#WasmCoreType#> {
//     }
// }
// ```
//
// where:
// - <#TargetType#>: the higher-level type to be lowered/lifted
// - <#WasmCoreType#>: the corresponding WebAssembly core type or Void
// - `func bridgeJSLowerParameter()`: lower the given higher-level parameter to a WebAssembly core type
// - `func bridgeJSLiftReturn(_ ...) -> <#TargetType#>`: lift the given Wasm core type return value to a higher-level type
// - `func bridgeJSLiftParameter(_ ...) -> <#TargetType#>`: lift the given Wasm core type parameters to a higher-level type
// - `func bridgeJSLowerReturn() -> <#WasmCoreType#>`: lower the given higher-level return value to a Wasm core type
//
// See JSGlueGen.swift in BridgeJSLink for JS-side lowering/lifting implementation.

/// A protocol that Swift types that can appear as parameters or return values on
public protocol _BridgedSwiftTypeLoweredIntoSingleWasmCoreType {
    associatedtype WasmCoreType
    // MARK: ImportTS
    consuming func bridgeJSLowerParameter() -> WasmCoreType
    static func bridgeJSLiftReturn(_ value: WasmCoreType) -> Self
    // MARK: ExportSwift
    static func bridgeJSLiftParameter(_ value: WasmCoreType) -> Self
    consuming func bridgeJSLowerReturn() -> WasmCoreType
}

extension Bool: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        self ? 1 : 0
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Bool {
        value == 1
    }
    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Bool {
        value == 1
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        self ? 1 : 0
    }
}

extension Int: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        Int32(self)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Int {
        Int(value)
    }
    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Int {
        Int(value)
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        Int32(self)
    }
}

extension Float: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Float32 {
        Float32(self)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Float32) -> Float {
        Float(value)
    }
    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Float32) -> Float {
        Float(value)
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Float32 {
        Float32(self)
    }
}

extension Double: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Float64 {
        Float64(self)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Float64) -> Double {
        Double(value)
    }
    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Float64) -> Double {
        Double(value)
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Float64 {
        Float64(self)
    }
}

extension String {
    // MARK: ImportTS

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Int32 {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_make_js_string")
        func _swift_js_make_js_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32
        #else
        /// Creates a JavaScript string from UTF-8 data in WebAssembly memory
        func _swift_js_make_js_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32 {
            _onlyAvailableOnWasm()
        }
        #endif
        return self.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ bytesCount: Int32) -> String {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_init_memory_with_result")
        func _swift_js_init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
        #else
        /// Initializes WebAssembly memory with result data of JavaScript function call
        func _swift_js_init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
            _onlyAvailableOnWasm()
        }
        guard #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) else { _onlyAvailableOnWasm() }
        #endif
        return String(unsafeUninitializedCapacity: Int(bytesCount)) { b in
            _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(bytesCount))
            return Int(bytesCount)
        }
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ bytes: Int32, _ count: Int32) -> String {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_init_memory")
        func _swift_js_init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?)
        #else
        /// Initializes a part of WebAssembly memory with Uint8Array a JavaScript object
        func _swift_js_init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?) {
            _onlyAvailableOnWasm()
        }
        guard #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) else { _onlyAvailableOnWasm() }
        #endif
        return String(unsafeUninitializedCapacity: Int(count)) { b in
            _swift_js_init_memory(bytes, b.baseAddress.unsafelyUnwrapped)
            return Int(count)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_string")
        func _swift_js_return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
        #else
        /// Write a string to reserved string storage to be returned to JavaScript
        func _swift_js_return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
            _onlyAvailableOnWasm()
        }
        #endif
        return self.withUTF8 { ptr in
            _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
        }
    }
}

extension JSObject {
    // MARK: ImportTS

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        Int32(bitPattern: self.id)
    }
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ id: Int32) -> JSObject {
        JSObject(id: JavaScriptObjectRef(bitPattern: id))
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ id: Int32) -> JSObject {
        JSObject(id: JavaScriptObjectRef(bitPattern: id))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Int32 {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_retain")
        func _swift_js_retain(_ id: Int32) -> Int32
        #else
        /// Retains a JavaScript object reference to ensure the object id
        /// remains valid after the function returns
        func _swift_js_retain(_ id: Int32) -> Int32 {
            _onlyAvailableOnWasm()
        }
        #endif
        return _swift_js_retain(Int32(bitPattern: self.id))
    }
}

/// A protocol that Swift heap objects exposed to JavaScript via `@JS class` must conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftHeapObject: AnyObject {}

/// Define the lowering/lifting for `_BridgedSwiftHeapObject`
extension _BridgedSwiftHeapObject {

    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> UnsafeMutableRawPointer {
        // For protocol parameters, we pass the unretained pointer since JS already has a reference
        return Unmanaged.passUnretained(self).toOpaque()
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ pointer: UnsafeMutableRawPointer) -> Self {
        // For protocol returns, take an unretained value since JS manages the lifetime
        return Unmanaged<Self>.fromOpaque(pointer).takeUnretainedValue()
    }

    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ pointer: UnsafeMutableRawPointer) -> Self {
        Unmanaged<Self>.fromOpaque(pointer).takeUnretainedValue()
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> UnsafeMutableRawPointer {
        // Perform a manual retain on the object, which will be balanced by a release called via FinalizationRegistry
        return Unmanaged.passRetained(self).toOpaque()
    }
}

extension _JSBridgedClass {
    // MARK: ImportTS
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Int32 { jsObject.bridgeJSLowerParameter() }
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ id: Int32) -> Self {
        Self(unsafelyWrapping: JSObject.bridgeJSLiftReturn(id))
    }

    // MARK: ExportSwift
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ id: Int32) -> Self {
        Self(unsafelyWrapping: JSObject.bridgeJSLiftParameter(id))
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Int32 { jsObject.bridgeJSLowerReturn() }
}

/// A protocol that Swift protocol wrappers exposed from JavaScript must conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftProtocolWrapper {
    var jsObject: JSObject { get }
    static func bridgeJSLiftParameter(_ value: Int32) -> Self
}

extension _BridgedSwiftProtocolWrapper {
    // MARK: ExportSwift
    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Int32 {
        jsObject.bridgeJSLowerReturn()
    }
}

/// A protocol that Swift enum types that do not have a payload can conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftEnumNoPayload {}

/// A protocol that Swift case enum types (enums without raw values or associated values) conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) static func bridgeJSLiftParameter(_ value: Int32) -> Self
    @_spi(BridgeJS) consuming func bridgeJSLowerReturn() -> Int32
}

/// A protocol that Swift associated value enum types conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) static func bridgeJSLiftParameter(_ caseId: Int32) -> Self
    @_spi(BridgeJS) consuming func bridgeJSLowerReturn() -> Void
}

extension _BridgedSwiftEnumNoPayload where Self: RawRepresentable, RawValue == String {
    // MARK: ImportTS
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Int32 { rawValue.bridgeJSLowerParameter() }
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ bytesCount: Int32) -> Self {
        Self(rawValue: .bridgeJSLiftReturn(bytesCount))!
    }

    // MARK: ExportSwift
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ bytes: Int32, _ count: Int32) -> Self {
        Self(rawValue: .bridgeJSLiftParameter(bytes, count))!
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void { rawValue.bridgeJSLowerReturn() }
}

extension _BridgedSwiftEnumNoPayload
where Self: RawRepresentable, RawValue: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType {
    // MARK: ImportTS
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> RawValue.WasmCoreType {
        rawValue.bridgeJSLowerParameter()
    }
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ value: RawValue.WasmCoreType) -> Self {
        Self(rawValue: .bridgeJSLiftReturn(value))!
    }

    // MARK: ExportSwift
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ value: RawValue.WasmCoreType) -> Self {
        Self(rawValue: .bridgeJSLiftParameter(value))!
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> RawValue.WasmCoreType {
        rawValue.bridgeJSLowerReturn()
    }
}

// MARK: Wasm externs used by generated enum glue

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_init_memory")
@_spi(BridgeJS) public func _swift_js_init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>)
#else
@_spi(BridgeJS) public func _swift_js_init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_push_tag")
@_spi(BridgeJS) public func _swift_js_push_tag(_ tag: Int32)
#else
@_spi(BridgeJS) public func _swift_js_push_tag(_ tag: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_push_string")
@_spi(BridgeJS) public func _swift_js_push_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
#else
@_spi(BridgeJS) public func _swift_js_push_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_push_int")
@_spi(BridgeJS) public func _swift_js_push_int(_ value: Int32)
#else
@_spi(BridgeJS) public func _swift_js_push_int(_ value: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_push_f32")
@_spi(BridgeJS) public func _swift_js_push_f32(_ value: Float32)
#else
@_spi(BridgeJS) public func _swift_js_push_f32(_ value: Float32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_push_f64")
@_spi(BridgeJS) public func _swift_js_push_f64(_ value: Float64)
#else
@_spi(BridgeJS) public func _swift_js_push_f64(_ value: Float64) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_pop_param_int32")
@_spi(BridgeJS) public func _swift_js_pop_param_int32() -> Int32
#else
@_spi(BridgeJS) public func _swift_js_pop_param_int32() -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_pop_param_f32")
@_spi(BridgeJS) public func _swift_js_pop_param_f32() -> Float32
#else
@_spi(BridgeJS) public func _swift_js_pop_param_f32() -> Float32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_pop_param_f64")
@_spi(BridgeJS) public func _swift_js_pop_param_f64() -> Float64
#else
@_spi(BridgeJS) public func _swift_js_pop_param_f64() -> Float64 {
    _onlyAvailableOnWasm()
}
#endif

// MARK: Optional Type Support

extension Optional where Wrapped == Bool {
    // MARK: ImportTS

    @available(*, unavailable, message: "Optional Bool type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {}

    @available(*, unavailable, message: "Optional Bool type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ wrappedValue: Int32) -> Bool? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Bool? {
        if isSome == 0 {
            return nil
        } else {
            return Bool.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_optional_bool")
        func _swift_js_return_optional_bool(_ isSome: Int32, _ value: Int32)
        #else
        /// Sets the optional bool for return value storage
        func _swift_js_return_optional_bool(_ isSome: Int32, _ value: Int32) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch consume self {
        case .none:
            _swift_js_return_optional_bool(0, 0)
        case .some(let value):
            _swift_js_return_optional_bool(1, value.bridgeJSLowerReturn())
        }
    }
}

/// Optional support for Int
extension Optional where Wrapped == Int {
    // MARK: ImportTS

    @available(*, unavailable, message: "Optional Int type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public func bridgeJSLowerParameter() -> Void {}

    @available(*, unavailable, message: "Optional Int type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ wrappedValue: Int32) -> Int? { return nil }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Int? {
        if isSome == 0 {
            return nil
        } else {
            return Int.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_optional_int")
        func _swift_js_return_optional_int(_ isSome: Int32, _ value: Int32)
        #else
        /// Sets the optional int for return value storage
        func _swift_js_return_optional_int(_ isSome: Int32, _ value: Int32) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch self {
        case .none:
            _swift_js_return_optional_int(0, 0)
        case .some(let value):
            _swift_js_return_optional_int(1, value.bridgeJSLowerReturn())
        }
    }
}
extension Optional where Wrapped == String {
    // MARK: ImportTS

    @available(*, unavailable, message: "Optional String type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public func bridgeJSLowerParameter() -> Void {}

    @available(*, unavailable, message: "Optional String type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32) -> String? { return nil }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ bytes: Int32, _ count: Int32) -> String?
    {
        if isSome == 0 {
            return nil
        } else {
            return String.bridgeJSLiftParameter(bytes, count)
        }
    }

    @_spi(BridgeJS) public func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_optional_string")
        func _swift_js_return_optional_string(_ isSome: Int32, _ ptr: UnsafePointer<UInt8>?, _ len: Int32)
        #else
        /// Write an optional string to reserved string storage to be returned to JavaScript
        func _swift_js_return_optional_string(_ isSome: Int32, _ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch self {
        case .none:
            _swift_js_return_optional_string(0, nil, 0)
        case .some(var value):
            return value.withUTF8 { ptr in
                _swift_js_return_optional_string(1, ptr.baseAddress, Int32(ptr.count))
            }
        }
    }
}
extension Optional where Wrapped == JSObject {
    // MARK: ImportTS

    @available(*, unavailable, message: "Optional JSObject type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public func bridgeJSLowerParameter() -> Void {}

    @available(*, unavailable, message: "Optional JSObject type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ objectId: Int32) -> JSObject? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ objectId: Int32) -> JSObject? {
        if isSome == 0 {
            return nil
        } else {
            return JSObject.bridgeJSLiftParameter(objectId)
        }
    }

    @_spi(BridgeJS) public func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_optional_object")
        func _swift_js_return_optional_object(_ isSome: Int32, _ objectId: Int32)
        #else
        /// Write an optional JSObject to reserved storage to be returned to JavaScript
        func _swift_js_return_optional_object(_ isSome: Int32, _ objectId: Int32) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch self {
        case .none:
            _swift_js_return_optional_object(0, 0)
        case .some(let value):
            let retainedId = value.bridgeJSLowerReturn()
            _swift_js_return_optional_object(1, retainedId)
        }
    }
}

extension Optional where Wrapped: _BridgedSwiftProtocolWrapper {
    // MARK: ImportTS

    @available(
        *,
        unavailable,
        message: "Optional protocol types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public func bridgeJSLowerParameter() -> Void {}

    @available(
        *,
        unavailable,
        message: "Optional protocol types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ objectId: Int32) -> Wrapped? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ objectId: Int32) -> Wrapped? {
        if isSome == 0 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftParameter(objectId)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_optional_object")
        func _swift_js_return_optional_object(_ isSome: Int32, _ objectId: Int32)
        #else
        /// Write an optional protocol wrapper to reserved storage to be returned to JavaScript
        func _swift_js_return_optional_object(_ isSome: Int32, _ objectId: Int32) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch consume self {
        case .none:
            _swift_js_return_optional_object(0, 0)
        case .some(let wrapper):
            let retainedId = wrapper.bridgeJSLowerReturn()
            _swift_js_return_optional_object(1, retainedId)
        }
    }
}

/// Optional support for Swift heap objects
extension Optional where Wrapped: _BridgedSwiftHeapObject {
    // MARK: ImportTS
    @available(
        *,
        unavailable,
        message: "Optional Swift heap objects are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Void {}

    @available(
        *,
        unavailable,
        message: "Optional Swift heap objects are not supported to be returned from imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ pointer: UnsafeMutableRawPointer) -> Void {
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ pointer: UnsafeMutableRawPointer
    ) -> Optional<Wrapped> {
        if isSome == 0 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftParameter(pointer)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_optional_heap_object")
        func _swift_js_return_optional_heap_object(_ isSome: Int32, _ pointer: UnsafeMutableRawPointer?)
        #else
        /// Write an optional Swift heap object to reserved storage to be returned to JavaScript
        func _swift_js_return_optional_heap_object(_ isSome: Int32, _ pointer: UnsafeMutableRawPointer?) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch consume self {
        case .none:
            _swift_js_return_optional_heap_object(0, nil)
        case .some(let value):
            let retainedPointer = value.bridgeJSLowerReturn()
            _swift_js_return_optional_heap_object(1, retainedPointer)
        }
    }
}
extension Optional where Wrapped == Float {
    // MARK: ImportTS

    @available(*, unavailable, message: "Optional Float type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {}

    @available(*, unavailable, message: "Optional Float type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ wrappedValue: Float32) -> Float? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float32) -> Float? {
        if isSome == 0 {
            return nil
        } else {
            return Float.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_optional_float")
        func _swift_js_return_optional_float(_ isSome: Int32, _ value: Float32)
        #else
        /// Sets the optional float for return value storage
        func _swift_js_return_optional_float(_ isSome: Int32, _ value: Float32) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch consume self {
        case .none:
            _swift_js_return_optional_float(0, 0.0)
        case .some(let value):
            _swift_js_return_optional_float(1, value.bridgeJSLowerReturn())
        }
    }
}

/// Optional support for Double
extension Optional where Wrapped == Double {
    // MARK: ImportTS

    @available(*, unavailable, message: "Optional Double type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {}

    @available(*, unavailable, message: "Optional Double type is not supported to be passed to imported JS functions")
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ wrappedValue: Float64) -> Double? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float64) -> Double? {
        if isSome == 0 {
            return nil
        } else {
            return Double.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_optional_double")
        func _swift_js_return_optional_double(_ isSome: Int32, _ value: Float64)
        #else
        /// Sets the optional double for return value storage
        func _swift_js_return_optional_double(_ isSome: Int32, _ value: Float64) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch consume self {
        case .none:
            _swift_js_return_optional_double(0, 0.0)
        case .some(let value):
            _swift_js_return_optional_double(1, value.bridgeJSLowerReturn())
        }
    }
}

/// Optional support for case enums
extension Optional where Wrapped: _BridgedSwiftCaseEnum {
    // MARK: ImportTS

    @available(
        *,
        unavailable,
        message: "Optional case enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {}

    @available(
        *,
        unavailable,
        message: "Optional case enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ wrappedValue: Int32) -> Wrapped? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Wrapped? {
        if isSome == 0 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_return_optional_int")
        func _swift_js_return_optional_int(_ isSome: Int32, _ value: Int32)
        #else
        /// Sets the optional int for return value storage
        func _swift_js_return_optional_int(_ isSome: Int32, _ value: Int32) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch consume self {
        case .none:
            _swift_js_return_optional_int(0, 0)
        case .some(let value):
            _swift_js_return_optional_int(1, value.bridgeJSLowerReturn())
        }
    }
}

public protocol _BridgedSwiftTypeLoweredIntoVoidType {
    // MARK: ExportSwift
    consuming func bridgeJSLowerReturn() -> Void
}

extension Optional where Wrapped: _BridgedSwiftTypeLoweredIntoVoidType {
    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        switch consume self {
        case .none:
            ()
        case .some(let value):
            value.bridgeJSLowerReturn()
        }
    }
}

// MARK: Optional Raw Value Enum Support

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == String {
    // MARK: ImportTS

    @available(
        *,
        unavailable,
        message: "Optional String raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {}

    @available(
        *,
        unavailable,
        message: "Optional String raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32) -> Wrapped? { return nil }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ bytes: Int32,
        _ count: Int32
    ) -> Wrapped? {
        let optionalRawValue = String?.bridgeJSLiftParameter(isSome, bytes, count)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: String? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Int {
    // MARK: ImportTS

    @available(
        *,
        unavailable,
        message: "Optional Int raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {}

    @available(
        *,
        unavailable,
        message: "Optional Int raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ wrappedValue: Int32) -> Wrapped? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Wrapped? {
        let optionalRawValue = Int?.bridgeJSLiftParameter(isSome, wrappedValue)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: Int? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Bool {
    // MARK: ImportTS

    @available(
        *,
        unavailable,
        message: "Optional Bool raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {}

    @available(
        *,
        unavailable,
        message: "Optional Bool raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ wrappedValue: Int32) -> Wrapped? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Wrapped? {
        let optionalRawValue = Bool?.bridgeJSLiftParameter(isSome, wrappedValue)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: Bool? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Float {
    // MARK: ImportTS

    @available(
        *,
        unavailable,
        message: "Optional Float raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {}

    @available(
        *,
        unavailable,
        message: "Optional Float raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ wrappedValue: Float32) -> Wrapped? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float32) -> Wrapped? {
        let optionalRawValue = Float?.bridgeJSLiftParameter(isSome, wrappedValue)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: Float? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Double {
    // MARK: ImportTS

    @available(
        *,
        unavailable,
        message: "Optional Double raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {}

    @available(
        *,
        unavailable,
        message: "Optional Double raw value enum types are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ wrappedValue: Float64) -> Wrapped? {
        return nil
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float64) -> Wrapped? {
        let optionalRawValue = Double?.bridgeJSLiftParameter(isSome, wrappedValue)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: Double? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

// MARK: Optional Associated Value Enum Support

extension Optional where Wrapped: _BridgedSwiftAssociatedValueEnum {
    // MARK: ImportTS
    @available(
        *,
        unavailable,
        message: "Optional associated value enums are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Void {
        fatalError("Optional associated value enum bridgeJSLowerParameter is not supported for ImportTS")
    }

    @available(
        *,
        unavailable,
        message: "Optional associated value enums are not supported to be passed to imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ isSome: Int32, _ caseId: Int32) -> Wrapped? { return nil }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ caseId: Int32) -> Wrapped? {
        if isSome == 0 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftParameter(caseId)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "bjs", name: "swift_js_push_tag")
        func _swift_js_push_tag(_ tag: Int32)
        #else
        func _swift_js_push_tag(_ tag: Int32) {
            _onlyAvailableOnWasm()
        }
        #endif

        switch consume self {
        case .none:
            _swift_js_push_tag(-1)  // Use -1 as sentinel for null
        case .some(let value):
            value.bridgeJSLowerReturn()
        }
    }
}
