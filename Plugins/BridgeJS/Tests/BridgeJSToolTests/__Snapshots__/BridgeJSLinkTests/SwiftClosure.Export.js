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

export const ThemeValues = {
    Light: "light",
    Dark: "dark",
    Auto: "auto",
};

export const HttpStatusValues = {
    Ok: 200,
    NotFound: 404,
    ServerError: 500,
    Unknown: -1,
};

export const APIResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
        Flag: 2,
        Rate: 3,
        Precise: 4,
        Info: 5,
    },
};

const __bjs_createAPIResultValuesHelpers = () => {
    return (tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case APIResultValues.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: APIResultValues.Tag.Success, cleanup };
                }
                case APIResultValues.Tag.Failure: {
                    tmpParamInts.push((value.param0 | 0));
                    const cleanup = undefined;
                    return { caseId: APIResultValues.Tag.Failure, cleanup };
                }
                case APIResultValues.Tag.Flag: {
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = undefined;
                    return { caseId: APIResultValues.Tag.Flag, cleanup };
                }
                case APIResultValues.Tag.Rate: {
                    tmpParamF32s.push(Math.fround(value.param0));
                    const cleanup = undefined;
                    return { caseId: APIResultValues.Tag.Rate, cleanup };
                }
                case APIResultValues.Tag.Precise: {
                    tmpParamF64s.push(value.param0);
                    const cleanup = undefined;
                    return { caseId: APIResultValues.Tag.Precise, cleanup };
                }
                case APIResultValues.Tag.Info: {
                    const cleanup = undefined;
                    return { caseId: APIResultValues.Tag.Info, cleanup };
                }
                default: throw new Error("Unknown APIResultValues tag: " + String(enumTag));
            }
        },
        lift: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case APIResultValues.Tag.Success: {
                    const string = tmpRetStrings.pop();
                    return { tag: APIResultValues.Tag.Success, param0: string };
                }
                case APIResultValues.Tag.Failure: {
                    const int = tmpRetInts.pop();
                    return { tag: APIResultValues.Tag.Failure, param0: int };
                }
                case APIResultValues.Tag.Flag: {
                    const bool = tmpRetInts.pop();
                    return { tag: APIResultValues.Tag.Flag, param0: bool };
                }
                case APIResultValues.Tag.Rate: {
                    const f32 = tmpRetF32s.pop();
                    return { tag: APIResultValues.Tag.Rate, param0: f32 };
                }
                case APIResultValues.Tag.Precise: {
                    const f64 = tmpRetF64s.pop();
                    return { tag: APIResultValues.Tag.Precise, param0: f64 };
                }
                case APIResultValues.Tag.Info: return { tag: APIResultValues.Tag.Info };
                default: throw new Error("Unknown APIResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
};
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
    let tmpRetTag;
    let tmpRetStrings = [];
    let tmpRetInts = [];
    let tmpRetF32s = [];
    let tmpRetF64s = [];
    let tmpParamInts = [];
    let tmpParamF32s = [];
    let tmpParamF64s = [];
    let tmpRetPointers = [];
    let tmpParamPointers = [];
    let tmpStructCleanups = [];
    const enumHelpers = {};
    const structHelpers = {};
    
    let _exports = null;
    let bjs = null;

    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            bjs["swift_js_return_string"] = function(ptr, len) {
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                tmpRetString = textDecoder.decode(bytes);
            }
            bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
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
            bjs["swift_js_push_tag"] = function(tag) {
                tmpRetTag = tag;
            }
            bjs["swift_js_push_int"] = function(v) {
                tmpRetInts.push(v | 0);
            }
            bjs["swift_js_push_f32"] = function(v) {
                tmpRetF32s.push(Math.fround(v));
            }
            bjs["swift_js_push_f64"] = function(v) {
                tmpRetF64s.push(v);
            }
            bjs["swift_js_push_string"] = function(ptr, len) {
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                const value = textDecoder.decode(bytes);
                tmpRetStrings.push(value);
            }
            bjs["swift_js_pop_param_int32"] = function() {
                return tmpParamInts.pop();
            }
            bjs["swift_js_pop_param_f32"] = function() {
                return tmpParamF32s.pop();
            }
            bjs["swift_js_pop_param_f64"] = function() {
                return tmpParamF64s.pop();
            }
            bjs["swift_js_push_pointer"] = function(pointer) {
                tmpRetPointers.push(pointer);
            }
            bjs["swift_js_pop_param_pointer"] = function() {
                return tmpParamPointers.pop();
            }
            bjs["swift_js_struct_cleanup"] = function(cleanupId) {
                if (cleanupId === 0) { return; }
                const index = (cleanupId | 0) - 1;
                const cleanup = tmpStructCleanups[index];
                tmpStructCleanups[index] = null;
                if (cleanup) { cleanup(); }
                while (tmpStructCleanups.length > 0 && tmpStructCleanups[tmpStructCleanups.length - 1] == null) {
                    tmpStructCleanups.pop();
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
            
            bjs["invoke_js_callback_TestModule_10TestModule10HttpStatusO_Si"] = function(callbackId, param0Id) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0 = param0Id;
                    const result = callback(param0);
                    return result | 0;
                } catch (error) {
                    setException?.(error);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModule10HttpStatusO_Si"] = function(closurePtr) {
                return function(param0) {
                    try {
                        return instance.exports.invoke_swift_closure_TestModule_10TestModule10HttpStatusO_Si(closurePtr, param0) | 0;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModule5ThemeO_SS"] = function(callbackId, param0Id) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    const param0IdObject = swift.memory.getObject(param0Id);
                    swift.memory.release(param0Id);
                    let param0 = String(param0IdObject);
                    const result = callback(param0);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModule5ThemeO_SS"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const param0Bytes = textEncoder.encode(param0);
                        const param0Id = swift.memory.retain(param0Bytes);
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModule5ThemeO_SS(closurePtr, param0Id, param0Bytes.length);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModule5ThemeO_Sb"] = function(callbackId, param0Id) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    const param0IdObject = swift.memory.getObject(param0Id);
                    swift.memory.release(param0Id);
                    let param0 = String(param0IdObject);
                    const result = callback(param0);
                    return result ? 1 : 0;
                } catch (error) {
                    setException?.(error);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModule5ThemeO_Sb"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const param0Bytes = textEncoder.encode(param0);
                        const param0Id = swift.memory.retain(param0Bytes);
                        return instance.exports.invoke_swift_closure_TestModule_10TestModule5ThemeO_Sb(closurePtr, param0Id, param0Bytes.length) !== 0;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModule6PersonC_SS"] = function(callbackId, param0Id) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0 = _exports['Person'].__construct(param0Id);
                    const result = callback(param0);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModule6PersonC_SS"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModule6PersonC_SS(closurePtr, param0.pointer);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModule9APIResultO_SS"] = function(callbackId, param0Id) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0 = enumHelpers.APIResult.lift(param0Id, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    const result = callback(param0);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModule9APIResultO_SS"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const { caseId: param0CaseId, cleanup: param0Cleanup } = enumHelpers.APIResult.lower(param0);
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModule9APIResultO_SS(closurePtr, param0CaseId);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModule9DirectionO_SS"] = function(callbackId, param0Id) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0 = param0Id;
                    const result = callback(param0);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModule9DirectionO_SS"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModule9DirectionO_SS(closurePtr, param0);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModule9DirectionO_Sb"] = function(callbackId, param0Id) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0 = param0Id;
                    const result = callback(param0);
                    return result ? 1 : 0;
                } catch (error) {
                    setException?.(error);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModule9DirectionO_Sb"] = function(closurePtr) {
                return function(param0) {
                    try {
                        return instance.exports.invoke_swift_closure_TestModule_10TestModule9DirectionO_Sb(closurePtr, param0) !== 0;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModuleSS_SS"] = function(callbackId, param0Id) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    const param0IdObject = swift.memory.getObject(param0Id);
                    swift.memory.release(param0Id);
                    let param0 = String(param0IdObject);
                    const result = callback(param0);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModuleSS_SS"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const param0Bytes = textEncoder.encode(param0);
                        const param0Id = swift.memory.retain(param0Bytes);
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModuleSS_SS(closurePtr, param0Id, param0Bytes.length);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModuleSq5ThemeO_SS"] = function(callbackId, param0IsSome, param0Value) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0;
                    if (param0IsSome) {
                        const param0Object = swift.memory.getObject(param0Value);
                        swift.memory.release(param0Value);
                        param0 = String(param0Object);
                    } else {
                        param0 = null;
                    }
                    const result = callback(param0);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModuleSq5ThemeO_SS"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const isSome = param0 != null;
                        let param0Id, param0Bytes;
                        if (isSome) {
                            param0Bytes = textEncoder.encode(param0);
                            param0Id = swift.memory.retain(param0Bytes);
                        }
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModuleSq5ThemeO_SS(closurePtr, +isSome, isSome ? param0Id : 0, isSome ? param0Bytes.length : 0);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModuleSq6PersonCSqSSSqSd_SS"] = function(callbackId, param0IsSome, param0Value, param1IsSome, param1Value, param2IsSome, param2Value) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0;
                    if (param0IsSome) {
                        param0 = _exports['Person'].__construct(param0Value);
                    } else {
                        param0 = null;
                    }
                    let param1;
                    if (param1IsSome) {
                        const param1Object = swift.memory.getObject(param1Value);
                        swift.memory.release(param1Value);
                        param1 = String(param1Object);
                    } else {
                        param1 = null;
                    }
                    let param2;
                    if (param2IsSome) {
                        param2 = param2Value;
                    } else {
                        param2 = null;
                    }
                    const result = callback(param0, param1, param2);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModuleSq6PersonCSqSSSqSd_SS"] = function(closurePtr) {
                return function(param0, param1, param2) {
                    try {
                        const isSome = param0 != null;
                        const isSome1 = param1 != null;
                        let param1Id, param1Bytes;
                        if (isSome1) {
                            param1Bytes = textEncoder.encode(param1);
                            param1Id = swift.memory.retain(param1Bytes);
                        }
                        const isSome2 = param2 != null;
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModuleSq6PersonCSqSSSqSd_SS(closurePtr, +isSome, isSome ? param0.pointer : 0, +isSome1, isSome1 ? param1Id : 0, isSome1 ? param1Bytes.length : 0, +isSome2, isSome2 ? param2 : 0);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModuleSq6PersonC_SS"] = function(callbackId, param0IsSome, param0Value) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0;
                    if (param0IsSome) {
                        param0 = _exports['Person'].__construct(param0Value);
                    } else {
                        param0 = null;
                    }
                    const result = callback(param0);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModuleSq6PersonC_SS"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const isSome = param0 != null;
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModuleSq6PersonC_SS(closurePtr, +isSome, isSome ? param0.pointer : 0);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModuleSq9APIResultO_SS"] = function(callbackId, param0IsSome, param0Value) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0;
                    if (param0IsSome) {
                        param0 = enumHelpers.APIResult.lift(param0Value, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    } else {
                        param0 = null;
                    }
                    const result = callback(param0);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModuleSq9APIResultO_SS"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const isSome = param0 != null;
                        let param0CaseId, param0Cleanup;
                        if (isSome) {
                            const enumResult = enumHelpers.APIResult.lower(param0);
                            param0CaseId = enumResult.caseId;
                            param0Cleanup = enumResult.cleanup;
                        }
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModuleSq9APIResultO_SS(closurePtr, +isSome, isSome ? param0CaseId : 0);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            
            bjs["invoke_js_callback_TestModule_10TestModuleSq9DirectionO_SS"] = function(callbackId, param0IsSome, param0Value) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let param0;
                    if (param0IsSome) {
                        param0 = param0Value;
                    } else {
                        param0 = null;
                    }
                    const result = callback(param0);
                    if (typeof result !== "string") {
                        throw new TypeError("Callback must return a string");
                    }
                    tmpRetBytes = textEncoder.encode(result);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException?.(error);
                    tmpRetBytes = new Uint8Array(0);
                    return 0;
                }
            };
            
            bjs["lower_closure_TestModule_10TestModuleSq9DirectionO_SS"] = function(closurePtr) {
                return function(param0) {
                    try {
                        const isSome = param0 != null;
                        const resultLen = instance.exports.invoke_swift_closure_TestModule_10TestModuleSq9DirectionO_SS(closurePtr, +isSome, isSome ? param0 : 0);
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    } catch (error) {
                        setException?.(error);
                        throw error;
                    }
                };
            };
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Person_wrap"] = function(pointer) {
                const obj = Person.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_TestProcessor_wrap"] = function(pointer) {
                const obj = TestProcessor.__construct(pointer);
                return swift.memory.retain(obj);
            };
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            const APIResultHelpers = __bjs_createAPIResultValuesHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.APIResult = APIResultHelpers;
            
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
            class Person extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Person_deinit, Person.prototype);
                }
            
                constructor(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_Person_init(nameId, nameBytes.length);
                    swift.memory.release(nameId);
                    return Person.__construct(ret);
                }
            }
            class TestProcessor extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_TestProcessor_deinit, TestProcessor.prototype);
                }
            
                constructor(transform) {
                    const callbackId = swift.memory.retain(transform);
                    const ret = instance.exports.bjs_TestProcessor_init(callbackId);
                    return TestProcessor.__construct(ret);
                }
                getTransform() {
                    const ret = instance.exports.bjs_TestProcessor_getTransform(this.pointer);
                    return bjs["lower_closure_TestModule_10TestModuleSS_SS"](ret);
                }
                processWithCustom(text, customTransform) {
                    const textBytes = textEncoder.encode(text);
                    const textId = swift.memory.retain(textBytes);
                    const callbackId = swift.memory.retain(customTransform);
                    instance.exports.bjs_TestProcessor_processWithCustom(this.pointer, textId, textBytes.length, callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    swift.memory.release(textId);
                    return ret;
                }
                printTogether(person, name, ratio, customTransform) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const callbackId = swift.memory.retain(customTransform);
                    instance.exports.bjs_TestProcessor_printTogether(this.pointer, person.pointer, nameId, nameBytes.length, ratio, callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    swift.memory.release(nameId);
                    return ret;
                }
                roundtrip(personClosure) {
                    const callbackId = swift.memory.retain(personClosure);
                    const ret = instance.exports.bjs_TestProcessor_roundtrip(this.pointer, callbackId);
                    return bjs["lower_closure_TestModule_10TestModule6PersonC_SS"](ret);
                }
                roundtripOptional(personClosure) {
                    const callbackId = swift.memory.retain(personClosure);
                    const ret = instance.exports.bjs_TestProcessor_roundtripOptional(this.pointer, callbackId);
                    return bjs["lower_closure_TestModule_10TestModuleSq6PersonC_SS"](ret);
                }
                processDirection(callback) {
                    const callbackId = swift.memory.retain(callback);
                    instance.exports.bjs_TestProcessor_processDirection(this.pointer, callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                processTheme(callback) {
                    const callbackId = swift.memory.retain(callback);
                    instance.exports.bjs_TestProcessor_processTheme(this.pointer, callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                processHttpStatus(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_TestProcessor_processHttpStatus(this.pointer, callbackId);
                    return ret;
                }
                processAPIResult(callback) {
                    const callbackId = swift.memory.retain(callback);
                    instance.exports.bjs_TestProcessor_processAPIResult(this.pointer, callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                makeDirectionChecker() {
                    const ret = instance.exports.bjs_TestProcessor_makeDirectionChecker(this.pointer);
                    return bjs["lower_closure_TestModule_10TestModule9DirectionO_Sb"](ret);
                }
                makeThemeValidator() {
                    const ret = instance.exports.bjs_TestProcessor_makeThemeValidator(this.pointer);
                    return bjs["lower_closure_TestModule_10TestModule5ThemeO_Sb"](ret);
                }
                makeStatusCodeExtractor() {
                    const ret = instance.exports.bjs_TestProcessor_makeStatusCodeExtractor(this.pointer);
                    return bjs["lower_closure_TestModule_10TestModule10HttpStatusO_Si"](ret);
                }
                makeAPIResultHandler() {
                    const ret = instance.exports.bjs_TestProcessor_makeAPIResultHandler(this.pointer);
                    return bjs["lower_closure_TestModule_10TestModule9APIResultO_SS"](ret);
                }
                processOptionalDirection(callback) {
                    const callbackId = swift.memory.retain(callback);
                    instance.exports.bjs_TestProcessor_processOptionalDirection(this.pointer, callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                processOptionalTheme(callback) {
                    const callbackId = swift.memory.retain(callback);
                    instance.exports.bjs_TestProcessor_processOptionalTheme(this.pointer, callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                processOptionalAPIResult(callback) {
                    const callbackId = swift.memory.retain(callback);
                    instance.exports.bjs_TestProcessor_processOptionalAPIResult(this.pointer, callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                makeOptionalDirectionFormatter() {
                    const ret = instance.exports.bjs_TestProcessor_makeOptionalDirectionFormatter(this.pointer);
                    return bjs["lower_closure_TestModule_10TestModuleSq9DirectionO_SS"](ret);
                }
            }
            const exports = {
                Person,
                TestProcessor,
                Direction: DirectionValues,
                Theme: ThemeValues,
                HttpStatus: HttpStatusValues,
                APIResult: APIResultValues,
            };
            _exports = exports;
            return exports;
        },
    }
}