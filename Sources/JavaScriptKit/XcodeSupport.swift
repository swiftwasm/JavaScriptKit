import _CJavaScriptKit

/// Note:
/// Define all runtime functions stub which are imported from JavaScript environment.
/// SwiftPM doesn't support WebAssembly target yet, so we need to define them to
/// avoid link failure.
/// When running with JavaScript runtime library, they are ignored completely.
#if !arch(wasm32)
    func _set_prop(
        _: JavaScriptObjectRef,
        _: UnsafePointer<Int8>!, _: Int32,
        _: UnsafePointer<RawJSValue>!
    ) { fatalError() }
    func _get_prop(
        _: JavaScriptObjectRef,
        _: UnsafePointer<Int8>!, _: Int32,
        _: UnsafePointer<RawJSValue>!
    ) { fatalError() }
    func _set_subscript(
        _: JavaScriptObjectRef,
        _: Int32,
        _: UnsafePointer<RawJSValue>!
    ) { fatalError() }
    func _get_subscript(
        _: JavaScriptObjectRef,
        _: Int32,
        _: UnsafePointer<RawJSValue>!
    ) { fatalError() }
    func _load_string(
        _: JavaScriptObjectRef,
        _: UnsafeMutablePointer<UInt8>!
    ) { fatalError() }
    func _call_function(
        _: JavaScriptObjectRef,
        _: UnsafePointer<RawJSValue>!, _: Int32,
        _: UnsafePointer<RawJSValue>!
    ) { fatalError() }
    func _call_function_with_this(
        _: JavaScriptObjectRef,
        _: JavaScriptObjectRef,
        _: UnsafePointer<RawJSValue>!, _: Int32,
        _: UnsafePointer<RawJSValue>!
    ) { fatalError() }
    func _call_new(
        _: JavaScriptObjectRef,
        _: UnsafePointer<RawJSValue>!, _: Int32,
        _: UnsafeMutablePointer<JavaScriptObjectRef>!
    ) { fatalError() }
    func _create_function(
        _: JavaScriptHostFuncRef,
        _: UnsafePointer<JavaScriptObjectRef>!
    ) { fatalError() }
    func _destroy_ref(_: JavaScriptObjectRef) { fatalError() }
#endif
