// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

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

    const __bjs_codec_JSObject = {
        lower: (v) => {
            const objId = swift.memory.retain(v);
            i32Stack.push(objId);
        },
        lift: () => {
            const objId = i32Stack.pop();
            const obj = swift.memory.getObject(objId);
            swift.memory.release(objId);
            return obj;
        },
    };
    const __bjs_codec_Optional_JSObject = __bjs_optionalCodec(__bjs_codec_JSObject);
    const __bjs_codec_TestModule_WithOptionalJSClass = {
        lower: (v) => {
            const objId = swift.memory.retain(v);
            i32Stack.push(objId);
        },
        lift: () => {
            const objId = i32Stack.pop();
            const obj = swift.memory.getObject(objId);
            swift.memory.release(objId);
            return obj;
        },
    };
    const __bjs_codec_Optional_TestModule_WithOptionalJSClass = __bjs_optionalCodec(__bjs_codec_TestModule_WithOptionalJSClass);


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
            importObject["TestModule"]["bjs_Greeter_wrap"] = function(pointer) {
                const obj = _exports['Greeter'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_OptionalPropertyHolder_wrap"] = function(pointer) {
                const obj = _exports['OptionalPropertyHolder'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_WithOptionalJSClass_init"] = function bjs_WithOptionalJSClass_init(valueOrNullIsSome, valueOrNullBytes, valueOrNullCount, valueOrUndefinedIsSome, valueOrUndefinedBytes, valueOrUndefinedCount) {
                try {
                    let optResult;
                    if (valueOrNullIsSome) {
                        const string = decodeString(valueOrNullBytes, valueOrNullCount);
                        optResult = string;
                    } else {
                        optResult = null;
                    }
                    let optResult1;
                    if (valueOrUndefinedIsSome) {
                        const string1 = decodeString(valueOrUndefinedBytes, valueOrUndefinedCount);
                        optResult1 = string1;
                    } else {
                        optResult1 = undefined;
                    }
                    return swift.memory.retain(new imports.WithOptionalJSClass(optResult, optResult1));
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrNull_get"] = function bjs_WithOptionalJSClass_stringOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).stringOrNull;
                    const isSome = ret != null;
                    tmpRetString = isSome ? ret : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrUndefined_get"] = function bjs_WithOptionalJSClass_stringOrUndefined_get(self) {
                try {
                    let ret = swift.memory.getObject(self).stringOrUndefined;
                    const isSome = ret !== undefined;
                    tmpRetString = isSome ? ret : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_doubleOrNull_get"] = function bjs_WithOptionalJSClass_doubleOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).doubleOrNull;
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_double"](isSome ? 1 : 0, isSome ? ret : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_doubleOrUndefined_get"] = function bjs_WithOptionalJSClass_doubleOrUndefined_get(self) {
                try {
                    let ret = swift.memory.getObject(self).doubleOrUndefined;
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_double"](isSome ? 1 : 0, isSome ? ret : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_boolOrNull_get"] = function bjs_WithOptionalJSClass_boolOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).boolOrNull;
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_bool"](isSome ? 1 : 0, isSome ? (ret ? 1 : 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_boolOrUndefined_get"] = function bjs_WithOptionalJSClass_boolOrUndefined_get(self) {
                try {
                    let ret = swift.memory.getObject(self).boolOrUndefined;
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_bool"](isSome ? 1 : 0, isSome ? (ret ? 1 : 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_intOrNull_get"] = function bjs_WithOptionalJSClass_intOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).intOrNull;
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_intOrUndefined_get"] = function bjs_WithOptionalJSClass_intOrUndefined_get(self) {
                try {
                    let ret = swift.memory.getObject(self).intOrUndefined;
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_childOrNull_get"] = function bjs_WithOptionalJSClass_childOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).childOrNull;
                    __bjs_codec_Optional_TestModule_WithOptionalJSClass.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrNull_set"] = function bjs_WithOptionalJSClass_stringOrNull_set(self, newValueIsSome, newValueBytes, newValueCount) {
                try {
                    let optResult;
                    if (newValueIsSome) {
                        const string = decodeString(newValueBytes, newValueCount);
                        optResult = string;
                    } else {
                        optResult = null;
                    }
                    swift.memory.getObject(self).stringOrNull = optResult;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrUndefined_set"] = function bjs_WithOptionalJSClass_stringOrUndefined_set(self, newValueIsSome, newValueBytes, newValueCount) {
                try {
                    let optResult;
                    if (newValueIsSome) {
                        const string = decodeString(newValueBytes, newValueCount);
                        optResult = string;
                    } else {
                        optResult = undefined;
                    }
                    swift.memory.getObject(self).stringOrUndefined = optResult;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_doubleOrNull_set"] = function bjs_WithOptionalJSClass_doubleOrNull_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).doubleOrNull = newValueIsSome ? newValueWrappedValue : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_doubleOrUndefined_set"] = function bjs_WithOptionalJSClass_doubleOrUndefined_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).doubleOrUndefined = newValueIsSome ? newValueWrappedValue : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_boolOrNull_set"] = function bjs_WithOptionalJSClass_boolOrNull_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).boolOrNull = newValueIsSome ? newValueWrappedValue !== 0 : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_boolOrUndefined_set"] = function bjs_WithOptionalJSClass_boolOrUndefined_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).boolOrUndefined = newValueIsSome ? newValueWrappedValue !== 0 : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_intOrNull_set"] = function bjs_WithOptionalJSClass_intOrNull_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).intOrNull = newValueIsSome ? newValueWrappedValue : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_intOrUndefined_set"] = function bjs_WithOptionalJSClass_intOrUndefined_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).intOrUndefined = newValueIsSome ? newValueWrappedValue : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_childOrNull_set"] = function bjs_WithOptionalJSClass_childOrNull_set(self, newValueIsSome, newValueObjectId) {
                try {
                    swift.memory.getObject(self).childOrNull = newValueIsSome ? swift.memory.getObject(newValueObjectId) : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripStringOrNull"] = function bjs_WithOptionalJSClass_roundTripStringOrNull(self, valueIsSome, valueBytes, valueCount) {
                try {
                    let optResult;
                    if (valueIsSome) {
                        const string = decodeString(valueBytes, valueCount);
                        optResult = string;
                    } else {
                        optResult = null;
                    }
                    let ret = swift.memory.getObject(self).roundTripStringOrNull(optResult);
                    const isSome = ret != null;
                    tmpRetString = isSome ? ret : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripStringOrUndefined"] = function bjs_WithOptionalJSClass_roundTripStringOrUndefined(self, valueIsSome, valueBytes, valueCount) {
                try {
                    let optResult;
                    if (valueIsSome) {
                        const string = decodeString(valueBytes, valueCount);
                        optResult = string;
                    } else {
                        optResult = undefined;
                    }
                    let ret = swift.memory.getObject(self).roundTripStringOrUndefined(optResult);
                    const isSome = ret !== undefined;
                    tmpRetString = isSome ? ret : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripDoubleOrNull"] = function bjs_WithOptionalJSClass_roundTripDoubleOrNull(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripDoubleOrNull(valueIsSome ? valueWrappedValue : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_double"](isSome ? 1 : 0, isSome ? ret : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripDoubleOrUndefined"] = function bjs_WithOptionalJSClass_roundTripDoubleOrUndefined(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripDoubleOrUndefined(valueIsSome ? valueWrappedValue : undefined);
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_double"](isSome ? 1 : 0, isSome ? ret : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripBoolOrNull"] = function bjs_WithOptionalJSClass_roundTripBoolOrNull(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripBoolOrNull(valueIsSome ? valueWrappedValue !== 0 : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_bool"](isSome ? 1 : 0, isSome ? (ret ? 1 : 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripBoolOrUndefined"] = function bjs_WithOptionalJSClass_roundTripBoolOrUndefined(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripBoolOrUndefined(valueIsSome ? valueWrappedValue !== 0 : undefined);
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_bool"](isSome ? 1 : 0, isSome ? (ret ? 1 : 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripIntOrNull"] = function bjs_WithOptionalJSClass_roundTripIntOrNull(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripIntOrNull(valueIsSome ? valueWrappedValue : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripIntOrUndefined"] = function bjs_WithOptionalJSClass_roundTripIntOrUndefined(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripIntOrUndefined(valueIsSome ? valueWrappedValue : undefined);
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripChildOrNull"] = function bjs_WithOptionalJSClass_roundTripChildOrNull(self, valueIsSome, valueObjectId) {
                try {
                    let ret = swift.memory.getObject(self).roundTripChildOrNull(valueIsSome ? swift.memory.getObject(valueObjectId) : null);
                    __bjs_codec_Optional_TestModule_WithOptionalJSClass.lower(ret);
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
            class Greeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Greeter_deinit, Greeter.prototype, null);
                }

                constructor(name) {
                    const isSome = name != null;
                    let result, result1;
                    if (isSome) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        result = nameId;
                        result1 = nameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    const ret = instance.exports.bjs_Greeter_init(+isSome, result, result1);
                    return Greeter.__construct(ret);
                }
                greet() {
                    instance.exports.bjs_Greeter_greet(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                changeName(name) {
                    const isSome = name != null;
                    let result, result1;
                    if (isSome) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        result = nameId;
                        result1 = nameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_Greeter_changeName(this.pointer, +isSome, result, result1);
                }
                get name() {
                    instance.exports.bjs_Greeter_name_get(this.pointer);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                set name(value) {
                    const isSome = value != null;
                    let result, result1;
                    if (isSome) {
                        const valueBytes = textEncoder.encode(value);
                        const valueId = swift.memory.retain(valueBytes);
                        result = valueId;
                        result1 = valueBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_Greeter_name_set(this.pointer, +isSome, result, result1);
                }
            }
            class OptionalPropertyHolder extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_OptionalPropertyHolder_deinit, OptionalPropertyHolder.prototype, null);
                }

                constructor() {
                    const ret = instance.exports.bjs_OptionalPropertyHolder_init();
                    return OptionalPropertyHolder.__construct(ret);
                }
                get optionalName() {
                    instance.exports.bjs_OptionalPropertyHolder_optionalName_get(this.pointer);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                set optionalName(value) {
                    const isSome = value != null;
                    let result, result1;
                    if (isSome) {
                        const valueBytes = textEncoder.encode(value);
                        const valueId = swift.memory.retain(valueBytes);
                        result = valueId;
                        result1 = valueBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_OptionalPropertyHolder_optionalName_set(this.pointer, +isSome, result, result1);
                }
                get optionalAge() {
                    instance.exports.bjs_OptionalPropertyHolder_optionalAge_get(this.pointer);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                }
                set optionalAge(value) {
                    const isSome = value != null;
                    instance.exports.bjs_OptionalPropertyHolder_optionalAge_set(this.pointer, +isSome, isSome ? value : 0);
                }
                get optionalGreeter() {
                    instance.exports.bjs_OptionalPropertyHolder_optionalGreeter_get(this.pointer);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : Greeter.__construct(pointer);
                    return optResult;
                }
                set optionalGreeter(value) {
                    const isSome = value != null;
                    let result;
                    if (isSome) {
                        result = value.pointer;
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_OptionalPropertyHolder_optionalGreeter_set(this.pointer, +isSome, result);
                }
            }
            const exports = {
                roundTripOptionalClass: function bjs_roundTripOptionalClass(value) {
                    const isSome = value != null;
                    let result;
                    if (isSome) {
                        result = value.pointer;
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_roundTripOptionalClass(+isSome, result);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : Greeter.__construct(pointer);
                    return optResult;
                },
                testOptionalPropertyRoundtrip: function bjs_testOptionalPropertyRoundtrip(holder) {
                    const isSome = holder != null;
                    let result;
                    if (isSome) {
                        result = holder.pointer;
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_testOptionalPropertyRoundtrip(+isSome, result);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : OptionalPropertyHolder.__construct(pointer);
                    return optResult;
                },
                roundTripExportedOptionalJSObject: function bjs_roundTripExportedOptionalJSObject(value) {
                    const isSome = value != null;
                    let result;
                    if (isSome) {
                        result = swift.memory.retain(value);
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_roundTripExportedOptionalJSObject(+isSome, result);
                    const optValue = __bjs_codec_Optional_JSObject.lift();
                    return optValue;
                },
                roundTripExportedOptionalJSClass: function bjs_roundTripExportedOptionalJSClass(value) {
                    const isSome = value != null;
                    let result;
                    if (isSome) {
                        result = swift.memory.retain(value);
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_roundTripExportedOptionalJSClass(+isSome, result);
                    const optValue = __bjs_codec_Optional_TestModule_WithOptionalJSClass.lift();
                    return optValue;
                },
                roundTripString: function bjs_roundTripString(name) {
                    const isSome = name != null;
                    let result, result1;
                    if (isSome) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        result = nameId;
                        result1 = nameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripString(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripInt: function bjs_roundTripInt(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripInt(+isSome, isSome ? value : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripInt8: function bjs_roundTripInt8(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripInt8(+isSome, isSome ? value : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripUInt8: function bjs_roundTripUInt8(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripUInt8(+isSome, isSome ? value : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripInt16: function bjs_roundTripInt16(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripInt16(+isSome, isSome ? value : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripUInt16: function bjs_roundTripUInt16(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripUInt16(+isSome, isSome ? value : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripInt32: function bjs_roundTripInt32(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripInt32(+isSome, isSome ? value : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripUInt32: function bjs_roundTripUInt32(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripUInt32(+isSome, isSome ? value : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripBool: function bjs_roundTripBool(flag) {
                    const isSome = flag != null;
                    instance.exports.bjs_roundTripBool(+isSome, isSome ? flag ? 1 : 0 : 0);
                    const optResult = tmpRetOptionalBool;
                    tmpRetOptionalBool = undefined;
                    return optResult;
                },
                roundTripFloat: function bjs_roundTripFloat(number) {
                    const isSome = number != null;
                    instance.exports.bjs_roundTripFloat(+isSome, isSome ? number : 0.0);
                    const optResult = tmpRetOptionalFloat;
                    tmpRetOptionalFloat = undefined;
                    return optResult;
                },
                roundTripDouble: function bjs_roundTripDouble(precision) {
                    const isSome = precision != null;
                    instance.exports.bjs_roundTripDouble(+isSome, isSome ? precision : 0.0);
                    const optResult = tmpRetOptionalDouble;
                    tmpRetOptionalDouble = undefined;
                    return optResult;
                },
                roundTripSyntax: function bjs_roundTripSyntax(name) {
                    const isSome = name != null;
                    let result, result1;
                    if (isSome) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        result = nameId;
                        result1 = nameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripSyntax(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripMixSyntax: function bjs_roundTripMixSyntax(name) {
                    const isSome = name != null;
                    let result, result1;
                    if (isSome) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        result = nameId;
                        result1 = nameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripMixSyntax(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripSwiftSyntax: function bjs_roundTripSwiftSyntax(name) {
                    const isSome = name != null;
                    let result, result1;
                    if (isSome) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        result = nameId;
                        result1 = nameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripSwiftSyntax(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripMixedSwiftSyntax: function bjs_roundTripMixedSwiftSyntax(name) {
                    const isSome = name != null;
                    let result, result1;
                    if (isSome) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        result = nameId;
                        result1 = nameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripMixedSwiftSyntax(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripWithSpaces: function bjs_roundTripWithSpaces(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripWithSpaces(+isSome, isSome ? value : 0.0);
                    const optResult = tmpRetOptionalDouble;
                    tmpRetOptionalDouble = undefined;
                    return optResult;
                },
                roundTripAlias: function bjs_roundTripAlias(age) {
                    const isSome = age != null;
                    instance.exports.bjs_roundTripAlias(+isSome, isSome ? age : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripOptionalAlias: function bjs_roundTripOptionalAlias(name) {
                    const isSome = name != null;
                    let result, result1;
                    if (isSome) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        result = nameId;
                        result1 = nameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalAlias(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                testMixedOptionals: function bjs_testMixedOptionals(firstName, lastName, age, active) {
                    const isSome = firstName != null;
                    let result, result1;
                    if (isSome) {
                        const firstNameBytes = textEncoder.encode(firstName);
                        const firstNameId = swift.memory.retain(firstNameBytes);
                        result = firstNameId;
                        result1 = firstNameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    const isSome1 = lastName != null;
                    let result2, result3;
                    if (isSome1) {
                        const lastNameBytes = textEncoder.encode(lastName);
                        const lastNameId = swift.memory.retain(lastNameBytes);
                        result2 = lastNameId;
                        result3 = lastNameBytes.length;
                    } else {
                        result2 = 0;
                        result3 = 0;
                    }
                    const isSome2 = age != null;
                    instance.exports.bjs_testMixedOptionals(+isSome, result, result1, +isSome1, result2, result3, +isSome2, isSome2 ? age : 0, active);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                Greeter,
                OptionalPropertyHolder,
            };
            _exports = exports;
            return exports;
        },
    }
}