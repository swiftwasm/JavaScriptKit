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
    const __bjs_createFooContainerHelpers = () => ({
        lower: (value) => {
            let id;
            if (value.foo != null) {
                id = swift.memory.retain(value.foo);
            } else {
                id = undefined;
            }
            i32Stack.push(id !== undefined ? id : 0);
            const isSome = value.optionalFoo != null;
            if (isSome) {
                let id1;
                if (value.optionalFoo != null) {
                    id1 = swift.memory.retain(value.optionalFoo);
                } else {
                    id1 = undefined;
                }
                i32Stack.push(id1 !== undefined ? id1 : 0);
            } else {
                i32Stack.push(0);
            }
            i32Stack.push(isSome ? 1 : 0);
        },
        lift: () => {
            const isSome = i32Stack.pop();
            let optional;
            if (isSome) {
                const objectId = i32Stack.pop();
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
            const objectId1 = i32Stack.pop();
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
            bjs["swift_js_struct_lower_FooContainer"] = function(objectId) {
                structHelpers.FooContainer.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_FooContainer"] = function() {
                const value = structHelpers.FooContainer.lift();
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
            bjs["swift_js_closure_unregister"] = function(funcRef) {}
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
            const FooContainerHelpers = __bjs_createFooContainerHelpers();
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
                    for (const elem of foos) {
                        const objId = swift.memory.retain(elem);
                        i32Stack.push(objId);
                    }
                    i32Stack.push(foos.length);
                    instance.exports.bjs_processFooArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const objId1 = i32Stack.pop();
                        const obj = swift.memory.getObject(objId1);
                        swift.memory.release(objId1);
                        arrayResult.push(obj);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processOptionalFooArray: function bjs_processOptionalFooArray(foos) {
                    for (const elem of foos) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            const objId = swift.memory.retain(elem);
                            i32Stack.push(objId);
                        } else {
                            i32Stack.push(0);
                        }
                        i32Stack.push(isSome);
                    }
                    i32Stack.push(foos.length);
                    instance.exports.bjs_processOptionalFooArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = i32Stack.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const objId1 = i32Stack.pop();
                            const obj = swift.memory.getObject(objId1);
                            swift.memory.release(objId1);
                            optValue = obj;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                roundtripFooContainer: function bjs_roundtripFooContainer(container) {
                    structHelpers.FooContainer.lower(container);
                    instance.exports.bjs_roundtripFooContainer();
                    const structValue = structHelpers.FooContainer.lift();
                    return structValue;
                },
            };
            _exports = exports;
            return exports;
        },
    }
}