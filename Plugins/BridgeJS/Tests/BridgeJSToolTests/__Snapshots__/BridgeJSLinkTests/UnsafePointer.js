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
    const __bjs_createPointerFieldsHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                tmpParamPointers.push((value.raw | 0));
                tmpParamPointers.push((value.mutRaw | 0));
                tmpParamPointers.push((value.opaque | 0));
                tmpParamPointers.push((value.ptr | 0));
                tmpParamPointers.push((value.mutPtr | 0));
                return { cleanup: undefined };
            },
            lift: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                const pointer = tmpRetPointers.pop();
                const pointer1 = tmpRetPointers.pop();
                const pointer2 = tmpRetPointers.pop();
                const pointer3 = tmpRetPointers.pop();
                const pointer4 = tmpRetPointers.pop();
                return { raw: pointer4, mutRaw: pointer3, opaque: pointer2, ptr: pointer1, mutPtr: pointer };
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
            bjs["swift_js_struct_lower_PointerFields"] = function(objectId) {
                const { cleanup: cleanup } = structHelpers.PointerFields.lower(swift.memory.getObject(objectId));
                if (cleanup) {
                    return tmpStructCleanups.push(cleanup);
                }
                return 0;
            }
            bjs["swift_js_struct_lift_PointerFields"] = function() {
                const value = structHelpers.PointerFields.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
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
            const PointerFieldsHelpers = __bjs_createPointerFieldsHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.PointerFields = PointerFieldsHelpers;

            const exports = {
                takeUnsafeRawPointer: function bjs_takeUnsafeRawPointer(p) {
                    instance.exports.bjs_takeUnsafeRawPointer(p);
                },
                takeUnsafeMutableRawPointer: function bjs_takeUnsafeMutableRawPointer(p) {
                    instance.exports.bjs_takeUnsafeMutableRawPointer(p);
                },
                takeOpaquePointer: function bjs_takeOpaquePointer(p) {
                    instance.exports.bjs_takeOpaquePointer(p);
                },
                takeUnsafePointer: function bjs_takeUnsafePointer(p) {
                    instance.exports.bjs_takeUnsafePointer(p);
                },
                takeUnsafeMutablePointer: function bjs_takeUnsafeMutablePointer(p) {
                    instance.exports.bjs_takeUnsafeMutablePointer(p);
                },
                returnUnsafeRawPointer: function bjs_returnUnsafeRawPointer() {
                    const ret = instance.exports.bjs_returnUnsafeRawPointer();
                    return ret;
                },
                returnUnsafeMutableRawPointer: function bjs_returnUnsafeMutableRawPointer() {
                    const ret = instance.exports.bjs_returnUnsafeMutableRawPointer();
                    return ret;
                },
                returnOpaquePointer: function bjs_returnOpaquePointer() {
                    const ret = instance.exports.bjs_returnOpaquePointer();
                    return ret;
                },
                returnUnsafePointer: function bjs_returnUnsafePointer() {
                    const ret = instance.exports.bjs_returnUnsafePointer();
                    return ret;
                },
                returnUnsafeMutablePointer: function bjs_returnUnsafeMutablePointer() {
                    const ret = instance.exports.bjs_returnUnsafeMutablePointer();
                    return ret;
                },
                roundTripPointerFields: function bjs_roundTripPointerFields(value) {
                    const { cleanup: cleanup } = structHelpers.PointerFields.lower(value);
                    instance.exports.bjs_roundTripPointerFields();
                    const structValue = structHelpers.PointerFields.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                    if (cleanup) { cleanup(); }
                    return structValue;
                },
                PointerFields: {
                    init: function(raw, mutRaw, opaque, ptr, mutPtr) {
                        instance.exports.bjs_PointerFields_init(raw, mutRaw, opaque, ptr, mutPtr);
                        const structValue = structHelpers.PointerFields.lift(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                        return structValue;
                    },
                },
            };
            _exports = exports;
            return exports;
        },
    }
}