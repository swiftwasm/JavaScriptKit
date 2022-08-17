import _CJavaScriptKit

/// Note:
/// Define all runtime function stubs which are imported from JavaScript environment.
/// SwiftPM doesn't support WebAssembly target yet, so we need to define them to
/// avoid link failure.
/// When running with JavaScript runtime library, they are ignored completely.
#if !arch(wasm32)
    func _set_prop(
        _: JavaScriptObjectRef,
        _: JavaScriptObjectRef,
        _: JavaScriptValueKind,
        _: JavaScriptPayload1,
        _: JavaScriptPayload2
    ) { fatalError() }
    func _get_prop(
        _: JavaScriptObjectRef,
        _: JavaScriptObjectRef,
        _: UnsafeMutablePointer<JavaScriptValueKind>!,
        _: UnsafeMutablePointer<JavaScriptPayload1>!,
        _: UnsafeMutablePointer<JavaScriptPayload2>!
    ) { fatalError() }
    func _set_subscript(
        _: JavaScriptObjectRef,
        _: Int32,
        _: JavaScriptValueKind,
        _: JavaScriptPayload1,
        _: JavaScriptPayload2
    ) { fatalError() }
    func _get_subscript(
        _: JavaScriptObjectRef,
        _: Int32,
        _: UnsafeMutablePointer<JavaScriptValueKind>!,
        _: UnsafeMutablePointer<JavaScriptPayload1>!,
        _: UnsafeMutablePointer<JavaScriptPayload2>!
    ) { fatalError() }
    func _encode_string(
        _: JavaScriptObjectRef,
        _: UnsafeMutablePointer<JavaScriptObjectRef>!
    ) -> Int32 { fatalError() }
    func _decode_string(
        _: UnsafePointer<UInt8>!,
        _: Int32
    ) -> JavaScriptObjectRef { fatalError() }
    func _load_string(
        _: JavaScriptObjectRef,
        _: UnsafeMutablePointer<UInt8>!
    ) { fatalError() }
    func _i64_to_bigint_slow(
        _: UInt32, _: UInt32, _: Bool
    ) -> JavaScriptObjectRef { fatalError() }
    func _call_function(
        _: JavaScriptObjectRef,
        _: UnsafePointer<RawJSValue>!, _: Int32,
        _: UnsafeMutablePointer<JavaScriptPayload1>!,
        _: UnsafeMutablePointer<JavaScriptPayload2>!
    ) -> UInt32 { fatalError() }
    func _call_function_no_catch(
        _: JavaScriptObjectRef,
        _: UnsafePointer<RawJSValue>!, _: Int32,
        _: UnsafeMutablePointer<JavaScriptPayload1>!,
        _: UnsafeMutablePointer<JavaScriptPayload2>!
    ) -> UInt32 { fatalError() }
    func _call_function_with_this(
        _: JavaScriptObjectRef,
        _: JavaScriptObjectRef,
        _: UnsafePointer<RawJSValue>!, _: Int32,
        _: UnsafeMutablePointer<JavaScriptPayload1>!,
        _: UnsafeMutablePointer<JavaScriptPayload2>!
    ) -> UInt32 { fatalError() }
    func _call_function_with_this_no_catch(
        _: JavaScriptObjectRef,
        _: JavaScriptObjectRef,
        _: UnsafePointer<RawJSValue>!, _: Int32,
        _: UnsafeMutablePointer<JavaScriptPayload1>!,
        _: UnsafeMutablePointer<JavaScriptPayload2>!
    ) -> UInt32 { fatalError() }
    func _call_new(
        _: JavaScriptObjectRef,
        _: UnsafePointer<RawJSValue>!, _: Int32
    ) -> JavaScriptObjectRef { fatalError() }
    func _call_throwing_new(
        _: JavaScriptObjectRef,
        _: UnsafePointer<RawJSValue>!, _: Int32,
        _: UnsafeMutablePointer<JavaScriptValueKindAndFlags>!,
        _: UnsafeMutablePointer<JavaScriptPayload1>!,
        _: UnsafeMutablePointer<JavaScriptPayload2>!
    ) -> JavaScriptObjectRef { fatalError() }
    func _instanceof(
        _: JavaScriptObjectRef,
        _: JavaScriptObjectRef
    ) -> Bool { fatalError() }
    func _create_function(_: JavaScriptHostFuncRef, _: UInt32, _: JavaScriptObjectRef) -> JavaScriptObjectRef { fatalError() }
    func _create_typed_array<T: TypedArrayElement>(
        _: JavaScriptObjectRef,
        _: UnsafePointer<T>,
        _: Int32
    ) -> JavaScriptObjectRef { fatalError() }
    func _load_typed_array(
        _: JavaScriptObjectRef,
        _: UnsafeMutablePointer<UInt8>!
    ) { fatalError() }
    func _release(_: JavaScriptObjectRef) { fatalError() }
#endif
