// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

/// Shared helpers for encoding associated-value enums between JS and Swift.
const __bjs_ParamType = { STRING: 1, INT32: 2, BOOL: 3, FLOAT32: 4, FLOAT64: 5 };
function __bjs_encodeEnumParams(textEncoder, swift, parts) {
    const SIZE_U8 = 1, SIZE_U32 = 4, SIZE_F32 = 4, SIZE_F64 = 8;
    let totalLen = SIZE_U32;
    for (const p of parts) {
        switch (p.t) {
            case __bjs_ParamType.STRING: {
                const bytes = textEncoder.encode(p.v);
                p._bytes = bytes;
                totalLen += SIZE_U8 + SIZE_U32 + bytes.length;
                break;
            }
            case __bjs_ParamType.INT32: totalLen += SIZE_U8 + SIZE_U32; break;
            case __bjs_ParamType.BOOL: totalLen += SIZE_U8 + SIZE_U8; break;
            case __bjs_ParamType.FLOAT32: totalLen += SIZE_U8 + SIZE_F32; break;
            case __bjs_ParamType.FLOAT64: totalLen += SIZE_U8 + SIZE_F64; break;
            default: throw new Error("Unsupported param type tag: " + p.t);
        }
    }
    const buf = new Uint8Array(totalLen);
    const view = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
    let off = 0;
    view.setUint32(off, parts.length, true); off += SIZE_U32;
    for (const p of parts) {
        view.setUint8(off, p.t); off += SIZE_U8;
        switch (p.t) {
            case __bjs_ParamType.STRING: {
                const b = p._bytes;
                view.setUint32(off, b.length, true); off += SIZE_U32;
                buf.set(b, off); off += b.length;
                break;
            }
            case __bjs_ParamType.INT32:
                view.setInt32(off, (p.v | 0), true); off += SIZE_U32; break;
            case __bjs_ParamType.BOOL:
                view.setUint8(off, p.v ? 1 : 0); off += SIZE_U8; break;
            case __bjs_ParamType.FLOAT32:
                view.setFloat32(off, Math.fround(p.v), true); off += SIZE_F32; break;
            case __bjs_ParamType.FLOAT64:
                view.setFloat64(off, p.v, true); off += SIZE_F64; break;
            default: throw new Error("Unsupported param type tag: " + p.t);
        }
    }
    const paramsId = swift.memory.retain(buf);
    return { paramsId, paramsLen: buf.length, cleanup: () => { swift.memory.release(paramsId); } };
}
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
    return (textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case APIResult.Tag.Success: {
                    const parts = [
                        { t: __bjs_ParamType.STRING, v: value.param0 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: APIResult.Tag.Success, paramsId, paramsLen, cleanup };
                }
                case APIResult.Tag.Failure: {
                    const parts = [
                        { t: __bjs_ParamType.INT32, v: (value.param0 | 0) }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: APIResult.Tag.Failure, paramsId, paramsLen, cleanup };
                }
                case APIResult.Tag.Flag: {
                    const parts = [
                        { t: __bjs_ParamType.BOOL, v: value.param0 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: APIResult.Tag.Flag, paramsId, paramsLen, cleanup };
                }
                case APIResult.Tag.Rate: {
                    const parts = [
                        { t: __bjs_ParamType.FLOAT32, v: value.param0 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: APIResult.Tag.Rate, paramsId, paramsLen, cleanup };
                }
                case APIResult.Tag.Precise: {
                    const parts = [
                        { t: __bjs_ParamType.FLOAT64, v: value.param0 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: APIResult.Tag.Precise, paramsId, paramsLen, cleanup };
                }
                case APIResult.Tag.Info: {
                    const parts = [];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: APIResult.Tag.Info, paramsId, paramsLen, cleanup };
                }
                default: throw new Error("Unknown APIResult tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetBools) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case APIResult.Tag.Success: return { tag: APIResult.Tag.Success, param0: tmpRetStrings[0] };
                case APIResult.Tag.Failure: return { tag: APIResult.Tag.Failure, param0: tmpRetInts[0] };
                case APIResult.Tag.Flag: return { tag: APIResult.Tag.Flag, param0: tmpRetBools[0] };
                case APIResult.Tag.Rate: return { tag: APIResult.Tag.Rate, param0: tmpRetF32s[0] };
                case APIResult.Tag.Precise: return { tag: APIResult.Tag.Precise, param0: tmpRetF64s[0] };
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
    return (textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case ComplexResult.Tag.Success: {
                    const parts = [
                        { t: __bjs_ParamType.STRING, v: value.param0 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: ComplexResult.Tag.Success, paramsId, paramsLen, cleanup };
                }
                case ComplexResult.Tag.Error: {
                    const parts = [
                        { t: __bjs_ParamType.STRING, v: value.param0 },
                        { t: __bjs_ParamType.INT32, v: (value.param1 | 0) }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: ComplexResult.Tag.Error, paramsId, paramsLen, cleanup };
                }
                case ComplexResult.Tag.Status: {
                    const parts = [
                        { t: __bjs_ParamType.BOOL, v: value.param0 },
                        { t: __bjs_ParamType.INT32, v: (value.param1 | 0) },
                        { t: __bjs_ParamType.STRING, v: value.param2 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: ComplexResult.Tag.Status, paramsId, paramsLen, cleanup };
                }
                case ComplexResult.Tag.Coordinates: {
                    const parts = [
                        { t: __bjs_ParamType.FLOAT64, v: value.param0 },
                        { t: __bjs_ParamType.FLOAT64, v: value.param1 },
                        { t: __bjs_ParamType.FLOAT64, v: value.param2 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: ComplexResult.Tag.Coordinates, paramsId, paramsLen, cleanup };
                }
                case ComplexResult.Tag.Comprehensive: {
                    const parts = [
                        { t: __bjs_ParamType.BOOL, v: value.param0 },
                        { t: __bjs_ParamType.BOOL, v: value.param1 },
                        { t: __bjs_ParamType.INT32, v: (value.param2 | 0) },
                        { t: __bjs_ParamType.INT32, v: (value.param3 | 0) },
                        { t: __bjs_ParamType.FLOAT64, v: value.param4 },
                        { t: __bjs_ParamType.FLOAT64, v: value.param5 },
                        { t: __bjs_ParamType.STRING, v: value.param6 },
                        { t: __bjs_ParamType.STRING, v: value.param7 },
                        { t: __bjs_ParamType.STRING, v: value.param8 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: ComplexResult.Tag.Comprehensive, paramsId, paramsLen, cleanup };
                }
                case ComplexResult.Tag.Info: {
                    const parts = [];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: ComplexResult.Tag.Info, paramsId, paramsLen, cleanup };
                }
                default: throw new Error("Unknown ComplexResult tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetBools) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case ComplexResult.Tag.Success: return { tag: ComplexResult.Tag.Success, param0: tmpRetStrings[0] };
                case ComplexResult.Tag.Error: return { tag: ComplexResult.Tag.Error, param0: tmpRetStrings[0], param1: tmpRetInts[0] };
                case ComplexResult.Tag.Status: return { tag: ComplexResult.Tag.Status, param0: tmpRetBools[0], param1: tmpRetInts[0], param2: tmpRetStrings[0] };
                case ComplexResult.Tag.Coordinates: return { tag: ComplexResult.Tag.Coordinates, param0: tmpRetF64s[0], param1: tmpRetF64s[1], param2: tmpRetF64s[2] };
                case ComplexResult.Tag.Comprehensive: return { tag: ComplexResult.Tag.Comprehensive, param0: tmpRetBools[0], param1: tmpRetBools[1], param2: tmpRetInts[0], param3: tmpRetInts[1], param4: tmpRetF64s[0], param5: tmpRetF64s[1], param6: tmpRetStrings[0], param7: tmpRetStrings[1], param8: tmpRetStrings[2] };
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
    return (textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case Result.Tag.Success: {
                    const parts = [
                        { t: __bjs_ParamType.STRING, v: value.param0 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: Result.Tag.Success, paramsId, paramsLen, cleanup };
                }
                case Result.Tag.Failure: {
                    const parts = [
                        { t: __bjs_ParamType.STRING, v: value.param0 },
                        { t: __bjs_ParamType.INT32, v: (value.param1 | 0) }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: Result.Tag.Failure, paramsId, paramsLen, cleanup };
                }
                case Result.Tag.Status: {
                    const parts = [
                        { t: __bjs_ParamType.BOOL, v: value.param0 },
                        { t: __bjs_ParamType.INT32, v: (value.param1 | 0) },
                        { t: __bjs_ParamType.STRING, v: value.param2 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: Result.Tag.Status, paramsId, paramsLen, cleanup };
                }
                default: throw new Error("Unknown Result tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetBools) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case Result.Tag.Success: return { tag: Result.Tag.Success, param0: tmpRetStrings[0] };
                case Result.Tag.Failure: return { tag: Result.Tag.Failure, param0: tmpRetStrings[0], param1: tmpRetInts[0] };
                case Result.Tag.Status: return { tag: Result.Tag.Status, param0: tmpRetBools[0], param1: tmpRetInts[0], param2: tmpRetStrings[0] };
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
    return (textEncoder, swift) => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case NetworkingResult.Tag.Success: {
                    const parts = [
                        { t: __bjs_ParamType.STRING, v: value.param0 }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: NetworkingResult.Tag.Success, paramsId, paramsLen, cleanup };
                }
                case NetworkingResult.Tag.Failure: {
                    const parts = [
                        { t: __bjs_ParamType.STRING, v: value.param0 },
                        { t: __bjs_ParamType.INT32, v: (value.param1 | 0) }
                    ];
                    const { paramsId, paramsLen, cleanup } = __bjs_encodeEnumParams(textEncoder, swift, parts);
                    return { caseId: NetworkingResult.Tag.Failure, paramsId, paramsLen, cleanup };
                }
                default: throw new Error("Unknown NetworkingResult tag: " + String(enumTag));
            }
        },
        raise: (tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetBools) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case NetworkingResult.Tag.Success: return { tag: NetworkingResult.Tag.Success, param0: tmpRetStrings[0] };
                case NetworkingResult.Tag.Failure: return { tag: NetworkingResult.Tag.Failure, param0: tmpRetStrings[0], param1: tmpRetInts[0] };
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
    let tmpRetBools = [];
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
                const value = textDecoder.decode(bytes);
                tmpRetString = value;
                tmpRetStrings.push(value);
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
            bjs["swift_js_return_tag"] = function(tag) {
                tmpRetTag = tag | 0;
                tmpRetString = undefined;
                tmpRetStrings = [];
                tmpRetInts = [];
                tmpRetF32s = [];
                tmpRetF64s = [];
                tmpRetBools = [];
            }
            bjs["swift_js_return_int"] = function(v) {
                const value = v | 0;
                tmpRetInts.push(value);
            }
            bjs["swift_js_return_f32"] = function(v) {
                const value = Math.fround(v);
                tmpRetF32s.push(value);
            }
            bjs["swift_js_return_f64"] = function(v) {
                tmpRetF64s.push(v);
            }
            bjs["swift_js_return_bool"] = function(v) {
                const value = v !== 0;
                tmpRetBools.push(value);
            }


        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;
            

            const APIResultHelpers = __bjs_createAPIResultHelpers()(textEncoder, swift);
            enumHelpers.APIResult = APIResultHelpers;
            
            const ComplexResultHelpers = __bjs_createComplexResultHelpers()(textEncoder, swift);
            enumHelpers.ComplexResult = ComplexResultHelpers;
            
            const ResultHelpers = __bjs_createResultHelpers()(textEncoder, swift);
            enumHelpers.Result = ResultHelpers;
            
            const NetworkingResultHelpers = __bjs_createNetworkingResultHelpers()(textEncoder, swift);
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
                    const { caseId: resultCaseId, paramsId: resultParamsId, paramsLen: resultParamsLen, cleanup: resultCleanup } = enumHelpers.APIResult.lower(result);
                    instance.exports.bjs_handle(resultCaseId, resultParamsId, resultParamsLen);
                    if (resultCleanup) { resultCleanup(); }
                },
                getResult: function bjs_getResult() {
                    instance.exports.bjs_getResult();
                    const ret = enumHelpers.APIResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetBools);
                    return ret;
                },
                handleComplex: function bjs_handleComplex(result) {
                    const { caseId: resultCaseId, paramsId: resultParamsId, paramsLen: resultParamsLen, cleanup: resultCleanup } = enumHelpers.ComplexResult.lower(result);
                    instance.exports.bjs_handleComplex(resultCaseId, resultParamsId, resultParamsLen);
                    if (resultCleanup) { resultCleanup(); }
                },
                getComplexResult: function bjs_getComplexResult() {
                    instance.exports.bjs_getComplexResult();
                    const ret = enumHelpers.ComplexResult.raise(tmpRetTag, tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetBools);
                    return ret;
                },
            };
        },
    }
}