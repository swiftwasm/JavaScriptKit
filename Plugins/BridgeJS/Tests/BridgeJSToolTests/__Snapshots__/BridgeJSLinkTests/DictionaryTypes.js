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
    let tmpRetTag = [];
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
            const imports = options.getImports(importsContext);
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
                tmpRetTag.push(tag);
            }
            bjs["swift_js_push_i32"] = function(v) {
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
            bjs["swift_js_pop_i32"] = function() {
                return tmpParamInts.pop();
            }
            bjs["swift_js_pop_f32"] = function() {
                return tmpParamF32s.pop();
            }
            bjs["swift_js_pop_f64"] = function() {
                return tmpParamF64s.pop();
            }
            bjs["swift_js_push_pointer"] = function(pointer) {
                tmpRetPointers.push(pointer);
            }
            bjs["swift_js_pop_pointer"] = function() {
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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Box_wrap"] = function(pointer) {
                const obj = Box.__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_importMirrorDictionary"] = function bjs_importMirrorDictionary() {
                try {
                    const dictLen = tmpRetInts.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const f64 = tmpRetF64s.pop();
                        const string = tmpRetStrings.pop();
                        dictResult[string] = f64;
                    }
                    let ret = imports.importMirrorDictionary(dictResult);
                    const arrayCleanups = [];
                    const entries = Object.entries(ret);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        tmpParamInts.push(bytes.length);
                        tmpParamInts.push(id);
                        arrayCleanups.push(() => {
                            swift.memory.release(id);
                        });
                        tmpParamF64s.push(value);
                    }
                    tmpParamInts.push(entries.length);
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
            class Box extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Box_deinit, Box.prototype);
                }

            }
            const exports = {
                Box,
                mirrorDictionary: function bjs_mirrorDictionary(values) {
                    const arrayCleanups = [];
                    const entries = Object.entries(values);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        tmpParamInts.push(bytes.length);
                        tmpParamInts.push(id);
                        arrayCleanups.push(() => {
                            swift.memory.release(id);
                        });
                        tmpParamInts.push((value | 0));
                    }
                    tmpParamInts.push(entries.length);
                    instance.exports.bjs_mirrorDictionary();
                    const dictLen = tmpRetInts.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const int = tmpRetInts.pop();
                        const string = tmpRetStrings.pop();
                        dictResult[string] = int;
                    }
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return dictResult;
                },
                optionalDictionary: function bjs_optionalDictionary(values) {
                    const isSome = values != null;
                    const valuesCleanups = [];
                    if (isSome) {
                        const arrayCleanups = [];
                        const entries = Object.entries(values);
                        for (const entry of entries) {
                            const [key, value] = entry;
                            const bytes = textEncoder.encode(key);
                            const id = swift.memory.retain(bytes);
                            tmpParamInts.push(bytes.length);
                            tmpParamInts.push(id);
                            arrayCleanups.push(() => {
                                swift.memory.release(id);
                            });
                            const bytes1 = textEncoder.encode(value);
                            const id1 = swift.memory.retain(bytes1);
                            tmpParamInts.push(bytes1.length);
                            tmpParamInts.push(id1);
                            arrayCleanups.push(() => {
                                swift.memory.release(id1);
                            });
                        }
                        tmpParamInts.push(entries.length);
                        valuesCleanups.push(() => { for (const cleanup of arrayCleanups) { cleanup(); } });
                    }
                    instance.exports.bjs_optionalDictionary(+isSome);
                    const isSome1 = tmpRetInts.pop();
                    let optResult;
                    if (isSome1) {
                        const dictLen = tmpRetInts.pop();
                        const dictResult = {};
                        for (let i = 0; i < dictLen; i++) {
                            const string = tmpRetStrings.pop();
                            const string1 = tmpRetStrings.pop();
                            dictResult[string1] = string;
                        }
                        optResult = dictResult;
                    } else {
                        optResult = null;
                    }
                    for (const cleanup of valuesCleanups) { cleanup(); }
                    return optResult;
                },
                nestedDictionary: function bjs_nestedDictionary(values) {
                    const arrayCleanups = [];
                    const entries = Object.entries(values);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        tmpParamInts.push(bytes.length);
                        tmpParamInts.push(id);
                        arrayCleanups.push(() => {
                            swift.memory.release(id);
                        });
                        const arrayCleanups1 = [];
                        for (const elem of value) {
                            tmpParamInts.push((elem | 0));
                        }
                        tmpParamInts.push(value.length);
                        arrayCleanups.push(() => {
                            for (const cleanup of arrayCleanups1) { cleanup(); }
                        });
                    }
                    tmpParamInts.push(entries.length);
                    instance.exports.bjs_nestedDictionary();
                    const dictLen = tmpRetInts.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const arrayLen = tmpRetInts.pop();
                        const arrayResult = [];
                        for (let i1 = 0; i1 < arrayLen; i1++) {
                            const int = tmpRetInts.pop();
                            arrayResult.push(int);
                        }
                        arrayResult.reverse();
                        const string = tmpRetStrings.pop();
                        dictResult[string] = arrayResult;
                    }
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return dictResult;
                },
                boxDictionary: function bjs_boxDictionary(boxes) {
                    const arrayCleanups = [];
                    const entries = Object.entries(boxes);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        tmpParamInts.push(bytes.length);
                        tmpParamInts.push(id);
                        arrayCleanups.push(() => {
                            swift.memory.release(id);
                        });
                        tmpParamPointers.push(value.pointer);
                    }
                    tmpParamInts.push(entries.length);
                    instance.exports.bjs_boxDictionary();
                    const dictLen = tmpRetInts.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const ptr = tmpRetPointers.pop();
                        const obj = _exports['Box'].__construct(ptr);
                        const string = tmpRetStrings.pop();
                        dictResult[string] = obj;
                    }
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return dictResult;
                },
                optionalBoxDictionary: function bjs_optionalBoxDictionary(boxes) {
                    const arrayCleanups = [];
                    const entries = Object.entries(boxes);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        tmpParamInts.push(bytes.length);
                        tmpParamInts.push(id);
                        arrayCleanups.push(() => {
                            swift.memory.release(id);
                        });
                        const isSome = value != null ? 1 : 0;
                        if (isSome) {
                            tmpParamPointers.push(value.pointer);
                        } else {
                            tmpParamPointers.push(0);
                        }
                        tmpParamInts.push(isSome);
                    }
                    tmpParamInts.push(entries.length);
                    instance.exports.bjs_optionalBoxDictionary();
                    const dictLen = tmpRetInts.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const isSome1 = tmpRetInts.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const ptr = tmpRetPointers.pop();
                            const obj = _exports['Box'].__construct(ptr);
                            optValue = obj;
                        }
                        const string = tmpRetStrings.pop();
                        dictResult[string] = optValue;
                    }
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return dictResult;
                },
            };
            _exports = exports;
            return exports;
        },
    }
}