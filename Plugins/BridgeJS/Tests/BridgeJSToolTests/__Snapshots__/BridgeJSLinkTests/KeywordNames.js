// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const TokenValues = {
    Tag: {
        Break: 0,
        Return: 1,
    },
};
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

    let _exports = null;
    let bjs = null;
    const __bjs_createRecordHelpers = () => ({
        lower: (value) => {
            i32Stack.push((value.case | 0));
            const bytes = textEncoder.encode(value.continue);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
        },
        lift: () => {
            const string = strStack.pop();
            const int = i32Stack.pop();
            const instance1 = { case: int, continue: string };
            instance1.as = function() {
                structHelpers.Record.lower(this);
                const ret = instance.exports.bjs_Record_as();
                const ret1 = tmpRetString;
                tmpRetString = undefined;
                return ret1;
            }.bind(instance1);
            return instance1;
        }
    });
    const __bjs_createTokenValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case TokenValues.Tag.Break: {
                    return TokenValues.Tag.Break;
                }
                case TokenValues.Tag.Return: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return TokenValues.Tag.Return;
                }
                default: throw new Error("Unknown TokenValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case TokenValues.Tag.Break: return { tag: TokenValues.Tag.Break };
                case TokenValues.Tag.Return: {
                    const string = strStack.pop();
                    return { tag: TokenValues.Tag.Return, param0: string };
                }
                default: throw new Error("Unknown TokenValues tag returned from Swift: " + String(tag));
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
            bjs["swift_js_struct_lower_Record"] = function(objectId) {
                structHelpers.Record.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Record"] = function() {
                const value = structHelpers.Record.lift();
                return swift.memory.retain(value);
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
            importObject["TestModule"]["bjs_Parser_wrap"] = function(pointer) {
                const obj = _exports['Parser'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_Observer_do_get"] = function bjs_Observer_do_get(self) {
                try {
                    let ret = swift.memory.getObject(self).do;
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_Observer_do_set"] = function bjs_Observer_do_set(self, value) {
                try {
                    swift.memory.getObject(self).do = value;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_Observer_for_get"] = function bjs_Observer_for_get(self) {
                try {
                    let ret = swift.memory.getObject(self).for;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_Observer_if"] = function bjs_Observer_if(self, value) {
                try {
                    let ret = swift.memory.getObject(self).if(value);
                    return ret ? 1 : 0;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_Observer_else"] = function bjs_Observer_else(self) {
                try {
                    let ret = swift.memory.getObject(self).else();
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
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
            class Parser extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Parser_deinit, Parser.prototype, null);
                }

                constructor(in) {
                    const ret = instance.exports.bjs_Parser_init(in);
                    return Parser.__construct(ret);
                }
                class() {
                    const ret = instance.exports.bjs_Parser_class(this.pointer);
                    return ret;
                }
                static where(value) {
                    const ret = instance.exports.bjs_Parser_static_where(value);
                    return ret;
                }
                get in() {
                    const ret = instance.exports.bjs_Parser_in_get(this.pointer);
                    return ret;
                }
                set in(value) {
                    instance.exports.bjs_Parser_in_set(this.pointer, value);
                }
                static get self() {
                    instance.exports.bjs_Parser_static_self_get();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
            }
            const RecordHelpers = __bjs_createRecordHelpers();
            structHelpers.Record = RecordHelpers;

            const TokenHelpers = __bjs_createTokenValuesHelpers();
            enumHelpers.Token = TokenHelpers;

            const exports = {
                default: function bjs_default() {
                    instance.exports.bjs_default();
                },
                delete: function bjs_delete(value) {
                    const ret = instance.exports.bjs_delete(value);
                    return ret;
                },
                Token: {
                    ...TokenValues,
                    switch: function(value) {
                        const ret = instance.exports.bjs_Token_static_switch(value);
                        return ret;
                    }
                },
                Parser,
                Record: {
                    init: function(case, continue) {
                        const continueBytes = textEncoder.encode(continue);
                        const continueId = swift.memory.retain(continueBytes);
                        instance.exports.bjs_Record_init(case, continueId, continueBytes.length);
                        const structValue = structHelpers.Record.lift();
                        return structValue;
                    },
                },
            };
            _exports = exports;
            return exports;
        },
    }
}