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

export const ExampleEnumValues = {
    Test: "test",
    Test2: "test2",
};

export const ResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
    },
};
export const PriorityValues = {
    Low: -1,
    Medium: 0,
    High: 1,
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

    const __bjs_codec_TestModule_MyViewControllerDelegate = {
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
    const __bjs_codec_Array_TestModule_MyViewControllerDelegate = __bjs_arrayCodec(__bjs_codec_TestModule_MyViewControllerDelegate);
    const __bjs_codec_Dict_TestModule_MyViewControllerDelegate = __bjs_dictCodec(__bjs_codec_TestModule_MyViewControllerDelegate);

    const __bjs_createResultValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case ResultValues.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return ResultValues.Tag.Success;
                }
                case ResultValues.Tag.Failure: {
                    i32Stack.push((value.param0 | 0));
                    return ResultValues.Tag.Failure;
                }
                default: throw new Error("Unknown ResultValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case ResultValues.Tag.Success: {
                    const string = strStack.pop();
                    return { tag: ResultValues.Tag.Success, param0: string };
                }
                case ResultValues.Tag.Failure: {
                    const int = i32Stack.pop();
                    return { tag: ResultValues.Tag.Failure, param0: int };
                }
                default: throw new Error("Unknown ResultValues tag returned from Swift: " + String(tag));
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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_DelegateManager_wrap"] = function(pointer) {
                const obj = _exports['DelegateManager'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_Helper_wrap"] = function(pointer) {
                const obj = _exports['Helper'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_MyViewController_wrap"] = function(pointer) {
                const obj = _exports['MyViewController'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_MyViewControllerDelegate_eventCount_get"] = function bjs_MyViewControllerDelegate_eventCount_get(self) {
                try {
                    let ret = swift.memory.getObject(self).eventCount;
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_eventCount_set"] = function bjs_MyViewControllerDelegate_eventCount_set(self, value) {
                try {
                    swift.memory.getObject(self).eventCount = value;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_delegateName_get"] = function bjs_MyViewControllerDelegate_delegateName_get(self) {
                try {
                    let ret = swift.memory.getObject(self).delegateName;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalName_get"] = function bjs_MyViewControllerDelegate_optionalName_get(self) {
                try {
                    let ret = swift.memory.getObject(self).optionalName;
                    tmpRetString = ret;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalName_set"] = function bjs_MyViewControllerDelegate_optionalName_set(self, valueIsSome, valueBytes, valueCount) {
                try {
                    let optResult;
                    if (valueIsSome) {
                        const string = decodeString(valueBytes, valueCount);
                        optResult = string;
                    } else {
                        optResult = null;
                    }
                    swift.memory.getObject(self).optionalName = optResult;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalRawEnum_get"] = function bjs_MyViewControllerDelegate_optionalRawEnum_get(self) {
                try {
                    let ret = swift.memory.getObject(self).optionalRawEnum;
                    tmpRetString = ret;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalRawEnum_set"] = function bjs_MyViewControllerDelegate_optionalRawEnum_set(self, valueIsSome, valueBytes, valueCount) {
                try {
                    let optResult;
                    if (valueIsSome) {
                        const string = decodeString(valueBytes, valueCount);
                        optResult = string;
                    } else {
                        optResult = null;
                    }
                    swift.memory.getObject(self).optionalRawEnum = optResult;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_rawStringEnum_get"] = function bjs_MyViewControllerDelegate_rawStringEnum_get(self) {
                try {
                    let ret = swift.memory.getObject(self).rawStringEnum;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_rawStringEnum_set"] = function bjs_MyViewControllerDelegate_rawStringEnum_set(self, valueBytes, valueCount) {
                try {
                    const string = decodeString(valueBytes, valueCount);
                    swift.memory.getObject(self).rawStringEnum = string;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_result_get"] = function bjs_MyViewControllerDelegate_result_get(self) {
                try {
                    let ret = swift.memory.getObject(self).result;
                    const caseId = enumHelpers.Result.lower(ret);
                    return caseId;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_result_set"] = function bjs_MyViewControllerDelegate_result_set(self, value) {
                try {
                    const enumValue = enumHelpers.Result.lift(value);
                    swift.memory.getObject(self).result = enumValue;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalResult_get"] = function bjs_MyViewControllerDelegate_optionalResult_get(self) {
                try {
                    let ret = swift.memory.getObject(self).optionalResult;
                    const isSome = ret != null;
                    if (isSome) {
                        const caseId = enumHelpers.Result.lower(ret);
                        return caseId;
                    } else {
                        return -1;
                    }
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalResult_set"] = function bjs_MyViewControllerDelegate_optionalResult_set(self, valueIsSome, valueCaseId) {
                try {
                    let optResult;
                    if (valueIsSome) {
                        const enumValue = enumHelpers.Result.lift(valueCaseId);
                        optResult = enumValue;
                    } else {
                        optResult = null;
                    }
                    swift.memory.getObject(self).optionalResult = optResult;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_direction_get"] = function bjs_MyViewControllerDelegate_direction_get(self) {
                try {
                    let ret = swift.memory.getObject(self).direction;
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_direction_set"] = function bjs_MyViewControllerDelegate_direction_set(self, value) {
                try {
                    swift.memory.getObject(self).direction = value;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_directionOptional_get"] = function bjs_MyViewControllerDelegate_directionOptional_get(self) {
                try {
                    let ret = swift.memory.getObject(self).directionOptional;
                    const isSome = ret != null;
                    return isSome ? ret : -1;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_directionOptional_set"] = function bjs_MyViewControllerDelegate_directionOptional_set(self, valueIsSome, valueWrappedValue) {
                try {
                    swift.memory.getObject(self).directionOptional = valueIsSome ? valueWrappedValue : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_priority_get"] = function bjs_MyViewControllerDelegate_priority_get(self) {
                try {
                    let ret = swift.memory.getObject(self).priority;
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_priority_set"] = function bjs_MyViewControllerDelegate_priority_set(self, value) {
                try {
                    swift.memory.getObject(self).priority = value;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_priorityOptional_get"] = function bjs_MyViewControllerDelegate_priorityOptional_get(self) {
                try {
                    let ret = swift.memory.getObject(self).priorityOptional;
                    tmpRetOptionalInt = ret;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_priorityOptional_set"] = function bjs_MyViewControllerDelegate_priorityOptional_set(self, valueIsSome, valueWrappedValue) {
                try {
                    swift.memory.getObject(self).priorityOptional = valueIsSome ? valueWrappedValue : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onSomethingHappened"] = function bjs_MyViewControllerDelegate_onSomethingHappened(self) {
                try {
                    swift.memory.getObject(self).onSomethingHappened();
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onValueChanged"] = function bjs_MyViewControllerDelegate_onValueChanged(self, valueBytes, valueCount) {
                try {
                    const string = decodeString(valueBytes, valueCount);
                    swift.memory.getObject(self).onValueChanged(string);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onCountUpdated"] = function bjs_MyViewControllerDelegate_onCountUpdated(self, count) {
                try {
                    let ret = swift.memory.getObject(self).onCountUpdated(count);
                    return ret ? 1 : 0;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onLabelUpdated"] = function bjs_MyViewControllerDelegate_onLabelUpdated(self, prefixBytes, prefixCount, suffixBytes, suffixCount) {
                try {
                    const string = decodeString(prefixBytes, prefixCount);
                    const string1 = decodeString(suffixBytes, suffixCount);
                    swift.memory.getObject(self).onLabelUpdated(string, string1);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_isCountEven"] = function bjs_MyViewControllerDelegate_isCountEven(self) {
                try {
                    let ret = swift.memory.getObject(self).isCountEven();
                    return ret ? 1 : 0;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onHelperUpdated"] = function bjs_MyViewControllerDelegate_onHelperUpdated(self, helper) {
                try {
                    swift.memory.getObject(self).onHelperUpdated(_exports['Helper'].__construct(helper));
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_createHelper"] = function bjs_MyViewControllerDelegate_createHelper(self) {
                try {
                    let ret = swift.memory.getObject(self).createHelper();
                    return ret.pointer;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onOptionalHelperUpdated"] = function bjs_MyViewControllerDelegate_onOptionalHelperUpdated(self, helperIsSome, helperPointer) {
                try {
                    swift.memory.getObject(self).onOptionalHelperUpdated(helperIsSome ? _exports['Helper'].__construct(helperPointer) : null);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_createOptionalHelper"] = function bjs_MyViewControllerDelegate_createOptionalHelper(self) {
                try {
                    let ret = swift.memory.getObject(self).createOptionalHelper();
                    const isSome = ret != null;
                    return isSome ? ret.pointer : 0;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_createEnum"] = function bjs_MyViewControllerDelegate_createEnum(self) {
                try {
                    let ret = swift.memory.getObject(self).createEnum();
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_handleResult"] = function bjs_MyViewControllerDelegate_handleResult(self, result) {
                try {
                    const enumValue = enumHelpers.Result.lift(result);
                    swift.memory.getObject(self).handleResult(enumValue);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_getResult"] = function bjs_MyViewControllerDelegate_getResult(self) {
                try {
                    let ret = swift.memory.getObject(self).getResult();
                    const caseId = enumHelpers.Result.lower(ret);
                    return caseId;
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
            class Helper extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Helper_deinit, Helper.prototype, null);
                }

                constructor(value) {
                    const ret = instance.exports.bjs_Helper_init(value);
                    return Helper.__construct(ret);
                }
                increment() {
                    instance.exports.bjs_Helper_increment(this.pointer);
                }
                get value() {
                    const ret = instance.exports.bjs_Helper_value_get(this.pointer);
                    return ret;
                }
                set value(value) {
                    instance.exports.bjs_Helper_value_set(this.pointer, value);
                }
            }
            class MyViewController extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_MyViewController_deinit, MyViewController.prototype, null);
                }

                constructor(delegate) {
                    const ret = instance.exports.bjs_MyViewController_init(swift.memory.retain(delegate));
                    return MyViewController.__construct(ret);
                }
                triggerEvent() {
                    instance.exports.bjs_MyViewController_triggerEvent(this.pointer);
                }
                updateValue(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_MyViewController_updateValue(this.pointer, valueId, valueBytes.length);
                }
                updateCount(count) {
                    const ret = instance.exports.bjs_MyViewController_updateCount(this.pointer, count);
                    return ret !== 0;
                }
                updateLabel(prefix, suffix) {
                    const prefixBytes = textEncoder.encode(prefix);
                    const prefixId = swift.memory.retain(prefixBytes);
                    const suffixBytes = textEncoder.encode(suffix);
                    const suffixId = swift.memory.retain(suffixBytes);
                    instance.exports.bjs_MyViewController_updateLabel(this.pointer, prefixId, prefixBytes.length, suffixId, suffixBytes.length);
                }
                checkEvenCount() {
                    const ret = instance.exports.bjs_MyViewController_checkEvenCount(this.pointer);
                    return ret !== 0;
                }
                sendHelper(helper) {
                    instance.exports.bjs_MyViewController_sendHelper(this.pointer, helper.pointer);
                }
                get delegate() {
                    const ret = instance.exports.bjs_MyViewController_delegate_get(this.pointer);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                }
                set delegate(value) {
                    instance.exports.bjs_MyViewController_delegate_set(this.pointer, swift.memory.retain(value));
                }
                get secondDelegate() {
                    instance.exports.bjs_MyViewController_secondDelegate_get(this.pointer);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                set secondDelegate(value) {
                    const isSome = value != null;
                    let result;
                    if (isSome) {
                        result = swift.memory.retain(value);
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_MyViewController_secondDelegate_set(this.pointer, +isSome, result);
                }
            }
            class DelegateManager extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_DelegateManager_deinit, DelegateManager.prototype, null);
                }

                constructor(delegates) {
                    __bjs_codec_Array_TestModule_MyViewControllerDelegate.lower(delegates);
                    const ret = instance.exports.bjs_DelegateManager_init();
                    return DelegateManager.__construct(ret);
                }
                notifyAll() {
                    instance.exports.bjs_DelegateManager_notifyAll(this.pointer);
                }
                get delegates() {
                    instance.exports.bjs_DelegateManager_delegates_get(this.pointer);
                    const arrayResult = __bjs_codec_Array_TestModule_MyViewControllerDelegate.lift();
                    return arrayResult;
                }
                set delegates(value) {
                    __bjs_codec_Array_TestModule_MyViewControllerDelegate.lower(value);
                    instance.exports.bjs_DelegateManager_delegates_set(this.pointer);
                }
                get delegatesByName() {
                    instance.exports.bjs_DelegateManager_delegatesByName_get(this.pointer);
                    const dictResult = __bjs_codec_Dict_TestModule_MyViewControllerDelegate.lift();
                    return dictResult;
                }
                set delegatesByName(value) {
                    __bjs_codec_Dict_TestModule_MyViewControllerDelegate.lower(value);
                    instance.exports.bjs_DelegateManager_delegatesByName_set(this.pointer);
                }
            }
            const ResultHelpers = __bjs_createResultValuesHelpers();
            enumHelpers.Result = ResultHelpers;

            const exports = {
                processDelegates: function bjs_processDelegates(delegates) {
                    __bjs_codec_Array_TestModule_MyViewControllerDelegate.lower(delegates);
                    instance.exports.bjs_processDelegates();
                    const arrayResult = __bjs_codec_Array_TestModule_MyViewControllerDelegate.lift();
                    return arrayResult;
                },
                processDelegatesByName: function bjs_processDelegatesByName(delegates) {
                    __bjs_codec_Dict_TestModule_MyViewControllerDelegate.lower(delegates);
                    instance.exports.bjs_processDelegatesByName();
                    const dictResult = __bjs_codec_Dict_TestModule_MyViewControllerDelegate.lift();
                    return dictResult;
                },
                Direction: DirectionValues,
                ExampleEnum: ExampleEnumValues,
                Result: ResultValues,
                Priority: PriorityValues,
                DelegateManager,
                Helper,
                MyViewController,
            };
            _exports = exports;
            return exports;
        },
    }
}