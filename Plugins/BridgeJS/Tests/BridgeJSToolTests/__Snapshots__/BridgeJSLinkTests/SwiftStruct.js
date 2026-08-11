// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const PrecisionValues = {
    Rough: 0.1,
    Fine: 0.001,
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

    const __bjs_codec_Optional_Int = __bjs_optionalCodec(__bjs_primitiveCodecs.Int);
    const __bjs_codec_Optional_Bool = __bjs_optionalCodec(__bjs_primitiveCodecs.Bool);
    const __bjs_codec_Optional_String = __bjs_optionalCodec(__bjs_stringCodec);
    const __bjs_codec_TestModule_Precision = {
        lower: (v) => {
            f32Stack.push(Math.fround(v));
        },
        lift: () => {
            const rawValue = f32Stack.pop();
            return rawValue;
        },
    };
    const __bjs_codec_Optional_TestModule_Precision = __bjs_optionalCodec(__bjs_codec_TestModule_Precision);
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

    const __bjs_createDataPointHelpers = () => ({
        lower: (value) => {
            f64Stack.push(value.x);
            f64Stack.push(value.y);
            const bytes = textEncoder.encode(value.label);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
            __bjs_codec_Optional_Int.lower(value.optCount);
            __bjs_codec_Optional_Bool.lower(value.optFlag);
        },
        lift: () => {
            const optValue = __bjs_codec_Optional_Bool.lift();
            const optValue1 = __bjs_codec_Optional_Int.lift();
            const string = strStack.pop();
            const f64 = f64Stack.pop();
            const f641 = f64Stack.pop();
            return { x: f641, y: f64, label: string, optCount: optValue1, optFlag: optValue };
        }
    });
    const __bjs_createAddressHelpers = () => ({
        lower: (value) => {
            const bytes = textEncoder.encode(value.street);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
            const bytes1 = textEncoder.encode(value.city);
            const id1 = swift.memory.retain(bytes1);
            i32Stack.push(bytes1.length);
            i32Stack.push(id1);
            __bjs_codec_Optional_Int.lower(value.zipCode);
        },
        lift: () => {
            const optValue = __bjs_codec_Optional_Int.lift();
            const string = strStack.pop();
            const string1 = strStack.pop();
            return { street: string1, city: string, zipCode: optValue };
        }
    });
    const __bjs_createPersonHelpers = () => ({
        lower: (value) => {
            const bytes = textEncoder.encode(value.name);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
            i32Stack.push((value.age | 0));
            structHelpers.Address.lower(value.address);
            __bjs_codec_Optional_String.lower(value.email);
        },
        lift: () => {
            const optValue = __bjs_codec_Optional_String.lift();
            const struct = structHelpers.Address.lift();
            const int = i32Stack.pop();
            const string = strStack.pop();
            return { name: string, age: int, address: struct, email: optValue };
        }
    });
    const __bjs_createSessionHelpers = () => ({
        lower: (value) => {
            i32Stack.push((value.id | 0));
            ptrStack.push(value.owner.pointer);
        },
        lift: () => {
            const ptr = ptrStack.pop();
            const obj = _exports['Greeter'].__construct(ptr);
            const int = i32Stack.pop();
            return { id: int, owner: obj };
        }
    });
    const __bjs_createMeasurementHelpers = () => ({
        lower: (value) => {
            f64Stack.push(value.value);
            f32Stack.push(Math.fround(value.precision));
            __bjs_codec_Optional_TestModule_Precision.lower(value.optionalPrecision);
        },
        lift: () => {
            const optValue = __bjs_codec_Optional_TestModule_Precision.lift();
            const rawValue = f32Stack.pop();
            const f64 = f64Stack.pop();
            return { value: f64, precision: rawValue, optionalPrecision: optValue };
        }
    });
    const __bjs_createConfigStructHelpers = () => ({
        lower: (value) => {
        },
        lift: () => {
            return {  };
        }
    });
    const __bjs_createContainerHelpers = () => ({
        lower: (value) => {
            let id;
            if (value.object != null) {
                id = swift.memory.retain(value.object);
            } else {
                id = undefined;
            }
            i32Stack.push(id !== undefined ? id : 0);
            __bjs_codec_Optional_JSObject.lower(value.optionalObject);
        },
        lift: () => {
            const optValue = __bjs_codec_Optional_JSObject.lift();
            const objectId = i32Stack.pop();
            let value;
            if (objectId !== 0) {
                value = swift.memory.getObject(objectId);
                swift.memory.release(objectId);
            } else {
                value = null;
            }
            return { object: value, optionalObject: optValue };
        }
    });
    const __bjs_createVector2DHelpers = () => ({
        lower: (value) => {
            f64Stack.push(value.dx);
            f64Stack.push(value.dy);
        },
        lift: () => {
            const f64 = f64Stack.pop();
            const f641 = f64Stack.pop();
            const instance1 = { dx: f641, dy: f64 };
            instance1.magnitude = function() {
                structHelpers.Vector2D.lower(this);
                const ret = instance.exports.bjs_Vector2D_magnitude();
                return ret;
            }.bind(instance1);
            instance1.scaled = function(factor) {
                structHelpers.Vector2D.lower(this);
                const ret1 = instance.exports.bjs_Vector2D_scaled(factor);
                const structValue = structHelpers.Vector2D.lift();
                return structValue;
            }.bind(instance1);
            instance1.describe = function() {
                structHelpers.Vector2D.lower(this);
                const ret2 = instance.exports.bjs_Vector2D_describe();
                const ret3 = tmpRetString;
                tmpRetString = undefined;
                return ret3;
            }.bind(instance1);
            return instance1;
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
            bjs["swift_js_struct_lower_DataPoint"] = function(objectId) {
                structHelpers.DataPoint.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_DataPoint"] = function() {
                const value = structHelpers.DataPoint.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Address"] = function(objectId) {
                structHelpers.Address.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Address"] = function() {
                const value = structHelpers.Address.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Person"] = function(objectId) {
                structHelpers.Person.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Person"] = function() {
                const value = structHelpers.Person.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Session"] = function(objectId) {
                structHelpers.Session.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Session"] = function() {
                const value = structHelpers.Session.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Measurement"] = function(objectId) {
                structHelpers.Measurement.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Measurement"] = function() {
                const value = structHelpers.Measurement.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_ConfigStruct"] = function(objectId) {
                structHelpers.ConfigStruct.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_ConfigStruct"] = function() {
                const value = structHelpers.ConfigStruct.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Container"] = function(objectId) {
                structHelpers.Container.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Container"] = function() {
                const value = structHelpers.Container.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Vector2D"] = function(objectId) {
                structHelpers.Vector2D.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Vector2D"] = function() {
                const value = structHelpers.Vector2D.lift();
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
            importObject["TestModule"]["bjs_Greeter_wrap"] = function(pointer) {
                const obj = _exports['Greeter'].__construct(pointer);
                return swift.memory.retain(obj);
            };
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
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_Greeter_init(nameId, nameBytes.length);
                    return Greeter.__construct(ret);
                }
                greet() {
                    instance.exports.bjs_Greeter_greet(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                get name() {
                    instance.exports.bjs_Greeter_name_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set name(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_Greeter_name_set(this.pointer, valueId, valueBytes.length);
                }
            }
            const DataPointHelpers = __bjs_createDataPointHelpers();
            structHelpers.DataPoint = DataPointHelpers;

            const AddressHelpers = __bjs_createAddressHelpers();
            structHelpers.Address = AddressHelpers;

            const PersonHelpers = __bjs_createPersonHelpers();
            structHelpers.Person = PersonHelpers;

            const SessionHelpers = __bjs_createSessionHelpers();
            structHelpers.Session = SessionHelpers;

            const MeasurementHelpers = __bjs_createMeasurementHelpers();
            structHelpers.Measurement = MeasurementHelpers;

            const ConfigStructHelpers = __bjs_createConfigStructHelpers();
            structHelpers.ConfigStruct = ConfigStructHelpers;

            const ContainerHelpers = __bjs_createContainerHelpers();
            structHelpers.Container = ContainerHelpers;

            const Vector2DHelpers = __bjs_createVector2DHelpers();
            structHelpers.Vector2D = Vector2DHelpers;

            const exports = {
                roundtrip: function bjs_roundtrip(session) {
                    structHelpers.Person.lower(session);
                    instance.exports.bjs_roundtrip();
                    const structValue = structHelpers.Person.lift();
                    return structValue;
                },
                roundtripContainer: function bjs_roundtripContainer(container) {
                    structHelpers.Container.lower(container);
                    instance.exports.bjs_roundtripContainer();
                    const structValue = structHelpers.Container.lift();
                    return structValue;
                },
                Precision: PrecisionValues,
                ConfigStruct: {
                    get maxRetries() {
                        const ret = instance.exports.bjs_ConfigStruct_static_maxRetries_get();
                        return ret;
                    },
                    get defaultConfig() {
                        instance.exports.bjs_ConfigStruct_static_defaultConfig_get();
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    },
                    set defaultConfig(value) {
                        const valueBytes = textEncoder.encode(value);
                        const valueId = swift.memory.retain(valueBytes);
                        instance.exports.bjs_ConfigStruct_static_defaultConfig_set(valueId, valueBytes.length);
                    },
                    get timeout() {
                        const ret = instance.exports.bjs_ConfigStruct_static_timeout_get();
                        return ret;
                    },
                    set timeout(value) {
                        instance.exports.bjs_ConfigStruct_static_timeout_set(value);
                    },
                    get computedSetting() {
                        instance.exports.bjs_ConfigStruct_static_computedSetting_get();
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    },
                    update: function(timeout) {
                        const ret = instance.exports.bjs_ConfigStruct_static_update(timeout);
                        return ret;
                    },
                },
                DataPoint: {
                    init: function(x, y, label, optCount, optFlag) {
                        const labelBytes = textEncoder.encode(label);
                        const labelId = swift.memory.retain(labelBytes);
                        const isSome = optCount != null;
                        const isSome1 = optFlag != null;
                        instance.exports.bjs_DataPoint_init(x, y, labelId, labelBytes.length, +isSome, isSome ? optCount : 0, +isSome1, isSome1 ? optFlag ? 1 : 0 : 0);
                        const structValue = structHelpers.DataPoint.lift();
                        return structValue;
                    },
                    get dimensions() {
                        const ret = instance.exports.bjs_DataPoint_static_dimensions_get();
                        return ret;
                    },
                    origin: function() {
                        instance.exports.bjs_DataPoint_static_origin();
                        const structValue = structHelpers.DataPoint.lift();
                        return structValue;
                    },
                },
                Greeter,
            };
            _exports = exports;
            return exports;
        },
    }
}