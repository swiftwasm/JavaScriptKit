// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const DirectionValues = {
    North: 0,
    South: 1,
    East: 2,
    West: 3,
};

export const StatusValues = {
    Pending: 0,
    Active: 1,
    Completed: 2,
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
    function __bjs_arrayCodec(elementCodec) {
        return {
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
    }
    function __bjs_optionalCodec(elementCodec, isUndefinedOr = false) {
        return {
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
    }
    function __bjs_dictCodec(valueCodec) {
        return {
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
    const __bjs_codec_Array_String = __bjs_arrayCodec(__bjs_stringCodec);
    const __bjs_codec_Array_Double = __bjs_arrayCodec(__bjs_primitiveCodecs.Double);
    const __bjs_codec_Array_Bool = __bjs_arrayCodec(__bjs_primitiveCodecs.Bool);
    const __bjs_codec_TestModule_Point = {
        lower: (v) => {
            structHelpers.Point.lower(v);
        },
        lift: () => {
            const struct = structHelpers.Point.lift();
            return struct;
        },
    };
    const __bjs_codec_Array_TestModule_Point = __bjs_arrayCodec(__bjs_codec_TestModule_Point);
    const __bjs_codec_TestModule_Direction = {
        lower: (v) => {
            i32Stack.push((v | 0));
        },
        lift: () => {
            const caseId = i32Stack.pop();
            return caseId;
        },
    };
    const __bjs_codec_Array_TestModule_Direction = __bjs_arrayCodec(__bjs_codec_TestModule_Direction);
    const __bjs_codec_TestModule_Status = {
        lower: (v) => {
            i32Stack.push((v | 0));
        },
        lift: () => {
            const rawValue = i32Stack.pop();
            return rawValue;
        },
    };
    const __bjs_codec_Array_TestModule_Status = __bjs_arrayCodec(__bjs_codec_TestModule_Status);
    const __bjs_codec_Surp = {
        lower: (v) => {
            ptrStack.push((v | 0));
        },
        lift: () => {
            const pointer = ptrStack.pop();
            return pointer;
        },
    };
    const __bjs_codec_Array_Surp = __bjs_arrayCodec(__bjs_codec_Surp);
    const __bjs_codec_Sumrp = {
        lower: (v) => {
            ptrStack.push((v | 0));
        },
        lift: () => {
            const pointer = ptrStack.pop();
            return pointer;
        },
    };
    const __bjs_codec_Array_Sumrp = __bjs_arrayCodec(__bjs_codec_Sumrp);
    const __bjs_codec_Sop = {
        lower: (v) => {
            ptrStack.push((v | 0));
        },
        lift: () => {
            const pointer = ptrStack.pop();
            return pointer;
        },
    };
    const __bjs_codec_Array_Sop = __bjs_arrayCodec(__bjs_codec_Sop);
    const __bjs_codec_Optional_Int = __bjs_optionalCodec(__bjs_primitiveCodecs.Int);
    const __bjs_codec_Array_Optional_Int = __bjs_arrayCodec(__bjs_codec_Optional_Int);
    const __bjs_codec_Optional_String = __bjs_optionalCodec(__bjs_stringCodec);
    const __bjs_codec_Array_Optional_String = __bjs_arrayCodec(__bjs_codec_Optional_String);
    const __bjs_codec_Optional_Array_Int = __bjs_optionalCodec(__bjs_codec_Array_Int);
    const __bjs_codec_Optional_TestModule_Point = __bjs_optionalCodec(__bjs_codec_TestModule_Point);
    const __bjs_codec_Array_Optional_TestModule_Point = __bjs_arrayCodec(__bjs_codec_Optional_TestModule_Point);
    const __bjs_codec_Optional_TestModule_Direction = __bjs_optionalCodec(__bjs_codec_TestModule_Direction);
    const __bjs_codec_Array_Optional_TestModule_Direction = __bjs_arrayCodec(__bjs_codec_Optional_TestModule_Direction);
    const __bjs_codec_Optional_TestModule_Status = __bjs_optionalCodec(__bjs_codec_TestModule_Status);
    const __bjs_codec_Array_Optional_TestModule_Status = __bjs_arrayCodec(__bjs_codec_Optional_TestModule_Status);
    const __bjs_codec_Array_Array_Int = __bjs_arrayCodec(__bjs_codec_Array_Int);
    const __bjs_codec_Array_Array_String = __bjs_arrayCodec(__bjs_codec_Array_String);
    const __bjs_codec_Array_Array_TestModule_Point = __bjs_arrayCodec(__bjs_codec_Array_TestModule_Point);
    const __bjs_codec_TestModule_Item = {
        lower: (v) => {
            ptrStack.push(v.pointer);
        },
        lift: () => {
            const ptr = ptrStack.pop();
            const obj = _exports['Item'].__construct(ptr);
            return obj;
        },
    };
    const __bjs_codec_Array_TestModule_Item = __bjs_arrayCodec(__bjs_codec_TestModule_Item);
    const __bjs_codec_Array_Array_TestModule_Item = __bjs_arrayCodec(__bjs_codec_Array_TestModule_Item);
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
    const __bjs_codec_Array_JSObject = __bjs_arrayCodec(__bjs_codec_JSObject);
    const __bjs_codec_Optional_JSObject = __bjs_optionalCodec(__bjs_codec_JSObject);
    const __bjs_codec_Array_Optional_JSObject = __bjs_arrayCodec(__bjs_codec_Optional_JSObject);
    const __bjs_codec_Array_Array_JSObject = __bjs_arrayCodec(__bjs_codec_Array_JSObject);
    const __bjs_codec_Optional_Array_String = __bjs_optionalCodec(__bjs_codec_Array_String);

    const __bjs_createPointHelpers = () => ({
        lower: (value) => {
            f64Stack.push(value.x);
            f64Stack.push(value.y);
        },
        lift: () => {
            const f64 = f64Stack.pop();
            const f641 = f64Stack.pop();
            return { x: f641, y: f64 };
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
            bjs["swift_js_struct_lower_Point"] = function(objectId) {
                structHelpers.Point.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Point"] = function() {
                const value = structHelpers.Point.lift();
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
            importObject["TestModule"]["bjs_Item_wrap"] = function(pointer) {
                const obj = _exports['Item'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_MultiArrayContainer_wrap"] = function(pointer) {
                const obj = _exports['MultiArrayContainer'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_checkArray"] = function bjs_checkArray(a) {
                try {
                    imports.checkArray(swift.memory.getObject(a));
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_checkArrayWithLength"] = function bjs_checkArrayWithLength(a, b) {
                try {
                    imports.checkArrayWithLength(swift.memory.getObject(a), b);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importProcessNumbers"] = function bjs_importProcessNumbers() {
                try {
                    const arrayResult = __bjs_codec_Array_Double.lift();
                    imports.importProcessNumbers(arrayResult);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importGetNumbers"] = function bjs_importGetNumbers() {
                try {
                    let ret = imports.importGetNumbers();
                    __bjs_codec_Array_Double.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importTransformNumbers"] = function bjs_importTransformNumbers() {
                try {
                    const arrayResult = __bjs_codec_Array_Double.lift();
                    let ret = imports.importTransformNumbers(arrayResult);
                    __bjs_codec_Array_Double.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importProcessStrings"] = function bjs_importProcessStrings() {
                try {
                    const arrayResult = __bjs_codec_Array_String.lift();
                    let ret = imports.importProcessStrings(arrayResult);
                    __bjs_codec_Array_String.lower(ret);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importProcessBooleans"] = function bjs_importProcessBooleans() {
                try {
                    const arrayResult = __bjs_codec_Array_Bool.lift();
                    let ret = imports.importProcessBooleans(arrayResult);
                    __bjs_codec_Array_Bool.lower(ret);
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
            class Item extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Item_deinit, Item.prototype, null);
                }

            }
            class MultiArrayContainer extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_MultiArrayContainer_deinit, MultiArrayContainer.prototype, null);
                }

                constructor(nums, strs) {
                    __bjs_codec_Array_Int.lower(nums);
                    __bjs_codec_Array_String.lower(strs);
                    const ret = instance.exports.bjs_MultiArrayContainer_init();
                    return MultiArrayContainer.__construct(ret);
                }
                get numbers() {
                    instance.exports.bjs_MultiArrayContainer_numbers_get(this.pointer);
                    const arrayResult = __bjs_codec_Array_Int.lift();
                    return arrayResult;
                }
                get strings() {
                    instance.exports.bjs_MultiArrayContainer_strings_get(this.pointer);
                    const arrayResult = __bjs_codec_Array_String.lift();
                    return arrayResult;
                }
            }
            const PointHelpers = __bjs_createPointHelpers();
            structHelpers.Point = PointHelpers;

            const exports = {
                processIntArray: function bjs_processIntArray(values) {
                    __bjs_codec_Array_Int.lower(values);
                    instance.exports.bjs_processIntArray();
                    const arrayResult = __bjs_codec_Array_Int.lift();
                    return arrayResult;
                },
                processStringArray: function bjs_processStringArray(values) {
                    __bjs_codec_Array_String.lower(values);
                    instance.exports.bjs_processStringArray();
                    const arrayResult = __bjs_codec_Array_String.lift();
                    return arrayResult;
                },
                processDoubleArray: function bjs_processDoubleArray(values) {
                    __bjs_codec_Array_Double.lower(values);
                    instance.exports.bjs_processDoubleArray();
                    const arrayResult = __bjs_codec_Array_Double.lift();
                    return arrayResult;
                },
                processBoolArray: function bjs_processBoolArray(values) {
                    __bjs_codec_Array_Bool.lower(values);
                    instance.exports.bjs_processBoolArray();
                    const arrayResult = __bjs_codec_Array_Bool.lift();
                    return arrayResult;
                },
                processPointArray: function bjs_processPointArray(points) {
                    __bjs_codec_Array_TestModule_Point.lower(points);
                    instance.exports.bjs_processPointArray();
                    const arrayResult = __bjs_codec_Array_TestModule_Point.lift();
                    return arrayResult;
                },
                processDirectionArray: function bjs_processDirectionArray(directions) {
                    __bjs_codec_Array_TestModule_Direction.lower(directions);
                    instance.exports.bjs_processDirectionArray();
                    const arrayResult = __bjs_codec_Array_TestModule_Direction.lift();
                    return arrayResult;
                },
                processStatusArray: function bjs_processStatusArray(statuses) {
                    __bjs_codec_Array_TestModule_Status.lower(statuses);
                    instance.exports.bjs_processStatusArray();
                    const arrayResult = __bjs_codec_Array_TestModule_Status.lift();
                    return arrayResult;
                },
                sumIntArray: function bjs_sumIntArray(values) {
                    __bjs_codec_Array_Int.lower(values);
                    const ret = instance.exports.bjs_sumIntArray();
                    return ret;
                },
                findFirstPoint: function bjs_findFirstPoint(points, matching) {
                    __bjs_codec_Array_TestModule_Point.lower(points);
                    const matchingBytes = textEncoder.encode(matching);
                    const matchingId = swift.memory.retain(matchingBytes);
                    instance.exports.bjs_findFirstPoint(matchingId, matchingBytes.length);
                    const structValue = structHelpers.Point.lift();
                    return structValue;
                },
                processUnsafeRawPointerArray: function bjs_processUnsafeRawPointerArray(values) {
                    __bjs_codec_Array_Surp.lower(values);
                    instance.exports.bjs_processUnsafeRawPointerArray();
                    const arrayResult = __bjs_codec_Array_Surp.lift();
                    return arrayResult;
                },
                processUnsafeMutableRawPointerArray: function bjs_processUnsafeMutableRawPointerArray(values) {
                    __bjs_codec_Array_Sumrp.lower(values);
                    instance.exports.bjs_processUnsafeMutableRawPointerArray();
                    const arrayResult = __bjs_codec_Array_Sumrp.lift();
                    return arrayResult;
                },
                processOpaquePointerArray: function bjs_processOpaquePointerArray(values) {
                    __bjs_codec_Array_Sop.lower(values);
                    instance.exports.bjs_processOpaquePointerArray();
                    const arrayResult = __bjs_codec_Array_Sop.lift();
                    return arrayResult;
                },
                processOptionalIntArray: function bjs_processOptionalIntArray(values) {
                    __bjs_codec_Array_Optional_Int.lower(values);
                    instance.exports.bjs_processOptionalIntArray();
                    const arrayResult = __bjs_codec_Array_Optional_Int.lift();
                    return arrayResult;
                },
                processOptionalStringArray: function bjs_processOptionalStringArray(values) {
                    __bjs_codec_Array_Optional_String.lower(values);
                    instance.exports.bjs_processOptionalStringArray();
                    const arrayResult = __bjs_codec_Array_Optional_String.lift();
                    return arrayResult;
                },
                processOptionalArray: function bjs_processOptionalArray(values) {
                    __bjs_codec_Optional_Array_Int.lower(values);
                    instance.exports.bjs_processOptionalArray();
                    const optValue = __bjs_codec_Optional_Array_Int.lift();
                    return optValue;
                },
                processOptionalPointArray: function bjs_processOptionalPointArray(points) {
                    __bjs_codec_Array_Optional_TestModule_Point.lower(points);
                    instance.exports.bjs_processOptionalPointArray();
                    const arrayResult = __bjs_codec_Array_Optional_TestModule_Point.lift();
                    return arrayResult;
                },
                processOptionalDirectionArray: function bjs_processOptionalDirectionArray(directions) {
                    __bjs_codec_Array_Optional_TestModule_Direction.lower(directions);
                    instance.exports.bjs_processOptionalDirectionArray();
                    const arrayResult = __bjs_codec_Array_Optional_TestModule_Direction.lift();
                    return arrayResult;
                },
                processOptionalStatusArray: function bjs_processOptionalStatusArray(statuses) {
                    __bjs_codec_Array_Optional_TestModule_Status.lower(statuses);
                    instance.exports.bjs_processOptionalStatusArray();
                    const arrayResult = __bjs_codec_Array_Optional_TestModule_Status.lift();
                    return arrayResult;
                },
                processNestedIntArray: function bjs_processNestedIntArray(values) {
                    __bjs_codec_Array_Array_Int.lower(values);
                    instance.exports.bjs_processNestedIntArray();
                    const arrayResult = __bjs_codec_Array_Array_Int.lift();
                    return arrayResult;
                },
                processNestedStringArray: function bjs_processNestedStringArray(values) {
                    __bjs_codec_Array_Array_String.lower(values);
                    instance.exports.bjs_processNestedStringArray();
                    const arrayResult = __bjs_codec_Array_Array_String.lift();
                    return arrayResult;
                },
                processNestedPointArray: function bjs_processNestedPointArray(points) {
                    __bjs_codec_Array_Array_TestModule_Point.lower(points);
                    instance.exports.bjs_processNestedPointArray();
                    const arrayResult = __bjs_codec_Array_Array_TestModule_Point.lift();
                    return arrayResult;
                },
                processItemArray: function bjs_processItemArray(items) {
                    __bjs_codec_Array_TestModule_Item.lower(items);
                    instance.exports.bjs_processItemArray();
                    const arrayResult = __bjs_codec_Array_TestModule_Item.lift();
                    return arrayResult;
                },
                processNestedItemArray: function bjs_processNestedItemArray(items) {
                    __bjs_codec_Array_Array_TestModule_Item.lower(items);
                    instance.exports.bjs_processNestedItemArray();
                    const arrayResult = __bjs_codec_Array_Array_TestModule_Item.lift();
                    return arrayResult;
                },
                processJSObjectArray: function bjs_processJSObjectArray(objects) {
                    __bjs_codec_Array_JSObject.lower(objects);
                    instance.exports.bjs_processJSObjectArray();
                    const arrayResult = __bjs_codec_Array_JSObject.lift();
                    return arrayResult;
                },
                processOptionalJSObjectArray: function bjs_processOptionalJSObjectArray(objects) {
                    __bjs_codec_Array_Optional_JSObject.lower(objects);
                    instance.exports.bjs_processOptionalJSObjectArray();
                    const arrayResult = __bjs_codec_Array_Optional_JSObject.lift();
                    return arrayResult;
                },
                processNestedJSObjectArray: function bjs_processNestedJSObjectArray(objects) {
                    __bjs_codec_Array_Array_JSObject.lower(objects);
                    instance.exports.bjs_processNestedJSObjectArray();
                    const arrayResult = __bjs_codec_Array_Array_JSObject.lift();
                    return arrayResult;
                },
                multiArrayParams: function bjs_multiArrayParams(nums, strs) {
                    __bjs_codec_Array_Int.lower(nums);
                    __bjs_codec_Array_String.lower(strs);
                    const ret = instance.exports.bjs_multiArrayParams();
                    return ret;
                },
                multiOptionalArrayParams: function bjs_multiOptionalArrayParams(a, b) {
                    __bjs_codec_Optional_Array_Int.lower(a);
                    __bjs_codec_Optional_Array_String.lower(b);
                    const ret = instance.exports.bjs_multiOptionalArrayParams();
                    return ret;
                },
                Direction: DirectionValues,
                Status: StatusValues,
                Item,
                MultiArrayContainer,
            };
            _exports = exports;
            return exports;
        },
    }
}