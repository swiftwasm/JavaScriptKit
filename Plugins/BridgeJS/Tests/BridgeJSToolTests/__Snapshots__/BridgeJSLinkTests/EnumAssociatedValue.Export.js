// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

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
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
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
export const ComplexResultValues = {
    Tag: {
        Success: 0,
        Error: 1,
        Status: 2,
        Coordinates: 3,
        Comprehensive: 4,
        Info: 5,
    },
};

const __bjs_createComplexResultValuesHelpers = () => {
    return (tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case ComplexResultValues.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: ComplexResultValues.Tag.Success, cleanup };
                }
                case ComplexResultValues.Tag.Error: {
                    tmpParamInts.push((value.param1 | 0));
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: ComplexResultValues.Tag.Error, cleanup };
                }
                case ComplexResultValues.Tag.Status: {
                    const bytes = textEncoder.encode(value.param2);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    tmpParamInts.push((value.param1 | 0));
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: ComplexResultValues.Tag.Status, cleanup };
                }
                case ComplexResultValues.Tag.Coordinates: {
                    tmpParamF64s.push(value.param2);
                    tmpParamF64s.push(value.param1);
                    tmpParamF64s.push(value.param0);
                    const cleanup = undefined;
                    return { caseId: ComplexResultValues.Tag.Coordinates, cleanup };
                }
                case ComplexResultValues.Tag.Comprehensive: {
                    const bytes = textEncoder.encode(value.param8);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const bytes1 = textEncoder.encode(value.param7);
                    const id1 = swift.memory.retain(bytes1);
                    tmpParamInts.push(bytes1.length);
                    tmpParamInts.push(id1);
                    const bytes2 = textEncoder.encode(value.param6);
                    const id2 = swift.memory.retain(bytes2);
                    tmpParamInts.push(bytes2.length);
                    tmpParamInts.push(id2);
                    tmpParamF64s.push(value.param5);
                    tmpParamF64s.push(value.param4);
                    tmpParamInts.push((value.param3 | 0));
                    tmpParamInts.push((value.param2 | 0));
                    tmpParamInts.push(value.param1 ? 1 : 0);
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = () => {
                        swift.memory.release(id);
                        swift.memory.release(id1);
                        swift.memory.release(id2);
                    };
                    return { caseId: ComplexResultValues.Tag.Comprehensive, cleanup };
                }
                case ComplexResultValues.Tag.Info: {
                    const cleanup = undefined;
                    return { caseId: ComplexResultValues.Tag.Info, cleanup };
                }
                default: throw new Error("Unknown ComplexResultValues tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case ComplexResultValues.Tag.Success: {
                    const string = tmpRetStrings.pop();
                    return { tag: ComplexResultValues.Tag.Success, param0: string };
                }
                case ComplexResultValues.Tag.Error: {
                    const int = tmpRetInts.pop();
                    const string = tmpRetStrings.pop();
                    return { tag: ComplexResultValues.Tag.Error, param0: string, param1: int };
                }
                case ComplexResultValues.Tag.Status: {
                    const string = tmpRetStrings.pop();
                    const int = tmpRetInts.pop();
                    const bool = tmpRetInts.pop();
                    return { tag: ComplexResultValues.Tag.Status, param0: bool, param1: int, param2: string };
                }
                case ComplexResultValues.Tag.Coordinates: {
                    const f64 = tmpRetF64s.pop();
                    const f641 = tmpRetF64s.pop();
                    const f642 = tmpRetF64s.pop();
                    return { tag: ComplexResultValues.Tag.Coordinates, param0: f642, param1: f641, param2: f64 };
                }
                case ComplexResultValues.Tag.Comprehensive: {
                    const string = tmpRetStrings.pop();
                    const string1 = tmpRetStrings.pop();
                    const string2 = tmpRetStrings.pop();
                    const f64 = tmpRetF64s.pop();
                    const f641 = tmpRetF64s.pop();
                    const int = tmpRetInts.pop();
                    const int1 = tmpRetInts.pop();
                    const bool = tmpRetInts.pop();
                    const bool1 = tmpRetInts.pop();
                    return { tag: ComplexResultValues.Tag.Comprehensive, param0: bool1, param1: bool, param2: int1, param3: int, param4: f641, param5: f64, param6: string2, param7: string1, param8: string };
                }
                case ComplexResultValues.Tag.Info: return { tag: ComplexResultValues.Tag.Info };
                default: throw new Error("Unknown ComplexResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
};
export const ResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
        Status: 2,
    },
};

const __bjs_createResultValuesHelpers = () => {
    return (tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case ResultValues.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: ResultValues.Tag.Success, cleanup };
                }
                case ResultValues.Tag.Failure: {
                    tmpParamInts.push((value.param1 | 0));
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: ResultValues.Tag.Failure, cleanup };
                }
                case ResultValues.Tag.Status: {
                    const bytes = textEncoder.encode(value.param2);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    tmpParamInts.push((value.param1 | 0));
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: ResultValues.Tag.Status, cleanup };
                }
                default: throw new Error("Unknown ResultValues tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case ResultValues.Tag.Success: {
                    const string = tmpRetStrings.pop();
                    return { tag: ResultValues.Tag.Success, param0: string };
                }
                case ResultValues.Tag.Failure: {
                    const int = tmpRetInts.pop();
                    const string = tmpRetStrings.pop();
                    return { tag: ResultValues.Tag.Failure, param0: string, param1: int };
                }
                case ResultValues.Tag.Status: {
                    const string = tmpRetStrings.pop();
                    const int = tmpRetInts.pop();
                    const bool = tmpRetInts.pop();
                    return { tag: ResultValues.Tag.Status, param0: bool, param1: int, param2: string };
                }
                default: throw new Error("Unknown ResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
};
export const NetworkingResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
    },
};

const __bjs_createNetworkingResultValuesHelpers = () => {
    return (tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case NetworkingResultValues.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: NetworkingResultValues.Tag.Success, cleanup };
                }
                case NetworkingResultValues.Tag.Failure: {
                    tmpParamInts.push((value.param1 | 0));
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: NetworkingResultValues.Tag.Failure, cleanup };
                }
                default: throw new Error("Unknown NetworkingResultValues tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case NetworkingResultValues.Tag.Success: {
                    const string = tmpRetStrings.pop();
                    return { tag: NetworkingResultValues.Tag.Success, param0: string };
                }
                case NetworkingResultValues.Tag.Failure: {
                    const int = tmpRetInts.pop();
                    const string = tmpRetStrings.pop();
                    return { tag: NetworkingResultValues.Tag.Failure, param0: string, param1: int };
                }
                default: throw new Error("Unknown NetworkingResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
};
export const APIOptionalResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
        Status: 2,
    },
};

const __bjs_createAPIOptionalResultValuesHelpers = () => {
    return (tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case APIOptionalResultValues.Tag.Success: {
                    const isSome = value.param0 != null;
                    let id;
                    if (isSome) {
                        let bytes = textEncoder.encode(value.param0);
                        id = swift.memory.retain(bytes);
                        tmpParamInts.push(bytes.length);
                        tmpParamInts.push(id);
                    } else {
                        tmpParamInts.push(0);
                        tmpParamInts.push(0);
                    }
                    tmpParamInts.push(isSome ? 1 : 0);
                    const cleanup = () => {
                        if(id) {
                            swift.memory.release(id);
                        }
                    };
                    return { caseId: APIOptionalResultValues.Tag.Success, cleanup };
                }
                case APIOptionalResultValues.Tag.Failure: {
                    const isSome = value.param1 != null;
                    tmpParamInts.push(isSome ? (value.param1 ? 1 : 0) : 0);
                    tmpParamInts.push(isSome ? 1 : 0);
                    const isSome1 = value.param0 != null;
                    tmpParamInts.push(isSome1 ? (value.param0 | 0) : 0);
                    tmpParamInts.push(isSome1 ? 1 : 0);
                    const cleanup = undefined;
                    return { caseId: APIOptionalResultValues.Tag.Failure, cleanup };
                }
                case APIOptionalResultValues.Tag.Status: {
                    const isSome = value.param2 != null;
                    let id;
                    if (isSome) {
                        let bytes = textEncoder.encode(value.param2);
                        id = swift.memory.retain(bytes);
                        tmpParamInts.push(bytes.length);
                        tmpParamInts.push(id);
                    } else {
                        tmpParamInts.push(0);
                        tmpParamInts.push(0);
                    }
                    tmpParamInts.push(isSome ? 1 : 0);
                    const isSome1 = value.param1 != null;
                    tmpParamInts.push(isSome1 ? (value.param1 | 0) : 0);
                    tmpParamInts.push(isSome1 ? 1 : 0);
                    const isSome2 = value.param0 != null;
                    tmpParamInts.push(isSome2 ? (value.param0 ? 1 : 0) : 0);
                    tmpParamInts.push(isSome2 ? 1 : 0);
                    const cleanup = () => {
                        if(id) {
                            swift.memory.release(id);
                        }
                    };
                    return { caseId: APIOptionalResultValues.Tag.Status, cleanup };
                }
                default: throw new Error("Unknown APIOptionalResultValues tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case APIOptionalResultValues.Tag.Success: {
                    const isSome = tmpRetInts.pop();
                    let optional;
                    if (isSome) {
                        const string = tmpRetStrings.pop();
                        optional = string;
                    } else {
                        optional = null;
                    }
                    return { tag: APIOptionalResultValues.Tag.Success, param0: optional };
                }
                case APIOptionalResultValues.Tag.Failure: {
                    const isSome = tmpRetInts.pop();
                    let optional;
                    if (isSome) {
                        const bool = tmpRetInts.pop();
                        optional = bool;
                    } else {
                        optional = null;
                    }
                    const isSome1 = tmpRetInts.pop();
                    let optional1;
                    if (isSome1) {
                        const int = tmpRetInts.pop();
                        optional1 = int;
                    } else {
                        optional1 = null;
                    }
                    return { tag: APIOptionalResultValues.Tag.Failure, param0: optional1, param1: optional };
                }
                case APIOptionalResultValues.Tag.Status: {
                    const isSome = tmpRetInts.pop();
                    let optional;
                    if (isSome) {
                        const string = tmpRetStrings.pop();
                        optional = string;
                    } else {
                        optional = null;
                    }
                    const isSome1 = tmpRetInts.pop();
                    let optional1;
                    if (isSome1) {
                        const int = tmpRetInts.pop();
                        optional1 = int;
                    } else {
                        optional1 = null;
                    }
                    const isSome2 = tmpRetInts.pop();
                    let optional2;
                    if (isSome2) {
                        const bool = tmpRetInts.pop();
                        optional2 = bool;
                    } else {
                        optional2 = null;
                    }
                    return { tag: APIOptionalResultValues.Tag.Status, param0: optional2, param1: optional1, param2: optional };
                }
                default: throw new Error("Unknown APIOptionalResultValues tag returned from Swift: " + String(tag));
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
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            const APIResultHelpers = __bjs_createAPIResultValuesHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.APIResult = APIResultHelpers;
            
            const ComplexResultHelpers = __bjs_createComplexResultValuesHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.ComplexResult = ComplexResultHelpers;
            
            const ResultHelpers = __bjs_createResultValuesHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.Result = ResultHelpers;
            
            const NetworkingResultHelpers = __bjs_createNetworkingResultValuesHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.NetworkingResult = NetworkingResultHelpers;
            
            const APIOptionalResultHelpers = __bjs_createAPIOptionalResultValuesHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.APIOptionalResult = APIOptionalResultHelpers;
            
            setException = (error) => {
                instance.exports._swift_js_exception.value = swift.memory.retain(error)
            }
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;
            const exports = {
                handle: function bjs_handle(result) {
                    const { caseId: resultCaseId, cleanup: resultCleanup } = enumHelpers.APIResult.lower(result);
                    instance.exports.bjs_handle(resultCaseId);
                    if (resultCleanup) { resultCleanup(); }
                },
                getResult: function bjs_getResult() {
                    instance.exports.bjs_getResult();
                    const ret = enumHelpers.APIResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    return ret;
                },
                roundtripAPIResult: function bjs_roundtripAPIResult(result) {
                    const { caseId: resultCaseId, cleanup: resultCleanup } = enumHelpers.APIResult.lower(result);
                    instance.exports.bjs_roundtripAPIResult(resultCaseId);
                    const ret = enumHelpers.APIResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    if (resultCleanup) { resultCleanup(); }
                    return ret;
                },
                roundTripOptionalAPIResult: function bjs_roundTripOptionalAPIResult(result) {
                    const isSome = result != null;
                    let resultCaseId, resultCleanup;
                    if (isSome) {
                        const enumResult = enumHelpers.APIResult.lower(result);
                        resultCaseId = enumResult.caseId;
                        resultCleanup = enumResult.cleanup;
                    }
                    instance.exports.bjs_roundTripOptionalAPIResult(+isSome, isSome ? resultCaseId : 0);
                    const isNull = (tmpRetTag === -1);
                    let optResult;
                    if (isNull) {
                        optResult = null;
                    } else {
                        optResult = enumHelpers.APIResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    }
                    if (resultCleanup) { resultCleanup(); }
                    return optResult;
                },
                handleComplex: function bjs_handleComplex(result) {
                    const { caseId: resultCaseId, cleanup: resultCleanup } = enumHelpers.ComplexResult.lower(result);
                    instance.exports.bjs_handleComplex(resultCaseId);
                    if (resultCleanup) { resultCleanup(); }
                },
                getComplexResult: function bjs_getComplexResult() {
                    instance.exports.bjs_getComplexResult();
                    const ret = enumHelpers.ComplexResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    return ret;
                },
                roundtripComplexResult: function bjs_roundtripComplexResult(result) {
                    const { caseId: resultCaseId, cleanup: resultCleanup } = enumHelpers.ComplexResult.lower(result);
                    instance.exports.bjs_roundtripComplexResult(resultCaseId);
                    const ret = enumHelpers.ComplexResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    if (resultCleanup) { resultCleanup(); }
                    return ret;
                },
                roundTripOptionalComplexResult: function bjs_roundTripOptionalComplexResult(result) {
                    const isSome = result != null;
                    let resultCaseId, resultCleanup;
                    if (isSome) {
                        const enumResult = enumHelpers.ComplexResult.lower(result);
                        resultCaseId = enumResult.caseId;
                        resultCleanup = enumResult.cleanup;
                    }
                    instance.exports.bjs_roundTripOptionalComplexResult(+isSome, isSome ? resultCaseId : 0);
                    const isNull = (tmpRetTag === -1);
                    let optResult;
                    if (isNull) {
                        optResult = null;
                    } else {
                        optResult = enumHelpers.ComplexResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    }
                    if (resultCleanup) { resultCleanup(); }
                    return optResult;
                },
                roundTripOptionalUtilitiesResult: function bjs_roundTripOptionalUtilitiesResult(result) {
                    const isSome = result != null;
                    let resultCaseId, resultCleanup;
                    if (isSome) {
                        const enumResult = enumHelpers.Result.lower(result);
                        resultCaseId = enumResult.caseId;
                        resultCleanup = enumResult.cleanup;
                    }
                    instance.exports.bjs_roundTripOptionalUtilitiesResult(+isSome, isSome ? resultCaseId : 0);
                    const isNull = (tmpRetTag === -1);
                    let optResult;
                    if (isNull) {
                        optResult = null;
                    } else {
                        optResult = enumHelpers.Result.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    }
                    if (resultCleanup) { resultCleanup(); }
                    return optResult;
                },
                roundTripOptionalNetworkingResult: function bjs_roundTripOptionalNetworkingResult(result) {
                    const isSome = result != null;
                    let resultCaseId, resultCleanup;
                    if (isSome) {
                        const enumResult = enumHelpers.NetworkingResult.lower(result);
                        resultCaseId = enumResult.caseId;
                        resultCleanup = enumResult.cleanup;
                    }
                    instance.exports.bjs_roundTripOptionalNetworkingResult(+isSome, isSome ? resultCaseId : 0);
                    const isNull = (tmpRetTag === -1);
                    let optResult;
                    if (isNull) {
                        optResult = null;
                    } else {
                        optResult = enumHelpers.NetworkingResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    }
                    if (resultCleanup) { resultCleanup(); }
                    return optResult;
                },
                roundTripOptionalAPIOptionalResult: function bjs_roundTripOptionalAPIOptionalResult(result) {
                    const isSome = result != null;
                    let resultCaseId, resultCleanup;
                    if (isSome) {
                        const enumResult = enumHelpers.APIOptionalResult.lower(result);
                        resultCaseId = enumResult.caseId;
                        resultCleanup = enumResult.cleanup;
                    }
                    instance.exports.bjs_roundTripOptionalAPIOptionalResult(+isSome, isSome ? resultCaseId : 0);
                    const isNull = (tmpRetTag === -1);
                    let optResult;
                    if (isNull) {
                        optResult = null;
                    } else {
                        optResult = enumHelpers.APIOptionalResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    }
                    if (resultCleanup) { resultCleanup(); }
                    return optResult;
                },
                compareAPIResults: function bjs_compareAPIResults(result1, result2) {
                    const isSome = result1 != null;
                    let result1CaseId, result1Cleanup;
                    if (isSome) {
                        const enumResult = enumHelpers.APIOptionalResult.lower(result1);
                        result1CaseId = enumResult.caseId;
                        result1Cleanup = enumResult.cleanup;
                    }
                    const isSome1 = result2 != null;
                    let result2CaseId, result2Cleanup;
                    if (isSome1) {
                        const enumResult1 = enumHelpers.APIOptionalResult.lower(result2);
                        result2CaseId = enumResult1.caseId;
                        result2Cleanup = enumResult1.cleanup;
                    }
                    instance.exports.bjs_compareAPIResults(+isSome, isSome ? result1CaseId : 0, +isSome1, isSome1 ? result2CaseId : 0);
                    const isNull = (tmpRetTag === -1);
                    let optResult;
                    if (isNull) {
                        optResult = null;
                    } else {
                        optResult = enumHelpers.APIOptionalResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s);
                    }
                    if (result1Cleanup) { result1Cleanup(); }
                    if (result2Cleanup) { result2Cleanup(); }
                    return optResult;
                },
                APIResult: APIResultValues,
                ComplexResult: ComplexResultValues,
                APIOptionalResult: APIOptionalResultValues,
                API: {
                    NetworkingResult: NetworkingResultValues,
                },
                Utilities: {
                    Result: ResultValues,
                },
            };
            _exports = exports;
            return exports;
        },
    }
}