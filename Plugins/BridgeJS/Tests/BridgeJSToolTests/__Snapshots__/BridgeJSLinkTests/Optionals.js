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
    let strStack = [];
    let i32Stack = [];
    let f32Stack = [];
    let f64Stack = [];
    let ptrStack = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;

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
            importObject["TestModule"]["bjs_OptionalPropertyHolder_wrap"] = function(pointer) {
                const obj = _exports['OptionalPropertyHolder'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_WithOptionalJSClass_init"] = function bjs_WithOptionalJSClass_init(valueOrNullIsSome, valueOrNullObjectId, valueOrUndefinedIsSome, valueOrUndefinedObjectId) {
                try {
                    let optResult;
                    if (valueOrNullIsSome) {
                        const valueOrNullObjectIdObject = swift.memory.getObject(valueOrNullObjectId);
                        swift.memory.release(valueOrNullObjectId);
                        optResult = valueOrNullObjectIdObject;
                    } else {
                        optResult = null;
                    }
                    let optResult1;
                    if (valueOrUndefinedIsSome) {
                        const valueOrUndefinedObjectIdObject = swift.memory.getObject(valueOrUndefinedObjectId);
                        swift.memory.release(valueOrUndefinedObjectId);
                        optResult1 = valueOrUndefinedObjectIdObject;
                    } else {
                        optResult1 = undefined;
                    }
                    return swift.memory.retain(new imports.WithOptionalJSClass(optResult, optResult1));
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrNull_get"] = function bjs_WithOptionalJSClass_stringOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).stringOrNull;
                    const isSome = ret != null;
                    tmpRetString = isSome ? ret : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrUndefined_get"] = function bjs_WithOptionalJSClass_stringOrUndefined_get(self) {
                try {
                    let ret = swift.memory.getObject(self).stringOrUndefined;
                    const isSome = ret !== undefined;
                    tmpRetString = isSome ? ret : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_doubleOrNull_get"] = function bjs_WithOptionalJSClass_doubleOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).doubleOrNull;
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_double"](isSome ? 1 : 0, isSome ? ret : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_doubleOrUndefined_get"] = function bjs_WithOptionalJSClass_doubleOrUndefined_get(self) {
                try {
                    let ret = swift.memory.getObject(self).doubleOrUndefined;
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_double"](isSome ? 1 : 0, isSome ? ret : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_boolOrNull_get"] = function bjs_WithOptionalJSClass_boolOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).boolOrNull;
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_bool"](isSome ? 1 : 0, isSome ? (ret ? 1 : 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_boolOrUndefined_get"] = function bjs_WithOptionalJSClass_boolOrUndefined_get(self) {
                try {
                    let ret = swift.memory.getObject(self).boolOrUndefined;
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_bool"](isSome ? 1 : 0, isSome ? (ret ? 1 : 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_intOrNull_get"] = function bjs_WithOptionalJSClass_intOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).intOrNull;
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_intOrUndefined_get"] = function bjs_WithOptionalJSClass_intOrUndefined_get(self) {
                try {
                    let ret = swift.memory.getObject(self).intOrUndefined;
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrNull_set"] = function bjs_WithOptionalJSClass_stringOrNull_set(self, newValueIsSome, newValueObjectId) {
                try {
                    let optResult;
                    if (newValueIsSome) {
                        const newValueObjectIdObject = swift.memory.getObject(newValueObjectId);
                        swift.memory.release(newValueObjectId);
                        optResult = newValueObjectIdObject;
                    } else {
                        optResult = null;
                    }
                    swift.memory.getObject(self).stringOrNull = optResult;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrUndefined_set"] = function bjs_WithOptionalJSClass_stringOrUndefined_set(self, newValueIsSome, newValueObjectId) {
                try {
                    let optResult;
                    if (newValueIsSome) {
                        const newValueObjectIdObject = swift.memory.getObject(newValueObjectId);
                        swift.memory.release(newValueObjectId);
                        optResult = newValueObjectIdObject;
                    } else {
                        optResult = undefined;
                    }
                    swift.memory.getObject(self).stringOrUndefined = optResult;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_doubleOrNull_set"] = function bjs_WithOptionalJSClass_doubleOrNull_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).doubleOrNull = newValueIsSome ? newValueWrappedValue : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_doubleOrUndefined_set"] = function bjs_WithOptionalJSClass_doubleOrUndefined_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).doubleOrUndefined = newValueIsSome ? newValueWrappedValue : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_boolOrNull_set"] = function bjs_WithOptionalJSClass_boolOrNull_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).boolOrNull = newValueIsSome ? newValueWrappedValue !== 0 : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_boolOrUndefined_set"] = function bjs_WithOptionalJSClass_boolOrUndefined_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).boolOrUndefined = newValueIsSome ? newValueWrappedValue !== 0 : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_intOrNull_set"] = function bjs_WithOptionalJSClass_intOrNull_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).intOrNull = newValueIsSome ? newValueWrappedValue : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_intOrUndefined_set"] = function bjs_WithOptionalJSClass_intOrUndefined_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    swift.memory.getObject(self).intOrUndefined = newValueIsSome ? newValueWrappedValue : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripStringOrNull"] = function bjs_WithOptionalJSClass_roundTripStringOrNull(self, valueIsSome, valueObjectId) {
                try {
                    let optResult;
                    if (valueIsSome) {
                        const valueObjectIdObject = swift.memory.getObject(valueObjectId);
                        swift.memory.release(valueObjectId);
                        optResult = valueObjectIdObject;
                    } else {
                        optResult = null;
                    }
                    let ret = swift.memory.getObject(self).roundTripStringOrNull(optResult);
                    const isSome = ret != null;
                    tmpRetString = isSome ? ret : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripStringOrUndefined"] = function bjs_WithOptionalJSClass_roundTripStringOrUndefined(self, valueIsSome, valueObjectId) {
                try {
                    let optResult;
                    if (valueIsSome) {
                        const valueObjectIdObject = swift.memory.getObject(valueObjectId);
                        swift.memory.release(valueObjectId);
                        optResult = valueObjectIdObject;
                    } else {
                        optResult = undefined;
                    }
                    let ret = swift.memory.getObject(self).roundTripStringOrUndefined(optResult);
                    const isSome = ret !== undefined;
                    tmpRetString = isSome ? ret : undefined;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripDoubleOrNull"] = function bjs_WithOptionalJSClass_roundTripDoubleOrNull(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripDoubleOrNull(valueIsSome ? valueWrappedValue : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_double"](isSome ? 1 : 0, isSome ? ret : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripDoubleOrUndefined"] = function bjs_WithOptionalJSClass_roundTripDoubleOrUndefined(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripDoubleOrUndefined(valueIsSome ? valueWrappedValue : undefined);
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_double"](isSome ? 1 : 0, isSome ? ret : 0.0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripBoolOrNull"] = function bjs_WithOptionalJSClass_roundTripBoolOrNull(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripBoolOrNull(valueIsSome ? valueWrappedValue !== 0 : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_bool"](isSome ? 1 : 0, isSome ? (ret ? 1 : 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripBoolOrUndefined"] = function bjs_WithOptionalJSClass_roundTripBoolOrUndefined(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripBoolOrUndefined(valueIsSome ? valueWrappedValue !== 0 : undefined);
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_bool"](isSome ? 1 : 0, isSome ? (ret ? 1 : 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripIntOrNull"] = function bjs_WithOptionalJSClass_roundTripIntOrNull(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripIntOrNull(valueIsSome ? valueWrappedValue : null);
                    const isSome = ret != null;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripIntOrUndefined"] = function bjs_WithOptionalJSClass_roundTripIntOrUndefined(self, valueIsSome, valueWrappedValue) {
                try {
                    let ret = swift.memory.getObject(self).roundTripIntOrUndefined(valueIsSome ? valueWrappedValue : undefined);
                    const isSome = ret !== undefined;
                    bjs["swift_js_return_optional_int"](isSome ? 1 : 0, isSome ? (ret | 0) : 0);
                } catch (error) {
                    setException(error);
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
            class Greeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Greeter_deinit, Greeter.prototype);
                }

                constructor(name) {
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
                    const ret = instance.exports.bjs_Greeter_init(+isSome, result, result1);
                    return Greeter.__construct(ret);
                }
                greet() {
                    instance.exports.bjs_Greeter_greet(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                changeName(name) {
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
                    instance.exports.bjs_Greeter_changeName(this.pointer, +isSome, result, result1);
                }
                get name() {
                    instance.exports.bjs_Greeter_name_get(this.pointer);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                set name(value) {
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
                    instance.exports.bjs_Greeter_name_set(this.pointer, +isSome, result, result1);
                }
            }
            class OptionalPropertyHolder extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_OptionalPropertyHolder_deinit, OptionalPropertyHolder.prototype);
                }

                constructor() {
                    const ret = instance.exports.bjs_OptionalPropertyHolder_init();
                    return OptionalPropertyHolder.__construct(ret);
                }
                get optionalName() {
                    instance.exports.bjs_OptionalPropertyHolder_optionalName_get(this.pointer);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                set optionalName(value) {
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
                    instance.exports.bjs_OptionalPropertyHolder_optionalName_set(this.pointer, +isSome, result, result1);
                }
                get optionalAge() {
                    instance.exports.bjs_OptionalPropertyHolder_optionalAge_get(this.pointer);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                }
                set optionalAge(value) {
                    const isSome = value != null;
                    instance.exports.bjs_OptionalPropertyHolder_optionalAge_set(this.pointer, +isSome, isSome ? value : 0);
                }
                get optionalGreeter() {
                    instance.exports.bjs_OptionalPropertyHolder_optionalGreeter_get(this.pointer);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : Greeter.__construct(pointer);
                    return optResult;
                }
                set optionalGreeter(value) {
                    const isSome = value != null;
                    let result;
                    if (isSome) {
                        result = value.pointer;
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_OptionalPropertyHolder_optionalGreeter_set(this.pointer, +isSome, result);
                }
            }
            const exports = {
                Greeter,
                OptionalPropertyHolder,
                roundTripOptionalClass: function bjs_roundTripOptionalClass(value) {
                    const isSome = value != null;
                    let result;
                    if (isSome) {
                        result = value.pointer;
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_roundTripOptionalClass(+isSome, result);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : Greeter.__construct(pointer);
                    return optResult;
                },
                testOptionalPropertyRoundtrip: function bjs_testOptionalPropertyRoundtrip(holder) {
                    const isSome = holder != null;
                    let result;
                    if (isSome) {
                        result = holder.pointer;
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_testOptionalPropertyRoundtrip(+isSome, result);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : OptionalPropertyHolder.__construct(pointer);
                    return optResult;
                },
                roundTripString: function bjs_roundTripString(name) {
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
                    instance.exports.bjs_roundTripString(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripInt: function bjs_roundTripInt(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripInt(+isSome, isSome ? value : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripBool: function bjs_roundTripBool(flag) {
                    const isSome = flag != null;
                    instance.exports.bjs_roundTripBool(+isSome, isSome ? flag ? 1 : 0 : 0);
                    const optResult = tmpRetOptionalBool;
                    tmpRetOptionalBool = undefined;
                    return optResult;
                },
                roundTripFloat: function bjs_roundTripFloat(number) {
                    const isSome = number != null;
                    instance.exports.bjs_roundTripFloat(+isSome, isSome ? number : 0.0);
                    const optResult = tmpRetOptionalFloat;
                    tmpRetOptionalFloat = undefined;
                    return optResult;
                },
                roundTripDouble: function bjs_roundTripDouble(precision) {
                    const isSome = precision != null;
                    instance.exports.bjs_roundTripDouble(+isSome, isSome ? precision : 0.0);
                    const optResult = tmpRetOptionalDouble;
                    tmpRetOptionalDouble = undefined;
                    return optResult;
                },
                roundTripSyntax: function bjs_roundTripSyntax(name) {
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
                    instance.exports.bjs_roundTripSyntax(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripMixSyntax: function bjs_roundTripMixSyntax(name) {
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
                    instance.exports.bjs_roundTripMixSyntax(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripSwiftSyntax: function bjs_roundTripSwiftSyntax(name) {
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
                    instance.exports.bjs_roundTripSwiftSyntax(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripMixedSwiftSyntax: function bjs_roundTripMixedSwiftSyntax(name) {
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
                    instance.exports.bjs_roundTripMixedSwiftSyntax(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                roundTripWithSpaces: function bjs_roundTripWithSpaces(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripWithSpaces(+isSome, isSome ? value : 0.0);
                    const optResult = tmpRetOptionalDouble;
                    tmpRetOptionalDouble = undefined;
                    return optResult;
                },
                roundTripAlias: function bjs_roundTripAlias(age) {
                    const isSome = age != null;
                    instance.exports.bjs_roundTripAlias(+isSome, isSome ? age : 0);
                    const optResult = tmpRetOptionalInt;
                    tmpRetOptionalInt = undefined;
                    return optResult;
                },
                roundTripOptionalAlias: function bjs_roundTripOptionalAlias(name) {
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
                    instance.exports.bjs_roundTripOptionalAlias(+isSome, result, result1);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
                testMixedOptionals: function bjs_testMixedOptionals(firstName, lastName, age, active) {
                    const isSome = firstName != null;
                    let result, result1;
                    if (isSome) {
                        const firstNameBytes = textEncoder.encode(firstName);
                        const firstNameId = swift.memory.retain(firstNameBytes);
                        result = firstNameId;
                        result1 = firstNameBytes.length;
                    } else {
                        result = 0;
                        result1 = 0;
                    }
                    const isSome1 = lastName != null;
                    let result2, result3;
                    if (isSome1) {
                        const lastNameBytes = textEncoder.encode(lastName);
                        const lastNameId = swift.memory.retain(lastNameBytes);
                        result2 = lastNameId;
                        result3 = lastNameBytes.length;
                    } else {
                        result2 = 0;
                        result3 = 0;
                    }
                    const isSome2 = age != null;
                    instance.exports.bjs_testMixedOptionals(+isSome, result, result1, +isSome1, result2, result3, +isSome2, isSome2 ? age : 0, active);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                },
            };
            _exports = exports;
            return exports;
        },
    }
}