// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const APIResult = {
    Tag: {
        Success: 0,
        Failure: 1,
        Flag: 2,
        Rate: 3,
        Precise: 4,
        Info: 5,
    }
};

const __bjs_createAPIResultHelpers = () => {
    return (tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case APIResult.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: APIResult.Tag.Success, cleanup };
                }
                case APIResult.Tag.Failure: {
                    tmpParamInts.push((value.param0 | 0));
                    const cleanup = undefined;
                    return { caseId: APIResult.Tag.Failure, cleanup };
                }
                case APIResult.Tag.Flag: {
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = undefined;
                    return { caseId: APIResult.Tag.Flag, cleanup };
                }
                case APIResult.Tag.Rate: {
                    tmpParamF32s.push(Math.fround(value.param0));
                    const cleanup = undefined;
                    return { caseId: APIResult.Tag.Rate, cleanup };
                }
                case APIResult.Tag.Precise: {
                    tmpParamF64s.push(value.param0);
                    const cleanup = undefined;
                    return { caseId: APIResult.Tag.Precise, cleanup };
                }
                case APIResult.Tag.Info: {
                    const cleanup = undefined;
                    return { caseId: APIResult.Tag.Info, cleanup };
                }
                default: throw new Error("Unknown APIResult tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case APIResult.Tag.Success: {
                    const string = tmpRetStrings.pop();
                    return { tag: APIResult.Tag.Success, param0: string };
                }
                case APIResult.Tag.Failure: {
                    const int = tmpRetInts.pop();
                    return { tag: APIResult.Tag.Failure, param0: int };
                }
                case APIResult.Tag.Flag: {
                    const bool = tmpRetInts.pop();
                    return { tag: APIResult.Tag.Flag, param0: bool };
                }
                case APIResult.Tag.Rate: {
                    const f32 = tmpRetF32s.pop();
                    return { tag: APIResult.Tag.Rate, param0: f32 };
                }
                case APIResult.Tag.Precise: {
                    const f64 = tmpRetF64s.pop();
                    return { tag: APIResult.Tag.Precise, param0: f64 };
                }
                case APIResult.Tag.Info: return { tag: APIResult.Tag.Info };
                default: throw new Error("Unknown APIResult tag returned from Swift: " + String(tag));
            }
        }
    });
};
export const ComplexResult = {
    Tag: {
        Success: 0,
        Error: 1,
        Status: 2,
        Coordinates: 3,
        Comprehensive: 4,
        Info: 5,
    }
};

const __bjs_createComplexResultHelpers = () => {
    return (tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case ComplexResult.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: ComplexResult.Tag.Success, cleanup };
                }
                case ComplexResult.Tag.Error: {
                    tmpParamInts.push((value.param1 | 0));
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: ComplexResult.Tag.Error, cleanup };
                }
                case ComplexResult.Tag.Status: {
                    const bytes = textEncoder.encode(value.param2);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    tmpParamInts.push((value.param1 | 0));
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: ComplexResult.Tag.Status, cleanup };
                }
                case ComplexResult.Tag.Coordinates: {
                    tmpParamF64s.push(value.param2);
                    tmpParamF64s.push(value.param1);
                    tmpParamF64s.push(value.param0);
                    const cleanup = undefined;
                    return { caseId: ComplexResult.Tag.Coordinates, cleanup };
                }
                case ComplexResult.Tag.Comprehensive: {
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
                    return { caseId: ComplexResult.Tag.Comprehensive, cleanup };
                }
                case ComplexResult.Tag.Info: {
                    const cleanup = undefined;
                    return { caseId: ComplexResult.Tag.Info, cleanup };
                }
                default: throw new Error("Unknown ComplexResult tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case ComplexResult.Tag.Success: {
                    const string = tmpRetStrings.pop();
                    return { tag: ComplexResult.Tag.Success, param0: string };
                }
                case ComplexResult.Tag.Error: {
                    const int = tmpRetInts.pop();
                    const string = tmpRetStrings.pop();
                    return { tag: ComplexResult.Tag.Error, param0: string, param1: int };
                }
                case ComplexResult.Tag.Status: {
                    const string = tmpRetStrings.pop();
                    const int = tmpRetInts.pop();
                    const bool = tmpRetInts.pop();
                    return { tag: ComplexResult.Tag.Status, param0: bool, param1: int, param2: string };
                }
                case ComplexResult.Tag.Coordinates: {
                    const f64 = tmpRetF64s.pop();
                    const f641 = tmpRetF64s.pop();
                    const f642 = tmpRetF64s.pop();
                    return { tag: ComplexResult.Tag.Coordinates, param0: f642, param1: f641, param2: f64 };
                }
                case ComplexResult.Tag.Comprehensive: {
                    const string = tmpRetStrings.pop();
                    const string1 = tmpRetStrings.pop();
                    const string2 = tmpRetStrings.pop();
                    const f64 = tmpRetF64s.pop();
                    const f641 = tmpRetF64s.pop();
                    const int = tmpRetInts.pop();
                    const int1 = tmpRetInts.pop();
                    const bool = tmpRetInts.pop();
                    const bool1 = tmpRetInts.pop();
                    return { tag: ComplexResult.Tag.Comprehensive, param0: bool1, param1: bool, param2: int1, param3: int, param4: f641, param5: f64, param6: string2, param7: string1, param8: string };
                }
                case ComplexResult.Tag.Info: return { tag: ComplexResult.Tag.Info };
                default: throw new Error("Unknown ComplexResult tag returned from Swift: " + String(tag));
            }
        }
    });
};
export const Result = {
    Tag: {
        Success: 0,
        Failure: 1,
        Status: 2,
    }
};

const __bjs_createResultHelpers = () => {
    return (tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case Result.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: Result.Tag.Success, cleanup };
                }
                case Result.Tag.Failure: {
                    tmpParamInts.push((value.param1 | 0));
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: Result.Tag.Failure, cleanup };
                }
                case Result.Tag.Status: {
                    const bytes = textEncoder.encode(value.param2);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    tmpParamInts.push((value.param1 | 0));
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: Result.Tag.Status, cleanup };
                }
                default: throw new Error("Unknown Result tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case Result.Tag.Success: {
                    const string = tmpRetStrings.pop();
                    return { tag: Result.Tag.Success, param0: string };
                }
                case Result.Tag.Failure: {
                    const int = tmpRetInts.pop();
                    const string = tmpRetStrings.pop();
                    return { tag: Result.Tag.Failure, param0: string, param1: int };
                }
                case Result.Tag.Status: {
                    const string = tmpRetStrings.pop();
                    const int = tmpRetInts.pop();
                    const bool = tmpRetInts.pop();
                    return { tag: Result.Tag.Status, param0: bool, param1: int, param2: string };
                }
                default: throw new Error("Unknown Result tag returned from Swift: " + String(tag));
            }
        }
    });
};
export const NetworkingResult = {
    Tag: {
        Success: 0,
        Failure: 1,
    }
};

const __bjs_createNetworkingResultHelpers = () => {
    return (tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case NetworkingResult.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: NetworkingResult.Tag.Success, cleanup };
                }
                case NetworkingResult.Tag.Failure: {
                    tmpParamInts.push((value.param1 | 0));
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    tmpParamInts.push(bytes.length);
                    tmpParamInts.push(id);
                    const cleanup = () => {
                        swift.memory.release(id);
                    };
                    return { caseId: NetworkingResult.Tag.Failure, cleanup };
                }
                default: throw new Error("Unknown NetworkingResult tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case NetworkingResult.Tag.Success: {
                    const string = tmpRetStrings.pop();
                    return { tag: NetworkingResult.Tag.Success, param0: string };
                }
                case NetworkingResult.Tag.Failure: {
                    const int = tmpRetInts.pop();
                    const string = tmpRetStrings.pop();
                    return { tag: NetworkingResult.Tag.Failure, param0: string, param1: int };
                }
                default: throw new Error("Unknown NetworkingResult tag returned from Swift: " + String(tag));
            }
        }
    });
};
if (typeof globalThis.Utilities === 'undefined') {
    globalThis.Utilities = {};
}
if (typeof globalThis.API === 'undefined') {
    globalThis.API = {};
}

globalThis.Utilities.Result = Result;
globalThis.API.NetworkingResult = NetworkingResult;

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
    const enumHelpers = {};

    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            const bjs = {};
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
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            const APIResultHelpers = __bjs_createAPIResultHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.APIResult = APIResultHelpers;
            
            const ComplexResultHelpers = __bjs_createComplexResultHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.ComplexResult = ComplexResultHelpers;
            
            const ResultHelpers = __bjs_createResultHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.Result = ResultHelpers;
            
            const NetworkingResultHelpers = __bjs_createNetworkingResultHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, textEncoder, swift);
            enumHelpers.NetworkingResult = NetworkingResultHelpers;
            
            setException = (error) => {
                instance.exports._swift_js_exception.value = swift.memory.retain(error)
            }
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;
            return {
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
            };
        },
    }
}