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


// Helper factory for APIResult enum
const __bjs_createAPIResultHelpers = () => {
    return (textEncoder, swift) => ({
        lower: (value) => {
            const t = value.tag;
            switch (t) {
                case APIResult.Tag.Success: {
                    const paramsObj = { "param0": value.param0 };
                    const paramsJson = JSON.stringify(paramsObj);
                    const paramsBytes = textEncoder.encode(paramsJson);
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 0, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                case APIResult.Tag.Failure: {
                    const paramsObj = { "param0": (value.param0 | 0) };
                    const paramsJson = JSON.stringify(paramsObj);
                    const paramsBytes = textEncoder.encode(paramsJson);
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 1, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                case APIResult.Tag.Flag: {
                    const paramsObj = { "param0": value.param0 };
                    const paramsJson = JSON.stringify(paramsObj);
                    const paramsBytes = textEncoder.encode(paramsJson);
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 2, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                case APIResult.Tag.Rate: {
                    const paramsObj = { "param0": Math.fround(value.param0) };
                    const paramsJson = JSON.stringify(paramsObj);
                    const paramsBytes = textEncoder.encode(paramsJson);
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 3, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                case APIResult.Tag.Precise: {
                    const paramsObj = { "param0": value.param0 };
                    const paramsJson = JSON.stringify(paramsObj);
                    const paramsBytes = textEncoder.encode(paramsJson);
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 4, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                case APIResult.Tag.Info: {
                    const paramsBytes = textEncoder.encode("{}");
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 5, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                default: throw new Error("Unknown APIResult tag: " + String(t));
            }
        },
        raise: (tmpRetTag, tmpRetString, tmpRetInt, tmpRetF32, tmpRetF64) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case 0: return { tag: APIResult.Tag.Success, param0: tmpRetString };
                case 1: return { tag: APIResult.Tag.Failure, param0: tmpRetInt | 0 };
                case 2: return { tag: APIResult.Tag.Flag, param0: (tmpRetInt !== 0) };
                case 3: return { tag: APIResult.Tag.Rate, param0: Math.fround(tmpRetF32) };
                case 4: return { tag: APIResult.Tag.Precise, param0: tmpRetF64 };
                case 5: return { tag: APIResult.Tag.Info };
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
        Info: 3,
    }
};


// Helper factory for ComplexResult enum
const __bjs_createComplexResultHelpers = () => {
    return (textEncoder, swift) => ({
        lower: (value) => {
            const t = value.tag;
            switch (t) {
                case ComplexResult.Tag.Success: {
                    const paramsObj = { "param0": value.param0 };
                    const paramsJson = JSON.stringify(paramsObj);
                    const paramsBytes = textEncoder.encode(paramsJson);
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 0, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                case ComplexResult.Tag.Error: {
                    const paramsObj = { "param0": value.param0, "param1": (value.param1 | 0) };
                    const paramsJson = JSON.stringify(paramsObj);
                    const paramsBytes = textEncoder.encode(paramsJson);
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 1, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                case ComplexResult.Tag.Status: {
                    const paramsObj = { "param0": value.param0, "param1": value.param1 };
                    const paramsJson = JSON.stringify(paramsObj);
                    const paramsBytes = textEncoder.encode(paramsJson);
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 2, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                case ComplexResult.Tag.Info: {
                    const paramsBytes = textEncoder.encode("{}");
                    const paramsId = swift.memory.retain(paramsBytes);
                    return { caseId: 3, paramsId: paramsId, paramsLen: paramsBytes.length, cleanup: () => { swift.memory.release(paramsId); } };
                }
                default: throw new Error("Unknown ComplexResult tag: " + String(t));
            }
        },
        raise: (tmpRetTag, tmpRetString, tmpRetInt, tmpRetF32, tmpRetF64) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case 0: return { tag: ComplexResult.Tag.Success, param0: tmpRetString };
                case 1: return { tag: ComplexResult.Tag.Error, param0: tmpRetString, param1: tmpRetInt | 0 };
                case 2: return { tag: ComplexResult.Tag.Status, param0: (tmpRetInt !== 0), param1: tmpRetString };
                case 3: return { tag: ComplexResult.Tag.Info };
                default: throw new Error("Unknown ComplexResult tag returned from Swift: " + String(tag));
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
    let tmpRetTag;
    let tmpRetInt;
    let tmpRetF32;
    let tmpRetF64;

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
            bjs["swift_js_return_tag"] = function(tag) {
                tmpRetTag = tag | 0;
            }
            bjs["swift_js_return_int"] = function(v) {
                tmpRetInt = v | 0;
            }
            bjs["swift_js_return_f32"] = function(v) {
                tmpRetF32 = Math.fround(v);
            }
            bjs["swift_js_return_f64"] = function(v) {
                tmpRetF64 = v;
            }


        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            // Set up APIResult enum helpers
            const APIResultHelpers = __bjs_createAPIResultHelpers()(textEncoder, swift);
            globalThis.__bjs_lower_APIResult = (value) => APIResultHelpers.lower(value);
            globalThis.__bjs_raise_APIResult = () => APIResultHelpers.raise(tmpRetTag, tmpRetString, tmpRetInt, tmpRetF32, tmpRetF64);
            
            // Set up ComplexResult enum helpers
            const ComplexResultHelpers = __bjs_createComplexResultHelpers()(textEncoder, swift);
            globalThis.__bjs_lower_ComplexResult = (value) => ComplexResultHelpers.lower(value);
            globalThis.__bjs_raise_ComplexResult = () => ComplexResultHelpers.raise(tmpRetTag, tmpRetString, tmpRetInt, tmpRetF32, tmpRetF64);
            
            setException = (error) => {
                instance.exports._swift_js_exception.value = swift.memory.retain(error)
            }
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;

            return {
                handle: function bjs_handle(result) {
                    const { caseId: resultCaseId, paramsId: resultParamsId, paramsLen: resultParamsLen, cleanup: resultCleanup } = globalThis.__bjs_lower_APIResult(result);
                    instance.exports.bjs_handle(resultCaseId, resultParamsId, resultParamsLen);
                    if (resultCleanup) { resultCleanup(); }
                },
                getResult: function bjs_getResult() {
                    instance.exports.bjs_getResult();
                    const ret = globalThis.__bjs_raise_APIResult();
                    return ret;
                },
                handleComplex: function bjs_handleComplex(result) {
                    const { caseId: resultCaseId, paramsId: resultParamsId, paramsLen: resultParamsLen, cleanup: resultCleanup } = globalThis.__bjs_lower_ComplexResult(result);
                    instance.exports.bjs_handleComplex(resultCaseId, resultParamsId, resultParamsLen);
                    if (resultCleanup) { resultCleanup(); }
                },
                getComplexResult: function bjs_getComplexResult() {
                    instance.exports.bjs_getComplexResult();
                    const ret = globalThis.__bjs_raise_ComplexResult();
                    return ret;
                },
            };
        },
    }
}