// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const GenericColorValues = {
    Red: 0,
    Green: 1,
};

export const GenericModeValues = {
    Light: "light",
    Dark: "dark",
};

export const GenericTaggedValues = {
    Tag: {
        Number: 0,
        Text: 1,
    },
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
    const __bjs_codecByTypeId = new Map();
    let __bjs_typeHandlesRegistered = false;
    function __bjs_registerTypeHandles() {
        if (__bjs_typeHandlesRegistered) {
            return;
        }
        __bjs_typeHandlesRegistered = true;
        instance.exports["bjs_core_register_type_handles"]();
        instance.exports["bjs_TestModule_register_type_handles"]?.();
    }
    function __bjs_codecForTypeId(typeId) {
        __bjs_registerTypeHandles();
        const codec = __bjs_codecByTypeId.get(typeId);
        if (!codec) {
            throw new Error("BridgeJS: no codec registered for type ID " + typeId);
        }
        return codec;
    }

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

    const __bjs_codec_Array_Int = __bjs_arrayCodec(__bjs_primitiveCodecs.Int);
    const __bjs_codec_Optional_Array_Int = __bjs_optionalCodec(__bjs_codec_Array_Int);
    const __bjs_codec_M10TestModuleT12GenericPoint = {
        lower: (v) => {
            structHelpers.M10TestModuleT12GenericPoint.lower(v);
        },
        lift: () => {
            const struct = structHelpers.M10TestModuleT12GenericPoint.lift();
            return struct;
        },
    };
    const __bjs_codec_M10TestModuleT16GenericImportBox = {
        lower: (v) => {
            ptrStack.push(v.pointer);
        },
        lift: () => {
            const ptr = ptrStack.pop();
            const obj = _exports['GenericImportBox'].__construct(ptr);
            return obj;
        },
    };
    const __bjs_codec_M10TestModuleT12GenericColor = {
        lower: (v) => {
            i32Stack.push((v | 0));
        },
        lift: () => {
            const caseId = i32Stack.pop();
            return caseId;
        },
    };
    const __bjs_codec_M10TestModuleT13GenericTagged = {
        lower: (v) => {
            const caseId = enumHelpers.M10TestModuleT13GenericTagged.lower(v);
            i32Stack.push(caseId);
        },
        lift: () => {
            const enumValue = enumHelpers.M10TestModuleT13GenericTagged.lift(i32Stack.pop());
            return enumValue;
        },
    };

    const __bjs_createStructHelpers_M10TestModuleT12GenericPoint = () => ({
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
    const __bjs_createEnumHelpers_M10TestModuleT13GenericTagged = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case GenericTaggedValues.Tag.Number: {
                    i32Stack.push((value.value | 0));
                    return GenericTaggedValues.Tag.Number;
                }
                case GenericTaggedValues.Tag.Text: {
                    const bytes = textEncoder.encode(value.value);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return GenericTaggedValues.Tag.Text;
                }
                default: throw new Error("Unknown GenericTaggedValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case GenericTaggedValues.Tag.Number: {
                    const int = i32Stack.pop();
                    return { tag: GenericTaggedValues.Tag.Number, value: int };
                }
                case GenericTaggedValues.Tag.Text: {
                    const string = strStack.pop();
                    return { tag: GenericTaggedValues.Tag.Text, value: string };
                }
                default: throw new Error("Unknown GenericTaggedValues tag returned from Swift: " + String(tag));
            }
        }
    });

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
            bjs["swift_js_struct_lower_GenericPoint"] = function(objectId) {
                structHelpers.M10TestModuleT12GenericPoint.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_GenericPoint"] = function() {
                const value = structHelpers.M10TestModuleT12GenericPoint.lift();
                return swift.memory.retain(value);
            }
            bjs["bjs_core_register_type_handles"] = function(base, count) {
                const codecs = [
                    __bjs_primitiveCodecs.Bool,
                    __bjs_primitiveCodecs.Int,
                    __bjs_primitiveCodecs.Int8,
                    __bjs_primitiveCodecs.UInt8,
                    __bjs_primitiveCodecs.Int16,
                    __bjs_primitiveCodecs.UInt16,
                    __bjs_primitiveCodecs.Int32,
                    __bjs_primitiveCodecs.UInt32,
                    __bjs_primitiveCodecs.UInt,
                    __bjs_primitiveCodecs.Int64,
                    __bjs_primitiveCodecs.UInt64,
                    __bjs_primitiveCodecs.Float,
                    __bjs_primitiveCodecs.Double,
                    __bjs_primitiveCodecs.String,
                    __bjs_primitiveCodecs.JSValue,
                ];
                const typeIds = new Int32Array(memory.buffer, base >>> 0, count >>> 0);
                for (let i = 0; i < count; i++) {
                    __bjs_codecByTypeId.set(typeIds[i], codecs[i]);
                }
            }
            bjs["bjs_TestModule_register_type_handles"] = function(base, count) {
                const codecs = [
                    __bjs_codec_M10TestModuleT12GenericPoint,
                    __bjs_codec_M10TestModuleT16GenericImportBox,
                    __bjs_codec_M10TestModuleT12GenericColor,
                    __bjs_stringCodec,
                    __bjs_codec_M10TestModuleT13GenericTagged,
                ];
                const typeIds = new Int32Array(memory.buffer, base >>> 0, count >>> 0);
                for (let i = 0; i < count; i++) {
                    __bjs_codecByTypeId.set(typeIds[i], codecs[i]);
                }
            }
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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_GenericImportBox_wrap"] = function(pointer) {
                const obj = _exports['GenericImportBox'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_genericRoundTrip"] = function bjs_genericRoundTrip(tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const value = codecT.lift();
                    let ret = imports.genericRoundTrip(value);
                    codecT.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_genericParse"] = function bjs_genericParse(jsonBytes, jsonCount, tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const string = decodeString(jsonBytes, jsonCount);
                    let ret = imports.genericParse(string);
                    codecT.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importGenericCombine"] = function bjs_importGenericCombine(tTypeId, uTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const codecU = __bjs_codecForTypeId(uTypeId);
                    const a = codecT.lift();
                    const b = codecU.lift();
                    let ret = imports.importGenericCombine(a, b);
                    codecU.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importGenericCaseDistinct"] = function bjs_importGenericCaseDistinct(tTypeId, tTypeId1) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const codect = __bjs_codecForTypeId(tTypeId1);
                    const a = codecT.lift();
                    const b = codect.lift();
                    let ret = imports.importGenericCaseDistinct(a, b);
                    codecT.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importGenericArray"] = function bjs_importGenericArray(tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const values = __bjs_arrayCodec(codecT).lift();
                    let ret = imports.importGenericArray(values);
                    __bjs_arrayCodec(codecT).lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importGenericOptional"] = function bjs_importGenericOptional(tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const value = __bjs_optionalCodec(codecT).lift();
                    let ret = imports.importGenericOptional(value);
                    __bjs_optionalCodec(codecT).lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importGenericDictionary"] = function bjs_importGenericDictionary(tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const values = __bjs_dictCodec(codecT).lift();
                    let ret = imports.importGenericDictionary(values);
                    __bjs_dictCodec(codecT).lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importGenericAfterOptionalArray"] = function bjs_importGenericAfterOptionalArray(tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const optValue = __bjs_codec_Optional_Array_Int.lift();
                    const value = codecT.lift();
                    let ret = imports.importGenericAfterOptionalArray(optValue, value);
                    codecT.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_GenericPairFactory_init"] = function bjs_GenericPairFactory_init(tagBytes, tagCount, tTypeId, uTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const codecU = __bjs_codecForTypeId(uTypeId);
                    const string = decodeString(tagBytes, tagCount);
                    const first = codecT.lift();
                    const second = codecU.lift();
                    return swift.memory.retain(new imports.GenericPairFactory(string, first, second));
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_GenericConsumer_init"] = function bjs_GenericConsumer_init(tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const value = codecT.lift();
                    return swift.memory.retain(new imports.GenericConsumer(value));
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_GenericConsumer_box_static"] = function bjs_GenericConsumer_box_static(tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const value = codecT.lift();
                    let ret = imports.GenericConsumer.box(value);
                    codecT.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_GenericConsumer_accept"] = function bjs_GenericConsumer_accept(self, tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const value = codecT.lift();
                    swift.memory.getObject(self).accept(value);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_GenericConsumer_identity"] = function bjs_GenericConsumer_identity(self, tTypeId) {
                try {
                    const codecT = __bjs_codecForTypeId(tTypeId);
                    const value = codecT.lift();
                    let ret = swift.memory.getObject(self).identity(value);
                    codecT.lower(ret);
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
            const swiftHeapObjectFinalizationRegistry = (typeof FinalizationRegistry === "undefined") ? { register: () => {}, unregister: () => {} } : new FinalizationRegistry((state) => {
                if (state.hasReleased) {
                    return;
                }
                state.hasReleased = true;
                state.identityMap?.delete(state.pointer);
                state.deinit(state.pointer);
            });

            /// Represents a Swift heap object like a class instance or an actor instance.
            class SwiftHeapObject {
                static __wrap(pointer, deinit, prototype, identityCache) {
                    pointer = pointer >>> 0;
                    const makeFresh = (identityMap) => {
                        const obj = Object.create(prototype);
                        const state = { pointer, deinit, hasReleased: false, identityMap };
                        obj.pointer = pointer;
                        obj.__swiftHeapObjectState = state;
                        swiftHeapObjectFinalizationRegistry.register(obj, state, state);
                        if (identityMap) {
                            identityMap.set(pointer, new WeakRef(obj));
                        }
                        return obj;
                    };

                    if (!identityCache) {
                        return makeFresh(null);
                    }

                    const cached = identityCache.get(pointer)?.deref();
                    if (cached && !cached.__swiftHeapObjectState.hasReleased) {
                        deinit(pointer);
                        return cached;
                    }
                    if (identityCache.has(pointer)) {
                        identityCache.delete(pointer);
                    }

                    return makeFresh(identityCache);
                }

                release() {
                    const state = this.__swiftHeapObjectState;
                    if (state.hasReleased) {
                        return;
                    }
                    state.hasReleased = true;
                    swiftHeapObjectFinalizationRegistry.unregister(state);
                    state.identityMap?.delete(state.pointer);
                    state.deinit(state.pointer);
                }
            }
            class GenericImportBox extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_GenericImportBox_deinit, GenericImportBox.prototype, null);
                }

                constructor(value) {
                    const ret = instance.exports.bjs_GenericImportBox_init(value);
                    return GenericImportBox.__construct(ret);
                }
                get() {
                    const ret = instance.exports.bjs_GenericImportBox_get(this.pointer);
                    return ret;
                }
                get value() {
                    const ret = instance.exports.bjs_GenericImportBox_value_get(this.pointer);
                    return ret;
                }
                set value(value) {
                    instance.exports.bjs_GenericImportBox_value_set(this.pointer, value);
                }
            }
            const __bjs_helpers_M10TestModuleT12GenericPoint = __bjs_createStructHelpers_M10TestModuleT12GenericPoint();
            structHelpers.M10TestModuleT12GenericPoint = __bjs_helpers_M10TestModuleT12GenericPoint;

            const __bjs_helpers_M10TestModuleT13GenericTagged = __bjs_createEnumHelpers_M10TestModuleT13GenericTagged();
            enumHelpers.M10TestModuleT13GenericTagged = __bjs_helpers_M10TestModuleT13GenericTagged;

            const exports = {
                GenericColor: GenericColorValues,
                GenericMode: GenericModeValues,
                GenericTagged: GenericTaggedValues,
                GenericImportBox,
            };
            _exports = exports;
            return exports;
        },
    }
}