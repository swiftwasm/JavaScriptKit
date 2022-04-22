import _CJavaScriptKit

/// Note:
/// Define all runtime function stubs which are imported from JavaScript environment.
/// SwiftPM doesn't support WebAssembly target yet, so we need to define them to
/// avoid link failure.
/// When running with JavaScript runtime library, they are ignored completely.
#if !arch(wasm32)
    func _i64_to_bigint(_: Int64, _: Bool) -> JavaScriptObjectRef { fatalError() }
    func _bigint_to_i64(_: JavaScriptObjectRef, _: Bool) -> Int64 { fatalError() }
#endif
