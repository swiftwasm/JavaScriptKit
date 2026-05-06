// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

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
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    const __bjs_createValueWithBoxedFieldHelpers = () => ({
        lower: (value) => {
            ptrStack.push(value.payload.pointer);
            const bytes = textEncoder.encode(value.label);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
        },
        lift: () => {
            const string = strStack.pop();
            const ptr = ptrStack.pop();
            const obj = _exports['Hi'].__construct(ptr);
            return { payload: obj, label: string };
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
                const bytes = new Uint8Array(memory.buffer, bytesPtr);
                bytes.set(source);
            }
            bjs["swift_js_make_js_string"] = function(ptr, len) {
                return swift.memory.retain(decodeString(ptr, len));
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
            bjs["swift_js_struct_lower_ValueWithBoxedField"] = function(objectId) {
                structHelpers.ValueWithBoxedField.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_ValueWithBoxedField"] = function() {
                const value = structHelpers.ValueWithBoxedField.lift();
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
            class LargePayload extends SwiftHeapObject {
                copy() {
                    return LargePayload.__construct(instance.exports.bjs_LargePayload_copy(this.pointer));
                }

                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_LargePayload_deinit, LargePayload.prototype, null);
                }

                get largeContents() {
                    instance.exports.bjs_LargePayload_largeContents_get(this.pointer);
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const int = i32Stack.pop();
                        arrayResult.push(int);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                }
            }
            class Hi extends SwiftHeapObject {
                copy() {
                    return Hi.__construct(instance.exports.bjs_Hi_copy(this.pointer));
                }

                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Hi_deinit, Hi.prototype, null);
                }

                constructor(largeContents) {
                    for (const elem of largeContents) {
                        i32Stack.push((elem | 0));
                    }
                    i32Stack.push(largeContents.length);
                    const ret = instance.exports.bjs_Hi_init();
                    return Hi.__construct(ret);
                }
                summarize() {
                    instance.exports.bjs_Hi_summarize(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                appendingZero() {
                    const ret = instance.exports.bjs_Hi_appendingZero(this.pointer);
                    return Hi.__construct(ret);
                }
                get largeContents() {
                    instance.exports.bjs_Hi_largeContents_get(this.pointer);
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const int = i32Stack.pop();
                        arrayResult.push(int);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                }
            }
            class Container extends SwiftHeapObject {
                copy() {
                    return Container.__construct(instance.exports.bjs_Container_copy(this.pointer));
                }

                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Container_deinit, Container.prototype, null);
                }

                get payload() {
                    const ret = instance.exports.bjs_Container_payload_get(this.pointer);
                    return LargePayload.__construct(ret);
                }
            }
            class MutableBox extends SwiftHeapObject {
                copy() {
                    return MutableBox.__construct(instance.exports.bjs_MutableBox_copy(this.pointer));
                }

                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_MutableBox_deinit, MutableBox.prototype, null);
                }

                get counter() {
                    const ret = instance.exports.bjs_MutableBox_counter_get(this.pointer);
                    return ret;
                }
                set counter(value) {
                    instance.exports.bjs_MutableBox_counter_set(this.pointer, value);
                }
                get label() {
                    instance.exports.bjs_MutableBox_label_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
            }
            const ValueWithBoxedFieldHelpers = __bjs_createValueWithBoxedFieldHelpers();
            structHelpers.ValueWithBoxedField = ValueWithBoxedFieldHelpers;

            const exports = {
                LargePayload,
                Hi,
                Container,
                MutableBox,
                roundtripBoxed: function bjs_roundtripBoxed(p) {
                    const ret = instance.exports.bjs_roundtripBoxed(p.pointer);
                    return LargePayload.__construct(ret);
                },
                mayMakeHi: function bjs_mayMakeHi(flag) {
                    instance.exports.bjs_mayMakeHi(flag);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : Hi.__construct(pointer);
                    return optResult;
                },
                consumeBoxedArray: function bjs_consumeBoxedArray(items) {
                    for (const elem of items) {
                        ptrStack.push(elem.pointer);
                    }
                    i32Stack.push(items.length);
                    instance.exports.bjs_consumeBoxedArray();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const ptr = ptrStack.pop();
                        const obj = Hi.__construct(ptr);
                        arrayResult.push(obj);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
                consumeBoxedDictionary: function bjs_consumeBoxedDictionary(items) {
                    const entries = Object.entries(items);
                    for (const entry of entries) {
                        const [key, value] = entry;
                        const bytes = textEncoder.encode(key);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                        ptrStack.push(value.pointer);
                    }
                    i32Stack.push(entries.length);
                    instance.exports.bjs_consumeBoxedDictionary();
                    const dictLen = i32Stack.pop();
                    const dictResult = {};
                    for (let i = 0; i < dictLen; i++) {
                        const ptr = ptrStack.pop();
                        const obj = Hi.__construct(ptr);
                        const string = strStack.pop();
                        dictResult[string] = obj;
                    }
                    return dictResult;
                },
                optionalBoxedArray: function bjs_optionalBoxedArray(flag) {
                    instance.exports.bjs_optionalBoxedArray(flag);
                    const isSome = i32Stack.pop();
                    let optResult;
                    if (isSome) {
                        const arrayLen = i32Stack.pop();
                        const arrayResult = [];
                        for (let i = 0; i < arrayLen; i++) {
                            const ptr = ptrStack.pop();
                            const obj = Hi.__construct(ptr);
                            arrayResult.push(obj);
                        }
                        arrayResult.reverse();
                        optResult = arrayResult;
                    } else {
                        optResult = null;
                    }
                    return optResult;
                },
                arrayOfOptionalBoxed: function bjs_arrayOfOptionalBoxed(flag) {
                    instance.exports.bjs_arrayOfOptionalBoxed(flag);
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const isSome = i32Stack.pop();
                        let optValue;
                        if (isSome === 0) {
                            optValue = null;
                        } else {
                            const ptr = ptrStack.pop();
                            const obj = Hi.__construct(ptr);
                            optValue = obj;
                        }
                        arrayResult.push(optValue);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                },
            };
            _exports = exports;
            return exports;
        },
    }
}