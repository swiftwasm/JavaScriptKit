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
                    const bytes_0 = textEncoder.encode(value.param0);
                    const bytesId_0 = swift.memory.retain(bytes_0);
                    tmpParamInts.push(bytes_0.length);
                    tmpParamInts.push(bytesId_0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_0);
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
                    const string_0 = tmpRetStrings.pop();
                    return { tag: APIResult.Tag.Success, param0: string_0 };
                }
                case APIResult.Tag.Failure: {
                    const int_0 = tmpRetInts.pop();
                    return { tag: APIResult.Tag.Failure, param0: int_0 };
                }
                case APIResult.Tag.Flag: {
                    const bool_0 = tmpRetInts.pop();
                    return { tag: APIResult.Tag.Flag, param0: bool_0 };
                }
                case APIResult.Tag.Rate: {
                    const f32_0 = tmpRetF32s.pop();
                    return { tag: APIResult.Tag.Rate, param0: f32_0 };
                }
                case APIResult.Tag.Precise: {
                    const f64_0 = tmpRetF64s.pop();
                    return { tag: APIResult.Tag.Precise, param0: f64_0 };
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
                    const bytes_0 = textEncoder.encode(value.param0);
                    const bytesId_0 = swift.memory.retain(bytes_0);
                    tmpParamInts.push(bytes_0.length);
                    tmpParamInts.push(bytesId_0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_0);
                    };
                    return { caseId: ComplexResult.Tag.Success, cleanup };
                }
                case ComplexResult.Tag.Error: {
                    tmpParamInts.push((value.param1 | 0));
                    const bytes_0 = textEncoder.encode(value.param0);
                    const bytesId_0 = swift.memory.retain(bytes_0);
                    tmpParamInts.push(bytes_0.length);
                    tmpParamInts.push(bytesId_0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_0);
                    };
                    return { caseId: ComplexResult.Tag.Error, cleanup };
                }
                case ComplexResult.Tag.Status: {
                    const bytes_2 = textEncoder.encode(value.param2);
                    const bytesId_2 = swift.memory.retain(bytes_2);
                    tmpParamInts.push(bytes_2.length);
                    tmpParamInts.push(bytesId_2);
                    tmpParamInts.push((value.param1 | 0));
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_2);
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
                    const bytes_8 = textEncoder.encode(value.param8);
                    const bytesId_8 = swift.memory.retain(bytes_8);
                    tmpParamInts.push(bytes_8.length);
                    tmpParamInts.push(bytesId_8);
                    const bytes_7 = textEncoder.encode(value.param7);
                    const bytesId_7 = swift.memory.retain(bytes_7);
                    tmpParamInts.push(bytes_7.length);
                    tmpParamInts.push(bytesId_7);
                    const bytes_6 = textEncoder.encode(value.param6);
                    const bytesId_6 = swift.memory.retain(bytes_6);
                    tmpParamInts.push(bytes_6.length);
                    tmpParamInts.push(bytesId_6);
                    tmpParamF64s.push(value.param5);
                    tmpParamF64s.push(value.param4);
                    tmpParamInts.push((value.param3 | 0));
                    tmpParamInts.push((value.param2 | 0));
                    tmpParamInts.push(value.param1 ? 1 : 0);
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_8);
                        swift.memory.release(bytesId_7);
                        swift.memory.release(bytesId_6);
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
                    const string_0 = tmpRetStrings.pop();
                    return { tag: ComplexResult.Tag.Success, param0: string_0 };
                }
                case ComplexResult.Tag.Error: {
                    const int_1 = tmpRetInts.pop();
                    const string_0 = tmpRetStrings.pop();
                    return { tag: ComplexResult.Tag.Error, param0: string_0, param1: int_1 };
                }
                case ComplexResult.Tag.Status: {
                    const string_2 = tmpRetStrings.pop();
                    const int_1 = tmpRetInts.pop();
                    const bool_0 = tmpRetInts.pop();
                    return { tag: ComplexResult.Tag.Status, param0: bool_0, param1: int_1, param2: string_2 };
                }
                case ComplexResult.Tag.Coordinates: {
                    const f64_2 = tmpRetF64s.pop();
                    const f64_1 = tmpRetF64s.pop();
                    const f64_0 = tmpRetF64s.pop();
                    return { tag: ComplexResult.Tag.Coordinates, param0: f64_0, param1: f64_1, param2: f64_2 };
                }
                case ComplexResult.Tag.Comprehensive: {
                    const string_8 = tmpRetStrings.pop();
                    const string_7 = tmpRetStrings.pop();
                    const string_6 = tmpRetStrings.pop();
                    const f64_5 = tmpRetF64s.pop();
                    const f64_4 = tmpRetF64s.pop();
                    const int_3 = tmpRetInts.pop();
                    const int_2 = tmpRetInts.pop();
                    const bool_1 = tmpRetInts.pop();
                    const bool_0 = tmpRetInts.pop();
                    return { tag: ComplexResult.Tag.Comprehensive, param0: bool_0, param1: bool_1, param2: int_2, param3: int_3, param4: f64_4, param5: f64_5, param6: string_6, param7: string_7, param8: string_8 };
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
                    const bytes_0 = textEncoder.encode(value.param0);
                    const bytesId_0 = swift.memory.retain(bytes_0);
                    tmpParamInts.push(bytes_0.length);
                    tmpParamInts.push(bytesId_0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_0);
                    };
                    return { caseId: Result.Tag.Success, cleanup };
                }
                case Result.Tag.Failure: {
                    tmpParamInts.push((value.param1 | 0));
                    const bytes_0 = textEncoder.encode(value.param0);
                    const bytesId_0 = swift.memory.retain(bytes_0);
                    tmpParamInts.push(bytes_0.length);
                    tmpParamInts.push(bytesId_0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_0);
                    };
                    return { caseId: Result.Tag.Failure, cleanup };
                }
                case Result.Tag.Status: {
                    const bytes_2 = textEncoder.encode(value.param2);
                    const bytesId_2 = swift.memory.retain(bytes_2);
                    tmpParamInts.push(bytes_2.length);
                    tmpParamInts.push(bytesId_2);
                    tmpParamInts.push((value.param1 | 0));
                    tmpParamInts.push(value.param0 ? 1 : 0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_2);
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
                    const string_0 = tmpRetStrings.pop();
                    return { tag: Result.Tag.Success, param0: string_0 };
                }
                case Result.Tag.Failure: {
                    const int_1 = tmpRetInts.pop();
                    const string_0 = tmpRetStrings.pop();
                    return { tag: Result.Tag.Failure, param0: string_0, param1: int_1 };
                }
                case Result.Tag.Status: {
                    const string_2 = tmpRetStrings.pop();
                    const int_1 = tmpRetInts.pop();
                    const bool_0 = tmpRetInts.pop();
                    return { tag: Result.Tag.Status, param0: bool_0, param1: int_1, param2: string_2 };
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
                    const bytes_0 = textEncoder.encode(value.param0);
                    const bytesId_0 = swift.memory.retain(bytes_0);
                    tmpParamInts.push(bytes_0.length);
                    tmpParamInts.push(bytesId_0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_0);
                    };
                    return { caseId: NetworkingResult.Tag.Success, cleanup };
                }
                case NetworkingResult.Tag.Failure: {
                    tmpParamInts.push((value.param1 | 0));
                    const bytes_0 = textEncoder.encode(value.param0);
                    const bytesId_0 = swift.memory.retain(bytes_0);
                    tmpParamInts.push(bytes_0.length);
                    tmpParamInts.push(bytesId_0);
                    const cleanup = () => {
                        swift.memory.release(bytesId_0);
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
                    const string_0 = tmpRetStrings.pop();
                    return { tag: NetworkingResult.Tag.Success, param0: string_0 };
                }
                case NetworkingResult.Tag.Failure: {
                    const int_1 = tmpRetInts.pop();
                    const string_0 = tmpRetStrings.pop();
                    return { tag: NetworkingResult.Tag.Failure, param0: string_0, param1: int_1 };
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
            };
        },
    }
}