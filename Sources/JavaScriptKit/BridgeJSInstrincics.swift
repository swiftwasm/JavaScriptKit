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
    @available(*, unavailable, message: "Swift heap objects are not supported to be passed to imported JS functions")
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Void {}
    @available(
        *,
        unavailable,
        message: "Swift heap objects are not supported to be returned from imported JS functions"
    )
    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ pointer: UnsafeMutableRawPointer) -> Void {}

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

/// A protocol that Swift enum types that do not have a payload can conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _BridgedSwiftEnumNoPayload {}

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

// MARK: Enum binary helpers

@_spi(BridgeJS) public enum _BJSParamType: UInt8 {
    case string = 1
    case int32 = 2
    case bool = 3
    case float32 = 4
    case float64 = 5
}

@_spi(BridgeJS) public struct _BJSBinaryReader {
    public let raw: UnsafeRawBufferPointer
    public var offset: Int = 0

    public init(raw: UnsafeRawBufferPointer) {
        self.raw = raw
    }

    @inline(__always)
    public mutating func readUInt8() -> UInt8 {
        let b = raw[offset]
        offset += 1
        return b
    }

    @inline(__always)
    public mutating func readUInt32() -> UInt32 {
        var v = UInt32(0)
        withUnsafeMutableBytes(of: &v) { dst in
            dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 4)]))
        }
        offset += 4
        return UInt32(littleEndian: v)
    }

    @inline(__always)
    public mutating func readInt32() -> Int32 {
        var v = Int32(0)
        withUnsafeMutableBytes(of: &v) { dst in
            dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 4)]))
        }
        offset += 4
        return Int32(littleEndian: v)
    }

    @inline(__always)
    public mutating func readFloat32() -> Float32 {
        var bits = UInt32(0)
        withUnsafeMutableBytes(of: &bits) { dst in
            dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 4)]))
        }
        offset += 4
        return Float32(bitPattern: UInt32(littleEndian: bits))
    }

    @inline(__always)
    public mutating func readFloat64() -> Float64 {
        var bits = UInt64(0)
        withUnsafeMutableBytes(of: &bits) { dst in
            dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 8)]))
        }
        offset += 8
        return Float64(bitPattern: UInt64(littleEndian: bits))
    }

    @inline(__always)
    public mutating func readString() -> String {
        let len = Int(readUInt32())
        let s = String(
            decoding: UnsafeBufferPointer(
                start: raw.baseAddress!.advanced(by: offset).assumingMemoryBound(to: UInt8.self),
                count: len
            ),
            as: UTF8.self
        )
        offset += len
        return s
    }

    @inline(__always)
    public mutating func expectTag(_ expected: _BJSParamType) {
        let rawTag = readUInt8()
        guard let got = _BJSParamType(rawValue: rawTag), got == expected else {
            preconditionFailure(
                "BridgeJS: mismatched enum param tag. Expected \(expected) got \(String(describing: _BJSParamType(rawValue: rawTag)))"
            )
        }
    }

    @inline(__always)
    public mutating func readParamCount(expected: Int) {
        let count = Int(readUInt32())
        precondition(count == expected, "BridgeJS: mismatched enum param count. Expected \(expected) got \(count)")
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
@_extern(wasm, module: "bjs", name: "swift_js_return_tag")
@_spi(BridgeJS) public func _swift_js_return_tag(_ tag: Int32)
#else
@_spi(BridgeJS) public func _swift_js_return_tag(_ tag: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_string")
@_spi(BridgeJS) public func _swift_js_return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
#else
@_spi(BridgeJS) public func _swift_js_return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_int")
@_spi(BridgeJS) public func _swift_js_return_int(_ value: Int32)
#else
@_spi(BridgeJS) public func _swift_js_return_int(_ value: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_f32")
@_spi(BridgeJS) public func _swift_js_return_f32(_ value: Float32)
#else
@_spi(BridgeJS) public func _swift_js_return_f32(_ value: Float32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_f64")
@_spi(BridgeJS) public func _swift_js_return_f64(_ value: Float64)
#else
@_spi(BridgeJS) public func _swift_js_return_f64(_ value: Float64) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_bool")
@_spi(BridgeJS) public func _swift_js_return_bool(_ value: Int32)
#else
@_spi(BridgeJS) public func _swift_js_return_bool(_ value: Int32) {
    _onlyAvailableOnWasm()
}
#endif
