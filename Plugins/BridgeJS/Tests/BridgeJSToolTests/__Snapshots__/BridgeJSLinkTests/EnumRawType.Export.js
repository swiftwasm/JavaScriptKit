// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const ThemeValues = {
    Light: "light",
    Dark: "dark",
    Auto: "auto",
};

export const TSTheme = {
    Light: "light",
    Dark: "dark",
    Auto: "auto",
};

export const FeatureFlagValues = {
    Enabled: true,
    Disabled: false,
};

export const HttpStatusValues = {
    Ok: 200,
    NotFound: 404,
    ServerError: 500,
};

export const TSHttpStatus = {
    Ok: 200,
    NotFound: 404,
    ServerError: 500,
};

export const PriorityValues = {
    Lowest: 1,
    Low: 2,
    Medium: 3,
    High: 4,
    Highest: 5,
};

export const FileSizeValues = {
    Tiny: 1024,
    Small: 10240,
    Medium: 102400,
    Large: 1048576,
};

export const UserIdValues = {
    Guest: 0,
    User: 1000,
    Admin: 9999,
};

export const TokenIdValues = {
    Invalid: 0,
    Session: 12345,
    Refresh: 67890,
};

export const SessionIdValues = {
    None: 0,
    Active: 9876543210,
    Expired: 1234567890,
};

export const PrecisionValues = {
    Rough: 0.1,
    Normal: 0.01,
    Fine: 0.001,
};

export const RatioValues = {
    Quarter: 0.25,
    Half: 0.5,
    Golden: 1.618,
    Pi: 3.14159,
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

            setException = (error) => {
                instance.exports._swift_js_exception.value = swift.memory.retain(error)
            }
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;
            return {
                setTheme: function bjs_setTheme(theme) {
                    const themeBytes = textEncoder.encode(theme);
                    const themeId = swift.memory.retain(themeBytes);
                    instance.exports.bjs_setTheme(themeId, themeBytes.length);
                    swift.memory.release(themeId);
                },
                getTheme: function bjs_getTheme() {
                    instance.exports.bjs_getTheme();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                roundTripOptionalTheme: function bjs_roundTripOptionalTheme(input) {
                    const isSome = input != null;
                    let inputId, inputBytes;
                    if (isSome) {
                        inputBytes = textEncoder.encode(input);
                        inputId = swift.memory.retain(inputBytes);
                    }
                    instance.exports.bjs_roundTripOptionalTheme(+isSome, isSome ? inputId : 0, isSome ? inputBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (inputId != undefined) {
                        swift.memory.release(inputId);
                    }
                    return optResult;
                },
                setTSTheme: function bjs_setTSTheme(theme) {
                    const themeBytes = textEncoder.encode(theme);
                    const themeId = swift.memory.retain(themeBytes);
                    instance.exports.bjs_setTSTheme(themeId, themeBytes.length);
                    swift.memory.release(themeId);
                },
                getTSTheme: function bjs_getTSTheme() {
                    instance.exports.bjs_getTSTheme();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                roundTripOptionalTSTheme: function bjs_roundTripOptionalTSTheme(input) {
                    const isSome = input != null;
                    let inputId, inputBytes;
                    if (isSome) {
                        inputBytes = textEncoder.encode(input);
                        inputId = swift.memory.retain(inputBytes);
                    }
                    instance.exports.bjs_roundTripOptionalTSTheme(+isSome, isSome ? inputId : 0, isSome ? inputBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (inputId != undefined) {
                        swift.memory.release(inputId);
                    }
                    return optResult;
                },
                setFeatureFlag: function bjs_setFeatureFlag(flag) {
                    instance.exports.bjs_setFeatureFlag(flag);
                },
                getFeatureFlag: function bjs_getFeatureFlag() {
                    const ret = instance.exports.bjs_getFeatureFlag();
                    return ret !== 0;
                },
                roundTripOptionalFeatureFlag: function bjs_roundTripOptionalFeatureFlag(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalFeatureFlag(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalBool;
                    tmpRetOptionalBool = undefined;
                    return optResult;
                },
                setHttpStatus: function bjs_setHttpStatus(status) {
                    instance.exports.bjs_setHttpStatus(status);
                },
                getHttpStatus: function bjs_getHttpStatus() {
                    const ret = instance.exports.bjs_getHttpStatus();
                    return ret;
                },
                roundTripOptionalHttpStatus: function bjs_roundTripOptionalHttpStatus(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalHttpStatus(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setTSHttpStatus: function bjs_setTSHttpStatus(status) {
                    instance.exports.bjs_setTSHttpStatus(status);
                },
                getTSHttpStatus: function bjs_getTSHttpStatus() {
                    const ret = instance.exports.bjs_getTSHttpStatus();
                    return ret;
                },
                roundTripOptionalHttpStatus: function bjs_roundTripOptionalHttpStatus(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalHttpStatus(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setPriority: function bjs_setPriority(priority) {
                    instance.exports.bjs_setPriority(priority);
                },
                getPriority: function bjs_getPriority() {
                    const ret = instance.exports.bjs_getPriority();
                    return ret;
                },
                roundTripOptionalPriority: function bjs_roundTripOptionalPriority(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalPriority(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setFileSize: function bjs_setFileSize(size) {
                    instance.exports.bjs_setFileSize(size);
                },
                getFileSize: function bjs_getFileSize() {
                    const ret = instance.exports.bjs_getFileSize();
                    return ret;
                },
                roundTripOptionalFileSize: function bjs_roundTripOptionalFileSize(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalFileSize(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setUserId: function bjs_setUserId(id) {
                    instance.exports.bjs_setUserId(id);
                },
                getUserId: function bjs_getUserId() {
                    const ret = instance.exports.bjs_getUserId();
                    return ret;
                },
                roundTripOptionalUserId: function bjs_roundTripOptionalUserId(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalUserId(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setTokenId: function bjs_setTokenId(token) {
                    instance.exports.bjs_setTokenId(token);
                },
                getTokenId: function bjs_getTokenId() {
                    const ret = instance.exports.bjs_getTokenId();
                    return ret;
                },
                roundTripOptionalTokenId: function bjs_roundTripOptionalTokenId(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalTokenId(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setSessionId: function bjs_setSessionId(session) {
                    instance.exports.bjs_setSessionId(session);
                },
                getSessionId: function bjs_getSessionId() {
                    const ret = instance.exports.bjs_getSessionId();
                    return ret;
                },
                roundTripOptionalSessionId: function bjs_roundTripOptionalSessionId(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalSessionId(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                setPrecision: function bjs_setPrecision(precision) {
                    instance.exports.bjs_setPrecision(precision);
                },
                getPrecision: function bjs_getPrecision() {
                    const ret = instance.exports.bjs_getPrecision();
                    return ret;
                },
                roundTripOptionalPrecision: function bjs_roundTripOptionalPrecision(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalPrecision(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalFloat;
                    tmpRetOptionalFloat = undefined;
                    return optResult;
                },
                setRatio: function bjs_setRatio(ratio) {
                    instance.exports.bjs_setRatio(ratio);
                },
                getRatio: function bjs_getRatio() {
                    const ret = instance.exports.bjs_getRatio();
                    return ret;
                },
                roundTripOptionalRatio: function bjs_roundTripOptionalRatio(input) {
                    const isSome = input != null;
                    instance.exports.bjs_roundTripOptionalRatio(+isSome, isSome ? input : 0);
                    const optResult = tmpRetOptionalDouble;
                    tmpRetOptionalDouble = undefined;
                    return optResult;
                },
                processTheme: function bjs_processTheme(theme) {
                    const themeBytes = textEncoder.encode(theme);
                    const themeId = swift.memory.retain(themeBytes);
                    const ret = instance.exports.bjs_processTheme(themeId, themeBytes.length);
                    swift.memory.release(themeId);
                    return ret;
                },
                convertPriority: function bjs_convertPriority(status) {
                    const ret = instance.exports.bjs_convertPriority(status);
                    return ret;
                },
                validateSession: function bjs_validateSession(session) {
                    instance.exports.bjs_validateSession(session);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                Theme: ThemeValues,
                FeatureFlag: FeatureFlagValues,
                HttpStatus: HttpStatusValues,
                Priority: PriorityValues,
                FileSize: FileSizeValues,
                UserId: UserIdValues,
                TokenId: TokenIdValues,
                SessionId: SessionIdValues,
                Precision: PrecisionValues,
                Ratio: RatioValues,
            };
        },
    }
}