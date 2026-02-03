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
    const __bjs_createFooContainerHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                let id;
                if (value.foo != null) {
                    id = swift.memory.retain(value.foo);
                } else {
                    id = undefined;
                }
                tmpParamInts.push(id !== undefined ? id : 0);
                const isSome = value.optionalFoo != null;
                let id1;
                if (isSome) {
                    id1 = swift.memory.retain(value.optionalFoo);
                    tmpParamInts.push(id1);
                } else {
                    id1 = undefined;
                    tmpParamInts.push(0);
                }
                tmpParamInts.push(isSome ? 1 : 0);
                const cleanup = () => {
                    if(id !== undefined && id !== 0) {
                        try {
                            swift.memory.getObject(id);
                            swift.memory.release(id);
                        } catch(e) {}
                    }
                    if(id1 !== undefined && id1 !== 0) {
                        try {
                            swift.memory.getObject(id1);
                            swift.memory.release(id1);
                        } catch(e) {}
                    }
                };
                return { cleanup };
            },
            lift: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                const isSome = tmpRetInts.pop();
                let optional;
                if (isSome) {
                    const objectId = tmpRetInts.pop();
                    let value;
                    if (objectId !== 0) {
                        value = swift.memory.getObject(objectId);
                        swift.memory.release(objectId);
                    } else {
                        value = null;
                    }
                    optional = value;
                } else {
                    optional = null;
                }
                const objectId1 = tmpRetInts.pop();
                let value1;
                if (objectId1 !== 0) {
                    value1 = swift.memory.getObject(objectId1);
                    swift.memory.release(objectId1);
                } else {
                    value1 = null;
                }
                return { foo: value1, optionalFoo: optional };
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
                tmpRetTag = tag;
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
            bjs["swift_js_struct_lower_FooContainer"] = function(objectId) {
                const { cleanup: cleanup } = structHelpers.FooContainer.lower(swift.memory.getObject(objectId));
                if (cleanup) {
                    return tmpStructCleanups.push(cleanup);
                }
                return 0;
            }
            bjs["swift_js_struct_lift_FooContainer"] = function() {
                const value = structHelpers.FooContainer.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                return swift.memory.retain(value);
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
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_Foo_init"] = function bjs_Foo_init() {
                try {
                    return swift.memory.retain(new imports.Foo());
                } catch (error) {
                    setException(error);
                    return 0
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
            const FooContainerHelpers = __bjs_createFooContainerHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.FooContainer = FooContainerHelpers;
            
            const exports = {
                makeFoo: function bjs_makeFoo() {
                    const ret = instance.exports.bjs_makeFoo();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret1;
                },
                processFooArray: function bjs_processFooArray(foos) {
                    const arrayCleanups = [];
                    for (const elem of foos) {
                        const objId = swift.memory.retain(elem);
                        tmpParamInts.push(objId);
                    }
                    tmpParamInts.push(foos.length);
                    instance.exports.bjs_processFooArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const objId1 = tmpRetInts.pop();
                        const obj = swift.memory.getObject(objId1);
                        swift.memory.release(objId1);
                        arrayResult.push(obj);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processOptionalFooArray: function bjs_processOptionalFooArray(foos) {
                    const arrayCleanups = [];
                    for (const elem of foos) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            const objId = swift.memory.retain(elem);
                            tmpParamInts.push(objId);
                        } else {
                            tmpParamInts.push(0);
                        }
                        tmpParamInts.push(isSome);
                    }
                    tmpParamInts.push(foos.length);
                    instance.exports.bjs_processOptionalFooArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = tmpRetInts.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const objId1 = tmpRetInts.pop();
                            const obj = swift.memory.getObject(objId1);
                            swift.memory.release(objId1);
                            optValue = obj;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                roundtripFooContainer: function bjs_roundtripFooContainer(container) {
                    const { cleanup: cleanup } = structHelpers.FooContainer.lower(container);
                    instance.exports.bjs_roundtripFooContainer();
                    const structValue = structHelpers.FooContainer.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                    if (cleanup) { cleanup(); }
                    return structValue;
                },
            };
            _exports = exports;
            return exports;
        },
    }
}