// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const ThemeValues = {
    Light: "light",
    Dark: "dark",
    Auto: "auto",
};

export const TSTheme = {
    Light: "light",
    Dark: "dark",
    Auto: "auto",
};

export const FeatureFlagValues = {
    Enabled: true,
    Disabled: false,
};

export const HttpStatusValues = {
    Ok: 200,
    NotFound: 404,
    ServerError: 500,
};

export const TSHttpStatus = {
    Ok: 200,
    NotFound: 404,
    ServerError: 500,
};

export const PriorityValues = {
    Lowest: -1,
    Low: 2,
    Medium: 3,
    High: 4,
    Highest: 5,
};

export const FileSizeValues = {
    Tiny: 1024n,
    Small: 10240n,
    Medium: 102400n,
    Large: 1048576n,
};

export const UserIdValues = {
    Guest: 0,
    User: 1000,
    Admin: 9999,
};

export const TokenIdValues = {
    Invalid: 0,
    Session: 12345,
    Refresh: 67890,
};

export const SessionIdValues = {
    None: 0n,
    Active: 9876543210n,
    Expired: 1234567890n,
};

export const PrecisionValues = {
    Rough: 0.1,
    Normal: 0.01,
    Fine: 0.001,
};

export const RatioValues = {
    Quarter: 0.25,
    Half: 0.5,
    Golden: 1.618,
    Pi: 3.14159,
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

    const __bjs_codec_TestModule_FileSize = {
        lower: (v) => {
            i64Stack.push(v);
        },
        lift: () => {
            const rawValue = i64Stack.pop();
            return rawValue;
        },
    };
    const __bjs_codec_Optional_TestModule_FileSize = __bjs_optionalCodec(__bjs_codec_TestModule_FileSize);
    const __bjs_codec_TestModule_SessionId = {
        lower: (v) => {
            i64Stack.push(v);
        },
        lift: () => {
            const rawValue = i64Stack.pop();
            return rawValue;
        },
    };
    const __bjs_codec_Optional_TestModule_SessionId = __bjs_optionalCodec(__bjs_codec_TestModule_SessionId);


    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            const imports = options.getImports(importsContext);
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
            bjs["bjs_core_register_type_handles"] = function() {};
            bjs["bjs_TestModule_register_type_handles"] = function() {};
            const __bjs_promiseSettlers = Symbol("JavaScriptKit.promiseSettlers");
            bjs["swift_js_make_promise"] = function() {
                let resolve, reject;
                const promise = new Promise((res, rej) => { resolve = res; reject = rej; });
                promise[__bjs_promiseSettlers] = { resolve, reject };
                return swift.memory.retain(promise);
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
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_takesFeatureFlag"] = function bjs_takesFeatureFlag(flagBytes, flagCount) {
                try {
                    const string = decodeString(flagBytes, flagCount);
                    imports.takesFeatureFlag(string);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_returnsFeatureFlag"] = function bjs_returnsFeatureFlag() {
                try {
                    let ret = imports.returnsFeatureFlag();
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
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
            const exports = {
                setTheme: function bjs_setTheme(theme) {
                    const themeBytes = textEncoder.encode(theme);
                    const themeId = swift.memory.retain(themeBytes);
                    instance.exports.bjs_setTheme(themeId, themeBytes.length);
                },
                getTheme: function bjs_getTheme() {
                    instance.exports.bjs_getTheme();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                roundTripOptionalTheme: function bjs_roundTripOptionalTheme(input) {
                    const isSome = input != null;
                    let result, result1;
                    if (isSome) {
                        const inputBytes = textEncoder.encode(input);
                        const inputId = swift.memory.retain(inputBytes);
                        result = inputId;
                        result1 = inputBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalTheme(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                setTSTheme: function bjs_setTSTheme(theme) {
                    const themeBytes = textEncoder.encode(theme);
                    const themeId = swift.memory.retain(themeBytes);
                    instance.exports.bjs_setTSTheme(themeId, themeBytes.length);
                },
                getTSTheme: function bjs_getTSTheme() {
                    instance.exports.bjs_getTSTheme();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                roundTripOptionalTSTheme: function bjs_roundTripOptionalTSTheme(input) {
                    const isSome = input != null;
                    let result, result1;
                    if (isSome) {
                        const inputBytes = textEncoder.encode(input);
                        const inputId = swift.memory.retain(inputBytes);
                        result = inputId;
                        result1 = inputBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalTSTheme(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                setFeatureFlag: function bjs_setFeatureFlag(flag) {
                    const flagBytes = textEncoder.encode(flag);
                    const flagId = swift.memory.retain(flagBytes);
                    instance.exports.bjs_setFeatureFlag(flagId, flagBytes.length);
                },
                getFeatureFlag: function bjs_getFeatureFlag() {
                    instance.exports.bjs_getFeatureFlag();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                roundTripOptionalFeatureFlag: function bjs_roundTripOptionalFeatureFlag(input) {
                    const isSome = input != null;
                    let result, result1;
                    if (isSome) {
                        const inputBytes = textEncoder.encode(input);
                        const inputId = swift.memory.retain(inputBytes);
                        result = inputId;
                        result1 = inputBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalFeatureFlag(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                setHttpStatus: function bjs_setHttpStatus(status) {
                    instance.exports.bjs_setHttpStatus(status);
                },
                getHttpStatus: function bjs_getHttpStatus() {
                    const ret = instance.exports.bjs_getHttpStatus();
                    return ret;
                },
                roundTripOptionalHttpStatus: function bjs_roundTripOptionalHttpStatus(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalHttpStatus(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setTSHttpStatus: function bjs_setTSHttpStatus(status) {
                    instance.exports.bjs_setTSHttpStatus(status);
                },
                getTSHttpStatus: function bjs_getTSHttpStatus() {
                    const ret = instance.exports.bjs_getTSHttpStatus();
                    return ret;
                },
                roundTripOptionalHttpStatus: function bjs_roundTripOptionalHttpStatus(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalHttpStatus(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setPriority: function bjs_setPriority(priority) {
                    instance.exports.bjs_setPriority(priority);
                },
                getPriority: function bjs_getPriority() {
                    const ret = instance.exports.bjs_getPriority();
                    return ret;
                },
                roundTripOptionalPriority: function bjs_roundTripOptionalPriority(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalPriority(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setFileSize: function bjs_setFileSize(size) {
                    instance.exports.bjs_setFileSize(size);
                },
                getFileSize: function bjs_getFileSize() {
                    const ret = instance.exports.bjs_getFileSize();
                    return ret;
                },
                roundTripOptionalFileSize: function bjs_roundTripOptionalFileSize(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalFileSize(+isSome, isSome ? input : 0n);
                    const optValue = __bjs_codec_Optional_TestModule_FileSize.lift();
                    return optValue;
                },
                setUserId: function bjs_setUserId(id) {
                    instance.exports.bjs_setUserId(id);
                },
                getUserId: function bjs_getUserId() {
                    const ret = instance.exports.bjs_getUserId();
                    return ret >>> 0;
                },
                roundTripOptionalUserId: function bjs_roundTripOptionalUserId(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalUserId(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setTokenId: function bjs_setTokenId(token) {
                    instance.exports.bjs_setTokenId(token);
                },
                getTokenId: function bjs_getTokenId() {
                    const ret = instance.exports.bjs_getTokenId();
                    return ret >>> 0;
                },
                roundTripOptionalTokenId: function bjs_roundTripOptionalTokenId(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalTokenId(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setSessionId: function bjs_setSessionId(session) {
                    instance.exports.bjs_setSessionId(session);
                },
                getSessionId: function bjs_getSessionId() {
                    const ret = instance.exports.bjs_getSessionId();
                    return BigInt.asUintN(64, ret);
                },
                roundTripOptionalSessionId: function bjs_roundTripOptionalSessionId(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalSessionId(+isSome, isSome ? input : 0n);
                    const optValue = __bjs_codec_Optional_TestModule_SessionId.lift();
                    return optValue;
                },
                setPrecision: function bjs_setPrecision(precision) {
                    instance.exports.bjs_setPrecision(precision);
                },
                getPrecision: function bjs_getPrecision() {
                    const ret = instance.exports.bjs_getPrecision();
                    return ret;
                },
                roundTripOptionalPrecision: function bjs_roundTripOptionalPrecision(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalPrecision(+isSome, isSome ? input : 0.0);
                    const optResult = tmpRetOptionalFloat;
                    tmpRetOptionalFloat = undefined;
                    return optResult;
                },
                setRatio: function bjs_setRatio(ratio) {
                    instance.exports.bjs_setRatio(ratio);
                },
                getRatio: function bjs_getRatio() {
                    const ret = instance.exports.bjs_getRatio();
                    return ret;
                },
                roundTripOptionalRatio: function bjs_roundTripOptionalRatio(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalRatio(+isSome, isSome ? input : 0.0);
                    const optResult = tmpRetOptionalDouble;
                    tmpRetOptionalDouble = undefined;
                    return optResult;
                },
                processTheme: function bjs_processTheme(theme) {
                    const themeBytes = textEncoder.encode(theme);
                    const themeId = swift.memory.retain(themeBytes);
                    const ret = instance.exports.bjs_processTheme(themeId, themeBytes.length);
                    return ret;
                },
                convertPriority: function bjs_convertPriority(status) {
                    const ret = instance.exports.bjs_convertPriority(status);
                    return ret;
                },
                validateSession: function bjs_validateSession(session) {
                    instance.exports.bjs_validateSession(session);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                Theme: ThemeValues,
                FeatureFlag: FeatureFlagValues,
                HttpStatus: HttpStatusValues,
                Priority: PriorityValues,
                FileSize: FileSizeValues,
                UserId: UserIdValues,
                TokenId: TokenIdValues,
                SessionId: SessionIdValues,
                Precision: PrecisionValues,
                Ratio: RatioValues,
            };
            _exports = exports;
            return exports;
        },
    }
}