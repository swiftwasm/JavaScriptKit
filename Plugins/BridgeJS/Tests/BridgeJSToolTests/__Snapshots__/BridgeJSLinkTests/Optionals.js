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
    let tmpStructCleanups = [];
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
            bjs["swift_js_struct_cleanup"] = function(cleanupId) {
                if (cleanupId === 0) { return; }
                const index = (cleanupId | 0) - 1;
                const cleanup = tmpStructCleanups[index];
                tmpStructCleanups[index] = null;
                if (cleanup) { cleanup(); }
                while (tmpStructCleanups.length > 0 && tmpStructCleanups[tmpStructCleanups.length - 1] == null) {
                    tmpStructCleanups.pop();
                }
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
                const obj = Greeter.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_OptionalPropertyHolder_wrap"] = function(pointer) {
                const obj = OptionalPropertyHolder.__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_WithOptionalJSClass_init"] = function bjs_WithOptionalJSClass_init(valueOrNullIsSome, valueOrNullWrappedValue, valueOrUndefinedIsSome, valueOrUndefinedWrappedValue) {
                try {
                    let obj;
                    if (valueOrNullIsSome) {
                        obj = swift.memory.getObject(valueOrNullWrappedValue);
                        swift.memory.release(valueOrNullWrappedValue);
                    }
                    let obj1;
                    if (valueOrUndefinedIsSome) {
                        obj1 = swift.memory.getObject(valueOrUndefinedWrappedValue);
                        swift.memory.release(valueOrUndefinedWrappedValue);
                    }
                    return swift.memory.retain(new imports.WithOptionalJSClass(valueOrNullIsSome ? obj : null, valueOrUndefinedIsSome ? obj1 : undefined));
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrNull_get"] = function bjs_WithOptionalJSClass_stringOrNull_get(self) {
                try {
                    let ret = swift.memory.getObject(self).stringOrNull;
                    const isSome = ret != null;
                    if (isSome) {
                        tmpRetString = ret;
                    } else {
                        tmpRetString = null;
                    }
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrUndefined_get"] = function bjs_WithOptionalJSClass_stringOrUndefined_get(self) {
                try {
                    let ret = swift.memory.getObject(self).stringOrUndefined;
                    const isSome = ret !== undefined;
                    if (isSome) {
                        tmpRetString = ret;
                    } else {
                        tmpRetString = null;
                    }
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
            TestModule["bjs_WithOptionalJSClass_stringOrNull_set"] = function bjs_WithOptionalJSClass_stringOrNull_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    let obj;
                    if (newValueIsSome) {
                        obj = swift.memory.getObject(newValueWrappedValue);
                        swift.memory.release(newValueWrappedValue);
                    }
                    swift.memory.getObject(self).stringOrNull = newValueIsSome ? obj : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_stringOrUndefined_set"] = function bjs_WithOptionalJSClass_stringOrUndefined_set(self, newValueIsSome, newValueWrappedValue) {
                try {
                    let obj;
                    if (newValueIsSome) {
                        obj = swift.memory.getObject(newValueWrappedValue);
                        swift.memory.release(newValueWrappedValue);
                    }
                    swift.memory.getObject(self).stringOrUndefined = newValueIsSome ? obj : undefined;
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
            TestModule["bjs_WithOptionalJSClass_roundTripStringOrNull"] = function bjs_WithOptionalJSClass_roundTripStringOrNull(self, valueIsSome, valueWrappedValue) {
                try {
                    let obj;
                    if (valueIsSome) {
                        obj = swift.memory.getObject(valueWrappedValue);
                        swift.memory.release(valueWrappedValue);
                    }
                    let ret = swift.memory.getObject(self).roundTripStringOrNull(valueIsSome ? obj : null);
                    const isSome = ret != null;
                    if (isSome) {
                        tmpRetString = ret;
                    } else {
                        tmpRetString = null;
                    }
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WithOptionalJSClass_roundTripStringOrUndefined"] = function bjs_WithOptionalJSClass_roundTripStringOrUndefined(self, valueIsSome, valueWrappedValue) {
                try {
                    let obj;
                    if (valueIsSome) {
                        obj = swift.memory.getObject(valueWrappedValue);
                        swift.memory.release(valueWrappedValue);
                    }
                    let ret = swift.memory.getObject(self).roundTripStringOrUndefined(valueIsSome ? obj : undefined);
                    const isSome = ret !== undefined;
                    if (isSome) {
                        tmpRetString = ret;
                    } else {
                        tmpRetString = null;
                    }
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
                    const isSome = name != null;
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    const ret = instance.exports.bjs_Greeter_init(+isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
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
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    instance.exports.bjs_Greeter_changeName(this.pointer, +isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
                }
                get name() {
                    instance.exports.bjs_Greeter_name_get(this.pointer);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                set name(value) {
                    const isSome = value != null;
                    let valueId, valueBytes;
                    if (isSome) {
                        valueBytes = textEncoder.encode(value);
                        valueId = swift.memory.retain(valueBytes);
                    }
                    instance.exports.bjs_Greeter_name_set(this.pointer, +isSome, isSome ? valueId : 0, isSome ? valueBytes.length : 0);
                    if (valueId != undefined) {
                        swift.memory.release(valueId);
                    }
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
                    let valueId, valueBytes;
                    if (isSome) {
                        valueBytes = textEncoder.encode(value);
                        valueId = swift.memory.retain(valueBytes);
                    }
                    instance.exports.bjs_OptionalPropertyHolder_optionalName_set(this.pointer, +isSome, isSome ? valueId : 0, isSome ? valueBytes.length : 0);
                    if (valueId != undefined) {
                        swift.memory.release(valueId);
                    }
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
                    instance.exports.bjs_OptionalPropertyHolder_optionalGreeter_set(this.pointer, +isSome, isSome ? value.pointer : 0);
                }
            }
            const exports = {
                Greeter,
                OptionalPropertyHolder,
                roundTripOptionalClass: function bjs_roundTripOptionalClass(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripOptionalClass(+isSome, isSome ? value.pointer : 0);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : Greeter.__construct(pointer);
                    return optResult;
                },
                testOptionalPropertyRoundtrip: function bjs_testOptionalPropertyRoundtrip(holder) {
                    const isSome = holder != null;
                    instance.exports.bjs_testOptionalPropertyRoundtrip(+isSome, isSome ? holder.pointer : 0);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : OptionalPropertyHolder.__construct(pointer);
                    return optResult;
                },
                roundTripString: function bjs_roundTripString(name) {
                    const isSome = name != null;
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    instance.exports.bjs_roundTripString(+isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
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
                    instance.exports.bjs_roundTripBool(+isSome, isSome ? flag : 0);
                    const optResult = tmpRetOptionalBool;
                    tmpRetOptionalBool = undefined;
                    return optResult;
                },
                roundTripFloat: function bjs_roundTripFloat(number) {
                    const isSome = number != null;
                    instance.exports.bjs_roundTripFloat(+isSome, isSome ? number : 0);
                    const optResult = tmpRetOptionalFloat;
                    tmpRetOptionalFloat = undefined;
                    return optResult;
                },
                roundTripDouble: function bjs_roundTripDouble(precision) {
                    const isSome = precision != null;
                    instance.exports.bjs_roundTripDouble(+isSome, isSome ? precision : 0);
                    const optResult = tmpRetOptionalDouble;
                    tmpRetOptionalDouble = undefined;
                    return optResult;
                },
                roundTripSyntax: function bjs_roundTripSyntax(name) {
                    const isSome = name != null;
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    instance.exports.bjs_roundTripSyntax(+isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
                    return optResult;
                },
                roundTripMixSyntax: function bjs_roundTripMixSyntax(name) {
                    const isSome = name != null;
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    instance.exports.bjs_roundTripMixSyntax(+isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
                    return optResult;
                },
                roundTripSwiftSyntax: function bjs_roundTripSwiftSyntax(name) {
                    const isSome = name != null;
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    instance.exports.bjs_roundTripSwiftSyntax(+isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
                    return optResult;
                },
                roundTripMixedSwiftSyntax: function bjs_roundTripMixedSwiftSyntax(name) {
                    const isSome = name != null;
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    instance.exports.bjs_roundTripMixedSwiftSyntax(+isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
                    return optResult;
                },
                roundTripWithSpaces: function bjs_roundTripWithSpaces(value) {
                    const isSome = value != null;
                    instance.exports.bjs_roundTripWithSpaces(+isSome, isSome ? value : 0);
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
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    instance.exports.bjs_roundTripOptionalAlias(+isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
                    return optResult;
                },
                testMixedOptionals: function bjs_testMixedOptionals(firstName, lastName, age, active) {
                    const isSome = firstName != null;
                    let firstNameId, firstNameBytes;
                    if (isSome) {
                        firstNameBytes = textEncoder.encode(firstName);
                        firstNameId = swift.memory.retain(firstNameBytes);
                    }
                    const isSome1 = lastName != null;
                    let lastNameId, lastNameBytes;
                    if (isSome1) {
                        lastNameBytes = textEncoder.encode(lastName);
                        lastNameId = swift.memory.retain(lastNameBytes);
                    }
                    const isSome2 = age != null;
                    instance.exports.bjs_testMixedOptionals(+isSome, isSome ? firstNameId : 0, isSome ? firstNameBytes.length : 0, +isSome1, isSome1 ? lastNameId : 0, isSome1 ? lastNameBytes.length : 0, +isSome2, isSome2 ? age : 0, active);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (firstNameId != undefined) {
                        swift.memory.release(firstNameId);
                    }
                    if (lastNameId != undefined) {
                        swift.memory.release(lastNameId);
                    }
                    return optResult;
                },
            };
            _exports = exports;
            return exports;
        },
    }
}