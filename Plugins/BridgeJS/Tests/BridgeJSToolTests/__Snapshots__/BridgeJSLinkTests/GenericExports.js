// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const LevelValues = {
    Low: 1,
    High: 9,
};

export const ExportModeValues = {
    On: "on",
    Off: "off",
};

export const ExportColorValues = {
    Red: 0,
    Green: 1,
};

export const ExportTaggedValues = {
    Tag: {
        Number: 0,
        Text: 1,
    },
};
export const GenericFactoryValues = {
    Primary: 0,
};

export const BridgeTypes = { Bool: "Bool", Int: "Int", Int8: "Int8", UInt8: "UInt8", Int16: "Int16", UInt16: "UInt16", Int32: "Int32", UInt32: "UInt32", UInt: "UInt", Int64: "Int64", UInt64: "UInt64", Float: "Float", Double: "Double", String: "String", JSValue: "JSValue", ExportPoint: "ExportPoint", ExportNamespace_Metadata: "ExportNamespace_Metadata", GenericPair: "GenericPair", ExportBox: "ExportBox", GenericBox: "GenericBox", ExportNamespace_Level: "ExportNamespace_Level", ExportMode: "ExportMode", ExportColor: "ExportColor", ExportTagged: "ExportTagged", GenericFactory: "GenericFactory" };
export async function createInstantiator(options, swift) {
    let instance;
    let memory;
    let setException;
    let decodeString;
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
    let i64Stack = [];
    let f32Stack = [];
    let f64Stack = [];
    let ptrStack = [];
    let taStack = [];
    const enumHelpers = {};
    const structHelpers = {};
    let __bjs_codecs;
    let __bjs_codecsById = [];
    function __bjs_resolveGenericType(token) {
        const codec = __bjs_codecs[token];
        if (!codec) {
            throw new Error("BridgeJS: no generic codec registered for type '" + token + "'");
        }
        let id = __bjs_codecsById.indexOf(codec);
        if (id === -1) {
            id = __bjs_codecsById.push(codec) - 1;
        }
        return id;
    }
    function __bjs_lowerArrayGeneric(value, codec) {
        for (let i = 0; i < value.length; i++) {
            codec.lower(value[i]);
        }
        i32Stack.push(value.length);
    }
    function __bjs_liftArrayGeneric(codec) {
        const count = i32Stack.pop();
        if (count === -1) {
            return taStack.pop();
        }
        const result = new Array(count);
        for (let i = count - 1; i >= 0; i--) {
            result[i] = codec.lift();
        }
        return result;
    }
    function __bjs_lowerOptionalGeneric(value, codec) {
        if (value === null || value === undefined) {
            i32Stack.push(0);
        } else {
            codec.lower(value);
            i32Stack.push(1);
        }
    }
    function __bjs_liftOptionalGeneric(codec) {
        if (i32Stack.pop() === 0) {
            return null;
        }
        return codec.lift();
    }
    function __bjs_lowerDictGeneric(value, codec) {
        const keys = Object.keys(value);
        for (let i = 0; i < keys.length; i++) {
            __bjs_codecs["String"].lower(keys[i]);
            codec.lower(value[keys[i]]);
        }
        i32Stack.push(keys.length);
    }
    function __bjs_liftDictGeneric(codec) {
        const count = i32Stack.pop();
        const result = {};
        for (let i = 0; i < count; i++) {
            const value = codec.lift();
            const key = __bjs_codecs["String"].lift();
            result[key] = value;
        }
        return result;
    }

    let _exports = null;
    let bjs = null;
    function __bjs_jsValueLower(value) {
        let kind;
        let payload1;
        let payload2;
        if (value === null) {
            kind = 4;
            payload1 = 0;
            payload2 = 0;
        } else {
            switch (typeof value) {
                case "boolean":
                    kind = 0;
                    payload1 = value ? 1 : 0;
                    payload2 = 0;
                    break;
                case "number":
                    kind = 2;
                    payload1 = 0;
                    payload2 = value;
                    break;
                case "string":
                    kind = 1;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "undefined":
                    kind = 5;
                    payload1 = 0;
                    payload2 = 0;
                    break;
                case "object":
                    kind = 3;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "function":
                    kind = 3;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "symbol":
                    kind = 7;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "bigint":
                    kind = 8;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                default:
                    throw new TypeError("Unsupported JSValue type");
            }
        }
        return [kind, payload1, payload2];
    }
    function __bjs_jsValueLift(kind, payload1, payload2) {
        let jsValue;
        switch (kind) {
            case 0:
                jsValue = payload1 !== 0;
                break;
            case 1:
                jsValue = swift.memory.getObject(payload1);
                break;
            case 2:
                jsValue = payload2;
                break;
            case 3:
                jsValue = swift.memory.getObject(payload1);
                break;
            case 4:
                jsValue = null;
                break;
            case 5:
                jsValue = undefined;
                break;
            case 7:
                jsValue = swift.memory.getObject(payload1);
                break;
            case 8:
                jsValue = swift.memory.getObject(payload1);
                break;
            default:
                throw new TypeError("Unsupported JSValue kind " + kind);
        }
        return jsValue;
    }

    const __bjs_createExportPointHelpers = () => ({
        lower: (value) => {
            i32Stack.push((value.x | 0));
            i32Stack.push((value.y | 0));
        },
        lift: () => {
            const int = i32Stack.pop();
            const int1 = i32Stack.pop();
            return { x: int1, y: int };
        }
    });
    const __bjs_createExportNamespace_MetadataHelpers = () => ({
        lower: (value) => {
            const bytes = textEncoder.encode(value.label);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
            i32Stack.push((value.count | 0));
        },
        lift: () => {
            const int = i32Stack.pop();
            const string = strStack.pop();
            return { label: string, count: int };
        }
    });
    const __bjs_createGenericPairHelpers = () => ({
        lower: (value) => {
        },
        lift: () => {
            const instance1 = {  };
            instance1.first = function(value, typeT) {
                const tTypeId = __bjs_resolveGenericType(typeT);
                const codecT = __bjs_codecsById[tTypeId];
                structHelpers.GenericPair.lower(this);
                codecT.lower(value);
                instance.exports.bjs_GenericPair_first(tTypeId);
                return codecT.lift();
            }.bind(instance1);
            instance1.combine = function(a, b, typeT, typet) {
                const tTypeId = __bjs_resolveGenericType(typeT);
                const codecT = __bjs_codecsById[tTypeId];
                const tTypeId1 = __bjs_resolveGenericType(typet);
                const codect = __bjs_codecsById[tTypeId1];
                structHelpers.GenericPair.lower(this);
                codecT.lower(a);
                codect.lower(b);
                instance.exports.bjs_GenericPair_combine(tTypeId, tTypeId1);
                return codecT.lift();
            }.bind(instance1);
            instance1.maybe = function(value, typeT) {
                const tTypeId = __bjs_resolveGenericType(typeT);
                const codecT = __bjs_codecsById[tTypeId];
                structHelpers.GenericPair.lower(this);
                codecT.lower(value);
                instance.exports.bjs_GenericPair_maybe(tTypeId);
                return __bjs_liftOptionalGeneric(codecT);
            }.bind(instance1);
            instance1.dict = function(value, typeT) {
                const tTypeId = __bjs_resolveGenericType(typeT);
                const codecT = __bjs_codecsById[tTypeId];
                structHelpers.GenericPair.lower(this);
                codecT.lower(value);
                instance.exports.bjs_GenericPair_dict(tTypeId);
                return __bjs_liftDictGeneric(codecT);
            }.bind(instance1);
            return instance1;
        }
    });
    const __bjs_createExportTaggedValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case ExportTaggedValues.Tag.Number: {
                    i32Stack.push((value.value | 0));
                    return ExportTaggedValues.Tag.Number;
                }
                case ExportTaggedValues.Tag.Text: {
                    const bytes = textEncoder.encode(value.value);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return ExportTaggedValues.Tag.Text;
                }
                default: throw new Error("Unknown ExportTaggedValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case ExportTaggedValues.Tag.Number: {
                    const int = i32Stack.pop();
                    return { tag: ExportTaggedValues.Tag.Number, value: int };
                }
                case ExportTaggedValues.Tag.Text: {
                    const string = strStack.pop();
                    return { tag: ExportTaggedValues.Tag.Text, value: string };
                }
                default: throw new Error("Unknown ExportTaggedValues tag returned from Swift: " + String(tag));
            }
        }
    });

    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            bjs["swift_js_return_string"] = function(ptr, len) {
                tmpRetString = decodeString(ptr, len);
            }
            bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
                swift.memory.release(sourceId);
                const bytes = new Uint8Array(memory.buffer, bytesPtr >>> 0);
                bytes.set(source);
            }
            bjs["swift_js_make_js_string"] = function(ptr, len) {
                return swift.memory.retain(decodeString(ptr, len));
            }
            bjs["swift_js_init_memory_with_result"] = function(ptr, len) {
                const target = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0);
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
                const value = decodeString(ptr, len);
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
            bjs["swift_js_push_i64"] = function(v) {
                i64Stack.push(v);
            }
            bjs["swift_js_pop_i64"] = function() {
                return i64Stack.pop();
            }
            const taCtors = [Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array];
            bjs["swift_js_push_typed_array"] = function(kind, ptr, count) {
                const Ctor = taCtors[kind];
                const byteLen = count * Ctor.BYTES_PER_ELEMENT;
                const copy = memory.buffer.slice(ptr, ptr + byteLen);
                taStack.push(Array.from(new Ctor(copy)));
            }
            bjs["swift_js_struct_lower_ExportPoint"] = function(objectId) {
                structHelpers.ExportPoint.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_ExportPoint"] = function() {
                const value = structHelpers.ExportPoint.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_ExportNamespace_Metadata"] = function(objectId) {
                structHelpers.ExportNamespace_Metadata.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_ExportNamespace_Metadata"] = function() {
                const value = structHelpers.ExportNamespace_Metadata.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_GenericPair"] = function(objectId) {
                structHelpers.GenericPair.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_GenericPair"] = function() {
                const value = structHelpers.GenericPair.lift();
                return swift.memory.retain(value);
            }
            __bjs_codecs = {
                "Bool": {
                    lower: (v) => {
                        i32Stack.push(v ? 1 : 0);
                    },
                    lift: () => {
                        const bool = i32Stack.pop() !== 0;
                        return bool;
                    },
                },
                "Int": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const int = i32Stack.pop();
                        return int;
                    },
                },
                "Int8": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const int = i32Stack.pop();
                        return int;
                    },
                },
                "UInt8": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const int = i32Stack.pop() >>> 0;
                        return int;
                    },
                },
                "Int16": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const int = i32Stack.pop();
                        return int;
                    },
                },
                "UInt16": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const int = i32Stack.pop() >>> 0;
                        return int;
                    },
                },
                "Int32": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const int = i32Stack.pop();
                        return int;
                    },
                },
                "UInt32": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const int = i32Stack.pop() >>> 0;
                        return int;
                    },
                },
                "UInt": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const int = i32Stack.pop() >>> 0;
                        return int;
                    },
                },
                "Int64": {
                    lower: (v) => {
                        i64Stack.push(v);
                    },
                    lift: () => {
                        const int = i64Stack.pop();
                        return int;
                    },
                },
                "UInt64": {
                    lower: (v) => {
                        i64Stack.push(v);
                    },
                    lift: () => {
                        const int = i64Stack.pop();
                        return int;
                    },
                },
                "Float": {
                    lower: (v) => {
                        f32Stack.push(Math.fround(v));
                    },
                    lift: () => {
                        const f32 = f32Stack.pop();
                        return f32;
                    },
                },
                "Double": {
                    lower: (v) => {
                        f64Stack.push(v);
                    },
                    lift: () => {
                        const f64 = f64Stack.pop();
                        return f64;
                    },
                },
                "String": {
                    lower: (v) => {
                        const bytes = textEncoder.encode(v);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                    },
                    lift: () => {
                        const string = strStack.pop();
                        return string;
                    },
                },
                "JSValue": {
                    lower: (v) => {
                        const [vKind, vPayload1, vPayload2] = __bjs_jsValueLower(v);
                        i32Stack.push(vKind);
                        i32Stack.push(vPayload1);
                        f64Stack.push(vPayload2);
                    },
                    lift: () => {
                        const jsValuePayload2 = f64Stack.pop();
                        const jsValuePayload1 = i32Stack.pop();
                        const jsValueKind = i32Stack.pop();
                        const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                        return jsValue;
                    },
                },
                "ExportPoint": {
                    lower: (v) => {
                        structHelpers.ExportPoint.lower(v);
                    },
                    lift: () => {
                        const struct = structHelpers.ExportPoint.lift();
                        return struct;
                    },
                },
                "ExportNamespace_Metadata": {
                    lower: (v) => {
                        structHelpers.ExportNamespace_Metadata.lower(v);
                    },
                    lift: () => {
                        const struct = structHelpers.ExportNamespace_Metadata.lift();
                        return struct;
                    },
                },
                "GenericPair": {
                    lower: (v) => {
                        structHelpers.GenericPair.lower(v);
                    },
                    lift: () => {
                        const struct = structHelpers.GenericPair.lift();
                        return struct;
                    },
                },
                "ExportBox": {
                    lower: (v) => {
                        ptrStack.push(v.pointer);
                    },
                    lift: () => {
                        const ptr = ptrStack.pop();
                        const obj = _exports['ExportBox'].__construct(ptr);
                        return obj;
                    },
                },
                "GenericBox": {
                    lower: (v) => {
                        ptrStack.push(v.pointer);
                    },
                    lift: () => {
                        const ptr = ptrStack.pop();
                        const obj = _exports['GenericBox'].__construct(ptr);
                        return obj;
                    },
                },
                "ExportNamespace_Level": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const rawValue = i32Stack.pop();
                        return rawValue;
                    },
                },
                "ExportMode": {
                    lower: (v) => {
                        const bytes = textEncoder.encode(v);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                    },
                    lift: () => {
                        const rawValue = strStack.pop();
                        return rawValue;
                    },
                },
                "ExportColor": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const caseId = i32Stack.pop();
                        return caseId;
                    },
                },
                "ExportTagged": {
                    lower: (v) => {
                        const caseId = enumHelpers.ExportTagged.lower(v);
                        i32Stack.push(caseId);
                    },
                    lift: () => {
                        const enumValue = enumHelpers.ExportTagged.lift(i32Stack.pop());
                        return enumValue;
                    },
                },
                "GenericFactory": {
                    lower: (v) => {
                        i32Stack.push((v | 0));
                    },
                    lift: () => {
                        const caseId = i32Stack.pop();
                        return caseId;
                    },
                },
            };
            bjs["swift_js_resolve_type_id"] = function(ptr, len) {
                return __bjs_resolveGenericType(decodeString(ptr, len));
            }
            const __bjs_promiseSettlers = Symbol("JavaScriptKit.promiseSettlers");
            bjs["swift_js_make_promise"] = function() {
                let resolve, reject;
                const promise = new Promise((res, rej) => { resolve = res; reject = rej; });
                promise[__bjs_promiseSettlers] = { resolve, reject };
                return swift.memory.retain(promise);
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
                    tmpRetString = decodeString(ptr, len);
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
            importObject["TestModule"]["bjs_ExportBox_wrap"] = function(pointer) {
                const obj = _exports['ExportBox'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_GenericBox_wrap"] = function(pointer) {
                const obj = _exports['GenericBox'].__construct(pointer);
                return swift.memory.retain(obj);
            };
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            decodeString = (ptr, len) => { const bytes = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0); return textDecoder.decode(bytes); }

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
                state.identityMap?.delete(state.pointer);
                state.deinit(state.pointer);
            });

            /// Represents a Swift heap object like a class instance or an actor instance.
            class SwiftHeapObject {
                static __wrap(pointer, deinit, prototype, identityCache) {
                    pointer = pointer >>> 0;
                    const makeFresh = (identityMap) => {
                        const obj = Object.create(prototype);
                        const state = { pointer, deinit, hasReleased: false, identityMap };
                        obj.pointer = pointer;
                        obj.__swiftHeapObjectState = state;
                        swiftHeapObjectFinalizationRegistry.register(obj, state, state);
                        if (identityMap) {
                            identityMap.set(pointer, new WeakRef(obj));
                        }
                        return obj;
                    };

                    if (!identityCache) {
                        return makeFresh(null);
                    }

                    const cached = identityCache.get(pointer)?.deref();
                    if (cached && !cached.__swiftHeapObjectState.hasReleased) {
                        deinit(pointer);
                        return cached;
                    }
                    if (identityCache.has(pointer)) {
                        identityCache.delete(pointer);
                    }

                    return makeFresh(identityCache);
                }

                release() {
                    const state = this.__swiftHeapObjectState;
                    if (state.hasReleased) {
                        return;
                    }
                    state.hasReleased = true;
                    swiftHeapObjectFinalizationRegistry.unregister(state);
                    state.identityMap?.delete(state.pointer);
                    state.deinit(state.pointer);
                }
            }
            class ExportBox extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_ExportBox_deinit, ExportBox.prototype, null);
                }

                constructor(value) {
                    const ret = instance.exports.bjs_ExportBox_init(value);
                    return ExportBox.__construct(ret);
                }
                get() {
                    const ret = instance.exports.bjs_ExportBox_get(this.pointer);
                    return ret;
                }
                get value() {
                    const ret = instance.exports.bjs_ExportBox_value_get(this.pointer);
                    return ret;
                }
                set value(value) {
                    instance.exports.bjs_ExportBox_value_set(this.pointer, value);
                }
            }
            class GenericBox extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_GenericBox_deinit, GenericBox.prototype, null);
                }

                constructor() {
                    const ret = instance.exports.bjs_GenericBox_init();
                    return GenericBox.__construct(ret);
                }
                wrap(value, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    codecT.lower(value);
                    instance.exports.bjs_GenericBox_wrap(this.pointer, tTypeId);
                    return codecT.lift();
                }
                combine(a, b, typeT, typet) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    const tTypeId1 = __bjs_resolveGenericType(typet);
                    const codect = __bjs_codecsById[tTypeId1];
                    codecT.lower(a);
                    codect.lower(b);
                    instance.exports.bjs_GenericBox_combine(this.pointer, tTypeId, tTypeId1);
                    return codecT.lift();
                }
                static makeArray(value, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    codecT.lower(value);
                    instance.exports.bjs_GenericBox_static_makeArray(tTypeId);
                    return __bjs_liftArrayGeneric(codecT);
                }
            }
            const ExportPointHelpers = __bjs_createExportPointHelpers();
            structHelpers.ExportPoint = ExportPointHelpers;

            const ExportNamespace_MetadataHelpers = __bjs_createExportNamespace_MetadataHelpers();
            structHelpers.ExportNamespace_Metadata = ExportNamespace_MetadataHelpers;

            const GenericPairHelpers = __bjs_createGenericPairHelpers();
            structHelpers.GenericPair = GenericPairHelpers;

            const ExportTaggedHelpers = __bjs_createExportTaggedValuesHelpers();
            enumHelpers.ExportTagged = ExportTaggedHelpers;

            const exports = {
                genericExportIdentity: function bjs_genericExportIdentity(value, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    codecT.lower(value);
                    instance.exports.bjs_genericExportIdentity(tTypeId);
                    return codecT.lift();
                },
                genericExportArray: function bjs_genericExportArray(values, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    __bjs_lowerArrayGeneric(values, codecT);
                    instance.exports.bjs_genericExportArray(tTypeId);
                    return __bjs_liftArrayGeneric(codecT);
                },
                genericExportOptional: function bjs_genericExportOptional(value, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    __bjs_lowerOptionalGeneric(value, codecT);
                    instance.exports.bjs_genericExportOptional(tTypeId);
                    return __bjs_liftOptionalGeneric(codecT);
                },
                genericExportDictionary: function bjs_genericExportDictionary(values, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    __bjs_lowerDictGeneric(values, codecT);
                    instance.exports.bjs_genericExportDictionary(tTypeId);
                    return __bjs_liftDictGeneric(codecT);
                },
                genericExportEcho: function bjs_genericExportEcho(value, tag, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    codecT.lower(value);
                    instance.exports.bjs_genericExportEcho(tag, tTypeId);
                    return codecT.lift();
                },
                genericExportStructConcreteLeading: function bjs_genericExportStructConcreteLeading(v, p, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    structHelpers.ExportPoint.lower(p);
                    codecT.lower(v);
                    instance.exports.bjs_genericExportStructConcreteLeading(tTypeId);
                    return codecT.lift();
                },
                genericExportStructAndScalar: function bjs_genericExportStructAndScalar(p, tag, v, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    structHelpers.ExportPoint.lower(p);
                    codecT.lower(v);
                    instance.exports.bjs_genericExportStructAndScalar(tag, tTypeId);
                    return codecT.lift();
                },
                genericExportPair: function bjs_genericExportPair(a, b, typeT) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    codecT.lower(a);
                    codecT.lower(b);
                    instance.exports.bjs_genericExportPair(tTypeId);
                    return codecT.lift();
                },
                genericExportCombine: function bjs_genericExportCombine(a, b, typeT, typeU) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    const uTypeId = __bjs_resolveGenericType(typeU);
                    const codecU = __bjs_codecsById[uTypeId];
                    codecT.lower(a);
                    codecU.lower(b);
                    instance.exports.bjs_genericExportCombine(tTypeId, uTypeId);
                    return codecT.lift();
                },
                genericExportCombineReturnU: function bjs_genericExportCombineReturnU(a, b, typeT, typeU) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    const uTypeId = __bjs_resolveGenericType(typeU);
                    const codecU = __bjs_codecsById[uTypeId];
                    codecT.lower(a);
                    codecU.lower(b);
                    instance.exports.bjs_genericExportCombineReturnU(tTypeId, uTypeId);
                    return codecU.lift();
                },
                genericExportCaseDistinct: function bjs_genericExportCaseDistinct(a, b, typeT, typet) {
                    const tTypeId = __bjs_resolveGenericType(typeT);
                    const codecT = __bjs_codecsById[tTypeId];
                    const tTypeId1 = __bjs_resolveGenericType(typet);
                    const codect = __bjs_codecsById[tTypeId1];
                    codecT.lower(a);
                    codect.lower(b);
                    instance.exports.bjs_genericExportCaseDistinct(tTypeId, tTypeId1);
                    return codecT.lift();
                },
                ExportMode: ExportModeValues,
                ExportColor: ExportColorValues,
                ExportTagged: ExportTaggedValues,
                GenericFactory: {
                    ...GenericFactoryValues,
                    one: function(value, typeT) {
                        const tTypeId = __bjs_resolveGenericType(typeT);
                        const codecT = __bjs_codecsById[tTypeId];
                        codecT.lower(value);
                        instance.exports.bjs_GenericFactory_static_one(tTypeId);
                        return codecT.lift();
                    }
                },
                ExportBox,
                ExportNamespace: {
                    Level: LevelValues,
                },
                GenericBox,
                GenericNamespace: {
                    make: function bjs_GenericNamespace_static_make(value, typeT) {
                        const tTypeId = __bjs_resolveGenericType(typeT);
                        const codecT = __bjs_codecsById[tTypeId];
                        codecT.lower(value);
                        instance.exports.bjs_GenericNamespace_static_make(tTypeId);
                        return codecT.lift();
                    },
                },
                GenericPair: {
                    init: function() {
                        instance.exports.bjs_GenericPair_init();
                        const structValue = structHelpers.GenericPair.lift();
                        return structValue;
                    },
                    wrap: function(value, typeT) {
                        const tTypeId = __bjs_resolveGenericType(typeT);
                        const codecT = __bjs_codecsById[tTypeId];
                        codecT.lower(value);
                        instance.exports.bjs_GenericPair_static_wrap(tTypeId);
                        return __bjs_liftArrayGeneric(codecT);
                    },
                },
            };
            _exports = exports;
            return exports;
        },
    }
}