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
    let decodeUTF8;
    const immortalStrings = new Map();
    const textDecoder = new TextDecoder("utf-8", { ignoreBOM: true });
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

    const swiftClosureRegistry = (typeof FinalizationRegistry === "undefined") ? { register: () => {}, unregister: () => {} } : new FinalizationRegistry((state) => {
        if (state.unregistered) { return; }
        instance?.exports?.bjs_release_swift_closure(state.pointer);
    });
    const makeClosure = (pointer, file, line, func) => {
        const state = { pointer, file, line, unregistered: false };
        const real = (...args) => {
            if (state.unregistered) {
                const bytes = new Uint8Array(memory.buffer, state.file >>> 0);
                let length = 0;
                while (bytes[length] !== 0) { length += 1; }
                const fileID = decodeUTF8(state.file, length);
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


    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            const imports = options.getImports(importsContext);
            bjs["swift_js_return_string"] = function(word0, word1, word2) {
                tmpRetString = decodeString(word0, word1, word2);
            }
            bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
                swift.memory.release(sourceId);
                const bytes = new Uint8Array(memory.buffer, bytesPtr >>> 0);
                bytes.set(source);
            }
            bjs["swift_js_make_js_string"] = function(word0, word1, word2) {
                return swift.memory.retain(decodeString(word0, word1, word2));
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
            bjs["swift_js_push_string"] = function(word0, word1, word2) {
                const value = decodeString(word0, word1, word2);
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
            bjs["swift_js_return_optional_string"] = function(isSome, word0, word1, word2) {
                if (isSome === 0) {
                    tmpRetString = null;
                } else {
                    tmpRetString = decodeString(word0, word1, word2);
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
            bjs["invoke_js_callback_TestModule_10TestModules7JSValueV_y"] = function(callbackId, param0Kind, param0Payload1, param0Payload2) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    const jsValue = __bjs_jsValueLift(param0Kind, param0Payload1, param0Payload2);
                    callback(jsValue);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModules7JSValueV_y"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModules7JSValueV_y = function(param0) {
                    const [param0Kind, param0Payload1, param0Payload2] = __bjs_jsValueLower(param0);
                    instance.exports.invoke_swift_closure_TestModule_10TestModules7JSValueV_y(boxPtr, param0Kind, param0Payload1, param0Payload2);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModules7JSValueV_y);
            }
            bjs["invoke_js_callback_TestModule_10TestModulesSd_y"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    callback(param0);
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModulesSd_y"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModulesSd_y = function(param0) {
                    instance.exports.invoke_swift_closure_TestModule_10TestModulesSd_y(boxPtr, param0);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModulesSd_y);
            }
            bjs["invoke_js_callback_TestModule_10TestModuley_y"] = function(callbackId) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    callback();
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuley_y"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuley_y = function() {
                    instance.exports.invoke_swift_closure_TestModule_10TestModuley_y(boxPtr);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuley_y);
            }
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_AsyncBox_asyncStaticRoundTrip_static"] = function bjs_AsyncBox_asyncStaticRoundTrip_static(resolveRef, rejectRef, v) {
                const resolve = swift.memory.getObject(resolveRef);
                const reject = swift.memory.getObject(rejectRef);
                imports.AsyncBox.asyncStaticRoundTrip(v).then(resolve, reject);
            }
            TestModule["bjs_AsyncBox_asyncStaticVoid_static"] = function bjs_AsyncBox_asyncStaticVoid_static(resolveRef, rejectRef) {
                const resolve = swift.memory.getObject(resolveRef);
                const reject = swift.memory.getObject(rejectRef);
                imports.AsyncBox.asyncStaticVoid().then(resolve, reject);
            }
        },
        setInstance: (i) => {
            if (memory !== i.exports.memory) immortalStrings.clear();
            instance = i;
            memory = instance.exports.memory;

            decodeUTF8 = (ptr, len) => { const bytes = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0); return textDecoder.decode(bytes); }
            decodeString = (() => {
                const byteAt = (word0, word1, byteIndex) =>
                    byteIndex < 4
                        ? (word0 >>> (byteIndex * 8)) & 255
                        : (word1 >>> ((byteIndex - 4) * 8)) & 255;
                // Valid small Swift strings need at most eight UTF-16 code units.
                const decodeSmallUTF8 = (word0, word1, count) => {
                    if (count > 8) {
                        throw new Error(`Unsupported Swift inline String length: ${count} UTF-8 bytes (maximum 8). The Swift String layout may have changed; update JavaScriptKit and regenerate BridgeJS glue.`);
                    }
                    let byteIndex = 0,
                        unitCount = 0,
                        u0 = 0,
                        u1 = 0,
                        u2 = 0,
                        u3 = 0,
                        u4 = 0,
                        u5 = 0,
                        u6 = 0,
                        u7 = 0;
                    while (byteIndex < count) {
                        const b0 = byteAt(word0, word1, byteIndex++);
                        let codePoint;
                        if (b0 < 128) codePoint = b0;
                        else if (b0 < 224) codePoint = ((b0 & 31) << 6) | (byteAt(word0, word1, byteIndex++) & 63);
                        else if (b0 < 240) {
                            const b1 = byteAt(word0, word1, byteIndex++),
                                b2 = byteAt(word0, word1, byteIndex++);
                            codePoint = ((b0 & 15) << 12) | ((b1 & 63) << 6) | (b2 & 63);
                        } else {
                            const b1 = byteAt(word0, word1, byteIndex++),
                                b2 = byteAt(word0, word1, byteIndex++),
                                b3 = byteAt(word0, word1, byteIndex++);
                            codePoint = ((b0 & 7) << 18) | ((b1 & 63) << 12) | ((b2 & 63) << 6) | (b3 & 63);
                        }
                        const supplementary = codePoint > 0xffff;
                        const codeUnit = supplementary
                            ? 0xd800 + ((codePoint - 0x10000) >>> 10)
                            : codePoint;
                        switch (unitCount++) {
                            case 0:
                                u0 = codeUnit;
                                break;
                            case 1:
                                u1 = codeUnit;
                                break;
                            case 2:
                                u2 = codeUnit;
                                break;
                            case 3:
                                u3 = codeUnit;
                                break;
                            case 4:
                                u4 = codeUnit;
                                break;
                            case 5:
                                u5 = codeUnit;
                                break;
                            case 6:
                                u6 = codeUnit;
                                break;
                            case 7:
                                u7 = codeUnit;
                                break;
                        }
                        if (supplementary) {
                            const lowSurrogate = 0xdc00 + ((codePoint - 0x10000) & 1023);
                            switch (unitCount++) {
                                case 0:
                                    u0 = lowSurrogate;
                                    break;
                                case 1:
                                    u1 = lowSurrogate;
                                    break;
                                case 2:
                                    u2 = lowSurrogate;
                                    break;
                                case 3:
                                    u3 = lowSurrogate;
                                    break;
                                case 4:
                                    u4 = lowSurrogate;
                                    break;
                                case 5:
                                    u5 = lowSurrogate;
                                    break;
                                case 6:
                                    u6 = lowSurrogate;
                                    break;
                                case 7:
                                    u7 = lowSurrogate;
                                    break;
                            }
                        }
                    }
                    switch (unitCount) {
                        case 0:
                            return "";
                        case 1:
                            return String.fromCharCode(u0);
                        case 2:
                            return String.fromCharCode(u0, u1);
                        case 3:
                            return String.fromCharCode(u0, u1, u2);
                        case 4:
                            return String.fromCharCode(u0, u1, u2, u3);
                        case 5:
                            return String.fromCharCode(u0, u1, u2, u3, u4);
                        case 6:
                            return String.fromCharCode(u0, u1, u2, u3, u4, u5);
                        case 7:
                            return String.fromCharCode(u0, u1, u2, u3, u4, u5, u6);
                        case 8:
                            return String.fromCharCode(u0, u1, u2, u3, u4, u5, u6, u7);
                    }
                };
                const decodeSmall = (word0, word1, word2) => {
                    const count = (word2 >>> 8) & 0x0f;
                    if ((word2 & 0x4000 /* ASCII */) === 0) return decodeSmallUTF8(word0, word1, count);
                    const char = String.fromCharCode;
                    switch (count) {
                        case 0: return "";
                        case 1: return char(word0 & 0xff);
                        case 2: return char(word0 & 0xff, (word0 >>> 8) & 0xff);
                        case 3: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff);
                        case 4: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24);
                        case 5: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24, word1 & 0xff);
                        case 6: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24, word1 & 0xff, (word1 >>> 8) & 0xff);
                        case 7: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24, word1 & 0xff, (word1 >>> 8) & 0xff, (word1 >>> 16) & 0xff);
                        case 8: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24, word1 & 0xff, (word1 >>> 8) & 0xff, (word1 >>> 16) & 0xff, word1 >>> 24);
                        default:
                            throw new Error(`Unsupported Swift inline String length: ${count} UTF-8 bytes (maximum 8). The Swift String layout may have changed; update JavaScriptKit and regenerate BridgeJS glue.`);
                    }
                };
                return (word0, word1, word2) => {
                    if (word2 & 0x2000 /* small */) return decodeSmall(word0, word1, word2);
                    const ptr = (word1 + 20 /* nativeBias */) >>> 0;
                    const len = word0 >>> 0;
                    if ((word2 & 0x8000 /* immortal */) === 0 || len >= 0x200000 /* 2^21 Number key */) return decodeUTF8(ptr, len);
                    const key = ptr + len * 0x100000000;
                    const cached = immortalStrings.get(key);
                    if (cached !== undefined) return cached;
                    const value = decodeUTF8(ptr, len);
                    immortalStrings.set(key, value);
                    return value;
                };
            })();

            setException = (error) => {
                instance.exports._swift_js_exception.value = swift.memory.retain(error)
            }
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;
            const exports = {
            };
            _exports = exports;
            return exports;
        },
    }
}