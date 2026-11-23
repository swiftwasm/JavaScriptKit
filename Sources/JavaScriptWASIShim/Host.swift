import JavaScriptKit

// The browser globals the shim calls, imported through BridgeJS. Together with JavaScriptKit's
// runtime import `swjs_load_typed_array` (see `Random.swift`), they are everything the shim needs
// from the host, so it needs no JavaScript beyond the glue BridgeJS generates.
//
// These declarations stay outside the `#if` gate the rest of the module uses: BridgeJS generates
// glue for them regardless of `#if`, and that glue refers to them.

@JSClass(jsName: "console", from: .global)
struct HostConsole {
    @JSFunction static func log(_ line: String) throws(JSException)
    @JSFunction static func error(_ line: String) throws(JSException)
}

#if os(WASI) && compiler(>=6.4) && !_runtime(_multithreaded)
// The imports BridgeJS generates for `HostConsole`, redeclared under other names because its own
// declarations are fileprivate. The module name is this target's name.
// Once BridgeJS lowers `Span<UInt8>` / `UTF8Span` parameters to pointer and length, `log` and
// `error` can take the span directly and these, along with `unsafeCallUnowned`, can go.
@_extern(wasm, module: "JavaScriptWASIShim", name: "bjs_HostConsole_log_static")
func bjs_HostConsole_log_static_unowned(_ count: Int32, _ storage: Int32, _ flags: Int32)

@_extern(wasm, module: "JavaScriptWASIShim", name: "bjs_HostConsole_error_static")
func bjs_HostConsole_error_static_unowned(_ count: Int32, _ storage: Int32, _ flags: Int32)
#endif

// `getRandomValues` fills a JS-owned `Uint8Array` that `RandomSource` then copies into wasm
// memory. A BridgeJS `MutableSpan<UInt8>` parameter bridged as a view would remove that copy.
@JSClass(jsName: "crypto", from: .global)
struct HostCrypto {
    @JSFunction static func getRandomValues(_ array: HostUint8Array) throws(JSException)
}

@JSClass(jsName: "Uint8Array", from: .global)
struct HostUint8Array {
    @JSFunction init(_ length: Int) throws(JSException)
}

@JSClass(jsName: "Date", from: .global)
struct HostDate {
    @JSFunction static func now() throws(JSException) -> Double
}

@JSClass(jsName: "performance", from: .global)
struct HostPerformance {
    @JSFunction static func now() throws(JSException) -> Double
}

@JSClass(jsName: "SharedArrayBuffer", from: .global)
struct HostSharedArrayBuffer {
    @JSFunction init(_ length: Int) throws(JSException)
}

@JSClass(jsName: "Int32Array", from: .global)
struct HostInt32Array {
    @JSFunction init(_ buffer: HostSharedArrayBuffer) throws(JSException)
}

@JSClass(jsName: "Atomics", from: .global)
struct HostAtomics {
    @JSFunction static func wait(
        _ array: HostInt32Array,
        _ index: Int,
        _ value: Int,
        _ timeout: Double
    ) throws(JSException)
}
