// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const StatusValues = {
    Active: 0,
    Inactive: 1,
    Pending: 2,
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
    const structHelpers = {};
    
    let _exports = null;
    let bjs = null;
    const __bjs_createConfigHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                const bytes = textEncoder.encode(value.name);
                const id = swift.memory.retain(bytes);
                tmpParamInts.push(bytes.length);
                tmpParamInts.push(id);
                tmpParamInts.push((value.value | 0));
                tmpParamInts.push(value.enabled ? 1 : 0);
                const cleanup = () => {
                    swift.memory.release(id);
                };
                return { cleanup };
            },
            raise: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                const bool = tmpRetInts.pop() !== 0;
                const int = tmpRetInts.pop();
                const string = tmpRetStrings.pop();
                return { name: string, value: int, enabled: bool };
            }
        });
    };
    const __bjs_createMathOperationsHelpers = () => {
        return (tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers) => ({
            lower: (value) => {
                tmpParamF64s.push(value.baseValue);
                return { cleanup: undefined };
            },
            raise: (tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers) => {
                const f64 = tmpRetF64s.pop();
                const instance1 = { baseValue: f64 };
                instance1.add = function(a, b = 10.0) {
                    const { cleanup: structCleanup } = structHelpers.MathOperations.lower(this);
                    const ret = instance.exports.bjs_MathOperations_add(a, b);
                    if (structCleanup) { structCleanup(); }
                    return ret;
                }.bind(instance1);
                instance1.multiply = function(a, b) {
                    const { cleanup: structCleanup } = structHelpers.MathOperations.lower(this);
                    const ret = instance.exports.bjs_MathOperations_multiply(a, b);
                    if (structCleanup) { structCleanup(); }
                    return ret;
                }.bind(instance1);
                return instance1;
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
            importObject["TestModule"]["bjs_ConstructorDefaults_wrap"] = function(pointer) {
                const obj = ConstructorDefaults.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_DefaultGreeter_wrap"] = function(pointer) {
                const obj = DefaultGreeter.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_EmptyGreeter_wrap"] = function(pointer) {
                const obj = EmptyGreeter.__construct(pointer);
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
            class DefaultGreeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_DefaultGreeter_deinit, DefaultGreeter.prototype);
                }
            
                constructor(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_DefaultGreeter_init(nameId, nameBytes.length);
                    swift.memory.release(nameId);
                    return DefaultGreeter.__construct(ret);
                }
                get name() {
                    instance.exports.bjs_DefaultGreeter_name_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set name(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_DefaultGreeter_name_set(this.pointer, valueId, valueBytes.length);
                    swift.memory.release(valueId);
                }
            }
            class EmptyGreeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_EmptyGreeter_deinit, EmptyGreeter.prototype);
                }
            
                constructor() {
                    const ret = instance.exports.bjs_EmptyGreeter_init();
                    return EmptyGreeter.__construct(ret);
                }
            }
            class ConstructorDefaults extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_ConstructorDefaults_deinit, ConstructorDefaults.prototype);
                }
            
                constructor(name = "Default", count = 42, enabled = true, status = StatusValues.Active, tag = null) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const isSome = tag != null;
                    let tagId, tagBytes;
                    if (isSome) {
                        tagBytes = textEncoder.encode(tag);
                        tagId = swift.memory.retain(tagBytes);
                    }
                    const ret = instance.exports.bjs_ConstructorDefaults_init(nameId, nameBytes.length, count, enabled, status, +isSome, isSome ? tagId : 0, isSome ? tagBytes.length : 0);
                    swift.memory.release(nameId);
                    if (tagId != undefined) {
                        swift.memory.release(tagId);
                    }
                    return ConstructorDefaults.__construct(ret);
                }
                get name() {
                    instance.exports.bjs_ConstructorDefaults_name_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set name(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_ConstructorDefaults_name_set(this.pointer, valueId, valueBytes.length);
                    swift.memory.release(valueId);
                }
                get count() {
                    const ret = instance.exports.bjs_ConstructorDefaults_count_get(this.pointer);
                    return ret;
                }
                set count(value) {
                    instance.exports.bjs_ConstructorDefaults_count_set(this.pointer, value);
                }
                get enabled() {
                    const ret = instance.exports.bjs_ConstructorDefaults_enabled_get(this.pointer);
                    return ret !== 0;
                }
                set enabled(value) {
                    instance.exports.bjs_ConstructorDefaults_enabled_set(this.pointer, value);
                }
                get status() {
                    const ret = instance.exports.bjs_ConstructorDefaults_status_get(this.pointer);
                    return ret;
                }
                set status(value) {
                    instance.exports.bjs_ConstructorDefaults_status_set(this.pointer, value);
                }
                get tag() {
                    instance.exports.bjs_ConstructorDefaults_tag_get(this.pointer);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                set tag(value) {
                    const isSome = value != null;
                    let valueId, valueBytes;
                    if (isSome) {
                        valueBytes = textEncoder.encode(value);
                        valueId = swift.memory.retain(valueBytes);
                    }
                    instance.exports.bjs_ConstructorDefaults_tag_set(this.pointer, +isSome, isSome ? valueId : 0, isSome ? valueBytes.length : 0);
                    if (valueId != undefined) {
                        swift.memory.release(valueId);
                    }
                }
            }
            const ConfigHelpers = __bjs_createConfigHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.Config = ConfigHelpers;
            
            const MathOperationsHelpers = __bjs_createMathOperationsHelpers()(tmpParamInts, tmpParamF32s, tmpParamF64s, tmpParamPointers, tmpRetPointers, textEncoder, swift, enumHelpers);
            structHelpers.MathOperations = MathOperationsHelpers;
            
            const exports = {
                DefaultGreeter,
                EmptyGreeter,
                ConstructorDefaults,
                testStringDefault: function bjs_testStringDefault(message = "Hello World") {
                    const messageBytes = textEncoder.encode(message);
                    const messageId = swift.memory.retain(messageBytes);
                    instance.exports.bjs_testStringDefault(messageId, messageBytes.length);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    swift.memory.release(messageId);
                    return ret;
                },
                testNegativeIntDefault: function bjs_testNegativeIntDefault(value = -42) {
                    const ret = instance.exports.bjs_testNegativeIntDefault(value);
                    return ret;
                },
                testBoolDefault: function bjs_testBoolDefault(flag = true) {
                    const ret = instance.exports.bjs_testBoolDefault(flag);
                    return ret !== 0;
                },
                testNegativeFloatDefault: function bjs_testNegativeFloatDefault(temp = -273.15) {
                    const ret = instance.exports.bjs_testNegativeFloatDefault(temp);
                    return ret;
                },
                testDoubleDefault: function bjs_testDoubleDefault(precision = 2.718) {
                    const ret = instance.exports.bjs_testDoubleDefault(precision);
                    return ret;
                },
                testOptionalDefault: function bjs_testOptionalDefault(name = null) {
                    const isSome = name != null;
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    instance.exports.bjs_testOptionalDefault(+isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
                    return optResult;
                },
                testOptionalStringDefault: function bjs_testOptionalStringDefault(greeting = "Hi") {
                    const isSome = greeting != null;
                    let greetingId, greetingBytes;
                    if (isSome) {
                        greetingBytes = textEncoder.encode(greeting);
                        greetingId = swift.memory.retain(greetingBytes);
                    }
                    instance.exports.bjs_testOptionalStringDefault(+isSome, isSome ? greetingId : 0, isSome ? greetingBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (greetingId != undefined) {
                        swift.memory.release(greetingId);
                    }
                    return optResult;
                },
                testMultipleDefaults: function bjs_testMultipleDefaults(title = "Default Title", count = 10, enabled = false) {
                    const titleBytes = textEncoder.encode(title);
                    const titleId = swift.memory.retain(titleBytes);
                    instance.exports.bjs_testMultipleDefaults(titleId, titleBytes.length, count, enabled);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    swift.memory.release(titleId);
                    return ret;
                },
                testEnumDefault: function bjs_testEnumDefault(status = StatusValues.Active) {
                    const ret = instance.exports.bjs_testEnumDefault(status);
                    return ret;
                },
                testComplexInit: function bjs_testComplexInit(greeter = new DefaultGreeter("DefaultUser")) {
                    const ret = instance.exports.bjs_testComplexInit(greeter.pointer);
                    return DefaultGreeter.__construct(ret);
                },
                testEmptyInit: function bjs_testEmptyInit(greeter = new EmptyGreeter()) {
                    const ret = instance.exports.bjs_testEmptyInit(greeter.pointer);
                    return EmptyGreeter.__construct(ret);
                },
                testOptionalStructDefault: function bjs_testOptionalStructDefault(point = null) {
                    const isSome = point != null;
                    let pointCleanup;
                    if (isSome) {
                        const structResult = structHelpers.Config.lower(point);
                        pointCleanup = structResult.cleanup;
                    }
                    instance.exports.bjs_testOptionalStructDefault(+isSome);
                    const isSome1 = tmpRetInts.pop();
                    let optResult;
                    if (isSome1) {
                        optResult = structHelpers.Config.raise(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                    } else {
                        optResult = null;
                    }
                    if (pointCleanup) { pointCleanup(); }
                    return optResult;
                },
                testOptionalStructWithValueDefault: function bjs_testOptionalStructWithValueDefault(point = { name: "default", value: 42, enabled: true }) {
                    const isSome = point != null;
                    let pointCleanup;
                    if (isSome) {
                        const structResult = structHelpers.Config.lower(point);
                        pointCleanup = structResult.cleanup;
                    }
                    instance.exports.bjs_testOptionalStructWithValueDefault(+isSome);
                    const isSome1 = tmpRetInts.pop();
                    let optResult;
                    if (isSome1) {
                        optResult = structHelpers.Config.raise(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                    } else {
                        optResult = null;
                    }
                    if (pointCleanup) { pointCleanup(); }
                    return optResult;
                },
                Status: StatusValues,
                MathOperations: {
                    init: function(baseValue = 0.0) {
                        instance.exports.bjs_MathOperations_init(baseValue);
                        const structValue = structHelpers.MathOperations.raise(tmpRetStrings, tmpRetInts, tmpRetF32s, tmpRetF64s, tmpRetPointers);
                        return structValue;
                    },
                    subtract: function(a, b) {
                        const ret = instance.exports.bjs_MathOperations_static_subtract(a, b);
                        return ret;
                    },
                },
            };
            _exports = exports;
            return exports;
        },
    }
}