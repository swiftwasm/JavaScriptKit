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
    let decodeUTF8;
    const immortalStrings = new Map();
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

    let _exports = null;
    let bjs = null;

    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            bjs["swift_js_return_string"] = function(word0, word1, word2) {
                tmpRetString = decodeString(word0, word1, word2);
            }
            bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
                swift.memory.release(sourceId);
                const bytes = new Uint8Array(memory.buffer, bytesPtr >>> 0);
                bytes.set(source);
            }
            bjs["swift_js_make_js_string"] = function(word0, word1, word2) {
                return swift.memory.retain(decodeString(word0, word1, word2));
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
            bjs["swift_js_push_string"] = function(word0, word1, word2) {
                const value = decodeString(word0, word1, word2);
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
            bjs["bjs_core_register_type_handles"] = function() {};
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
            bjs["swift_js_return_optional_string"] = function(isSome, word0, word1, word2) {
                if (isSome === 0) {
                    tmpRetString = null;
                } else {
                    tmpRetString = decodeString(word0, word1, word2);
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
            importObject["TestModule"]["bjs_PropertyHolder_wrap"] = function(pointer) {
                const obj = _exports['PropertyHolder'].__construct(pointer);
                return swift.memory.retain(obj);
            };
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            decodeUTF8 = (ptr, len) => { const bytes = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0); return textDecoder.decode(bytes); }
            decodeString = (() => {
                const byteAt = (word0, word1, word2, i) => {
                    if (i < 4) return (word0 >>> (i * 8)) & 0xff;
                    if (i < 8) return (word1 >>> ((i - 4) * 8)) & 0xff;
                    if (i === 8) return word2 & 0xff;
                    return (word2 >>> 16) & 0xff;
                };
                const decodeSmallUTF8 = (word0, word1, word2, count) => {
                    let result = "";
                    let i = 0;
                    while (i < count) {
                        const b0 = byteAt(word0, word1, word2, i++);
                        let codePoint;
                        if (b0 < 0x80) {
                            codePoint = b0;
                        } else if (b0 < 0xe0) {
                            codePoint = ((b0 & 0x1f) << 6) | (byteAt(word0, word1, word2, i++) & 0x3f);
                        } else if (b0 < 0xf0) {
                            const b1 = byteAt(word0, word1, word2, i++);
                            const b2 = byteAt(word0, word1, word2, i++);
                            codePoint = ((b0 & 0x0f) << 12) | ((b1 & 0x3f) << 6) | (b2 & 0x3f);
                        } else {
                            const b1 = byteAt(word0, word1, word2, i++);
                            const b2 = byteAt(word0, word1, word2, i++);
                            const b3 = byteAt(word0, word1, word2, i++);
                            codePoint = ((b0 & 0x07) << 18) | ((b1 & 0x3f) << 12) | ((b2 & 0x3f) << 6) | (b3 & 0x3f);
                        }
                        result += String.fromCodePoint(codePoint);
                    }
                    return result;
                };
                const decodeSmall = (word0, word1, word2) => {
                    const count = (word2 >>> 8) & 0x0f;
                    if ((word2 & 0x4000 /* ASCII */) === 0) return decodeSmallUTF8(word0, word1, word2, count);
                    const char = String.fromCharCode;
                    switch (count) {
                        case 0: return "";
                        case 1: return char(word0 & 0xff);
                        case 2: return char(word0 & 0xff, (word0 >>> 8) & 0xff);
                        case 3: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff);
                        case 4: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24);
                        case 5: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24, word1 & 0xff);
                        case 6: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24, word1 & 0xff, (word1 >>> 8) & 0xff);
                        case 7: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24, word1 & 0xff, (word1 >>> 8) & 0xff, (word1 >>> 16) & 0xff);
                        case 8: return char(word0 & 0xff, (word0 >>> 8) & 0xff, (word0 >>> 16) & 0xff, word0 >>> 24, word1 & 0xff, (word1 >>> 8) & 0xff, (word1 >>> 16) & 0xff, word1 >>> 24);
                        default: return decodeSmallUTF8(word0, word1, word2, count);
                    }
                };
                return (word0, word1, word2) => {
                    if (word2 & 0x2000 /* small */) return decodeSmall(word0, word1, word2);
                    const ptr = (word1 + 20 /* nativeBias */) >>> 0;
                    const len = word0 >>> 0;
                    if ((word2 & 0x8000 /* immortal */) === 0 || len >= 0x200000 /* 2^21 Number key */) return decodeUTF8(ptr, len);
                    const key = ptr + len * 0x100000000;
                    const cached = immortalStrings.get(key);
                    if (cached !== undefined) return cached;
                    const value = decodeUTF8(ptr, len);
                    immortalStrings.set(key, value);
                    return value;
                };
            })();

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
            class PropertyHolder extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_PropertyHolder_deinit, PropertyHolder.prototype, null);
                }

                constructor(intValue, floatValue, doubleValue, boolValue, stringValue, jsObject) {
                    const stringValueBytes = textEncoder.encode(stringValue);
                    const stringValueId = swift.memory.retain(stringValueBytes);
                    const ret = instance.exports.bjs_PropertyHolder_init(intValue, floatValue, doubleValue, boolValue, stringValueId, stringValueBytes.length, swift.memory.retain(jsObject));
                    return PropertyHolder.__construct(ret);
                }
                getAllValues() {
                    instance.exports.bjs_PropertyHolder_getAllValues(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                get intValue() {
                    const ret = instance.exports.bjs_PropertyHolder_intValue_get(this.pointer);
                    return ret;
                }
                set intValue(value) {
                    instance.exports.bjs_PropertyHolder_intValue_set(this.pointer, value);
                }
                get floatValue() {
                    const ret = instance.exports.bjs_PropertyHolder_floatValue_get(this.pointer);
                    return ret;
                }
                set floatValue(value) {
                    instance.exports.bjs_PropertyHolder_floatValue_set(this.pointer, value);
                }
                get doubleValue() {
                    const ret = instance.exports.bjs_PropertyHolder_doubleValue_get(this.pointer);
                    return ret;
                }
                set doubleValue(value) {
                    instance.exports.bjs_PropertyHolder_doubleValue_set(this.pointer, value);
                }
                get boolValue() {
                    const ret = instance.exports.bjs_PropertyHolder_boolValue_get(this.pointer);
                    return ret !== 0;
                }
                set boolValue(value) {
                    instance.exports.bjs_PropertyHolder_boolValue_set(this.pointer, value);
                }
                get stringValue() {
                    instance.exports.bjs_PropertyHolder_stringValue_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set stringValue(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_PropertyHolder_stringValue_set(this.pointer, valueId, valueBytes.length);
                }
                get readonlyInt() {
                    const ret = instance.exports.bjs_PropertyHolder_readonlyInt_get(this.pointer);
                    return ret;
                }
                get readonlyFloat() {
                    const ret = instance.exports.bjs_PropertyHolder_readonlyFloat_get(this.pointer);
                    return ret;
                }
                get readonlyDouble() {
                    const ret = instance.exports.bjs_PropertyHolder_readonlyDouble_get(this.pointer);
                    return ret;
                }
                get readonlyBool() {
                    const ret = instance.exports.bjs_PropertyHolder_readonlyBool_get(this.pointer);
                    return ret !== 0;
                }
                get readonlyString() {
                    instance.exports.bjs_PropertyHolder_readonlyString_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                get jsObject() {
                    const ret = instance.exports.bjs_PropertyHolder_jsObject_get(this.pointer);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                }
                set jsObject(value) {
                    instance.exports.bjs_PropertyHolder_jsObject_set(this.pointer, swift.memory.retain(value));
                }
                get sibling() {
                    const ret = instance.exports.bjs_PropertyHolder_sibling_get(this.pointer);
                    return PropertyHolder.__construct(ret);
                }
                set sibling(value) {
                    instance.exports.bjs_PropertyHolder_sibling_set(this.pointer, value.pointer);
                }
                get lazyValue() {
                    instance.exports.bjs_PropertyHolder_lazyValue_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set lazyValue(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_PropertyHolder_lazyValue_set(this.pointer, valueId, valueBytes.length);
                }
                get computedReadonly() {
                    const ret = instance.exports.bjs_PropertyHolder_computedReadonly_get(this.pointer);
                    return ret;
                }
                get computedReadWrite() {
                    instance.exports.bjs_PropertyHolder_computedReadWrite_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set computedReadWrite(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_PropertyHolder_computedReadWrite_set(this.pointer, valueId, valueBytes.length);
                }
                get observedProperty() {
                    const ret = instance.exports.bjs_PropertyHolder_observedProperty_get(this.pointer);
                    return ret;
                }
                set observedProperty(value) {
                    instance.exports.bjs_PropertyHolder_observedProperty_set(this.pointer, value);
                }
            }
            const exports = {
                createPropertyHolder: function bjs_createPropertyHolder(intValue, floatValue, doubleValue, boolValue, stringValue, jsObject) {
                    const stringValueBytes = textEncoder.encode(stringValue);
                    const stringValueId = swift.memory.retain(stringValueBytes);
                    const ret = instance.exports.bjs_createPropertyHolder(intValue, floatValue, doubleValue, boolValue, stringValueId, stringValueBytes.length, swift.memory.retain(jsObject));
                    return PropertyHolder.__construct(ret);
                },
                testPropertyHolder: function bjs_testPropertyHolder(holder) {
                    instance.exports.bjs_testPropertyHolder(holder.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                PropertyHolder,
            };
            _exports = exports;
            return exports;
        },
    }
}