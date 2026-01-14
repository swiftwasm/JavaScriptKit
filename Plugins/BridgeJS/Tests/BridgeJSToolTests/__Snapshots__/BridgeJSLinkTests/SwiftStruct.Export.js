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
    const enumHelpers = {};
    const structHelpers = {};
    
    let _exports = null;
    let bjs = null;
    const __bjs_createDataPointHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                tmpParamF64s.push(value.x);
                tmpParamF64s.push(value.y);
                const bytes = textEncoder.encode(value.label);
                const id = swift.memory.retain(bytes);
                tmpParamInts.push(bytes.length);
                tmpParamInts.push(id);
                const isSome = value.optCount != null;
                if (isSome) {
                    tmpParamInts.push(value.optCount | 0);
                } else {
                    tmpParamInts.push(0);
                }
                tmpParamInts.push(isSome ? 1 : 0);
                const isSome1 = value.optFlag != null;
                if (isSome1) {
                    tmpParamInts.push(value.optFlag ? 1 : 0);
                } else {
                    tmpParamInts.push(0);
                }
                tmpParamInts.push(isSome1 ? 1 : 0);
                const cleanup = () => {
                    swift.memory.release(id);
                };
                return { cleanup };
            },
            raise: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                const isSome = tmpRetInts.pop();
                let optional;
                if (isSome) {
                    const bool = tmpRetInts.pop() !== 0;
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
                const string = tmpRetStrings.pop();
                const f64 = tmpRetF64s.pop();
                const f641 = tmpRetF64s.pop();
                return { x: f641, y: f64, label: string, optCount: optional1, optFlag: optional };
            }
        });
    };
    const __bjs_createAddressHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                const bytes = textEncoder.encode(value.street);
                const id = swift.memory.retain(bytes);
                tmpParamInts.push(bytes.length);
                tmpParamInts.push(id);
                const bytes1 = textEncoder.encode(value.city);
                const id1 = swift.memory.retain(bytes1);
                tmpParamInts.push(bytes1.length);
                tmpParamInts.push(id1);
                const isSome = value.zipCode != null;
                if (isSome) {
                    tmpParamInts.push(value.zipCode | 0);
                } else {
                    tmpParamInts.push(0);
                }
                tmpParamInts.push(isSome ? 1 : 0);
                const cleanup = () => {
                    swift.memory.release(id);
                    swift.memory.release(id1);
                };
                return { cleanup };
            },
            raise: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                const isSome = tmpRetInts.pop();
                let optional;
                if (isSome) {
                    const int = tmpRetInts.pop();
                    optional = int;
                } else {
                    optional = null;
                }
                const string = tmpRetStrings.pop();
                const string1 = tmpRetStrings.pop();
                return { street: string1, city: string, zipCode: optional };
            }
        });
    };
    const __bjs_createPersonHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                const bytes = textEncoder.encode(value.name);
                const id = swift.memory.retain(bytes);
                tmpParamInts.push(bytes.length);
                tmpParamInts.push(id);
                tmpParamInts.push((value.age | 0));
                const structResult = structHelpers.Address.lower(value.address);
                const isSome = value.email != null;
                let id1;
                if (isSome) {
                    const bytes1 = textEncoder.encode(value.email);
                    id1 = swift.memory.retain(bytes1);
                    tmpParamInts.push(bytes1.length);
                    tmpParamInts.push(id1);
                } else {
                    tmpParamInts.push(0);
                    tmpParamInts.push(0);
                }
                tmpParamInts.push(isSome ? 1 : 0);
                const cleanup = () => {
                    swift.memory.release(id);
                    if (structResult.cleanup) { structResult.cleanup(); }
                    if(id1 !== undefined) { swift.memory.release(id1); }
                };
                return { cleanup };
            },
            raise: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                const isSome = tmpRetInts.pop();
                let optional;
                if (isSome) {
                    const string = tmpRetStrings.pop();
                    optional = string;
                } else {
                    optional = null;
                }
                const struct = structHelpers.Address.raise(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                const int = tmpRetInts.pop();
                const string1 = tmpRetStrings.pop();
                return { name: string1, age: int, address: struct, email: optional };
            }
        });
    };
    const __bjs_createSessionHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                tmpParamInts.push((value.id | 0));
                tmpParamPointers.push(value.owner.pointer);
                return { cleanup: undefined };
            },
            raise: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                const ptr = tmpRetPointers.pop();
                const value = _exports['Greeter'].__construct(ptr);
                const int = tmpRetInts.pop();
                return { id: int, owner: value };
            }
        });
    };
    const __bjs_createConfigStructHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                return { cleanup: undefined };
            },
            raise: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                return {  };
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
            importObject["TestModule"]["bjs_Greeter_wrap"] = function(pointer) {
                const obj = Greeter.__construct(pointer);
                return swift.memory.retain(obj);
            };
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
            class Greeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Greeter_deinit, Greeter.prototype);
                }
            
                constructor(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_Greeter_init(nameId, nameBytes.length);
                    swift.memory.release(nameId);
                    return Greeter.__construct(ret);
                }
                greet() {
                    instance.exports.bjs_Greeter_greet(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                get name() {
                    instance.exports.bjs_Greeter_name_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set name(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_Greeter_name_set(this.pointer, valueId, valueBytes.length);
                    swift.memory.release(valueId);
                }
            }
            const DataPointHelpers = __bjs_createDataPointHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.DataPoint = DataPointHelpers;
            
            const AddressHelpers = __bjs_createAddressHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.Address = AddressHelpers;
            
            const PersonHelpers = __bjs_createPersonHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.Person = PersonHelpers;
            
            const SessionHelpers = __bjs_createSessionHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.Session = SessionHelpers;
            
            const ConfigStructHelpers = __bjs_createConfigStructHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.ConfigStruct = ConfigStructHelpers;
            
            const exports = {
                Greeter,
                roundtrip: function bjs_roundtrip(session) {
                    const { cleanup: cleanup } = structHelpers.Person.lower(session);
                    instance.exports.bjs_roundtrip();
                    const structValue = structHelpers.Person.raise(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                    if (cleanup) { cleanup(); }
                    return structValue;
                },
                DataPoint: {
                    init: function(x, y, label, optCount, optFlag) {
                        const labelBytes = textEncoder.encode(label);
                        const labelId = swift.memory.retain(labelBytes);
                        const isSome = optCount != null;
                        const isSome1 = optFlag != null;
                        instance.exports.bjs_DataPoint_init(x, y, labelId, labelBytes.length, +isSome, isSome ? optCount : 0, +isSome1, isSome1 ? optFlag : 0);
                        const structValue = structHelpers.DataPoint.raise(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                        swift.memory.release(labelId);
                        return structValue;
                    },
                },
                ConfigStruct: {
                    get maxRetries() {
                        const ret = instance.exports.bjs_ConfigStruct_static_maxRetries_get();
                        return ret;
                    },
                    get defaultConfig() {
                        instance.exports.bjs_ConfigStruct_static_defaultConfig_get();
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    },
                    set defaultConfig(value) {
                        const valueBytes = textEncoder.encode(value);
                        const valueId = swift.memory.retain(valueBytes);
                        instance.exports.bjs_ConfigStruct_static_defaultConfig_set(valueId, valueBytes.length);
                        swift.memory.release(valueId);
                    },
                    get timeout() {
                        const ret = instance.exports.bjs_ConfigStruct_static_timeout_get();
                        return ret;
                    },
                    set timeout(value) {
                        instance.exports.bjs_ConfigStruct_static_timeout_set(value);
                    },
                    get computedSetting() {
                        instance.exports.bjs_ConfigStruct_static_computedSetting_get();
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    },
                    update: function(timeout) {
                        const ret = instance.exports.bjs_ConfigStruct_static_update(timeout);
                        return ret;
                    },
                },
            };
            _exports = exports;
            return exports;
        },
    }
}