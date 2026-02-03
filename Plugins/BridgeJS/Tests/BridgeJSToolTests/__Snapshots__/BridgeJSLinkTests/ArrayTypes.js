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
    const __bjs_createPointHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                tmpParamF64s.push(value.x);
                tmpParamF64s.push(value.y);
                return { cleanup: undefined };
            },
            lift: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                const f64 = tmpRetF64s.pop();
                const f641 = tmpRetF64s.pop();
                return { x: f641, y: f64 };
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
            bjs["swift_js_struct_lower_Point"] = function(objectId) {
                const { cleanup: cleanup } = structHelpers.Point.lower(swift.memory.getObject(objectId));
                if (cleanup) {
                    return tmpStructCleanups.push(cleanup);
                }
                return 0;
            }
            bjs["swift_js_struct_lift_Point"] = function() {
                const value = structHelpers.Point.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Item_wrap"] = function(pointer) {
                const obj = Item.__construct(pointer);
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
            TestModule["bjs_checkArray"] = function bjs_checkArray(a) {
                try {
                    imports.checkArray(swift.memory.getObject(a));
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
            class Item extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Item_deinit, Item.prototype);
                }
            
            }
            const PointHelpers = __bjs_createPointHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.Point = PointHelpers;
            
            const exports = {
                Item,
                processIntArray: function bjs_processIntArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        tmpParamInts.push((elem | 0));
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processIntArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const int = tmpRetInts.pop();
                        arrayResult.push(int);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processStringArray: function bjs_processStringArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        const bytes = textEncoder.encode(elem);
                        const id = swift.memory.retain(bytes);
                        tmpParamInts.push(bytes.length);
                        tmpParamInts.push(id);
                        arrayCleanups.push(() => {
                            swift.memory.release(id);
                        });
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processStringArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const string = tmpRetStrings.pop();
                        arrayResult.push(string);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processDoubleArray: function bjs_processDoubleArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        tmpParamF64s.push(elem);
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processDoubleArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const f64 = tmpRetF64s.pop();
                        arrayResult.push(f64);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processBoolArray: function bjs_processBoolArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        tmpParamInts.push(elem ? 1 : 0);
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processBoolArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const bool = tmpRetInts.pop() !== 0;
                        arrayResult.push(bool);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processPointArray: function bjs_processPointArray(points) {
                    const arrayCleanups = [];
                    for (const elem of points) {
                        const { cleanup: cleanup } = structHelpers.Point.lower(elem);
                        arrayCleanups.push(() => {
                            if (cleanup) { cleanup(); }
                        });
                    }
                    tmpParamInts.push(points.length);
                    instance.exports.bjs_processPointArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const struct = structHelpers.Point.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                        arrayResult.push(struct);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processDirectionArray: function bjs_processDirectionArray(directions) {
                    const arrayCleanups = [];
                    for (const elem of directions) {
                        tmpParamInts.push((elem | 0));
                    }
                    tmpParamInts.push(directions.length);
                    instance.exports.bjs_processDirectionArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const caseId = tmpRetInts.pop();
                        arrayResult.push(caseId);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processStatusArray: function bjs_processStatusArray(statuses) {
                    const arrayCleanups = [];
                    for (const elem of statuses) {
                        tmpParamInts.push((elem | 0));
                    }
                    tmpParamInts.push(statuses.length);
                    instance.exports.bjs_processStatusArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const rawValue = tmpRetInts.pop();
                        arrayResult.push(rawValue);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                sumIntArray: function bjs_sumIntArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        tmpParamInts.push((elem | 0));
                    }
                    tmpParamInts.push(values.length);
                    const ret = instance.exports.bjs_sumIntArray();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return ret;
                },
                findFirstPoint: function bjs_findFirstPoint(points, matching) {
                    const arrayCleanups = [];
                    for (const elem of points) {
                        const { cleanup: cleanup } = structHelpers.Point.lower(elem);
                        arrayCleanups.push(() => {
                            if (cleanup) { cleanup(); }
                        });
                    }
                    tmpParamInts.push(points.length);
                    const matchingBytes = textEncoder.encode(matching);
                    const matchingId = swift.memory.retain(matchingBytes);
                    instance.exports.bjs_findFirstPoint(matchingId, matchingBytes.length);
                    const structValue = structHelpers.Point.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    swift.memory.release(matchingId);
                    return structValue;
                },
                processUnsafeRawPointerArray: function bjs_processUnsafeRawPointerArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        tmpParamPointers.push((elem | 0));
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processUnsafeRawPointerArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const pointer = tmpRetPointers.pop();
                        arrayResult.push(pointer);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processUnsafeMutableRawPointerArray: function bjs_processUnsafeMutableRawPointerArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        tmpParamPointers.push((elem | 0));
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processUnsafeMutableRawPointerArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const pointer = tmpRetPointers.pop();
                        arrayResult.push(pointer);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processOpaquePointerArray: function bjs_processOpaquePointerArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        tmpParamPointers.push((elem | 0));
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processOpaquePointerArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const pointer = tmpRetPointers.pop();
                        arrayResult.push(pointer);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processOptionalIntArray: function bjs_processOptionalIntArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            tmpParamInts.push((elem | 0));
                        } else {
                            tmpParamInts.push(0);
                        }
                        tmpParamInts.push(isSome);
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processOptionalIntArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = tmpRetInts.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const int = tmpRetInts.pop();
                            optValue = int;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processOptionalStringArray: function bjs_processOptionalStringArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            const bytes = textEncoder.encode(elem);
                            const id = swift.memory.retain(bytes);
                            tmpParamInts.push(bytes.length);
                            tmpParamInts.push(id);
                            arrayCleanups.push(() => { swift.memory.release(id); });
                        } else {
                            tmpParamInts.push(0);
                            tmpParamInts.push(0);
                        }
                        tmpParamInts.push(isSome);
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processOptionalStringArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = tmpRetInts.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const string = tmpRetStrings.pop();
                            optValue = string;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processOptionalArray: function bjs_processOptionalArray(values) {
                    const isSome = values != null;
                    const valuesCleanups = [];
                    if (isSome) {
                        const arrayCleanups = [];
                        for (const elem of values) {
                            tmpParamInts.push((elem | 0));
                        }
                        tmpParamInts.push(values.length);
                        valuesCleanups.push(() => { for (const cleanup of arrayCleanups) { cleanup(); } });
                    }
                    instance.exports.bjs_processOptionalArray(+isSome);
                    const isSome1 = tmpRetInts.pop();
                    let optResult;
                    if (isSome1) {
                        const arrayLen = tmpRetInts.pop();
                        const arrayResult = [];
                        for (let i = 0; i < arrayLen; i++) {
                            const int = tmpRetInts.pop();
                            arrayResult.push(int);
                        }
                        arrayResult.reverse();
                        optResult = arrayResult;
                    } else {
                        optResult = null;
                    }
                    for (const cleanup of valuesCleanups) { cleanup(); }
                    return optResult;
                },
                processOptionalPointArray: function bjs_processOptionalPointArray(points) {
                    const arrayCleanups = [];
                    for (const elem of points) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            const { cleanup: cleanup } = structHelpers.Point.lower(elem);
                            arrayCleanups.push(() => { if (cleanup) { cleanup(); } });
                        } else {
                        }
                        tmpParamInts.push(isSome);
                    }
                    tmpParamInts.push(points.length);
                    instance.exports.bjs_processOptionalPointArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = tmpRetInts.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const struct = structHelpers.Point.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                            optValue = struct;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processOptionalDirectionArray: function bjs_processOptionalDirectionArray(directions) {
                    const arrayCleanups = [];
                    for (const elem of directions) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            tmpParamInts.push((elem | 0));
                        } else {
                            tmpParamInts.push(0);
                        }
                        tmpParamInts.push(isSome);
                    }
                    tmpParamInts.push(directions.length);
                    instance.exports.bjs_processOptionalDirectionArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = tmpRetInts.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const caseId = tmpRetInts.pop();
                            optValue = caseId;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processOptionalStatusArray: function bjs_processOptionalStatusArray(statuses) {
                    const arrayCleanups = [];
                    for (const elem of statuses) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            tmpParamInts.push((elem | 0));
                        } else {
                            tmpParamInts.push(0);
                        }
                        tmpParamInts.push(isSome);
                    }
                    tmpParamInts.push(statuses.length);
                    instance.exports.bjs_processOptionalStatusArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome1 = tmpRetInts.pop();
                        let optValue;
                        if (isSome1 === 0) {
                            optValue = null;
                        } else {
                            const rawValue = tmpRetInts.pop();
                            optValue = rawValue;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processNestedIntArray: function bjs_processNestedIntArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        const arrayCleanups1 = [];
                        for (const elem1 of elem) {
                            tmpParamInts.push((elem1 | 0));
                        }
                        tmpParamInts.push(elem.length);
                        arrayCleanups.push(() => {
                            for (const cleanup of arrayCleanups1) { cleanup(); }
                        });
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processNestedIntArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const arrayLen1 = tmpRetInts.pop();
                        const arrayResult1 = [];
                        for (let i1 = 0; i1 < arrayLen1; i1++) {
                            const int = tmpRetInts.pop();
                            arrayResult1.push(int);
                        }
                        arrayResult1.reverse();
                        arrayResult.push(arrayResult1);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processNestedStringArray: function bjs_processNestedStringArray(values) {
                    const arrayCleanups = [];
                    for (const elem of values) {
                        const arrayCleanups1 = [];
                        for (const elem1 of elem) {
                            const bytes = textEncoder.encode(elem1);
                            const id = swift.memory.retain(bytes);
                            tmpParamInts.push(bytes.length);
                            tmpParamInts.push(id);
                            arrayCleanups1.push(() => {
                                swift.memory.release(id);
                            });
                        }
                        tmpParamInts.push(elem.length);
                        arrayCleanups.push(() => {
                            for (const cleanup of arrayCleanups1) { cleanup(); }
                        });
                    }
                    tmpParamInts.push(values.length);
                    instance.exports.bjs_processNestedStringArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const arrayLen1 = tmpRetInts.pop();
                        const arrayResult1 = [];
                        for (let i1 = 0; i1 < arrayLen1; i1++) {
                            const string = tmpRetStrings.pop();
                            arrayResult1.push(string);
                        }
                        arrayResult1.reverse();
                        arrayResult.push(arrayResult1);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processNestedPointArray: function bjs_processNestedPointArray(points) {
                    const arrayCleanups = [];
                    for (const elem of points) {
                        const arrayCleanups1 = [];
                        for (const elem1 of elem) {
                            const { cleanup: cleanup } = structHelpers.Point.lower(elem1);
                            arrayCleanups1.push(() => {
                                if (cleanup) { cleanup(); }
                            });
                        }
                        tmpParamInts.push(elem.length);
                        arrayCleanups.push(() => {
                            for (const cleanup of arrayCleanups1) { cleanup(); }
                        });
                    }
                    tmpParamInts.push(points.length);
                    instance.exports.bjs_processNestedPointArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const arrayLen1 = tmpRetInts.pop();
                        const arrayResult1 = [];
                        for (let i1 = 0; i1 < arrayLen1; i1++) {
                            const struct = structHelpers.Point.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                            arrayResult1.push(struct);
                        }
                        arrayResult1.reverse();
                        arrayResult.push(arrayResult1);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processItemArray: function bjs_processItemArray(items) {
                    const arrayCleanups = [];
                    for (const elem of items) {
                        tmpParamPointers.push(elem.pointer);
                    }
                    tmpParamInts.push(items.length);
                    instance.exports.bjs_processItemArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const ptr = tmpRetPointers.pop();
                        const obj = Item.__construct(ptr);
                        arrayResult.push(obj);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                processNestedItemArray: function bjs_processNestedItemArray(items) {
                    const arrayCleanups = [];
                    for (const elem of items) {
                        const arrayCleanups1 = [];
                        for (const elem1 of elem) {
                            tmpParamPointers.push(elem1.pointer);
                        }
                        tmpParamInts.push(elem.length);
                        arrayCleanups.push(() => {
                            for (const cleanup of arrayCleanups1) { cleanup(); }
                        });
                    }
                    tmpParamInts.push(items.length);
                    instance.exports.bjs_processNestedItemArray();
                    const arrayLen = tmpRetInts.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const arrayLen1 = tmpRetInts.pop();
                        const arrayResult1 = [];
                        for (let i1 = 0; i1 < arrayLen1; i1++) {
                            const ptr = tmpRetPointers.pop();
                            const obj = Item.__construct(ptr);
                            arrayResult1.push(obj);
                        }
                        arrayResult1.reverse();
                        arrayResult.push(arrayResult1);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
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