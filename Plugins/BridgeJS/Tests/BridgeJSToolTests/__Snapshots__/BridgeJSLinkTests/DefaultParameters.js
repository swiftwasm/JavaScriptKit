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
    let strStack = [];
    let i32Stack = [];
    let f32Stack = [];
    let f64Stack = [];
    let ptrStack = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    const __bjs_createConfigHelpers = () => ({
        lower: (value) => {
            const bytes = textEncoder.encode(value.name);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
            i32Stack.push((value.value | 0));
            i32Stack.push(value.enabled ? 1 : 0);
        },
        lift: () => {
            const bool = i32Stack.pop() !== 0;
            const int = i32Stack.pop();
            const string = strStack.pop();
            return { name: string, value: int, enabled: bool };
        }
    });
    const __bjs_createMathOperationsHelpers = () => ({
        lower: (value) => {
            f64Stack.push(value.baseValue);
        },
        lift: () => {
            const f64 = f64Stack.pop();
            const instance1 = { baseValue: f64 };
            instance1.add = function(a, b = 10.0) {
                structHelpers.MathOperations.lower(this);
                const ret = instance.exports.bjs_MathOperations_add(a, b);
                return ret;
            }.bind(instance1);
            instance1.multiply = function(a, b) {
                structHelpers.MathOperations.lower(this);
                const ret = instance.exports.bjs_MathOperations_multiply(a, b);
                return ret;
            }.bind(instance1);
            return instance1;
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
            bjs["swift_js_struct_lower_Config"] = function(objectId) {
                structHelpers.Config.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Config"] = function() {
                const value = structHelpers.Config.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_MathOperations"] = function(objectId) {
                structHelpers.MathOperations.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_MathOperations"] = function() {
                const value = structHelpers.MathOperations.lift();
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
            importObject["TestModule"]["bjs_ConstructorDefaults_wrap"] = function(pointer) {
                const obj = _exports['ConstructorDefaults'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_DefaultGreeter_wrap"] = function(pointer) {
                const obj = _exports['DefaultGreeter'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_EmptyGreeter_wrap"] = function(pointer) {
                const obj = _exports['EmptyGreeter'].__construct(pointer);
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
                state.deinit(state.pointer);
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
                    state.deinit(state.pointer);
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
                    let result, result1;
                    if (isSome) {
                        const tagBytes = textEncoder.encode(tag);
                        const tagId = swift.memory.retain(tagBytes);
                        result = tagId;
                        result1 = tagBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    const ret = instance.exports.bjs_ConstructorDefaults_init(nameId, nameBytes.length, count, enabled, status, +isSome, result, result1);
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
                    let result, result1;
                    if (isSome) {
                        const valueBytes = textEncoder.encode(value);
                        const valueId = swift.memory.retain(valueBytes);
                        result = valueId;
                        result1 = valueBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_ConstructorDefaults_tag_set(this.pointer, +isSome, result, result1);
                }
            }
            const ConfigHelpers = __bjs_createConfigHelpers();
            structHelpers.Config = ConfigHelpers;

            const MathOperationsHelpers = __bjs_createMathOperationsHelpers();
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
                    let result, result1;
                    if (isSome) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        result = nameId;
                        result1 = nameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_testOptionalDefault(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                testOptionalStringDefault: function bjs_testOptionalStringDefault(greeting = "Hi") {
                    const isSome = greeting != null;
                    let result, result1;
                    if (isSome) {
                        const greetingBytes = textEncoder.encode(greeting);
                        const greetingId = swift.memory.retain(greetingBytes);
                        result = greetingId;
                        result1 = greetingBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    instance.exports.bjs_testOptionalStringDefault(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                testMultipleDefaults: function bjs_testMultipleDefaults(title = "Default Title", count = 10, enabled = false) {
                    const titleBytes = textEncoder.encode(title);
                    const titleId = swift.memory.retain(titleBytes);
                    instance.exports.bjs_testMultipleDefaults(titleId, titleBytes.length, count, enabled);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
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
                    if (isSome) {
                        structHelpers.Config.lower(point);
                    }
                    i32Stack.push(+isSome);
                    instance.exports.bjs_testOptionalStructDefault();
                    const isSome1 = i32Stack.pop();
                    const optResult = isSome1 ? structHelpers.Config.lift() : null;
                    return optResult;
                },
                testOptionalStructWithValueDefault: function bjs_testOptionalStructWithValueDefault(point = { name: "default", value: 42, enabled: true }) {
                    const isSome = point != null;
                    if (isSome) {
                        structHelpers.Config.lower(point);
                    }
                    i32Stack.push(+isSome);
                    instance.exports.bjs_testOptionalStructWithValueDefault();
                    const isSome1 = i32Stack.pop();
                    const optResult = isSome1 ? structHelpers.Config.lift() : null;
                    return optResult;
                },
                testIntArrayDefault: function bjs_testIntArrayDefault(values = [1, 2, 3]) {
                    for (const elem of values) {
                        i32Stack.push((elem | 0));
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_testIntArrayDefault();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const int = i32Stack.pop();
                        arrayResult.push(int);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                testStringArrayDefault: function bjs_testStringArrayDefault(names = ["a", "b", "c"]) {
                    for (const elem of names) {
                        const bytes = textEncoder.encode(elem);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                    }
                    i32Stack.push(names.length);
                    instance.exports.bjs_testStringArrayDefault();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const string = strStack.pop();
                        arrayResult.push(string);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                testDoubleArrayDefault: function bjs_testDoubleArrayDefault(values = [1.5, 2.5, 3.5]) {
                    for (const elem of values) {
                        f64Stack.push(elem);
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_testDoubleArrayDefault();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const f64 = f64Stack.pop();
                        arrayResult.push(f64);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                testBoolArrayDefault: function bjs_testBoolArrayDefault(flags = [true, false, true]) {
                    for (const elem of flags) {
                        i32Stack.push(elem ? 1 : 0);
                    }
                    i32Stack.push(flags.length);
                    instance.exports.bjs_testBoolArrayDefault();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const bool = i32Stack.pop() !== 0;
                        arrayResult.push(bool);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                testEmptyArrayDefault: function bjs_testEmptyArrayDefault(items = []) {
                    for (const elem of items) {
                        i32Stack.push((elem | 0));
                    }
                    i32Stack.push(items.length);
                    instance.exports.bjs_testEmptyArrayDefault();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const int = i32Stack.pop();
                        arrayResult.push(int);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                testMixedWithArrayDefault: function bjs_testMixedWithArrayDefault(name = "test", values = [10, 20, 30], enabled = true) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    for (const elem of values) {
                        i32Stack.push((elem | 0));
                    }
                    i32Stack.push(values.length);
                    instance.exports.bjs_testMixedWithArrayDefault(nameId, nameBytes.length, enabled);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                Status: StatusValues,
                MathOperations: {
                    init: function(baseValue = 0.0) {
                        instance.exports.bjs_MathOperations_init(baseValue);
                        const structValue = structHelpers.MathOperations.lift();
                        return structValue;
                    },
                    subtract: function(a, b = 5.0) {
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