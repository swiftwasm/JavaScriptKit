// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const AsyncDirectionValues = {
    North: 0,
    South: 1,
};

export const AsyncThemeValues = {
    Light: "light",
    Dark: "dark",
};

export async function createInstantiator(options, swift) {
    let instance;
    let memory;
    let setException;
    let decodeString;
    const textDecoder = new TextDecoder("utf-8");
    const textEncoder = new TextEncoder("utf-8");
    let tmpRetString;
    let tmpRetBytes;
    let tmpRetException;
    let tmpRetOptionalBool;
    let tmpRetOptionalInt;
    let tmpRetOptionalFloat;
    let tmpRetOptionalDouble;
    let tmpRetOptionalHeapObject;
    let strStack = [];
    let i32Stack = [];
    let i64Stack = [];
    let f32Stack = [];
    let f64Stack = [];
    let ptrStack = [];
    let taStack = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    const __bjs_arrayCodecCache = new WeakMap();
    function __bjs_arrayCodec(elementCodec) {
        let codec = __bjs_arrayCodecCache.get(elementCodec);
        if (codec !== undefined) {
            return codec;
        }
        codec = {
            lower(value) {
                for (let i = 0; i < value.length; i++) {
                    elementCodec.lower(value[i]);
                }
                i32Stack.push(value.length);
            },
            lift() {
                const count = i32Stack.pop();
                if (count === -1) {
                    return taStack.pop();
                }
                const result = new Array(count);
                for (let i = count - 1; i >= 0; i--) {
                    result[i] = elementCodec.lift();
                }
                return result;
            },
        };
        __bjs_arrayCodecCache.set(elementCodec, codec);
        return codec;
    }
    const __bjs_optionalCodecCache = new WeakMap();
    const __bjs_optionalCodecUndefinedOrCache = new WeakMap();
    function __bjs_optionalCodec(elementCodec, isUndefinedOr = false) {
        const cache = isUndefinedOr ? __bjs_optionalCodecUndefinedOrCache : __bjs_optionalCodecCache;
        let codec = cache.get(elementCodec);
        if (codec !== undefined) {
            return codec;
        }
        codec = {
            lower(value) {
                const isSome = isUndefinedOr ? value !== undefined : value != null;
                if (isSome) {
                    elementCodec.lower(value);
                    i32Stack.push(1);
                } else {
                    i32Stack.push(0);
                }
            },
            lift() {
                if (i32Stack.pop() === 0) {
                    return isUndefinedOr ? undefined : null;
                }
                return elementCodec.lift();
            },
        };
        cache.set(elementCodec, codec);
        return codec;
    }
    const __bjs_dictCodecCache = new WeakMap();
    function __bjs_dictCodec(valueCodec) {
        let codec = __bjs_dictCodecCache.get(valueCodec);
        if (codec !== undefined) {
            return codec;
        }
        codec = {
            lower(value) {
                const keys = Object.keys(value);
                for (let i = 0; i < keys.length; i++) {
                    __bjs_stringCodec.lower(keys[i]);
                    valueCodec.lower(value[keys[i]]);
                }
                i32Stack.push(keys.length);
            },
            lift() {
                const count = i32Stack.pop();
                const result = {};
                for (let i = 0; i < count; i++) {
                    const value = valueCodec.lift();
                    const key = __bjs_stringCodec.lift();
                    result[key] = value;
                }
                return result;
            },
        };
        __bjs_dictCodecCache.set(valueCodec, codec);
        return codec;
    }

    const __bjs_stringCodec = {
        lower: (v) => {
            const bytes = textEncoder.encode(v);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
        },
        lift: () => {
            const string = strStack.pop();
            return string;
        },
    };
    const __bjs_primitiveCodecs = {
        Bool: {
            lower: (v) => {
                i32Stack.push(v ? 1 : 0);
            },
            lift: () => {
                const bool = i32Stack.pop() !== 0;
                return bool;
            },
        },
        Int: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop();
                return int;
            },
        },
        Int8: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop();
                return int;
            },
        },
        UInt8: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop() >>> 0;
                return int;
            },
        },
        Int16: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop();
                return int;
            },
        },
        UInt16: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop() >>> 0;
                return int;
            },
        },
        Int32: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop();
                return int;
            },
        },
        UInt32: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop() >>> 0;
                return int;
            },
        },
        UInt: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop() >>> 0;
                return int;
            },
        },
        Int64: {
            lower: (v) => {
                i64Stack.push(v);
            },
            lift: () => {
                const int = i64Stack.pop();
                return int;
            },
        },
        UInt64: {
            lower: (v) => {
                i64Stack.push(v);
            },
            lift: () => {
                const int = i64Stack.pop();
                return int;
            },
        },
        Float: {
            lower: (v) => {
                f32Stack.push(Math.fround(v));
            },
            lift: () => {
                const f32 = f32Stack.pop();
                return f32;
            },
        },
        Double: {
            lower: (v) => {
                f64Stack.push(v);
            },
            lift: () => {
                const f64 = f64Stack.pop();
                return f64;
            },
        },
        String: __bjs_stringCodec,
        JSValue: {
            lower: (v) => {
                const [vKind, vPayload1, vPayload2] = __bjs_jsValueLower(v);
                i32Stack.push(vKind);
                i32Stack.push(vPayload1);
                f64Stack.push(vPayload2);
            },
            lift: () => {
                const jsValuePayload2 = f64Stack.pop();
                const jsValuePayload1 = i32Stack.pop();
                const jsValueKind = i32Stack.pop();
                const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                return jsValue;
            },
        },
    };

    function __bjs_jsValueLower(value) {
        let kind;
        let payload1;
        let payload2;
        if (value === null) {
            kind = 4;
            payload1 = 0;
            payload2 = 0;
        } else {
            switch (typeof value) {
                case "boolean":
                    kind = 0;
                    payload1 = value ? 1 : 0;
                    payload2 = 0;
                    break;
                case "number":
                    kind = 2;
                    payload1 = 0;
                    payload2 = value;
                    break;
                case "string":
                    kind = 1;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "undefined":
                    kind = 5;
                    payload1 = 0;
                    payload2 = 0;
                    break;
                case "object":
                    kind = 3;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "function":
                    kind = 3;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "symbol":
                    kind = 7;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "bigint":
                    kind = 8;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                default:
                    throw new TypeError("Unsupported JSValue type");
            }
        }
        return [kind, payload1, payload2];
    }
    function __bjs_jsValueLift(kind, payload1, payload2) {
        let jsValue;
        switch (kind) {
            case 0:
                jsValue = payload1 !== 0;
                break;
            case 1:
                jsValue = swift.memory.getObject(payload1);
                break;
            case 2:
                jsValue = payload2;
                break;
            case 3:
                jsValue = swift.memory.getObject(payload1);
                break;
            case 4:
                jsValue = null;
                break;
            case 5:
                jsValue = undefined;
                break;
            case 7:
                jsValue = swift.memory.getObject(payload1);
                break;
            case 8:
                jsValue = swift.memory.getObject(payload1);
                break;
            default:
                throw new TypeError("Unsupported JSValue kind " + kind);
        }
        return jsValue;
    }

    const __bjs_codec_TestModule_AsyncPoint = {
        lower: (v) => {
            structHelpers.AsyncPoint.lower(v);
        },
        lift: () => {
            const struct = structHelpers.AsyncPoint.lift();
            return struct;
        },
    };
    const __bjs_codec_Optional_TestModule_AsyncPoint = __bjs_optionalCodec(__bjs_codec_TestModule_AsyncPoint);
    const __bjs_codec_Array_TestModule_AsyncPoint = __bjs_arrayCodec(__bjs_codec_TestModule_AsyncPoint);
    const __bjs_codec_TestModule_AsyncDirection = {
        lower: (v) => {
            i32Stack.push((v | 0));
        },
        lift: () => {
            const caseId = i32Stack.pop();
            return caseId;
        },
    };
    const __bjs_codec_Array_TestModule_AsyncDirection = __bjs_arrayCodec(__bjs_codec_TestModule_AsyncDirection);
    const __bjs_codec_Dict_TestModule_AsyncPoint = __bjs_dictCodec(__bjs_codec_TestModule_AsyncPoint);
    const __bjs_codec_Dict_TestModule_AsyncDirection = __bjs_dictCodec(__bjs_codec_TestModule_AsyncDirection);

    const __bjs_createAsyncPointHelpers = () => ({
        lower: (value) => {
            i32Stack.push((value.x | 0));
            i32Stack.push((value.y | 0));
        },
        lift: () => {
            const int = i32Stack.pop();
            const int1 = i32Stack.pop();
            return { x: int1, y: int };
        }
    });

    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            bjs["swift_js_return_string"] = function(ptr, len) {
                tmpRetString = decodeString(ptr, len);
            }
            bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
                swift.memory.release(sourceId);
                const bytes = new Uint8Array(memory.buffer, bytesPtr >>> 0);
                bytes.set(source);
            }
            bjs["swift_js_make_js_string"] = function(ptr, len) {
                return swift.memory.retain(decodeString(ptr, len));
            }
            bjs["swift_js_init_memory_with_result"] = function(ptr, len) {
                const target = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0);
                target.set(tmpRetBytes);
                tmpRetBytes = undefined;
            }
            bjs["swift_js_throw"] = function(id) {
                tmpRetException = swift.memory.retainByRef(id);
            }
            bjs["swift_js_retain"] = function(id) {
                return swift.memory.retainByRef(id);
            }
            bjs["swift_js_release"] = function(id) {
                swift.memory.release(id);
            }
            bjs["swift_js_push_i32"] = function(v) {
                i32Stack.push(v | 0);
            }
            bjs["swift_js_push_f32"] = function(v) {
                f32Stack.push(Math.fround(v));
            }
            bjs["swift_js_push_f64"] = function(v) {
                f64Stack.push(v);
            }
            bjs["swift_js_push_string"] = function(ptr, len) {
                const value = decodeString(ptr, len);
                strStack.push(value);
            }
            bjs["swift_js_pop_i32"] = function() {
                return i32Stack.pop();
            }
            bjs["swift_js_pop_f32"] = function() {
                return f32Stack.pop();
            }
            bjs["swift_js_pop_f64"] = function() {
                return f64Stack.pop();
            }
            bjs["swift_js_push_pointer"] = function(pointer) {
                ptrStack.push(pointer);
            }
            bjs["swift_js_pop_pointer"] = function() {
                return ptrStack.pop();
            }
            bjs["swift_js_push_i64"] = function(v) {
                i64Stack.push(v);
            }
            bjs["swift_js_pop_i64"] = function() {
                return i64Stack.pop();
            }
            const taCtors = [Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array];
            bjs["swift_js_push_typed_array"] = function(kind, ptr, count) {
                const Ctor = taCtors[kind];
                const byteLen = count * Ctor.BYTES_PER_ELEMENT;
                const copy = memory.buffer.slice(ptr, ptr + byteLen);
                taStack.push(Array.from(new Ctor(copy)));
            }
            bjs["swift_js_struct_lower_AsyncPoint"] = function(objectId) {
                structHelpers.AsyncPoint.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_AsyncPoint"] = function() {
                const value = structHelpers.AsyncPoint.lift();
                return swift.memory.retain(value);
            }
            bjs["bjs_core_register_type_handles"] = function() {};
            bjs["bjs_TestModule_register_type_handles"] = function() {};
            const __bjs_promiseSettlers = Symbol("JavaScriptKit.promiseSettlers");
            bjs["swift_js_make_promise"] = function() {
                let resolve, reject;
                const promise = new Promise((res, rej) => { resolve = res; reject = rej; });
                promise[__bjs_promiseSettlers] = { resolve, reject };
                return swift.memory.retain(promise);
            }
            bjs["promise_resolve_TestModule_y"] = function(promise) {
                try {
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve();
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_Si"] = function(promise, value) {
                try {
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(value);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_SS"] = function(promise, valueBytes, valueCount) {
                try {
                    const string = decodeString(valueBytes, valueCount);
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(string);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_Sb"] = function(promise, value) {
                try {
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(value !== 0);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_Sf"] = function(promise, value) {
                try {
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(value);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_Sd"] = function(promise, value) {
                try {
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(value);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_8JSObjectC"] = function(promise, value) {
                try {
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(swift.memory.getObject(value));
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_10AsyncPointV"] = function(promise) {
                try {
                    const structValue = structHelpers.AsyncPoint.lift();
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(structValue);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_14AsyncDirectionO"] = function(promise, value) {
                try {
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(value);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_10AsyncThemeO"] = function(promise, valueBytes, valueCount) {
                try {
                    const string = decodeString(valueBytes, valueCount);
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(string);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_Sq14AsyncDirectionO"] = function(promise, valueIsSome, valueWrappedValue) {
                try {
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(valueIsSome ? valueWrappedValue : null);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_Sq10AsyncThemeO"] = function(promise, valueIsSome, valueBytes, valueCount) {
                try {
                    let optResult;
                    if (valueIsSome) {
                        const string = decodeString(valueBytes, valueCount);
                        optResult = string;
                    } else {
                        optResult = null;
                    }
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(optResult);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_Sq10AsyncPointV"] = function(promise, value) {
                try {
                    let optResult;
                    if (value) {
                        const struct = structHelpers.AsyncPoint.lift();
                        optResult = struct;
                    } else {
                        optResult = null;
                    }
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(optResult);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_Sa10AsyncPointV"] = function(promise) {
                try {
                    const arrayResult = __bjs_codec_Array_TestModule_AsyncPoint.lift();
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(arrayResult);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_Sa14AsyncDirectionO"] = function(promise) {
                try {
                    const arrayResult = __bjs_codec_Array_TestModule_AsyncDirection.lift();
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(arrayResult);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_SD10AsyncPointV"] = function(promise) {
                try {
                    const dictResult = __bjs_codec_Dict_TestModule_AsyncPoint.lift();
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(dictResult);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_resolve_TestModule_SD14AsyncDirectionO"] = function(promise) {
                try {
                    const dictResult = __bjs_codec_Dict_TestModule_AsyncDirection.lift();
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].resolve(dictResult);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["promise_reject_TestModule"] = function(promise, valueKind, valuePayload1, valuePayload2) {
                try {
                    const jsValue = __bjs_jsValueLift(valueKind, valuePayload1, valuePayload2);
                    swift.memory.getObject(promise)[__bjs_promiseSettlers].reject(jsValue);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["swift_js_return_optional_bool"] = function(isSome, value) {
                if (isSome === 0) {
                    tmpRetOptionalBool = null;
                } else {
                    tmpRetOptionalBool = value !== 0;
                }
            }
            bjs["swift_js_return_optional_int"] = function(isSome, value) {
                if (isSome === 0) {
                    tmpRetOptionalInt = null;
                } else {
                    tmpRetOptionalInt = value | 0;
                }
            }
            bjs["swift_js_return_optional_float"] = function(isSome, value) {
                if (isSome === 0) {
                    tmpRetOptionalFloat = null;
                } else {
                    tmpRetOptionalFloat = Math.fround(value);
                }
            }
            bjs["swift_js_return_optional_double"] = function(isSome, value) {
                if (isSome === 0) {
                    tmpRetOptionalDouble = null;
                } else {
                    tmpRetOptionalDouble = value;
                }
            }
            bjs["swift_js_return_optional_string"] = function(isSome, ptr, len) {
                if (isSome === 0) {
                    tmpRetString = null;
                } else {
                    tmpRetString = decodeString(ptr, len);
                }
            }
            bjs["swift_js_return_optional_object"] = function(isSome, objectId) {
                if (isSome === 0) {
                    tmpRetString = null;
                } else {
                    tmpRetString = swift.memory.getObject(objectId);
                }
            }
            bjs["swift_js_return_optional_heap_object"] = function(isSome, pointer) {
                if (isSome === 0) {
                    tmpRetOptionalHeapObject = null;
                } else {
                    tmpRetOptionalHeapObject = pointer;
                }
            }
            bjs["swift_js_get_optional_int_presence"] = function() {
                return tmpRetOptionalInt != null ? 1 : 0;
            }
            bjs["swift_js_get_optional_int_value"] = function() {
                const value = tmpRetOptionalInt;
                tmpRetOptionalInt = undefined;
                return value;
            }
            bjs["swift_js_get_optional_string"] = function() {
                const str = tmpRetString;
                tmpRetString = undefined;
                if (str == null) {
                    return -1;
                } else {
                    const bytes = textEncoder.encode(str);
                    tmpRetBytes = bytes;
                    return bytes.length;
                }
            }
            bjs["swift_js_get_optional_float_presence"] = function() {
                return tmpRetOptionalFloat != null ? 1 : 0;
            }
            bjs["swift_js_get_optional_float_value"] = function() {
                const value = tmpRetOptionalFloat;
                tmpRetOptionalFloat = undefined;
                return value;
            }
            bjs["swift_js_get_optional_double_presence"] = function() {
                return tmpRetOptionalDouble != null ? 1 : 0;
            }
            bjs["swift_js_get_optional_double_value"] = function() {
                const value = tmpRetOptionalDouble;
                tmpRetOptionalDouble = undefined;
                return value;
            }
            bjs["swift_js_get_optional_heap_object_pointer"] = function() {
                const pointer = tmpRetOptionalHeapObject;
                tmpRetOptionalHeapObject = undefined;
                return pointer || 0;
            }
            bjs["swift_js_closure_unregister"] = function(funcRef) {}
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            decodeString = (ptr, len) => { const bytes = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0); return textDecoder.decode(bytes); }

            setException = (error) => {
                instance.exports._swift_js_exception.value = swift.memory.retain(error)
            }
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;
            const AsyncPointHelpers = __bjs_createAsyncPointHelpers();
            structHelpers.AsyncPoint = AsyncPointHelpers;

            const exports = {
                asyncReturnVoid: function bjs_asyncReturnVoid() {
                    const ret = instance.exports.bjs_asyncReturnVoid();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripInt: function bjs_asyncRoundTripInt(v) {
                    const ret = instance.exports.bjs_asyncRoundTripInt(v);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripString: function bjs_asyncRoundTripString(v) {
                    const vBytes = textEncoder.encode(v);
                    const vId = swift.memory.retain(vBytes);
                    const ret = instance.exports.bjs_asyncRoundTripString(vId, vBytes.length);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripBool: function bjs_asyncRoundTripBool(v) {
                    const ret = instance.exports.bjs_asyncRoundTripBool(v);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripFloat: function bjs_asyncRoundTripFloat(v) {
                    const ret = instance.exports.bjs_asyncRoundTripFloat(v);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripDouble: function bjs_asyncRoundTripDouble(v) {
                    const ret = instance.exports.bjs_asyncRoundTripDouble(v);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripJSObject: function bjs_asyncRoundTripJSObject(v) {
                    const ret = instance.exports.bjs_asyncRoundTripJSObject(swift.memory.retain(v));
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripStruct: function bjs_asyncRoundTripStruct(v) {
                    structHelpers.AsyncPoint.lower(v);
                    const ret = instance.exports.bjs_asyncRoundTripStruct();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripStructThrows: function bjs_asyncRoundTripStructThrows(v) {
                    structHelpers.AsyncPoint.lower(v);
                    const ret = instance.exports.bjs_asyncRoundTripStructThrows();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret1;
                },
                asyncThrowsZeroArg: function bjs_asyncThrowsZeroArg() {
                    const ret = instance.exports.bjs_asyncThrowsZeroArg();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret1;
                },
                asyncCombineStructs: function bjs_asyncCombineStructs(a, b) {
                    structHelpers.AsyncPoint.lower(a);
                    structHelpers.AsyncPoint.lower(b);
                    const ret = instance.exports.bjs_asyncCombineStructs();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripEnum: function bjs_asyncRoundTripEnum(v) {
                    const ret = instance.exports.bjs_asyncRoundTripEnum(v);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripRawEnum: function bjs_asyncRoundTripRawEnum(v) {
                    const vBytes = textEncoder.encode(v);
                    const vId = swift.memory.retain(vBytes);
                    const ret = instance.exports.bjs_asyncRoundTripRawEnum(vId, vBytes.length);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripOptionalEnum: function bjs_asyncRoundTripOptionalEnum(v) {
                    const isSome = v != null;
                    const ret = instance.exports.bjs_asyncRoundTripOptionalEnum(+isSome, isSome ? v : 0);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripOptionalRawEnum: function bjs_asyncRoundTripOptionalRawEnum(v) {
                    const isSome = v != null;
                    let result, result1;
                    if (isSome) {
                        const vBytes = textEncoder.encode(v);
                        const vId = swift.memory.retain(vBytes);
                        result = vId;
                        result1 = vBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    const ret = instance.exports.bjs_asyncRoundTripOptionalRawEnum(+isSome, result, result1);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripOptionalStruct: function bjs_asyncRoundTripOptionalStruct(v) {
                    __bjs_codec_Optional_TestModule_AsyncPoint.lower(v);
                    const ret = instance.exports.bjs_asyncRoundTripOptionalStruct();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripStructArray: function bjs_asyncRoundTripStructArray(v) {
                    __bjs_codec_Array_TestModule_AsyncPoint.lower(v);
                    const ret = instance.exports.bjs_asyncRoundTripStructArray();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripEnumArray: function bjs_asyncRoundTripEnumArray(v) {
                    __bjs_codec_Array_TestModule_AsyncDirection.lower(v);
                    const ret = instance.exports.bjs_asyncRoundTripEnumArray();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripStructDictionary: function bjs_asyncRoundTripStructDictionary(v) {
                    __bjs_codec_Dict_TestModule_AsyncPoint.lower(v);
                    const ret = instance.exports.bjs_asyncRoundTripStructDictionary();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripEnumDictionary: function bjs_asyncRoundTripEnumDictionary(v) {
                    __bjs_codec_Dict_TestModule_AsyncDirection.lower(v);
                    const ret = instance.exports.bjs_asyncRoundTripEnumDictionary();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                AsyncDirection: AsyncDirectionValues,
                AsyncTheme: AsyncThemeValues,
            };
            _exports = exports;
            return exports;
        },
    }
}