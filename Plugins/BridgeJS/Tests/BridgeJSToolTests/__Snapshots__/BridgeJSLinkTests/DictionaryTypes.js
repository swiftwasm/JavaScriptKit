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
            importObject["TestModule"]["bjs_Box_wrap"] = function(pointer) {
                const obj = _exports['Box'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_importMirrorDictionary"] = function bjs_importMirrorDictionary() {
                try {
                    const dictLen = i32Stack.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const f64 = f64Stack.pop();
                        const string = strStack.pop();
                        dictResult[string] = f64;
                    }
                    let ret = imports.importMirrorDictionary(dictResult);
                    const entries = Object.entries(ret);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                        f64Stack.push(value);
                    }
                    i32Stack.push(entries.length);
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
            const swiftHeapObjectFinalizationRegistry = (typeof FinalizationRegistry === "undefined") ? { register: () => {}, unregister: () => {} } : new FinalizationRegistry((state) => {
                if (state.hasReleased) {
                    return;
                }
                state.hasReleased = true;
                state.deinit(state.pointer);
            });

            /// Represents a Swift heap object like a class instance or an actor instance.
            class SwiftHeapObject {
                static __wrap(pointer, deinit, prototype) {
                    const obj = Object.create(prototype);
                    const state = { pointer, deinit, hasReleased: false };
                    obj.pointer = pointer;
                    obj.__swiftHeapObjectState = state;
                    swiftHeapObjectFinalizationRegistry.register(obj, state, state);
                    return obj;
                }

                release() {
                    const state = this.__swiftHeapObjectState;
                    if (state.hasReleased) {
                        return;
                    }
                    state.hasReleased = true;
                    swiftHeapObjectFinalizationRegistry.unregister(state);
                    state.deinit(state.pointer);
                }
            }
            class Box extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Box_deinit, Box.prototype);
                }

            }
            const exports = {
                Box,
                mirrorDictionary: function bjs_mirrorDictionary(values) {
                    const entries = Object.entries(values);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                        i32Stack.push((value | 0));
                    }
                    i32Stack.push(entries.length);
                    instance.exports.bjs_mirrorDictionary();
                    const dictLen = i32Stack.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const int = i32Stack.pop();
                        const string = strStack.pop();
                        dictResult[string] = int;
                    }
                    return dictResult;
                },
                optionalDictionary: function bjs_optionalDictionary(values) {
                    const isSome = values != null;
                    if (isSome) {
                        const entries = Object.entries(values);
                        for (const entry of entries) {
                            const [key, value] = entry;
                            const bytes = textEncoder.encode(key);
                            const id = swift.memory.retain(bytes);
                            i32Stack.push(bytes.length);
                            i32Stack.push(id);
                            const bytes1 = textEncoder.encode(value);
                            const id1 = swift.memory.retain(bytes1);
                            i32Stack.push(bytes1.length);
                            i32Stack.push(id1);
                        }
                        i32Stack.push(entries.length);
                    }
                    i32Stack.push(+isSome);
                    instance.exports.bjs_optionalDictionary();
                    const isSome1 = i32Stack.pop();
                    let optResult;
                    if (isSome1) {
                        const dictLen = i32Stack.pop();
                        const dictResult = {};
                        for (let i = 0; i < dictLen; i++) {
                            const string = strStack.pop();
                            const string1 = strStack.pop();
                            dictResult[string1] = string;
                        }
                        optResult = dictResult;
                    } else {
                        optResult = null;
                    }
                    return optResult;
                },
                nestedDictionary: function bjs_nestedDictionary(values) {
                    const entries = Object.entries(values);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                        for (const elem of value) {
                            i32Stack.push((elem | 0));
                        }
                        i32Stack.push(value.length);
                    }
                    i32Stack.push(entries.length);
                    instance.exports.bjs_nestedDictionary();
                    const dictLen = i32Stack.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const arrayLen = i32Stack.pop();
                        const arrayResult = [];
                        for (let i1 = 0; i1 < arrayLen; i1++) {
                            const int = i32Stack.pop();
                            arrayResult.push(int);
                        }
                        arrayResult.reverse();
                        const string = strStack.pop();
                        dictResult[string] = arrayResult;
                    }
                    return dictResult;
                },
                boxDictionary: function bjs_boxDictionary(boxes) {
                    const entries = Object.entries(boxes);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                        ptrStack.push(value.pointer);
                    }
                    i32Stack.push(entries.length);
                    instance.exports.bjs_boxDictionary();
                    const dictLen = i32Stack.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const ptr = ptrStack.pop();
                        const obj = _exports['Box'].__construct(ptr);
                        const string = strStack.pop();
                        dictResult[string] = obj;
                    }
                    return dictResult;
                },
                optionalBoxDictionary: function bjs_optionalBoxDictionary(boxes) {
                    const entries = Object.entries(boxes);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                        const isSome = value != null ? 1 : 0;
                        if (isSome) {
                            ptrStack.push(value.pointer);
                        } else {
                            ptrStack.push(0);
                        }
                        i32Stack.push(isSome);
                    }
                    i32Stack.push(entries.length);
                    instance.exports.bjs_optionalBoxDictionary();
                    const dictLen = i32Stack.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const isSome1 = i32Stack.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const ptr = ptrStack.pop();
                            const obj = _exports['Box'].__construct(ptr);
                            optValue = obj;
                        }
                        const string = strStack.pop();
                        dictResult[string] = optValue;
                    }
                    return dictResult;
                },
            };
            _exports = exports;
            return exports;
        },
    }
}