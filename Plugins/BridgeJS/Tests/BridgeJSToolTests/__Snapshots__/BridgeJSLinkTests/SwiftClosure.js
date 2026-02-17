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
    let tmpStructCleanups = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    const swiftClosureRegistry = (typeof FinalizationRegistry === "undefined") ? { register: () => {}, unregister: () => {} } : new FinalizationRegistry((state) => {
        if (state.unregistered) { return; }
        instance?.exports?.bjs_release_swift_closure(state.pointer);
    });
    const makeClosure = (pointer, file, line, func) => {
        const state = { pointer, file, line, unregistered: false };
        const real = (...args) => {
            if (state.unregistered) {
                const bytes = new Uint8Array(memory.buffer, state.file);
                let length = 0;
                while (bytes[length] !== 0) { length += 1; }
                const fileID = textDecoder.decode(bytes.subarray(0, length));
                throw new Error(`Attempted to call a released JSTypedClosure created at ${fileID}:${state.line}`);
            }
            return func(...args);
        };
        real.__unregister = () => {
            if (state.unregistered) { return; }
            state.unregistered = true;
            swiftClosureRegistry.unregister(state);
        };
        swiftClosureRegistry.register(real, state, state);
        return swift.memory.retain(real);
    };

    const __bjs_createAPIResultValuesHelpers = () => {
        return () => ({
            lower: (value) => {
                const enumTag = value.tag;
                switch (enumTag) {
                    case APIResultValues.Tag.Success: {
                        const bytes = textEncoder.encode(value.param0);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                        const cleanup = undefined;
                        return { caseId: APIResultValues.Tag.Success, cleanup };
                    }
                    case APIResultValues.Tag.Failure: {
                        i32Stack.push((value.param0 | 0));
                        const cleanup = undefined;
                        return { caseId: APIResultValues.Tag.Failure, cleanup };
                    }
                    case APIResultValues.Tag.Flag: {
                        i32Stack.push(value.param0 ? 1 : 0);
                        const cleanup = undefined;
                        return { caseId: APIResultValues.Tag.Flag, cleanup };
                    }
                    case APIResultValues.Tag.Rate: {
                        f32Stack.push(Math.fround(value.param0));
                        const cleanup = undefined;
                        return { caseId: APIResultValues.Tag.Rate, cleanup };
                    }
                    case APIResultValues.Tag.Precise: {
                        f64Stack.push(value.param0);
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
            lift: (tag) => {
                tag = tag | 0;
                switch (tag) {
                    case APIResultValues.Tag.Success: {
                        const string = strStack.pop();
                        return { tag: APIResultValues.Tag.Success, param0: string };
                    }
                    case APIResultValues.Tag.Failure: {
                        const int = i32Stack.pop();
                        return { tag: APIResultValues.Tag.Failure, param0: int };
                    }
                    case APIResultValues.Tag.Flag: {
                        const bool = i32Stack.pop() !== 0;
                        return { tag: APIResultValues.Tag.Flag, param0: bool };
                    }
                    case APIResultValues.Tag.Rate: {
                        const f32 = f32Stack.pop();
                        return { tag: APIResultValues.Tag.Rate, param0: f32 };
                    }
                    case APIResultValues.Tag.Precise: {
                        const f64 = f64Stack.pop();
                        return { tag: APIResultValues.Tag.Precise, param0: f64 };
                    }
                    case APIResultValues.Tag.Info: return { tag: APIResultValues.Tag.Info };
                    default: throw new Error("Unknown APIResultValues tag returned from Swift: " + String(tag));
                }
            }
        });
    };

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
                const value = textDecoder.decode(bytes);
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
            bjs["swift_js_closure_unregister"] = function(funcRef) {}
            bjs["swift_js_closure_unregister"] = function(funcRef) {
                const func = swift.memory.getObject(funcRef);
                func.__unregister();
            }
            bjs["invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0);
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            bjs["make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO = function(param0) {
                    const ret = instance.exports.invoke_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO(boxPtr, param0);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO);
            }
            bjs["invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    const param0Object = swift.memory.getObject(param0);
                    swift.memory.release(param0);
                    let ret = callback(param0Object);
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModule5ThemeO_5ThemeO = function(param0) {
                    const param0Bytes = textEncoder.encode(param0);
                    const param0Id = swift.memory.retain(param0Bytes);
                    instance.exports.invoke_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO(boxPtr, param0Id, param0Bytes.length);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModule5ThemeO_5ThemeO);
            }
            bjs["invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(_exports['Person'].__construct(param0));
                    return ret.pointer;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            bjs["make_swift_closure_TestModule_10TestModule6PersonC_6PersonC"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModule6PersonC_6PersonC = function(param0) {
                    const ret = instance.exports.invoke_swift_closure_TestModule_10TestModule6PersonC_6PersonC(boxPtr, param0.pointer);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return _exports['Person'].__construct(ret);
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModule6PersonC_6PersonC);
            }
            bjs["invoke_js_callback_TestModule_10TestModule9APIResultO_9APIResultO"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    const enumValue = enumHelpers.APIResult.lift(param0);
                    let ret = callback(enumValue);
                    const { caseId: caseId, cleanup: cleanup } = enumHelpers.APIResult.lower(ret);
                    return caseId;
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModule9APIResultO_9APIResultO = function(param0) {
                    const { caseId: param0CaseId, cleanup: param0Cleanup } = enumHelpers.APIResult.lower(param0);
                    instance.exports.invoke_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO(boxPtr, param0CaseId);
                    const ret = enumHelpers.APIResult.lift(i32Stack.pop());
                    if (param0Cleanup) { param0Cleanup(); }
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModule9APIResultO_9APIResultO);
            }
            bjs["invoke_js_callback_TestModule_10TestModule9DirectionO_9DirectionO"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0);
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            bjs["make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModule9DirectionO_9DirectionO = function(param0) {
                    const ret = instance.exports.invoke_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO(boxPtr, param0);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModule9DirectionO_9DirectionO);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSS_SS"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    const param0Object = swift.memory.getObject(param0);
                    swift.memory.release(param0);
                    let ret = callback(param0Object);
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSS_SS"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSS_SS = function(param0) {
                    const param0Bytes = textEncoder.encode(param0);
                    const param0Id = swift.memory.retain(param0Bytes);
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSS_SS(boxPtr, param0Id, param0Bytes.length);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSS_SS);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSb_Sb"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0 !== 0);
                    return ret ? 1 : 0;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSb_Sb"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSb_Sb = function(param0) {
                    const ret = instance.exports.invoke_swift_closure_TestModule_10TestModuleSb_Sb(boxPtr, param0);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret !== 0;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSb_Sb);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSd_Sd"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0);
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSd_Sd"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSd_Sd = function(param0) {
                    const ret = instance.exports.invoke_swift_closure_TestModule_10TestModuleSd_Sd(boxPtr, param0);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSd_Sd);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSf_Sf"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0);
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSf_Sf"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSf_Sf = function(param0) {
                    const ret = instance.exports.invoke_swift_closure_TestModule_10TestModuleSf_Sf(boxPtr, param0);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSf_Sf);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSi_Si"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0);
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSi_Si"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSi_Si = function(param0) {
                    const ret = instance.exports.invoke_swift_closure_TestModule_10TestModuleSi_Si(boxPtr, param0);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSi_Si);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0IsSome ? param0WrappedValue : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO = function(param0) {
                    const isSome = param0 != null;
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO(boxPtr, +isSome, isSome ? param0 : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let obj;
                    if (param0IsSome) {
                        obj = swift.memory.getObject(param0WrappedValue);
                        swift.memory.release(param0WrappedValue);
                    }
                    let ret = callback(param0IsSome ? obj : null);
                    const isSome = ret != null;
                    if (isSome) {
                        tmpRetString = ret;
                    } else {
                        tmpRetString = null;
                    }
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO = function(param0) {
                    const isSome = param0 != null;
                    let param0Id, param0Bytes;
                    if (isSome) {
                        param0Bytes = textEncoder.encode(param0);
                        param0Id = swift.memory.retain(param0Bytes);
                    }
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(boxPtr, +isSome, isSome ? param0Id : 0, isSome ? param0Bytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0IsSome ? _exports['Person'].__construct(param0WrappedValue) : null);
                    const isSome = ret != null;
                    return isSome ? ret.pointer : 0;
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC = function(param0) {
                    const isSome = param0 != null;
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC(boxPtr, +isSome, isSome ? param0.pointer : 0);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : _exports['Person'].__construct(pointer);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let enumValue;
                    if (param0IsSome) {
                        enumValue = enumHelpers.APIResult.lift(param0WrappedValue);
                    }
                    let ret = callback(param0IsSome ? enumValue : null);
                    const isSome = ret != null;
                    if (isSome) {
                        const { caseId: caseId, cleanup: cleanup } = enumHelpers.APIResult.lower(ret);
                        return caseId;
                    } else {
                        return -1;
                    }
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO = function(param0) {
                    const isSome = param0 != null;
                    let param0CaseId, param0Cleanup;
                    if (isSome) {
                        const enumResult = enumHelpers.APIResult.lower(param0);
                        param0CaseId = enumResult.caseId;
                        param0Cleanup = enumResult.cleanup;
                    }
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO(boxPtr, +isSome, isSome ? param0CaseId : 0);
                    const tag = i32Stack.pop();
                    const isNull = (tag === -1);
                    let optResult;
                    if (isNull) {
                        optResult = null;
                    } else {
                        optResult = enumHelpers.APIResult.lift(tag);
                    }
                    if (param0Cleanup) { param0Cleanup(); }
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0IsSome ? param0WrappedValue : null);
                    const isSome = ret != null;
                    return isSome ? (ret | 0) : -1;
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO = function(param0) {
                    const isSome = param0 != null;
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO(boxPtr, +isSome, isSome ? param0 : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSqSS_SqSS"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let obj;
                    if (param0IsSome) {
                        obj = swift.memory.getObject(param0WrappedValue);
                        swift.memory.release(param0WrappedValue);
                    }
                    let ret = callback(param0IsSome ? obj : null);
                    const isSome = ret != null;
                    if (isSome) {
                        tmpRetString = ret;
                    } else {
                        tmpRetString = null;
                    }
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSqSS_SqSS"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSqSS_SqSS = function(param0) {
                    const isSome = param0 != null;
                    let param0Id, param0Bytes;
                    if (isSome) {
                        param0Bytes = textEncoder.encode(param0);
                        param0Id = swift.memory.retain(param0Bytes);
                    }
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSqSS_SqSS(boxPtr, +isSome, isSome ? param0Id : 0, isSome ? param0Bytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSqSS_SqSS);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSqSb_SqSb"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0IsSome ? param0WrappedValue !== 0 : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_bool"](isSome ? 1 : 0, isSome ? (ret ? 1 : 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSqSb_SqSb"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSqSb_SqSb = function(param0) {
                    const isSome = param0 != null;
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSqSb_SqSb(boxPtr, +isSome, isSome ? param0 : 0);
                    const optResult = tmpRetOptionalBool;
                    tmpRetOptionalBool = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSqSb_SqSb);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSqSd_SqSd"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0IsSome ? param0WrappedValue : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_double"](isSome ? 1 : 0, isSome ? ret : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSqSd_SqSd"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSqSd_SqSd = function(param0) {
                    const isSome = param0 != null;
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSqSd_SqSd(boxPtr, +isSome, isSome ? param0 : 0);
                    const optResult = tmpRetOptionalDouble;
                    tmpRetOptionalDouble = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSqSd_SqSd);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSqSf_SqSf"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0IsSome ? param0WrappedValue : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_float"](isSome ? 1 : 0, isSome ? Math.fround(ret) : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSqSf_SqSf"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSqSf_SqSf = function(param0) {
                    const isSome = param0 != null;
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSqSf_SqSf(boxPtr, +isSome, isSome ? param0 : 0);
                    const optResult = tmpRetOptionalFloat;
                    tmpRetOptionalFloat = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSqSf_SqSf);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSqSi_SqSi"] = function(callbackId, param0IsSome, param0WrappedValue) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0IsSome ? param0WrappedValue : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSqSi_SqSi"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSqSi_SqSi = function(param0) {
                    const isSome = param0 != null;
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSqSi_SqSi(boxPtr, +isSome, isSome ? param0 : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return optResult;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSqSi_SqSi);
            }
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Person_wrap"] = function(pointer) {
                const obj = _exports['Person'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_TestProcessor_wrap"] = function(pointer) {
                const obj = _exports['TestProcessor'].__construct(pointer);
                return swift.memory.retain(obj);
            };
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
            class Person extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Person_deinit, Person.prototype);
                }

                constructor(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_Person_init(nameId, nameBytes.length);
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
            }
            const APIResultHelpers = __bjs_createAPIResultValuesHelpers()();
            enumHelpers.APIResult = APIResultHelpers;

            const exports = {
                Person,
                TestProcessor,
                roundtripString: function bjs_roundtripString(stringClosure) {
                    const callbackId = swift.memory.retain(stringClosure);
                    const ret = instance.exports.bjs_roundtripString(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripInt: function bjs_roundtripInt(intClosure) {
                    const callbackId = swift.memory.retain(intClosure);
                    const ret = instance.exports.bjs_roundtripInt(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripBool: function bjs_roundtripBool(boolClosure) {
                    const callbackId = swift.memory.retain(boolClosure);
                    const ret = instance.exports.bjs_roundtripBool(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripFloat: function bjs_roundtripFloat(floatClosure) {
                    const callbackId = swift.memory.retain(floatClosure);
                    const ret = instance.exports.bjs_roundtripFloat(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripDouble: function bjs_roundtripDouble(doubleClosure) {
                    const callbackId = swift.memory.retain(doubleClosure);
                    const ret = instance.exports.bjs_roundtripDouble(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalString: function bjs_roundtripOptionalString(stringClosure) {
                    const callbackId = swift.memory.retain(stringClosure);
                    const ret = instance.exports.bjs_roundtripOptionalString(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalInt: function bjs_roundtripOptionalInt(intClosure) {
                    const callbackId = swift.memory.retain(intClosure);
                    const ret = instance.exports.bjs_roundtripOptionalInt(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalBool: function bjs_roundtripOptionalBool(boolClosure) {
                    const callbackId = swift.memory.retain(boolClosure);
                    const ret = instance.exports.bjs_roundtripOptionalBool(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalFloat: function bjs_roundtripOptionalFloat(floatClosure) {
                    const callbackId = swift.memory.retain(floatClosure);
                    const ret = instance.exports.bjs_roundtripOptionalFloat(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalDouble: function bjs_roundtripOptionalDouble(doubleClosure) {
                    const callbackId = swift.memory.retain(doubleClosure);
                    const ret = instance.exports.bjs_roundtripOptionalDouble(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripPerson: function bjs_roundtripPerson(personClosure) {
                    const callbackId = swift.memory.retain(personClosure);
                    const ret = instance.exports.bjs_roundtripPerson(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalPerson: function bjs_roundtripOptionalPerson(personClosure) {
                    const callbackId = swift.memory.retain(personClosure);
                    const ret = instance.exports.bjs_roundtripOptionalPerson(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripDirection: function bjs_roundtripDirection(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripDirection(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripTheme: function bjs_roundtripTheme(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripTheme(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripHttpStatus: function bjs_roundtripHttpStatus(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripHttpStatus(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripAPIResult: function bjs_roundtripAPIResult(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripAPIResult(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalDirection: function bjs_roundtripOptionalDirection(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripOptionalDirection(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalTheme: function bjs_roundtripOptionalTheme(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripOptionalTheme(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalHttpStatus: function bjs_roundtripOptionalHttpStatus(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripOptionalHttpStatus(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalAPIResult: function bjs_roundtripOptionalAPIResult(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripOptionalAPIResult(callbackId);
                    return swift.memory.getObject(ret);
                },
                roundtripOptionalDirection: function bjs_roundtripOptionalDirection(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripOptionalDirection(callbackId);
                    return swift.memory.getObject(ret);
                },
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