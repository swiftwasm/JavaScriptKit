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

/// Releases a Swift closure from the FinalizationRegistry
///
/// This function is called by the BridgeJS code generator when a Swift closure is released.
/// The closure is released from the FinalizationRegistry so it can be garbage collected to
/// balance the
///
/// - Parameter pointer: The pointer to `_BridgeJSTypedClosureBox` instance
@_expose(wasm, "bjs_release_swift_closure")
public func _bjs_release_swift_closure(_ pointer: UnsafeMutableRawPointer) {
    Unmanaged<AnyObject>.fromOpaque(pointer).release()
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_closure_unregister")
internal func _swift_js_closure_unregister(_ id: Int32)
#else
/// Unregisters a Swift closure from the FinalizationRegistry
///
/// - Parameter id: The JavaScriptObjectRef of the JS closure object created by
///                 the BridgeJS's `make_swift_closure_{signature}` function.
///
/// - Note: This is a best-effort operation.
///         According to the ECMAScript specification, calling
///         `FinalizationRegistry.prototype.unregister` does not guarantee that
///         a finalization callback will be suppressed if the target object has
///         already been garbage-collected and cleanup has been scheduled.
///         This means that the finalization callback should be tolerant of the
///         object being already collected.
///         See: https://tc39.es/ecma262/multipage/managing-memory.html#sec-finalization-registry.prototype.unregister
internal func _swift_js_closure_unregister(_ id: Int32) {
    _onlyAvailableOnWasm()
}
#endif

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
//     @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> <#Self#> {
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
// - `func bridgeJSLiftParameter() -> <#TargetType#>`: no-arg overload that pops parameters from the param stack internally.
//   Note: Pop order must match Swift's left-to-right argument evaluation order.
// - `func bridgeJSLowerReturn() -> <#WasmCoreType#>`: lower the given higher-level return value to a Wasm core type
// - `func bridgeJSLowerStackReturn()`: push the value onto the return stack (used by _BridgedSwiftStackType for array elements)
//
// Optional types (ExportSwift only) additionally define:
// - `func bridgeJSLowerParameterWithRetain()`: lower optional heap object with ownership transfer for escaping closures
// - `func bridgeJSLiftReturnFromSideChannel()`: lift optional from side-channel storage for protocol property getters
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

public protocol _BridgedSwiftStackType {
    associatedtype StackLiftResult = Self
    static func bridgeJSLiftParameter() -> StackLiftResult
    consuming func bridgeJSLowerStackReturn()
}

/// Types that bridge with the same (isSome, value) ABI as Optional.
/// Used by JSUndefinedOr so all bridge methods delegate to Optional<Wrapped>.
public protocol _BridgedAsOptional {
    associatedtype Wrapped
    var asOptional: Wrapped? { get }
    init(optional: Wrapped?)
}

extension Bool: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType, _BridgedSwiftStackType {
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
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Bool {
        bridgeJSLiftParameter(_swift_js_pop_i32())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        self ? 1 : 0
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(self ? 1 : 0)
    }
}

extension Int: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType, _BridgedSwiftStackType {
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
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Int {
        bridgeJSLiftParameter(_swift_js_pop_i32())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        Int32(self)
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(Int32(self))
    }
}

extension UInt: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType, _BridgedSwiftStackType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        Int32(bitPattern: UInt32(self))
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> UInt {
        UInt(UInt32(bitPattern: value))
    }
    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> UInt {
        UInt(UInt32(bitPattern: value))
    }
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> UInt {
        bridgeJSLiftParameter(_swift_js_pop_i32())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        Int32(bitPattern: UInt32(self))
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(Int32(bitPattern: UInt32(self)))
    }
}

extension Int32: _BridgedSwiftStackType {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Int32 {
        _swift_js_pop_i32()
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(self)
    }
}

extension Int64: _BridgedSwiftStackType {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Int64 {
        Int64(_swift_js_pop_i32())
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(Int32(self))
    }
}

extension UInt32: _BridgedSwiftStackType {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> UInt32 {
        UInt32(bitPattern: _swift_js_pop_i32())
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(Int32(bitPattern: self))
    }
}

extension UInt64: _BridgedSwiftStackType {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> UInt64 {
        UInt64(UInt32(bitPattern: _swift_js_pop_i32()))
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(Int32(bitPattern: UInt32(self)))
    }
}

extension Float: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType, _BridgedSwiftStackType {
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
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Float {
        bridgeJSLiftParameter(_swift_js_pop_f32())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Float32 {
        Float32(self)
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_f32(Float32(self))
    }
}

extension Double: _BridgedSwiftTypeLoweredIntoSingleWasmCoreType, _BridgedSwiftStackType {
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
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Double {
        bridgeJSLiftParameter(_swift_js_pop_f64())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Float64 {
        Float64(self)
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_f64(Float64(self))
    }
}

extension String: _BridgedSwiftStackType {
    public typealias StackLiftResult = String

    // MARK: ImportTS

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Int32 {
        return self.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ bytesCount: Int32) -> String {
        #if !arch(wasm32)
        guard #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) else { _onlyAvailableOnWasm() }
        #endif
        return String(unsafeUninitializedCapacity: Int(bytesCount)) { b in
            _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(bytesCount))
            return Int(bytesCount)
        }
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ bytes: Int32, _ count: Int32) -> String {
        #if !arch(wasm32)
        guard #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) else { _onlyAvailableOnWasm() }
        #endif
        return String(unsafeUninitializedCapacity: Int(count)) { b in
            _swift_js_init_memory(bytes, b.baseAddress.unsafelyUnwrapped)
            return Int(count)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> String {
        let bytes = _swift_js_pop_i32()
        let count = _swift_js_pop_i32()
        return bridgeJSLiftParameter(bytes, count)
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        return self.withUTF8 { ptr in
            _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        self.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
    }
}

extension JSObject: _BridgedSwiftStackType {
    // JSObject is a non-final class, so we must explicitly specify the associated type
    // rather than relying on the default `Self` (which Swift requires for covariant returns).
    public typealias StackLiftResult = JSObject

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

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> JSObject {
        bridgeJSLiftParameter(_swift_js_pop_i32())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Int32 {
        return _swift_js_retain(Int32(bitPattern: self.id))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(bridgeJSLowerReturn())
    }
}

extension JSValue: _BridgedSwiftStackType {
    public typealias StackLiftResult = JSValue

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (kind: Int32, payload1: Int32, payload2: Double) {
        return withRawJSValue { raw in
            (
                kind: Int32(raw.kind.rawValue),
                payload1: Int32(bitPattern: raw.payload1),
                payload2: raw.payload2
            )
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(
        _ kind: Int32,
        _ payload1: Int32,
        _ payload2: Double
    ) -> JSValue {
        return bridgeJSLiftParameter(kind, payload1, payload2)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ kind: Int32,
        _ payload1: Int32,
        _ payload2: Double
    ) -> JSValue {
        let retainedPayload1: Int32
        if let kindEnum = JavaScriptValueKind(rawValue: UInt32(kind)) {
            switch kindEnum {
            case .string, .object, .symbol, .bigInt:
                retainedPayload1 = _swift_js_retain(payload1)
            default:
                retainedPayload1 = payload1
            }
        } else {
            retainedPayload1 = payload1
        }

        guard let kindEnum = JavaScriptValueKind(rawValue: UInt32(kind)) else {
            fatalError("Invalid JSValue kind: \(kind)")
        }
        let rawValue = RawJSValue(
            kind: kindEnum,
            payload1: JavaScriptPayload1(UInt32(bitPattern: retainedPayload1)),
            payload2: payload2
        )
        return rawValue.jsValue
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> JSValue {
        let payload2 = _swift_js_pop_f64()
        let payload1 = _swift_js_pop_i32()
        let kind = _swift_js_pop_i32()
        return bridgeJSLiftParameter(kind, payload1, payload2)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn() -> JSValue {
        let payload2 = _swift_js_pop_f64()
        let payload1 = _swift_js_pop_i32()
        let kind = _swift_js_pop_i32()
        return bridgeJSLiftParameter(kind, payload1, payload2)
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let lowered = bridgeJSLowerParameter()
        let retainedPayload1: Int32
        if let kind = JavaScriptValueKind(rawValue: UInt32(lowered.kind)) {
            switch kind {
            case .string, .object, .symbol, .bigInt:
                retainedPayload1 = _swift_js_retain(lowered.payload1)
            default:
                retainedPayload1 = lowered.payload1
            }
        } else {
            retainedPayload1 = lowered.payload1
        }
        _swift_js_push_i32(lowered.kind)
        _swift_js_push_i32(retainedPayload1)
        _swift_js_push_f64(lowered.payload2)
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        bridgeJSLowerReturn()
    }
}

/// A protocol that Swift heap objects exposed to JavaScript via `@JS class` must conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftHeapObject: AnyObject, _BridgedSwiftStackType {}

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
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        bridgeJSLiftParameter(_swift_js_pop_pointer())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> UnsafeMutableRawPointer {
        // Perform a manual retain on the object, which will be balanced by a release called via FinalizationRegistry
        return Unmanaged.passRetained(self).toOpaque()
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_pointer(Unmanaged.passRetained(self).toOpaque())
    }
}
// MARK: Closure Box Protocol

/// A protocol that Swift closure box types must conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
@_spi(BridgeJS) public protocol _BridgedSwiftClosureBox: AnyObject {}

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
public protocol _BridgedSwiftProtocolWrapper: _BridgedSwiftStackType {
    var jsObject: JSObject { get }
    static func bridgeJSLiftParameter(_ value: Int32) -> Self
}

extension _BridgedSwiftProtocolWrapper {
    // MARK: ExportSwift
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        bridgeJSLiftParameter(_swift_js_pop_i32())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Int32 {
        jsObject.bridgeJSLowerReturn()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(jsObject.bridgeJSLowerReturn())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Int32 {
        jsObject.bridgeJSLowerParameter()
    }
}

/// A protocol that Swift enum types that do not have a payload can conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftEnumNoPayload {}

/// A protocol for raw value enums that enables automatic stack operations.
///
/// Conforming to this protocol provides default implementations of `_BridgedSwiftStackType`
/// methods by delegating to the raw value's stack operations. The raw value type must itself
/// conform to `_BridgedSwiftStackType`.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftRawValueEnum: _BridgedSwiftStackType, RawRepresentable
where RawValue: _BridgedSwiftStackType, RawValue.StackLiftResult == RawValue {}

extension _BridgedSwiftRawValueEnum {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(rawValue: RawValue.bridgeJSLiftParameter())!
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        rawValue.bridgeJSLowerStackReturn()
    }
}

/// A protocol that Swift case enum types (enums without raw values or associated values) conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftCaseEnum: _BridgedSwiftStackType {
    // MARK: ImportTS
    @_spi(BridgeJS) consuming func bridgeJSLowerParameter() -> Int32
    @_spi(BridgeJS) static func bridgeJSLiftReturn(_ value: Int32) -> Self

    // MARK: ExportSwift
    @_spi(BridgeJS) static func bridgeJSLiftParameter(_ value: Int32) -> Self
    @_spi(BridgeJS) consuming func bridgeJSLowerReturn() -> Int32
}

extension _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        bridgeJSLiftParameter(_swift_js_pop_i32())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_i32(bridgeJSLowerReturn())
    }
}

/// A protocol that Swift associated value enum types conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftAssociatedValueEnum: _BridgedSwiftTypeLoweredIntoVoidType, _BridgedSwiftStackType {
    // MARK: ImportTS
    @_spi(BridgeJS) consuming func bridgeJSLowerParameter() -> Int32
    @_spi(BridgeJS) static func bridgeJSLiftReturn(_ caseId: Int32) -> Self

    // MARK: ExportSwift
    @_spi(BridgeJS) static func bridgeJSLiftParameter(_ caseId: Int32) -> Self
    @_spi(BridgeJS) consuming func bridgeJSLowerReturn() -> Void
}

extension _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        bridgeJSLiftParameter(_swift_js_pop_i32())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        bridgeJSLowerReturn()
    }
}

/// A protocol that Swift struct types conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftStruct: _BridgedSwiftTypeLoweredIntoVoidType, _BridgedSwiftGenericOptionalStackType {
    // MARK: ExportSwift
    @_spi(BridgeJS) static func bridgeJSLiftParameter() -> Self
    @_spi(BridgeJS) consuming func bridgeJSLowerReturn() -> Void

    /// Initializes a Swift struct by copying the fields from a bridged JS object.
    init(unsafelyCopying jsObject: JSObject)
    /// Converts the struct into a bridged JS object by copying its fields.
    func toJSObject() -> JSObject
}

extension _BridgedSwiftStruct {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Int32 {
        return toJSObject().bridgeJSLowerReturn()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ objectId: Int32) -> Self {
        let jsObject = JSObject.bridgeJSLiftReturn(objectId)
        return Self(unsafelyCopying: jsObject)
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        bridgeJSLowerReturn()
    }
}

extension _BridgedSwiftEnumNoPayload where Self: RawRepresentable, RawValue == String {
    // MARK: ImportTS
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Int32 { rawValue.bridgeJSLowerParameter() }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ id: Int32) -> Self {
        Self(rawValue: .bridgeJSLiftReturn(id))!
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
@_extern(wasm, module: "bjs", name: "swift_js_push_i32")
@_spi(BridgeJS) public func _swift_js_push_i32(_ value: Int32)
#else
@_spi(BridgeJS) public func _swift_js_push_i32(_ value: Int32) {
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
@_extern(wasm, module: "bjs", name: "swift_js_pop_i32")
@_spi(BridgeJS) public func _swift_js_pop_i32() -> Int32
#else
@_spi(BridgeJS) public func _swift_js_pop_i32() -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_pop_f32")
@_spi(BridgeJS) public func _swift_js_pop_f32() -> Float32
#else
@_spi(BridgeJS) public func _swift_js_pop_f32() -> Float32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_pop_f64")
@_spi(BridgeJS) public func _swift_js_pop_f64() -> Float64
#else
@_spi(BridgeJS) public func _swift_js_pop_f64() -> Float64 {
    _onlyAvailableOnWasm()
}
#endif

// MARK: Struct bridging helpers (JS-side lowering/raising)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_cleanup")
@_spi(BridgeJS) public func _swift_js_struct_cleanup(_ cleanupId: Int32)
#else
@_spi(BridgeJS) public func _swift_js_struct_cleanup(_ cleanupId: Int32) {
    _onlyAvailableOnWasm()
}
#endif

// MARK: Wasm externs used by type lowering/lifting

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_make_js_string")
func _swift_js_make_js_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32
#else
/// Creates a JavaScript string from UTF-8 data in WebAssembly memory
func _swift_js_make_js_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_init_memory_with_result")
func _swift_js_init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
#else
/// Initializes WebAssembly memory with result data of JavaScript function call
func _swift_js_init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_string")
func _swift_js_return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
#else
/// Write a string to reserved string storage to be returned to JavaScript
func _swift_js_return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
    _onlyAvailableOnWasm()
}
#endif

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

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_optional_bool")
func _swift_js_return_optional_bool(_ isSome: Int32, _ value: Int32)
#else
/// Sets the optional bool for return value storage
func _swift_js_return_optional_bool(_ isSome: Int32, _ value: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_get_optional_int_presence")
func _swift_js_get_optional_int_presence() -> Int32
#else
func _swift_js_get_optional_int_presence() -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_get_optional_int_value")
func _swift_js_get_optional_int_value() -> Int32
#else
func _swift_js_get_optional_int_value() -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_optional_int")
func _swift_js_return_optional_int(_ isSome: Int32, _ value: Int32)
#else
/// Sets the optional int for return value storage
func _swift_js_return_optional_int(_ isSome: Int32, _ value: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_get_optional_string")
func _swift_js_get_optional_string() -> Int32
#else
func _swift_js_get_optional_string() -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_optional_string")
func _swift_js_return_optional_string(_ isSome: Int32, _ ptr: UnsafePointer<UInt8>?, _ len: Int32)
#else
/// Write an optional string to reserved string storage to be returned to JavaScript
func _swift_js_return_optional_string(_ isSome: Int32, _ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_optional_object")
func _swift_js_return_optional_object(_ isSome: Int32, _ objectId: Int32)
#else
/// Write an optional JSObject to reserved storage to be returned to JavaScript
func _swift_js_return_optional_object(_ isSome: Int32, _ objectId: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_get_optional_heap_object_pointer")
func _swift_js_get_optional_heap_object_pointer() -> UnsafeMutableRawPointer
#else
func _swift_js_get_optional_heap_object_pointer() -> UnsafeMutableRawPointer {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_optional_heap_object")
func _swift_js_return_optional_heap_object(_ isSome: Int32, _ pointer: UnsafeMutableRawPointer?)
#else
/// Write an optional Swift heap object to reserved storage to be returned to JavaScript
func _swift_js_return_optional_heap_object(_ isSome: Int32, _ pointer: UnsafeMutableRawPointer?) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_get_optional_float_presence")
func _swift_js_get_optional_float_presence() -> Int32
#else
func _swift_js_get_optional_float_presence() -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_get_optional_float_value")
func _swift_js_get_optional_float_value() -> Float32
#else
func _swift_js_get_optional_float_value() -> Float32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_optional_float")
func _swift_js_return_optional_float(_ isSome: Int32, _ value: Float32)
#else
/// Sets the optional float for return value storage
func _swift_js_return_optional_float(_ isSome: Int32, _ value: Float32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_get_optional_double_presence")
func _swift_js_get_optional_double_presence() -> Int32
#else
func _swift_js_get_optional_double_presence() -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_get_optional_double_value")
func _swift_js_get_optional_double_value() -> Float64
#else
func _swift_js_get_optional_double_value() -> Float64 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_optional_double")
func _swift_js_return_optional_double(_ isSome: Int32, _ value: Float64)
#else
/// Sets the optional double for return value storage
func _swift_js_return_optional_double(_ isSome: Int32, _ value: Float64) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_push_pointer")
@_spi(BridgeJS) public func _swift_js_push_pointer(_ pointer: UnsafeMutableRawPointer)
#else
@_spi(BridgeJS) public func _swift_js_push_pointer(_ pointer: UnsafeMutableRawPointer) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_pop_pointer")
private func _swift_js_pop_pointer_extern() -> UnsafeMutableRawPointer
#else
private func _swift_js_pop_pointer_extern() -> UnsafeMutableRawPointer {
    _onlyAvailableOnWasm()
}
#endif

@_spi(BridgeJS) @inline(never) public func _swift_js_pop_pointer() -> UnsafeMutableRawPointer {
    _swift_js_pop_pointer_extern()
}

// MARK: - UnsafePointer family

extension UnsafeMutableRawPointer: _BridgedSwiftStackType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> UnsafeMutableRawPointer { self }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(
        _ pointer: UnsafeMutableRawPointer
    )
        -> UnsafeMutableRawPointer
    {
        pointer
    }

    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(
        _ pointer: UnsafeMutableRawPointer
    )
        -> UnsafeMutableRawPointer
    {
        pointer
    }
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> UnsafeMutableRawPointer {
        bridgeJSLiftParameter(_swift_js_pop_pointer())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> UnsafeMutableRawPointer { self }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_pointer(self)
    }
}

extension UnsafeRawPointer: _BridgedSwiftStackType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(mutating: self)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(
        _ pointer: UnsafeMutableRawPointer
    )
        -> UnsafeRawPointer
    {
        UnsafeRawPointer(pointer)
    }

    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(
        _ pointer: UnsafeMutableRawPointer
    )
        -> UnsafeRawPointer
    {
        UnsafeRawPointer(pointer)
    }
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> UnsafeRawPointer {
        bridgeJSLiftParameter(_swift_js_pop_pointer())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> UnsafeMutableRawPointer {
        bridgeJSLowerParameter()
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_pointer(UnsafeMutableRawPointer(mutating: self))
    }
}

extension OpaquePointer: _BridgedSwiftStackType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(mutating: UnsafeRawPointer(self))
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(
        _ pointer: UnsafeMutableRawPointer
    )
        -> OpaquePointer
    {
        OpaquePointer(UnsafeRawPointer(pointer))
    }

    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(
        _ pointer: UnsafeMutableRawPointer
    )
        -> OpaquePointer
    {
        OpaquePointer(UnsafeRawPointer(pointer))
    }
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> OpaquePointer {
        bridgeJSLiftParameter(_swift_js_pop_pointer())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> UnsafeMutableRawPointer {
        bridgeJSLowerParameter()
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_pointer(UnsafeMutableRawPointer(mutating: UnsafeRawPointer(self)))
    }
}

extension UnsafePointer: _BridgedSwiftStackType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(mutating: UnsafeRawPointer(self))
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(
        _ pointer: UnsafeMutableRawPointer
    )
        -> UnsafePointer<Pointee>
    {
        UnsafeRawPointer(pointer).assumingMemoryBound(to: Pointee.self)
    }

    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(
        _ pointer: UnsafeMutableRawPointer
    )
        -> UnsafePointer<Pointee>
    {
        UnsafeRawPointer(pointer).assumingMemoryBound(to: Pointee.self)
    }
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> UnsafePointer<Pointee> {
        bridgeJSLiftParameter(_swift_js_pop_pointer())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> UnsafeMutableRawPointer {
        bridgeJSLowerParameter()
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_pointer(bridgeJSLowerParameter())
    }
}

extension UnsafeMutablePointer: _BridgedSwiftStackType {
    // MARK: ImportTS
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(self)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(
        _ pointer: UnsafeMutableRawPointer
    )
        -> UnsafeMutablePointer<Pointee>
    {
        pointer.assumingMemoryBound(to: Pointee.self)
    }

    // MARK: ExportSwift
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(
        _ pointer: UnsafeMutableRawPointer
    )
        -> UnsafeMutablePointer<Pointee>
    {
        pointer.assumingMemoryBound(to: Pointee.self)
    }
    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> UnsafeMutablePointer<Pointee> {
        bridgeJSLiftParameter(_swift_js_pop_pointer())
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> UnsafeMutableRawPointer {
        bridgeJSLowerParameter()
    }
    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        _swift_js_push_pointer(bridgeJSLowerParameter())
    }
}

// Optional support for JSTypedClosure
extension Optional {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter<Signature>() -> (
        isSome: Int32, value: Int32
    ) where Wrapped == JSTypedClosure<Signature> {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0)
        case .some(let wrapped):
            // Use return lowering to retain the JS function so JS lifting can fetch it from the heap.
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }
}

extension Optional where Wrapped == Bool {
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Int32
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Bool? {
        if isSome == 0 {
            return nil
        } else {
            return Bool.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Bool? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ value: Int32) -> Bool? {
        switch value {
        case -1:
            return nil
        case 0:
            return false
        case 1:
            return true
        default:
            return nil  // Treat invalid values as null
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        switch consume self {
        case .none:
            _swift_js_return_optional_bool(0, 0)
        case .some(let value):
            _swift_js_return_optional_bool(1, value.bridgeJSLowerReturn())
        }
    }
}

extension Optional where Wrapped == Int {
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Int32
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Int? {
        if isSome == 0 {
            return nil
        } else {
            return Int.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Int? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Int? {
        let isSome = _swift_js_get_optional_int_presence()
        if isSome == 0 {
            return nil
        } else {
            return Int.bridgeJSLiftReturn(_swift_js_get_optional_int_value())
        }
    }

    @_spi(BridgeJS) public func bridgeJSLowerReturn() -> Void {
        switch self {
        case .none:
            _swift_js_return_optional_int(0, 0)
        case .some(let value):
            _swift_js_return_optional_int(1, value.bridgeJSLowerReturn())
        }
    }
}

extension Optional where Wrapped == UInt {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Int32
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> UInt? {
        if isSome == 0 {
            return nil
        } else {
            return UInt.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> UInt? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> UInt? {
        let isSome = _swift_js_get_optional_int_presence()
        if isSome == 0 {
            return nil
        } else {
            return UInt.bridgeJSLiftReturn(_swift_js_get_optional_int_value())
        }
    }

    @_spi(BridgeJS) public func bridgeJSLowerReturn() -> Void {
        switch self {
        case .none:
            _swift_js_return_optional_int(0, 0)
        case .some(let value):
            _swift_js_return_optional_int(1, value.bridgeJSLowerReturn())
        }
    }
}
extension Optional where Wrapped == String {
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Int32
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ bytes: Int32, _ count: Int32) -> String?
    {
        if isSome == 0 {
            return nil
        } else {
            return String.bridgeJSLiftParameter(bytes, count)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> String? {
        let isSome = _swift_js_pop_i32()
        let bytes = _swift_js_pop_i32()
        let count = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, bytes, count)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> String? {
        let length = _swift_js_get_optional_string()
        if length < 0 {
            return nil
        } else {
            return String.bridgeJSLiftReturn(length)
        }
    }

    @_spi(BridgeJS) public func bridgeJSLowerReturn() -> Void {
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
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Int32
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ objectId: Int32) -> JSObject? {
        if isSome == 0 {
            return nil
        } else {
            return JSObject.bridgeJSLiftParameter(objectId)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> JSObject? {
        let isSome = _swift_js_pop_i32()
        let objectId = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, objectId)
    }

    @_spi(BridgeJS) public func bridgeJSLowerReturn() -> Void {
        switch self {
        case .none:
            _swift_js_return_optional_object(0, 0)
        case .some(let value):
            let retainedId = value.bridgeJSLowerReturn()
            _swift_js_return_optional_object(1, retainedId)
        }
    }
}

extension Optional where Wrapped == JSValue {
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, kind: Int32, payload1: Int32, payload2: Double
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, kind: 0, payload1: 0, payload2: 0)
        case .some(let wrapped):
            let lowered = wrapped.bridgeJSLowerParameter()
            return (
                isSome: 1,
                kind: lowered.kind,
                payload1: lowered.payload1,
                payload2: lowered.payload2
            )
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ kind: Int32,
        _ payload1: Int32,
        _ payload2: Double
    ) -> JSValue? {
        if isSome == 0 {
            return nil
        } else {
            return JSValue.bridgeJSLiftParameter(kind, payload1, payload2)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> JSValue? {
        let isSome = _swift_js_pop_i32()
        if isSome == 0 {
            return nil
        }
        let payload2 = _swift_js_pop_f64()
        let payload1 = _swift_js_pop_i32()
        let kind = _swift_js_pop_i32()
        return JSValue.bridgeJSLiftParameter(kind, payload1, payload2)
    }

    @_spi(BridgeJS) public func bridgeJSLowerReturn() -> Void {
        switch self {
        case .none:
            _swift_js_push_i32(0)
        case .some(let value):
            value.bridgeJSLowerReturn()
            _swift_js_push_i32(1)
        }
    }
}

extension Optional where Wrapped == [JSValue] {
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch consume self {
        case .none:
            return 0
        case .some(let array):
            array.bridgeJSLowerReturn()
            return 1
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32) -> [JSValue]? {
        if isSome == 0 {
            return nil
        }
        return [JSValue].bridgeJSLiftParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn() -> [JSValue]? {
        let isSome = _swift_js_pop_i32()
        if isSome == 0 {
            return nil
        }
        return [JSValue].bridgeJSLiftReturn()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        switch consume self {
        case .none:
            _swift_js_push_i32(0)
        case .some(let array):
            array.bridgeJSLowerReturn()
            _swift_js_push_i32(1)
        }
    }
}

extension Optional where Wrapped: _BridgedSwiftProtocolWrapper {
    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ objectId: Int32) -> Wrapped? {
        if isSome == 0 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftParameter(objectId)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        switch consume self {
        case .none:
            _swift_js_return_optional_object(0, 0)
        case .some(let wrapper):
            let retainedId: Int32 = wrapper.bridgeJSLowerReturn()
            _swift_js_return_optional_object(1, retainedId)
        }
    }
}

/// Optional support for Swift heap objects
extension Optional where Wrapped: _BridgedSwiftHeapObject {
    // MARK: ExportSwift
    /// Lowers optional Swift heap object as (isSome, pointer) tuple for protocol parameters.
    ///
    /// This method uses `passUnretained()` because the caller (JavaScript protocol implementation)
    /// already owns the object and will not retain it. The pointer is only valid for the
    /// duration of the call.
    ///
    /// - Returns: A tuple containing presence flag (0 for nil, 1 for some) and unretained pointer
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, pointer: UnsafeMutableRawPointer
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, pointer: UnsafeMutableRawPointer(bitPattern: 1)!)
        case .some(let value):
            return (isSome: 1, pointer: value.bridgeJSLowerParameter())
        }
    }

    /// Lowers optional Swift heap object with ownership transfer for escaping closures.
    ///
    /// This method uses `passRetained()` to transfer ownership to JavaScript, ensuring the
    /// object remains valid even if the JavaScript closure escapes and stores the parameter.
    /// JavaScript must wrap the pointer with `__construct()` to create a managed reference
    /// that will be cleaned up via FinalizationRegistry.
    ///
    /// - Returns: A tuple containing presence flag (0 for nil, 1 for some) and retained pointer
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameterWithRetain() -> (
        isSome: Int32, pointer: UnsafeMutableRawPointer
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, pointer: UnsafeMutableRawPointer(bitPattern: 1)!)
        case .some(let value):
            return (isSome: 1, pointer: Unmanaged.passRetained(value).toOpaque())
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ pointer: UnsafeMutableRawPointer) -> Wrapped?
    {
        if pointer == UnsafeMutableRawPointer(bitPattern: 0) {
            return nil
        } else {
            return Wrapped.bridgeJSLiftReturn(pointer)
        }
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

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Wrapped? {
        let isSome = _swift_js_pop_i32()
        let pointer = _swift_js_pop_pointer()
        return bridgeJSLiftParameter(isSome, pointer)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Wrapped? {
        let pointer = _swift_js_get_optional_heap_object_pointer()
        if pointer == UnsafeMutableRawPointer(bitPattern: 0) {
            return nil
        } else {
            return Wrapped.bridgeJSLiftReturn(pointer)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        switch consume self {
        case .none:
            _swift_js_return_optional_heap_object(0, nil)
        case .some(let value):
            let retainedPointer: UnsafeMutableRawPointer = value.bridgeJSLowerReturn()
            _swift_js_return_optional_heap_object(1, retainedPointer)
        }
    }
}
extension Optional where Wrapped == Float {
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Float32
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0.0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float32) -> Float? {
        if isSome == 0 {
            return nil
        } else {
            return Float.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Float? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_f32()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Float? {
        let isSome = _swift_js_get_optional_float_presence()
        if isSome == 0 {
            return nil
        } else {
            return Float.bridgeJSLiftReturn(_swift_js_get_optional_float_value())
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
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
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Float64
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0.0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float64) -> Double? {
        if isSome == 0 {
            return nil
        } else {
            return Double.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Double? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_f64()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Double? {
        let isSome = _swift_js_get_optional_double_presence()
        if isSome == 0 {
            return nil
        } else {
            return Double.bridgeJSLiftReturn(_swift_js_get_optional_double_value())
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
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
    // MARK: ExportSwift

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0)
        case .some(let value):
            return (isSome: 1, value: value.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Wrapped? {
        if isSome == 0 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftParameter(wrappedValue)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Wrapped? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ value: Int32) -> Wrapped? {
        if value == -1 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftReturn(value)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
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

// MARK: Optional Raw Value Enum Support

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == String {
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Int32
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ bytes: Int32,
        _ count: Int32
    ) -> Wrapped? {
        let optionalRawValue = String?.bridgeJSLiftParameter(isSome, bytes, count)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Wrapped? {
        let isSome = _swift_js_pop_i32()
        let bytes = _swift_js_pop_i32()
        let count = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, bytes, count)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Wrapped? {
        let length = _swift_js_get_optional_string()
        if length < 0 {
            return nil
        } else {
            let rawValue = String.bridgeJSLiftReturn(length)
            return Wrapped(rawValue: rawValue)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: String? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Int {
    // MARK: ExportSwift
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0)
        case .some(let value):
            return (isSome: 1, value: value.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Wrapped? {
        let optionalRawValue = Int?.bridgeJSLiftParameter(isSome, wrappedValue)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Wrapped? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Wrapped? {
        let isSome = _swift_js_get_optional_int_presence()
        if isSome == 0 {
            return nil
        } else {
            let rawValue = _swift_js_get_optional_int_value()
            return Wrapped(rawValue: Int(rawValue))
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: Int? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Bool {
    // MARK: ExportSwift

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Wrapped? {
        let optionalRawValue = Bool?.bridgeJSLiftParameter(isSome, wrappedValue)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Wrapped? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: Bool? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Float {
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Float32
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0.0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float32) -> Wrapped? {
        let optionalRawValue = Float?.bridgeJSLiftParameter(isSome, wrappedValue)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Wrapped? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_f32()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Wrapped? {
        let isSome = _swift_js_get_optional_float_presence()
        if isSome == 0 {
            return nil
        } else {
            let rawValue = _swift_js_get_optional_float_value()
            return Wrapped(rawValue: Float(rawValue))
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: Float? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

extension Optional where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Double {
    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> (
        isSome: Int32, value: Float64
    ) {
        switch consume self {
        case .none:
            return (isSome: 0, value: 0.0)
        case .some(let wrapped):
            return (isSome: 1, value: wrapped.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float64) -> Wrapped? {
        let optionalRawValue = Double?.bridgeJSLiftParameter(isSome, wrappedValue)
        return optionalRawValue.flatMap { Wrapped(rawValue: $0) }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Wrapped? {
        let isSome = _swift_js_pop_i32()
        let wrappedValue = _swift_js_pop_f64()
        return bridgeJSLiftParameter(isSome, wrappedValue)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Wrapped? {
        let isSome = _swift_js_get_optional_double_presence()
        if isSome == 0 {
            return nil
        } else {
            let rawValue = _swift_js_get_optional_double_value()
            return Wrapped(rawValue: Double(rawValue))
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        let optionalRawValue: Double? = self?.rawValue
        optionalRawValue.bridgeJSLowerReturn()
    }
}

// MARK: Optional Associated Value Enum Support

extension Optional where Wrapped: _BridgedSwiftAssociatedValueEnum {
    // MARK: ExportSwift

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, caseId: Int32) {
        switch consume self {
        case .none:
            return (isSome: 0, caseId: 0)
        case .some(let value):
            return (isSome: 1, caseId: value.bridgeJSLowerParameter())
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ caseId: Int32) -> Wrapped? {
        if isSome == 0 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftParameter(caseId)
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Wrapped? {
        let isSome = _swift_js_pop_i32()
        let caseId = _swift_js_pop_i32()
        return bridgeJSLiftParameter(isSome, caseId)
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ caseId: Int32) -> Wrapped? {
        if caseId == -1 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftReturn(caseId)
        }
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        switch consume self {
        case .none:
            _swift_js_push_tag(-1)  // Use -1 as sentinel for null
        case .some(let value):
            value.bridgeJSLowerReturn()
        }
    }
}

// MARK: Optional Struct Support

extension Optional where Wrapped: _BridgedSwiftStruct {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32) -> Wrapped? {
        if isSome == 0 {
            return nil
        } else {
            return Wrapped.bridgeJSLiftParameter()
        }
    }
}

// MARK: - Generic Optional Stack Support

/// Marker protocol for types whose Optional wrapper should use the generic
/// stack-based ABI (`_BridgedSwiftStackType`).  Only Array, Dictionary, and
/// `_BridgedSwiftStruct` conform. Primitives and other types keep their
/// own type-specific Optional extensions.
public protocol _BridgedSwiftGenericOptionalStackType: _BridgedSwiftStackType
where StackLiftResult == Self {}

extension Optional: _BridgedSwiftStackType
where Wrapped: _BridgedSwiftGenericOptionalStackType {
    public typealias StackLiftResult = Wrapped?

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Wrapped? {
        let isSome = _swift_js_pop_i32()
        if isSome == 0 {
            return nil
        }
        return Wrapped.bridgeJSLiftParameter()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        bridgeJSLowerReturn()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        switch consume self {
        case .none:
            _swift_js_push_i32(0)
        case .some(let value):
            value.bridgeJSLowerStackReturn()
            _swift_js_push_i32(1)
        }
    }
}

// MARK: - _BridgedAsOptional (JSUndefinedOr) delegating to Optional<Wrapped>

extension _BridgedAsOptional where Wrapped == Bool {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ value: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturn(value))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped == Int {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped == UInt {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped == String {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ bytes: Int32,
        _ count: Int32
    ) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, bytes, count))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped == JSObject {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ objectId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, objectId))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped: _BridgedSwiftProtocolWrapper {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ objectId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, objectId))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped: _BridgedSwiftHeapObject {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, pointer: UnsafeMutableRawPointer)
    {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameterWithRetain() -> (
        isSome: Int32, pointer: UnsafeMutableRawPointer
    ) {
        asOptional.bridgeJSLowerParameterWithRetain()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ pointer: UnsafeMutableRawPointer
    ) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, pointer))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped == Float {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Float32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped == Double {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Float64) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float64) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ caseId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, caseId))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ caseId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturn(caseId))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional
where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == String {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ bytes: Int32,
        _ count: Int32
    ) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, bytes, count))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional
where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Int {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional
where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Bool {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional
where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Float {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Float32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional
where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Double {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Float64) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float64) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, caseId: Int32) {
        asOptional.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ caseId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, caseId))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ caseId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturn(caseId))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

extension _BridgedAsOptional where Wrapped: _BridgedSwiftStruct {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}

// MARK: - Array Support

extension Array: _BridgedSwiftGenericOptionalStackType
where Element: _BridgedSwiftStackType, Element.StackLiftResult == Element {}
extension Array: _BridgedSwiftStackType where Element: _BridgedSwiftStackType, Element.StackLiftResult == Element {
    public typealias StackLiftResult = [Element]

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> [Element] {
        let count = Int(_swift_js_pop_i32())
        var result: [Element] = []
        result.reserveCapacity(count)
        for _ in 0..<count {
            result.append(Element.bridgeJSLiftParameter())
        }
        result.reverse()
        return result
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn() -> [Element] {
        bridgeJSLiftParameter()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        bridgeJSLowerReturn()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() {
        let array = self
        for elem in array {
            elem.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(Int32(array.count))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() {
        bridgeJSLowerReturn()
    }
}

// MARK: - Dictionary Support

public protocol _BridgedSwiftDictionaryStackType: _BridgedSwiftTypeLoweredIntoVoidType,
    _BridgedSwiftGenericOptionalStackType
{
    associatedtype DictionaryValue: _BridgedSwiftStackType
    where DictionaryValue.StackLiftResult == DictionaryValue
}

extension Dictionary: _BridgedSwiftGenericOptionalStackType
where Key == String, Value: _BridgedSwiftStackType, Value.StackLiftResult == Value {}
extension Dictionary: _BridgedSwiftStackType
where Key == String, Value: _BridgedSwiftStackType, Value.StackLiftResult == Value {
    public typealias StackLiftResult = [String: Value]
    // Lowering/return use stack-based encoding, so dictionary also behaves like a void-lowered type.
    // Optional/JSUndefinedOr wrappers rely on this conformance to push an isSome flag and
    // then delegate to the stack-based lowering defined below.
    // swiftlint:disable:next type_name
}

extension Dictionary: _BridgedSwiftTypeLoweredIntoVoidType, _BridgedSwiftDictionaryStackType
where Key == String, Value: _BridgedSwiftStackType, Value.StackLiftResult == Value {
    public typealias DictionaryValue = Value

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> [String: Value] {
        let count = Int(_swift_js_pop_i32())
        var result: [String: Value] = [:]
        result.reserveCapacity(count)
        for _ in 0..<count {
            let value = Value.bridgeJSLiftParameter()
            let key = String.bridgeJSLiftParameter()
            result[key] = value
        }
        return result
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn() -> [String: Value] {
        bridgeJSLiftParameter()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerStackReturn() {
        bridgeJSLowerReturn()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() {
        let count = Int32(self.count)
        for (key, value) in self {
            key.bridgeJSLowerStackReturn()
            value.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(count)
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() {
        bridgeJSLowerReturn()
    }
}

extension Optional where Wrapped: _BridgedSwiftDictionaryStackType {
    typealias DictionaryValue = Wrapped.DictionaryValue

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Int32 {
        switch consume self {
        case .none:
            return 0
        case .some(let dict):
            dict.bridgeJSLowerReturn()
            return 1
        }
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32) -> [String: Wrapped.DictionaryValue]? {
        if isSome == 0 {
            return nil
        }
        return Dictionary<String, Wrapped.DictionaryValue>.bridgeJSLiftParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn() -> [String: Wrapped.DictionaryValue]? {
        let isSome = _swift_js_pop_i32()
        if isSome == 0 {
            return nil
        }
        return Dictionary<String, Wrapped.DictionaryValue>.bridgeJSLiftParameter()
    }
}

extension _BridgedAsOptional where Wrapped: _BridgedSwiftDictionaryStackType {
    typealias DictionaryValue = Wrapped.DictionaryValue

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> Int32 {
        let opt = asOptional
        if let dict = opt {
            dict.bridgeJSLowerReturn()
            return 1
        }
        return 0
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn() -> Self {
        let isSome = _swift_js_pop_i32()
        if isSome == 0 {
            return Self(optional: nil)
        }
        let value = Dictionary<String, Wrapped.DictionaryValue>.bridgeJSLiftParameter() as! Wrapped
        return Self(optional: value)
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        asOptional.bridgeJSLowerReturn()
    }
}
