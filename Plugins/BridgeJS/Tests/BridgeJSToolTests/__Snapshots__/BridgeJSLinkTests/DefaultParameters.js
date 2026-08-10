// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const StatusValues = {
    Active: 0,
    Inactive: 1,
    Pending: 2,
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
    function __bjs_enumCodec(helper) {
        return {
            lower(value) {
                i32Stack.push(helper.lower(value));
            },
            lift() {
                return helper.lift(i32Stack.pop());
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

    const __bjs_createConfigHelpers = () => ({
        lower: (value) => {
            const bytes = textEncoder.encode(value.name);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
            i32Stack.push((value.value | 0));
            i32Stack.push(value.enabled ? 1 : 0);
        },
        lift: () => {
            const bool = i32Stack.pop() !== 0;
            const int = i32Stack.pop();
            const string = strStack.pop();
            return { name: string, value: int, enabled: bool };
        }
    });
    const __bjs_createMathOperationsHelpers = () => ({
        lower: (value) => {
            f64Stack.push(value.baseValue);
        },
        lift: () => {
            const f64 = f64Stack.pop();
            const instance1 = { baseValue: f64 };
            instance1.add = function(a, b = 10.0) {
                structHelpers.MathOperations.lower(this);
                const ret = instance.exports.bjs_MathOperations_add(a, b);
                return ret;
            }.bind(instance1);
            instance1.multiply = function(a, b) {
                structHelpers.MathOperations.lower(this);
                const ret1 = instance.exports.bjs_MathOperations_multiply(a, b);
                return ret1;
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
            bjs["swift_js_struct_lower_Config"] = function(objectId) {
                structHelpers.Config.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Config"] = function() {
                const value = structHelpers.Config.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_MathOperations"] = function(objectId) {
                structHelpers.MathOperations.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_MathOperations"] = function() {
                const value = structHelpers.MathOperations.lift();
                return swift.memory.retain(value);
            }
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
            importObject["TestModule"]["bjs_ConstructorDefaults_wrap"] = function(pointer) {
                const obj = _exports['ConstructorDefaults'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_DefaultGreeter_wrap"] = function(pointer) {
                const obj = _exports['DefaultGreeter'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_EmptyGreeter_wrap"] = function(pointer) {
                const obj = _exports['EmptyGreeter'].__construct(pointer);
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
            class DefaultGreeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_DefaultGreeter_deinit, DefaultGreeter.prototype, null);
                }

                constructor(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_DefaultGreeter_init(nameId, nameBytes.length);
                    return DefaultGreeter.__construct(ret);
                }
                get name() {
                    instance.exports.bjs_DefaultGreeter_name_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set name(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_DefaultGreeter_name_set(this.pointer, valueId, valueBytes.length);
                }
            }
            class EmptyGreeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_EmptyGreeter_deinit, EmptyGreeter.prototype, null);
                }

                constructor() {
                    const ret = instance.exports.bjs_EmptyGreeter_init();
                    return EmptyGreeter.__construct(ret);
                }
            }
            class ConstructorDefaults extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_ConstructorDefaults_deinit, ConstructorDefaults.prototype, null);
                }

                constructor(name = "Default", count = 42, enabled = true, status = StatusValues.Active, tag = null) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const isSome = tag != null;
                    let result, result1;
                    if (isSome) {
                        const tagBytes = textEncoder.encode(tag);
                        const tagId = swift.memory.retain(tagBytes);
                        result = tagId;
                        result1 = tagBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    const ret = instance.exports.bjs_ConstructorDefaults_init(nameId, nameBytes.length, count, enabled, status, +isSome, result, result1);
                    return ConstructorDefaults.__construct(ret);
                }
                get name() {
                    instance.exports.bjs_ConstructorDefaults_name_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set name(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_ConstructorDefaults_name_set(this.pointer, valueId, valueBytes.length);
                }
                get count() {
                    const ret = instance.exports.bjs_ConstructorDefaults_count_get(this.pointer);
                    return ret;
                }
                set count(value) {
                    instance.exports.bjs_ConstructorDefaults_count_set(this.pointer, value);
                }
                get enabled() {
                    const ret = instance.exports.bjs_ConstructorDefaults_enabled_get(this.pointer);
                    return ret !== 0;
                }
                set enabled(value) {
                    instance.exports.bjs_ConstructorDefaults_enabled_set(this.pointer, value);
                }
                get status() {
                    const ret = instance.exports.bjs_ConstructorDefaults_status_get(this.pointer);
                    return ret;
                }
                set status(value) {
                    instance.exports.bjs_ConstructorDefaults_status_set(this.pointer, value);
                }
                get tag() {
                    instance.exports.bjs_ConstructorDefaults_tag_get(this.pointer);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                set tag(value) {
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
                    instance.exports.bjs_ConstructorDefaults_tag_set(this.pointer, +isSome, result, result1);
                }
            }
            const ConfigHelpers = __bjs_createConfigHelpers();
            structHelpers.Config = ConfigHelpers;

            const MathOperationsHelpers = __bjs_createMathOperationsHelpers();
            structHelpers.MathOperations = MathOperationsHelpers;

            const exports = {
                testStringDefault: function bjs_testStringDefault(message = "Hello World") {
                    const messageBytes = textEncoder.encode(message);
                    const messageId = swift.memory.retain(messageBytes);
                    instance.exports.bjs_testStringDefault(messageId, messageBytes.length);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                testNegativeIntDefault: function bjs_testNegativeIntDefault(value = -42) {
                    const ret = instance.exports.bjs_testNegativeIntDefault(value);
                    return ret;
                },
                testBoolDefault: function bjs_testBoolDefault(flag = true) {
                    const ret = instance.exports.bjs_testBoolDefault(flag);
                    return ret !== 0;
                },
                testNegativeFloatDefault: function bjs_testNegativeFloatDefault(temp = -273.15) {
                    const ret = instance.exports.bjs_testNegativeFloatDefault(temp);
                    return ret;
                },
                testDoubleDefault: function bjs_testDoubleDefault(precision = 2.718) {
                    const ret = instance.exports.bjs_testDoubleDefault(precision);
                    return ret;
                },
                testOptionalDefault: function bjs_testOptionalDefault(name = null) {
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
                    instance.exports.bjs_testOptionalDefault(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                testOptionalStringDefault: function bjs_testOptionalStringDefault(greeting = "Hi") {
                    const isSome = greeting != null;
                    let result, result1;
                    if (isSome) {
                        const greetingBytes = textEncoder.encode(greeting);
                        const greetingId = swift.memory.retain(greetingBytes);
                        result = greetingId;
                        result1 = greetingBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_testOptionalStringDefault(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                testMultipleDefaults: function bjs_testMultipleDefaults(title = "Default Title", count = 10, enabled = false) {
                    const titleBytes = textEncoder.encode(title);
                    const titleId = swift.memory.retain(titleBytes);
                    instance.exports.bjs_testMultipleDefaults(titleId, titleBytes.length, count, enabled);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                testEnumDefault: function bjs_testEnumDefault(status = StatusValues.Active) {
                    const ret = instance.exports.bjs_testEnumDefault(status);
                    return ret;
                },
                testComplexInit: function bjs_testComplexInit(greeter = new DefaultGreeter("DefaultUser")) {
                    const ret = instance.exports.bjs_testComplexInit(greeter.pointer);
                    return DefaultGreeter.__construct(ret);
                },
                testEmptyInit: function bjs_testEmptyInit(greeter = new EmptyGreeter()) {
                    const ret = instance.exports.bjs_testEmptyInit(greeter.pointer);
                    return EmptyGreeter.__construct(ret);
                },
                testOptionalStructDefault: function bjs_testOptionalStructDefault(point = null) {
                    __bjs_optionalCodec(structHelpers.Config).lower(point);
                    instance.exports.bjs_testOptionalStructDefault();
                    const optValue = __bjs_optionalCodec(structHelpers.Config).lift();
                    return optValue;
                },
                testOptionalStructWithValueDefault: function bjs_testOptionalStructWithValueDefault(point = { name: "default", value: 42, enabled: true }) {
                    __bjs_optionalCodec(structHelpers.Config).lower(point);
                    instance.exports.bjs_testOptionalStructWithValueDefault();
                    const optValue = __bjs_optionalCodec(structHelpers.Config).lift();
                    return optValue;
                },
                testIntArrayDefault: function bjs_testIntArrayDefault(values = [1, 2, 3]) {
                    __bjs_arrayCodec(__bjs_primitiveCodecs.Int).lower(values);
                    instance.exports.bjs_testIntArrayDefault();
                    const arrayResult = __bjs_arrayCodec(__bjs_primitiveCodecs.Int).lift();
                    return arrayResult;
                },
                testStringArrayDefault: function bjs_testStringArrayDefault(names = ["a", "b", "c"]) {
                    __bjs_arrayCodec(__bjs_stringCodec).lower(names);
                    instance.exports.bjs_testStringArrayDefault();
                    const arrayResult = __bjs_arrayCodec(__bjs_stringCodec).lift();
                    return arrayResult;
                },
                testDoubleArrayDefault: function bjs_testDoubleArrayDefault(values = [1.5, 2.5, 3.5]) {
                    __bjs_arrayCodec(__bjs_primitiveCodecs.Double).lower(values);
                    instance.exports.bjs_testDoubleArrayDefault();
                    const arrayResult = __bjs_arrayCodec(__bjs_primitiveCodecs.Double).lift();
                    return arrayResult;
                },
                testBoolArrayDefault: function bjs_testBoolArrayDefault(flags = [true, false, true]) {
                    __bjs_arrayCodec(__bjs_primitiveCodecs.Bool).lower(flags);
                    instance.exports.bjs_testBoolArrayDefault();
                    const arrayResult = __bjs_arrayCodec(__bjs_primitiveCodecs.Bool).lift();
                    return arrayResult;
                },
                testEmptyArrayDefault: function bjs_testEmptyArrayDefault(items = []) {
                    __bjs_arrayCodec(__bjs_primitiveCodecs.Int).lower(items);
                    instance.exports.bjs_testEmptyArrayDefault();
                    const arrayResult = __bjs_arrayCodec(__bjs_primitiveCodecs.Int).lift();
                    return arrayResult;
                },
                testMixedWithArrayDefault: function bjs_testMixedWithArrayDefault(name = "test", values = [10, 20, 30], enabled = true) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    __bjs_arrayCodec(__bjs_primitiveCodecs.Int).lower(values);
                    instance.exports.bjs_testMixedWithArrayDefault(nameId, nameBytes.length, enabled);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                Status: StatusValues,
                ConstructorDefaults,
                DefaultGreeter,
                EmptyGreeter,
                MathOperations: {
                    init: function(baseValue = 0.0) {
                        instance.exports.bjs_MathOperations_init(baseValue);
                        const structValue = structHelpers.MathOperations.lift();
                        return structValue;
                    },
                    subtract: function(a, b = 5.0) {
                        const ret = instance.exports.bjs_MathOperations_static_subtract(a, b);
                        return ret;
                    },
                },
            };
            _exports = exports;
            return exports;
        },
    }
}