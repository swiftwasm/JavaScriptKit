// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export async function createInstantiator(options, swift) {
    let instance;
    let memory;
    let setException;
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
    let f32Stack = [];
    let f64Stack = [];
    let ptrStack = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
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


    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            const imports = options.getImports(importsContext);
            bjs["swift_js_return_string"] = function(ptr, len) {
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                tmpRetString = textDecoder.decode(bytes);
            }
            bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
                swift.memory.release(sourceId);
                const bytes = new Uint8Array(memory.buffer, bytesPtr);
                bytes.set(source);
            }
            bjs["swift_js_make_js_string"] = function(ptr, len) {
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                return swift.memory.retain(textDecoder.decode(bytes));
            }
            bjs["swift_js_init_memory_with_result"] = function(ptr, len) {
                const target = new Uint8Array(memory.buffer, ptr, len);
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
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                strStack.push(textDecoder.decode(bytes));
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
                    const bytes = new Uint8Array(memory.buffer, ptr, len);
                    tmpRetString = textDecoder.decode(bytes);
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
            importObject["TestModule"]["bjs_JSValueHolder_wrap"] = function(pointer) {
                const obj = JSValueHolder.__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_jsEchoJSValue"] = function bjs_jsEchoJSValue(valueKind, valuePayload1, valuePayload2) {
                try {
                    const jsValue = __bjs_jsValueLift(valueKind, valuePayload1, valuePayload2);
                    let ret = imports.jsEchoJSValue(jsValue);
                    const [retKind, retPayload1, retPayload2] = __bjs_jsValueLower(ret);
                    i32Stack.push(retKind);
                    i32Stack.push(retPayload1);
                    f64Stack.push(retPayload2);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_jsEchoJSValueArray"] = function bjs_jsEchoJSValueArray() {
                try {
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const jsValuePayload2 = f64Stack.pop();
                        const jsValuePayload1 = i32Stack.pop();
                        const jsValueKind = i32Stack.pop();
                        const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                        arrayResult.push(jsValue);
                    }
                    arrayResult.reverse();
                    let ret = imports.jsEchoJSValueArray(arrayResult);
                    for (const elem of ret) {
                        const [elemKind, elemPayload1, elemPayload2] = __bjs_jsValueLower(elem);
                        i32Stack.push(elemKind);
                        i32Stack.push(elemPayload1);
                        f64Stack.push(elemPayload2);
                    }
                    i32Stack.push(ret.length);
                } catch (error) {
                    setException(error);
                }
            }
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            setException = (error) => {
                instance.exports._swift_js_exception.value = swift.memory.retain(error)
            }
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;
            /// Represents a Swift heap object like a class instance or an actor instance.
            class SwiftHeapObject {
                static __wrap(pointer, deinit, prototype) {
                    const obj = Object.create(prototype);
                    obj.pointer = pointer;
                    obj.hasReleased = false;
                    obj.deinit = deinit;
                    obj.registry = new FinalizationRegistry((pointer) => {
                        deinit(pointer);
                    });
                    obj.registry.register(this, obj.pointer);
                    return obj;
                }

                release() {
                    this.registry.unregister(this);
                    this.deinit(this.pointer);
                }
            }
            class JSValueHolder extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_JSValueHolder_deinit, JSValueHolder.prototype);
                }

                constructor(value, optionalValue) {
                    const [valueKind, valuePayload1, valuePayload2] = __bjs_jsValueLower(value);
                    const isSome = optionalValue != null;
                    let result;
                    let result1;
                    let result2;
                    if (isSome) {
                        const [optionalValueKind, optionalValuePayload1, optionalValuePayload2] = __bjs_jsValueLower(optionalValue);
                        result = optionalValueKind;
                        result1 = optionalValuePayload1;
                        result2 = optionalValuePayload2;
                    } else {
                        result = 0;
                        result1 = 0;
                        result2 = 0.0;
                    }
                    const ret = instance.exports.bjs_JSValueHolder_init(valueKind, valuePayload1, valuePayload2, +isSome, result, result1, result2);
                    return JSValueHolder.__construct(ret);
                }
                update(value, optionalValue) {
                    const [valueKind, valuePayload1, valuePayload2] = __bjs_jsValueLower(value);
                    const isSome = optionalValue != null;
                    let result;
                    let result1;
                    let result2;
                    if (isSome) {
                        const [optionalValueKind, optionalValuePayload1, optionalValuePayload2] = __bjs_jsValueLower(optionalValue);
                        result = optionalValueKind;
                        result1 = optionalValuePayload1;
                        result2 = optionalValuePayload2;
                    } else {
                        result = 0;
                        result1 = 0;
                        result2 = 0.0;
                    }
                    instance.exports.bjs_JSValueHolder_update(this.pointer, valueKind, valuePayload1, valuePayload2, +isSome, result, result1, result2);
                }
                echo(value) {
                    const [valueKind, valuePayload1, valuePayload2] = __bjs_jsValueLower(value);
                    instance.exports.bjs_JSValueHolder_echo(this.pointer, valueKind, valuePayload1, valuePayload2);
                    const jsValuePayload2 = f64Stack.pop();
                    const jsValuePayload1 = i32Stack.pop();
                    const jsValueKind = i32Stack.pop();
                    const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                    return jsValue;
                }
                echoOptional(value) {
                    const isSome = value != null;
                    let result;
                    let result1;
                    let result2;
                    if (isSome) {
                        const [valueKind, valuePayload1, valuePayload2] = __bjs_jsValueLower(value);
                        result = valueKind;
                        result1 = valuePayload1;
                        result2 = valuePayload2;
                    } else {
                        result = 0;
                        result1 = 0;
                        result2 = 0.0;
                    }
                    instance.exports.bjs_JSValueHolder_echoOptional(this.pointer, +isSome, result, result1, result2);
                    const isSome1 = i32Stack.pop();
                    let optResult;
                    if (isSome1) {
                        const jsValuePayload2 = f64Stack.pop();
                        const jsValuePayload1 = i32Stack.pop();
                        const jsValueKind = i32Stack.pop();
                        const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                        optResult = jsValue;
                    } else {
                        optResult = null;
                    }
                    return optResult;
                }
                get value() {
                    instance.exports.bjs_JSValueHolder_value_get(this.pointer);
                    const jsValuePayload2 = f64Stack.pop();
                    const jsValuePayload1 = i32Stack.pop();
                    const jsValueKind = i32Stack.pop();
                    const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                    return jsValue;
                }
                set value(value) {
                    const [valueKind, valuePayload1, valuePayload2] = __bjs_jsValueLower(value);
                    instance.exports.bjs_JSValueHolder_value_set(this.pointer, valueKind, valuePayload1, valuePayload2);
                }
                get optionalValue() {
                    instance.exports.bjs_JSValueHolder_optionalValue_get(this.pointer);
                    const isSome = i32Stack.pop();
                    let optResult;
                    if (isSome) {
                        const jsValuePayload2 = f64Stack.pop();
                        const jsValuePayload1 = i32Stack.pop();
                        const jsValueKind = i32Stack.pop();
                        const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                        optResult = jsValue;
                    } else {
                        optResult = null;
                    }
                    return optResult;
                }
                set optionalValue(value) {
                    const isSome = value != null;
                    let result;
                    let result1;
                    let result2;
                    if (isSome) {
                        const [valueKind, valuePayload1, valuePayload2] = __bjs_jsValueLower(value);
                        result = valueKind;
                        result1 = valuePayload1;
                        result2 = valuePayload2;
                    } else {
                        result = 0;
                        result1 = 0;
                        result2 = 0.0;
                    }
                    instance.exports.bjs_JSValueHolder_optionalValue_set(this.pointer, +isSome, result, result1, result2);
                }
            }
            const exports = {
                JSValueHolder,
                roundTripJSValue: function bjs_roundTripJSValue(value) {
                    const [valueKind, valuePayload1, valuePayload2] = __bjs_jsValueLower(value);
                    instance.exports.bjs_roundTripJSValue(valueKind, valuePayload1, valuePayload2);
                    const jsValuePayload2 = f64Stack.pop();
                    const jsValuePayload1 = i32Stack.pop();
                    const jsValueKind = i32Stack.pop();
                    const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                    return jsValue;
                },
                roundTripOptionalJSValue: function bjs_roundTripOptionalJSValue(value) {
                    const isSome = value != null;
                    let result;
                    let result1;
                    let result2;
                    if (isSome) {
                        const [valueKind, valuePayload1, valuePayload2] = __bjs_jsValueLower(value);
                        result = valueKind;
                        result1 = valuePayload1;
                        result2 = valuePayload2;
                    } else {
                        result = 0;
                        result1 = 0;
                        result2 = 0.0;
                    }
                    instance.exports.bjs_roundTripOptionalJSValue(+isSome, result, result1, result2);
                    const isSome1 = i32Stack.pop();
                    let optResult;
                    if (isSome1) {
                        const jsValuePayload2 = f64Stack.pop();
                        const jsValuePayload1 = i32Stack.pop();
                        const jsValueKind = i32Stack.pop();
                        const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                        optResult = jsValue;
                    } else {
                        optResult = null;
                    }
                    return optResult;
                },
                roundTripJSValueArray: function bjs_roundTripJSValueArray(values) {
                    for (const elem of values) {
                        const [elemKind, elemPayload1, elemPayload2] = __bjs_jsValueLower(elem);
                        i32Stack.push(elemKind);
                        i32Stack.push(elemPayload1);
                        f64Stack.push(elemPayload2);
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_roundTripJSValueArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const jsValuePayload2 = f64Stack.pop();
                        const jsValuePayload1 = i32Stack.pop();
                        const jsValueKind = i32Stack.pop();
                        const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                        arrayResult.push(jsValue);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                roundTripOptionalJSValueArray: function bjs_roundTripOptionalJSValueArray(values) {
                    const isSome = values != null;
                    if (isSome) {
                        for (const elem of values) {
                            const [elemKind, elemPayload1, elemPayload2] = __bjs_jsValueLower(elem);
                            i32Stack.push(elemKind);
                            i32Stack.push(elemPayload1);
                            f64Stack.push(elemPayload2);
                        }
                        i32Stack.push(values.length);
                    }
                    i32Stack.push(+isSome);
                    instance.exports.bjs_roundTripOptionalJSValueArray();
                    const isSome1 = i32Stack.pop();
                    let optResult;
                    if (isSome1) {
                        const arrayLen = i32Stack.pop();
                        const arrayResult = [];
                        for (let i = 0; i < arrayLen; i++) {
                            const jsValuePayload2 = f64Stack.pop();
                            const jsValuePayload1 = i32Stack.pop();
                            const jsValueKind = i32Stack.pop();
                            const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                            arrayResult.push(jsValue);
                        }
                        arrayResult.reverse();
                        optResult = arrayResult;
                    } else {
                        optResult = null;
                    }
                    return optResult;
                },
            };
            _exports = exports;
            return exports;
        },
    }
}