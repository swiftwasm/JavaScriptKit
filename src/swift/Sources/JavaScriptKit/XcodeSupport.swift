import _CJavaScriptKit

/// Note:
/// Define all runtime functions stub which are imported from JavaScript environment.
/// SwiftPM doesn't support WebAssembly target yet, so we need to define them to
/// avoid link failure.
/// When running with JavaScript runtime library, they are ignored completely.
#if Xcode
func _set_prop(
    _ _this: JavaScriptObjectRef,
    _ prop: UnsafePointer<Int8>!, _ length: Int32,
    _ kind: JavaScriptValueKind,
    _ payload1: JavaScriptPayload,
    _ payload2: JavaScriptPayload) { fatalError() }
func _get_prop(
    _ _this: JavaScriptObjectRef,
    _ prop: UnsafePointer<Int8>!, _ length: Int32,
    _ kind: UnsafeMutablePointer<JavaScriptValueKind>!,
    _ payload1: UnsafeMutablePointer<JavaScriptPayload>!,
    _ payload2: UnsafeMutablePointer<JavaScriptPayload>!) { fatalError() }
func _set_subscript(
    _ _this: JavaScriptObjectRef,
    _ index: Int32,
    _ kind: JavaScriptValueKind,
    _ payload1: JavaScriptPayload,
    _ payload2: JavaScriptPayload) { fatalError() }
func _get_subscript(
    _ _this: JavaScriptObjectRef,
    _ index: Int32,
    _ kind: UnsafeMutablePointer<JavaScriptValueKind>!,
    _ payload1: UnsafeMutablePointer<JavaScriptPayload>!,
    _ payload2: UnsafeMutablePointer<JavaScriptPayload>!) { fatalError() }
func _load_string(
    _ ref: JavaScriptObjectRef,
    _ buffer: UnsafeMutablePointer<UInt8>!) { fatalError() }
func _call_function(
    _ ref: JavaScriptObjectRef,
    _ argv: UnsafePointer<RawJSValue>!, _ argc: Int32,
    _ result_kind: UnsafeMutablePointer<JavaScriptValueKind>!,
    _ result_payload1: UnsafeMutablePointer<JavaScriptPayload>!,
    _ result_payload2: UnsafeMutablePointer<JavaScriptPayload>!) { fatalError() }
func _create_function(_ host_func_id: JavaScriptHostFuncRef, _ func_ref_ptr: UnsafePointer<JavaScriptObjectRef>!) {}
#endif
