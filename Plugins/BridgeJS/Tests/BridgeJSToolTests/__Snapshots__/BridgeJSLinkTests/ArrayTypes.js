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

export const StatusValues = {
    Pending: 0,
    Active: 1,
    Completed: 2,
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
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    const __bjs_createPointHelpers = () => ({
        lower: (value) => {
            f64Stack.push(value.x);
            f64Stack.push(value.y);
        },
        lift: () => {
            const f64 = f64Stack.pop();
            const f641 = f64Stack.pop();
            return { x: f641, y: f64 };
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
            bjs["swift_js_struct_lower_Point"] = function(objectId) {
                structHelpers.Point.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Point"] = function() {
                const value = structHelpers.Point.lift();
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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Item_wrap"] = function(pointer) {
                const obj = _exports['Item'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_checkArray"] = function bjs_checkArray(a) {
                try {
                    imports.checkArray(swift.memory.getObject(a));
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_checkArrayWithLength"] = function bjs_checkArrayWithLength(a, b) {
                try {
                    imports.checkArrayWithLength(swift.memory.getObject(a), b);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importProcessNumbers"] = function bjs_importProcessNumbers() {
                try {
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const f64 = f64Stack.pop();
                        arrayResult.push(f64);
                    }
                    arrayResult.reverse();
                    imports.importProcessNumbers(arrayResult);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importGetNumbers"] = function bjs_importGetNumbers() {
                try {
                    let ret = imports.importGetNumbers();
                    for (const elem of ret) {
                        f64Stack.push(elem);
                    }
                    i32Stack.push(ret.length);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importTransformNumbers"] = function bjs_importTransformNumbers() {
                try {
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const f64 = f64Stack.pop();
                        arrayResult.push(f64);
                    }
                    arrayResult.reverse();
                    let ret = imports.importTransformNumbers(arrayResult);
                    for (const elem of ret) {
                        f64Stack.push(elem);
                    }
                    i32Stack.push(ret.length);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importProcessStrings"] = function bjs_importProcessStrings() {
                try {
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const string = strStack.pop();
                        arrayResult.push(string);
                    }
                    arrayResult.reverse();
                    let ret = imports.importProcessStrings(arrayResult);
                    for (const elem of ret) {
                        const bytes = textEncoder.encode(elem);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                    }
                    i32Stack.push(ret.length);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_importProcessBooleans"] = function bjs_importProcessBooleans() {
                try {
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const bool = i32Stack.pop() !== 0;
                        arrayResult.push(bool);
                    }
                    arrayResult.reverse();
                    let ret = imports.importProcessBooleans(arrayResult);
                    for (const elem of ret) {
                        i32Stack.push(elem ? 1 : 0);
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
            class Item extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Item_deinit, Item.prototype);
                }

            }
            const PointHelpers = __bjs_createPointHelpers();
            structHelpers.Point = PointHelpers;

            const exports = {
                Item,
                processIntArray: function bjs_processIntArray(values) {
                    for (const elem of values) {
                        i32Stack.push((elem | 0));
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processIntArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const int = i32Stack.pop();
                        arrayResult.push(int);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processStringArray: function bjs_processStringArray(values) {
                    for (const elem of values) {
                        const bytes = textEncoder.encode(elem);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processStringArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const string = strStack.pop();
                        arrayResult.push(string);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processDoubleArray: function bjs_processDoubleArray(values) {
                    for (const elem of values) {
                        f64Stack.push(elem);
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processDoubleArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const f64 = f64Stack.pop();
                        arrayResult.push(f64);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processBoolArray: function bjs_processBoolArray(values) {
                    for (const elem of values) {
                        i32Stack.push(elem ? 1 : 0);
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processBoolArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const bool = i32Stack.pop() !== 0;
                        arrayResult.push(bool);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processPointArray: function bjs_processPointArray(points) {
                    for (const elem of points) {
                        structHelpers.Point.lower(elem);
                    }
                    i32Stack.push(points.length);
                    instance.exports.bjs_processPointArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const struct = structHelpers.Point.lift();
                        arrayResult.push(struct);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processDirectionArray: function bjs_processDirectionArray(directions) {
                    for (const elem of directions) {
                        i32Stack.push((elem | 0));
                    }
                    i32Stack.push(directions.length);
                    instance.exports.bjs_processDirectionArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const caseId = i32Stack.pop();
                        arrayResult.push(caseId);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processStatusArray: function bjs_processStatusArray(statuses) {
                    for (const elem of statuses) {
                        i32Stack.push((elem | 0));
                    }
                    i32Stack.push(statuses.length);
                    instance.exports.bjs_processStatusArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const rawValue = i32Stack.pop();
                        arrayResult.push(rawValue);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                sumIntArray: function bjs_sumIntArray(values) {
                    for (const elem of values) {
                        i32Stack.push((elem | 0));
                    }
                    i32Stack.push(values.length);
                    const ret = instance.exports.bjs_sumIntArray();
                    return ret;
                },
                findFirstPoint: function bjs_findFirstPoint(points, matching) {
                    for (const elem of points) {
                        structHelpers.Point.lower(elem);
                    }
                    i32Stack.push(points.length);
                    const matchingBytes = textEncoder.encode(matching);
                    const matchingId = swift.memory.retain(matchingBytes);
                    instance.exports.bjs_findFirstPoint(matchingId, matchingBytes.length);
                    const structValue = structHelpers.Point.lift();
                    return structValue;
                },
                processUnsafeRawPointerArray: function bjs_processUnsafeRawPointerArray(values) {
                    for (const elem of values) {
                        ptrStack.push((elem | 0));
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processUnsafeRawPointerArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const pointer = ptrStack.pop();
                        arrayResult.push(pointer);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processUnsafeMutableRawPointerArray: function bjs_processUnsafeMutableRawPointerArray(values) {
                    for (const elem of values) {
                        ptrStack.push((elem | 0));
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processUnsafeMutableRawPointerArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const pointer = ptrStack.pop();
                        arrayResult.push(pointer);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processOpaquePointerArray: function bjs_processOpaquePointerArray(values) {
                    for (const elem of values) {
                        ptrStack.push((elem | 0));
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processOpaquePointerArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const pointer = ptrStack.pop();
                        arrayResult.push(pointer);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processOptionalIntArray: function bjs_processOptionalIntArray(values) {
                    for (const elem of values) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            i32Stack.push((elem | 0));
                        } else {
                            i32Stack.push(0);
                        }
                        i32Stack.push(isSome);
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processOptionalIntArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = i32Stack.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const int = i32Stack.pop();
                            optValue = int;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processOptionalStringArray: function bjs_processOptionalStringArray(values) {
                    for (const elem of values) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            const bytes = textEncoder.encode(elem);
                            const id = swift.memory.retain(bytes);
                            i32Stack.push(bytes.length);
                            i32Stack.push(id);
                        } else {
                            i32Stack.push(0);
                            i32Stack.push(0);
                        }
                        i32Stack.push(isSome);
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processOptionalStringArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = i32Stack.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const string = strStack.pop();
                            optValue = string;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processOptionalArray: function bjs_processOptionalArray(values) {
                    const isSome = values != null;
                    if (isSome) {
                        for (const elem of values) {
                            i32Stack.push((elem | 0));
                        }
                        i32Stack.push(values.length);
                    }
                    i32Stack.push(+isSome);
                    instance.exports.bjs_processOptionalArray();
                    const isSome1 = i32Stack.pop();
                    let optResult;
                    if (isSome1) {
                        const arrayLen = i32Stack.pop();
                        const arrayResult = [];
                        for (let i = 0; i < arrayLen; i++) {
                            const int = i32Stack.pop();
                            arrayResult.push(int);
                        }
                        arrayResult.reverse();
                        optResult = arrayResult;
                    } else {
                        optResult = null;
                    }
                    return optResult;
                },
                processOptionalPointArray: function bjs_processOptionalPointArray(points) {
                    for (const elem of points) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            structHelpers.Point.lower(elem);
                        }
                        i32Stack.push(isSome);
                    }
                    i32Stack.push(points.length);
                    instance.exports.bjs_processOptionalPointArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = i32Stack.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const struct = structHelpers.Point.lift();
                            optValue = struct;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processOptionalDirectionArray: function bjs_processOptionalDirectionArray(directions) {
                    for (const elem of directions) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            i32Stack.push((elem | 0));
                        } else {
                            i32Stack.push(0);
                        }
                        i32Stack.push(isSome);
                    }
                    i32Stack.push(directions.length);
                    instance.exports.bjs_processOptionalDirectionArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = i32Stack.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const caseId = i32Stack.pop();
                            optValue = caseId;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processOptionalStatusArray: function bjs_processOptionalStatusArray(statuses) {
                    for (const elem of statuses) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            i32Stack.push((elem | 0));
                        } else {
                            i32Stack.push(0);
                        }
                        i32Stack.push(isSome);
                    }
                    i32Stack.push(statuses.length);
                    instance.exports.bjs_processOptionalStatusArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = i32Stack.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const rawValue = i32Stack.pop();
                            optValue = rawValue;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processNestedIntArray: function bjs_processNestedIntArray(values) {
                    for (const elem of values) {
                        for (const elem1 of elem) {
                            i32Stack.push((elem1 | 0));
                        }
                        i32Stack.push(elem.length);
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processNestedIntArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const arrayLen1 = i32Stack.pop();
                        const arrayResult1 = [];
                        for (let i1 = 0; i1 < arrayLen1; i1++) {
                            const int = i32Stack.pop();
                            arrayResult1.push(int);
                        }
                        arrayResult1.reverse();
                        arrayResult.push(arrayResult1);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processNestedStringArray: function bjs_processNestedStringArray(values) {
                    for (const elem of values) {
                        for (const elem1 of elem) {
                            const bytes = textEncoder.encode(elem1);
                            const id = swift.memory.retain(bytes);
                            i32Stack.push(bytes.length);
                            i32Stack.push(id);
                        }
                        i32Stack.push(elem.length);
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_processNestedStringArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const arrayLen1 = i32Stack.pop();
                        const arrayResult1 = [];
                        for (let i1 = 0; i1 < arrayLen1; i1++) {
                            const string = strStack.pop();
                            arrayResult1.push(string);
                        }
                        arrayResult1.reverse();
                        arrayResult.push(arrayResult1);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processNestedPointArray: function bjs_processNestedPointArray(points) {
                    for (const elem of points) {
                        for (const elem1 of elem) {
                            structHelpers.Point.lower(elem1);
                        }
                        i32Stack.push(elem.length);
                    }
                    i32Stack.push(points.length);
                    instance.exports.bjs_processNestedPointArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const arrayLen1 = i32Stack.pop();
                        const arrayResult1 = [];
                        for (let i1 = 0; i1 < arrayLen1; i1++) {
                            const struct = structHelpers.Point.lift();
                            arrayResult1.push(struct);
                        }
                        arrayResult1.reverse();
                        arrayResult.push(arrayResult1);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processItemArray: function bjs_processItemArray(items) {
                    for (const elem of items) {
                        ptrStack.push(elem.pointer);
                    }
                    i32Stack.push(items.length);
                    instance.exports.bjs_processItemArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const ptr = ptrStack.pop();
                        const obj = _exports['Item'].__construct(ptr);
                        arrayResult.push(obj);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processNestedItemArray: function bjs_processNestedItemArray(items) {
                    for (const elem of items) {
                        for (const elem1 of elem) {
                            ptrStack.push(elem1.pointer);
                        }
                        i32Stack.push(elem.length);
                    }
                    i32Stack.push(items.length);
                    instance.exports.bjs_processNestedItemArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const arrayLen1 = i32Stack.pop();
                        const arrayResult1 = [];
                        for (let i1 = 0; i1 < arrayLen1; i1++) {
                            const ptr = ptrStack.pop();
                            const obj = _exports['Item'].__construct(ptr);
                            arrayResult1.push(obj);
                        }
                        arrayResult1.reverse();
                        arrayResult.push(arrayResult1);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                processJSObjectArray: function bjs_processJSObjectArray(objects) {
                    for (const elem of objects) {
                        const objId = swift.memory.retain(elem);
                        i32Stack.push(objId);
                    }
                    i32Stack.push(objects.length);
                    instance.exports.bjs_processJSObjectArray();
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
                processOptionalJSObjectArray: function bjs_processOptionalJSObjectArray(objects) {
                    for (const elem of objects) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            const objId = swift.memory.retain(elem);
                            i32Stack.push(objId);
                        } else {
                            i32Stack.push(0);
                        }
                        i32Stack.push(isSome);
                    }
                    i32Stack.push(objects.length);
                    instance.exports.bjs_processOptionalJSObjectArray();
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
                processNestedJSObjectArray: function bjs_processNestedJSObjectArray(objects) {
                    for (const elem of objects) {
                        for (const elem1 of elem) {
                            const objId = swift.memory.retain(elem1);
                            i32Stack.push(objId);
                        }
                        i32Stack.push(elem.length);
                    }
                    i32Stack.push(objects.length);
                    instance.exports.bjs_processNestedJSObjectArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const arrayLen1 = i32Stack.pop();
                        const arrayResult1 = [];
                        for (let i1 = 0; i1 < arrayLen1; i1++) {
                            const objId1 = i32Stack.pop();
                            const obj = swift.memory.getObject(objId1);
                            swift.memory.release(objId1);
                            arrayResult1.push(obj);
                        }
                        arrayResult1.reverse();
                        arrayResult.push(arrayResult1);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                Direction: DirectionValues,
                Status: StatusValues,
            };
            _exports = exports;
            return exports;
        },
    }
}