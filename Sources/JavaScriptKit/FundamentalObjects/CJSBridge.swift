public struct CJSBridge: JSBridge {
    // MARK: Objects
    public static func set(on object: JSObject.Ref, property: JSObject.Ref, to value: RawJSValue) {
        _set_prop(object, property, value.kind, value.payload1, value.payload2)
    }
    public static func get(on object: JSObject.Ref, property: JSObject.Ref) -> RawJSValue {
        withRawJSValue {
            _get_prop(object, property, &$0.kind, &$0.payload1, &$0.payload2)
        }
    }

    public static func set(on object: JSObject.Ref, index: Int32, to newValue: RawJSValue) {
        _set_subscript(object, index, newValue.kind, newValue.payload1, newValue.payload2)
    }
    public static func get(on object: JSObject.Ref, index: Int32) -> RawJSValue {
        withRawJSValue {
            _get_subscript(object, index, &$0.kind, &$0.payload1, &$0.payload2)
        }
    }

    // MARK: Strings
    public static func encode(string: JSObject.Ref) -> String {
        var bytesRef: JSObject.Ref = 0
        let bytesLength = Int(_encode_string(string, &bytesRef))
        defer { Self.release(bytesRef) }
        // +1 for null terminator
        let buffer = [UInt8].init(unsafeUninitializedCapacity: bytesLength + 1) { buffer, initializedCount in
            _load_string(bytesRef, buffer.baseAddress)
            buffer[bytesLength] = 0
            initializedCount = bytesLength + 1
        }
        return String(decoding: buffer, as: UTF8.self)
    }
    public static func decode(string: inout String) -> JSObject.Ref {
        string.withUTF8 {
            _decode_string($0.baseAddress!, Int32($0.count))
        }
    }

    // MARK: Functions
    public static func call(function: JSObject.Ref, args: [RawJSValue]) -> ThrowingCallResult<RawJSValue> {
        args.withUnsafeBufferPointer { args in
            var kindAndFlags = RawJSValue.KindWithFlags()
            let value = withRawJSValue { jsValue in
                _call_function(function, args.baseAddress!, Int32(args.count), &kindAndFlags, &jsValue.payload1, &jsValue.payload2)
                jsValue.kind = kindAndFlags.kind
            }
            return kindAndFlags.isException ? .exception(value) : .success(value)
        }
    }

    public static func call(function: JSObject.Ref, this: JSObject.Ref, args: [RawJSValue]) -> ThrowingCallResult<RawJSValue> {
        args.withUnsafeBufferPointer { args in
            var kindAndFlags = RawJSValue.KindWithFlags()
            let value = withRawJSValue { jsValue in
                _call_function_with_this(function, this, args.baseAddress!, Int32(args.count), &kindAndFlags, &jsValue.payload1, &jsValue.payload2)
                jsValue.kind = kindAndFlags.kind
            }
            return kindAndFlags.isException ? .exception(value) : .success(value)
        }
    }

    public static func new(class: JSObject.Ref, args: [RawJSValue]) -> JSObject.Ref {
        args.withUnsafeBufferPointer { args in
            _call_new(`class`, args.baseAddress!, Int32(args.count))
        }
    }

    public static func throwingNew(class: JSObject.Ref, args: [RawJSValue]) -> ThrowingCallResult<JSObject.Ref> {
        args.withUnsafeBufferPointer { args in
            var kindAndFlags = RawJSValue.KindWithFlags()
            var exception = RawJSValue()
            let objectRef = _call_throwing_new(`class`, args.baseAddress!, Int32(args.count), &kindAndFlags, &exception.payload1, &exception.payload2)
            exception.kind = kindAndFlags.kind
            return kindAndFlags.isException ? .exception(exception) : .success(objectRef)
        }
    }

    public static func createFunction(calling funcRef: JSClosure.Ref) -> JSObject.Ref {
        _create_function(funcRef)
    }

    // MARK: Misc
    public static func instanceof(obj: JSObject.Ref, constructor: JSObject.Ref) -> Bool {
        _instanceof(obj, constructor)
    }

    public static func createTypedArray<Element: TypedArrayElement>(copying array: [Element]) -> JSObject.Ref {
        array.withUnsafeBufferPointer { buffer in
            _create_typed_array(Element.typedArrayClass.id, buffer.baseAddress!, Int32(buffer.count))
        }
    }

    public static func release(_ obj: JSObject.Ref) {
        _release(obj)
    }

    public static let globalThis: JSObject.Ref = 0
}
