// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const PrecisionValues = {
    Rough: 0.1,
    Fine: 0.001,
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
    let strStack = [];
    let i32Stack = [];
    let f32Stack = [];
    let f64Stack = [];
    let ptrStack = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    const __bjs_createDataPointHelpers = () => {
        return () => ({
            lower: (value) => {
                f64Stack.push(value.x);
                f64Stack.push(value.y);
                const bytes = textEncoder.encode(value.label);
                const id = swift.memory.retain(bytes);
                i32Stack.push(bytes.length);
                i32Stack.push(id);
                const isSome = value.optCount != null;
                if (isSome) {
                    i32Stack.push(value.optCount | 0);
                } else {
                    i32Stack.push(0);
                }
                i32Stack.push(isSome ? 1 : 0);
                const isSome1 = value.optFlag != null;
                if (isSome1) {
                    i32Stack.push(value.optFlag ? 1 : 0);
                } else {
                    i32Stack.push(0);
                }
                i32Stack.push(isSome1 ? 1 : 0);
            },
            lift: () => {
                const isSome = i32Stack.pop();
                let optional;
                if (isSome) {
                    const bool = i32Stack.pop() !== 0;
                    optional = bool;
                } else {
                    optional = null;
                }
                const isSome1 = i32Stack.pop();
                let optional1;
                if (isSome1) {
                    const int = i32Stack.pop();
                    optional1 = int;
                } else {
                    optional1 = null;
                }
                const string = strStack.pop();
                const f64 = f64Stack.pop();
                const f641 = f64Stack.pop();
                return { x: f641, y: f64, label: string, optCount: optional1, optFlag: optional };
            }
        });
    };
    const __bjs_createAddressHelpers = () => {
        return () => ({
            lower: (value) => {
                const bytes = textEncoder.encode(value.street);
                const id = swift.memory.retain(bytes);
                i32Stack.push(bytes.length);
                i32Stack.push(id);
                const bytes1 = textEncoder.encode(value.city);
                const id1 = swift.memory.retain(bytes1);
                i32Stack.push(bytes1.length);
                i32Stack.push(id1);
                const isSome = value.zipCode != null;
                if (isSome) {
                    i32Stack.push(value.zipCode | 0);
                } else {
                    i32Stack.push(0);
                }
                i32Stack.push(isSome ? 1 : 0);
            },
            lift: () => {
                const isSome = i32Stack.pop();
                let optional;
                if (isSome) {
                    const int = i32Stack.pop();
                    optional = int;
                } else {
                    optional = null;
                }
                const string = strStack.pop();
                const string1 = strStack.pop();
                return { street: string1, city: string, zipCode: optional };
            }
        });
    };
    const __bjs_createPersonHelpers = () => {
        return () => ({
            lower: (value) => {
                const bytes = textEncoder.encode(value.name);
                const id = swift.memory.retain(bytes);
                i32Stack.push(bytes.length);
                i32Stack.push(id);
                i32Stack.push((value.age | 0));
                structHelpers.Address.lower(value.address);
                const isSome = value.email != null;
                let id1;
                if (isSome) {
                    const bytes1 = textEncoder.encode(value.email);
                    id1 = swift.memory.retain(bytes1);
                    i32Stack.push(bytes1.length);
                    i32Stack.push(id1);
                } else {
                    i32Stack.push(0);
                    i32Stack.push(0);
                }
                i32Stack.push(isSome ? 1 : 0);
            },
            lift: () => {
                const isSome = i32Stack.pop();
                let optional;
                if (isSome) {
                    const string = strStack.pop();
                    optional = string;
                } else {
                    optional = null;
                }
                const struct = structHelpers.Address.lift();
                const int = i32Stack.pop();
                const string1 = strStack.pop();
                return { name: string1, age: int, address: struct, email: optional };
            }
        });
    };
    const __bjs_createSessionHelpers = () => {
        return () => ({
            lower: (value) => {
                i32Stack.push((value.id | 0));
                ptrStack.push(value.owner.pointer);
            },
            lift: () => {
                const ptr = ptrStack.pop();
                const obj = _exports['Greeter'].__construct(ptr);
                const int = i32Stack.pop();
                return { id: int, owner: obj };
            }
        });
    };
    const __bjs_createMeasurementHelpers = () => {
        return () => ({
            lower: (value) => {
                f64Stack.push(value.value);
                f32Stack.push(Math.fround(value.precision));
                const isSome = value.optionalPrecision != null;
                if (isSome) {
                    f32Stack.push(Math.fround(value.optionalPrecision));
                } else {
                    f32Stack.push(0.0);
                }
                i32Stack.push(isSome ? 1 : 0);
            },
            lift: () => {
                const isSome = i32Stack.pop();
                let optional;
                if (isSome) {
                    const rawValue = f32Stack.pop();
                    optional = rawValue;
                } else {
                    optional = null;
                }
                const rawValue1 = f32Stack.pop();
                const f64 = f64Stack.pop();
                return { value: f64, precision: rawValue1, optionalPrecision: optional };
            }
        });
    };
    const __bjs_createConfigStructHelpers = () => {
        return () => ({
            lower: (value) => {
            },
            lift: () => {
                return {  };
            }
        });
    };
    const __bjs_createContainerHelpers = () => {
        return () => ({
            lower: (value) => {
                let id;
                if (value.object != null) {
                    id = swift.memory.retain(value.object);
                } else {
                    id = undefined;
                }
                i32Stack.push(id !== undefined ? id : 0);
                const isSome = value.optionalObject != null;
                let id1;
                if (isSome) {
                    id1 = swift.memory.retain(value.optionalObject);
                    i32Stack.push(id1);
                } else {
                    id1 = undefined;
                    i32Stack.push(0);
                }
                i32Stack.push(isSome ? 1 : 0);
            },
            lift: () => {
                const isSome = i32Stack.pop();
                let optional;
                if (isSome) {
                    const objectId = i32Stack.pop();
                    let value;
                    if (objectId !== 0) {
                        value = swift.memory.getObject(objectId);
                        swift.memory.release(objectId);
                    } else {
                        value = null;
                    }
                    optional = value;
                } else {
                    optional = null;
                }
                const objectId1 = i32Stack.pop();
                let value1;
                if (objectId1 !== 0) {
                    value1 = swift.memory.getObject(objectId1);
                    swift.memory.release(objectId1);
                } else {
                    value1 = null;
                }
                return { object: value1, optionalObject: optional };
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
                swift.memory.release(sourceId);
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
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                const value = textDecoder.decode(bytes);
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
            bjs["swift_js_struct_lower_DataPoint"] = function(objectId) {
                structHelpers.DataPoint.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_DataPoint"] = function() {
                const value = structHelpers.DataPoint.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Address"] = function(objectId) {
                structHelpers.Address.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Address"] = function() {
                const value = structHelpers.Address.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Person"] = function(objectId) {
                structHelpers.Person.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Person"] = function() {
                const value = structHelpers.Person.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Session"] = function(objectId) {
                structHelpers.Session.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Session"] = function() {
                const value = structHelpers.Session.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Measurement"] = function(objectId) {
                structHelpers.Measurement.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Measurement"] = function() {
                const value = structHelpers.Measurement.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_ConfigStruct"] = function(objectId) {
                structHelpers.ConfigStruct.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_ConfigStruct"] = function() {
                const value = structHelpers.ConfigStruct.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Container"] = function(objectId) {
                structHelpers.Container.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Container"] = function() {
                const value = structHelpers.Container.lift();
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
            bjs["swift_js_closure_unregister"] = function(funcRef) {}
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Greeter_wrap"] = function(pointer) {
                const obj = _exports['Greeter'].__construct(pointer);
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
            const swiftHeapObjectFinalizationRegistry = (typeof FinalizationRegistry === "undefined") ? { register: () => {}, unregister: () => {} } : new FinalizationRegistry((state) => {
                if (state.hasReleased) {
                    return;
                }
                state.hasReleased = true;
                try {
                    state.deinit(state.pointer);
                } catch {}
            });

            /// Represents a Swift heap object like a class instance or an actor instance.
            class SwiftHeapObject {
                static __wrap(pointer, deinit, prototype) {
                    const obj = Object.create(prototype);
                    const state = { pointer, deinit, hasReleased: false };
                    obj.pointer = pointer;
                    obj.__swiftHeapObjectState = state;
                    swiftHeapObjectFinalizationRegistry.register(obj, state, state);
                    return obj;
                }

                release() {
                    const state = this.__swiftHeapObjectState;
                    if (state.hasReleased) {
                        return;
                    }
                    state.hasReleased = true;
                    swiftHeapObjectFinalizationRegistry.unregister(state);
                    try {
                        state.deinit(state.pointer);
                    } catch {}
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
                }
            }
            const DataPointHelpers = __bjs_createDataPointHelpers()();
            structHelpers.DataPoint = DataPointHelpers;

            const AddressHelpers = __bjs_createAddressHelpers()();
            structHelpers.Address = AddressHelpers;

            const PersonHelpers = __bjs_createPersonHelpers()();
            structHelpers.Person = PersonHelpers;

            const SessionHelpers = __bjs_createSessionHelpers()();
            structHelpers.Session = SessionHelpers;

            const MeasurementHelpers = __bjs_createMeasurementHelpers()();
            structHelpers.Measurement = MeasurementHelpers;

            const ConfigStructHelpers = __bjs_createConfigStructHelpers()();
            structHelpers.ConfigStruct = ConfigStructHelpers;

            const ContainerHelpers = __bjs_createContainerHelpers()();
            structHelpers.Container = ContainerHelpers;

            const exports = {
                Greeter,
                roundtrip: function bjs_roundtrip(session) {
                    structHelpers.Person.lower(session);
                    instance.exports.bjs_roundtrip();
                    const structValue = structHelpers.Person.lift();
                    return structValue;
                },
                roundtripContainer: function bjs_roundtripContainer(container) {
                    structHelpers.Container.lower(container);
                    instance.exports.bjs_roundtripContainer();
                    const structValue = structHelpers.Container.lift();
                    return structValue;
                },
                Precision: PrecisionValues,
                DataPoint: {
                    init: function(x, y, label, optCount, optFlag) {
                        const labelBytes = textEncoder.encode(label);
                        const labelId = swift.memory.retain(labelBytes);
                        const isSome = optCount != null;
                        const isSome1 = optFlag != null;
                        instance.exports.bjs_DataPoint_init(x, y, labelId, labelBytes.length, +isSome, isSome ? optCount : 0, +isSome1, isSome1 ? optFlag : 0);
                        const structValue = structHelpers.DataPoint.lift();
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