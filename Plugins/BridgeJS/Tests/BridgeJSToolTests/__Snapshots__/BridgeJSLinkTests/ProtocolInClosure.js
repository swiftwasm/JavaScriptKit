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
    const swiftClosureRegistry = (typeof FinalizationRegistry === "undefined") ? { register: () => {}, unregister: () => {} } : new FinalizationRegistry((state) => {
        if (state.unregistered) { return; }
        instance?.exports?.bjs_release_swift_closure(state.pointer);
    });
    const makeClosure = (pointer, file, line, func) => {
        const state = { pointer, file, line, unregistered: false };
        const real = (...args) => {
            if (state.unregistered) {
                const bytes = new Uint8Array(memory.buffer, state.file);
                let length = 0;
                while (bytes[length] !== 0) { length += 1; }
                const fileID = decodeString(state.file, length);
                throw new Error(`Attempted to call a released JSTypedClosure created at ${fileID}:${state.line}`);
            }
            return func(...args);
        };
        real.__unregister = () => {
            if (state.unregistered) { return; }
            state.unregistered = true;
            swiftClosureRegistry.unregister(state);
        };
        swiftClosureRegistry.register(real, state, state);
        return swift.memory.retain(real);
    };


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
            bjs["swift_js_closure_unregister"] = function(funcRef) {
                const func = swift.memory.getObject(funcRef);
                func.__unregister();
            }
            bjs["invoke_js_callback_TestModule_10TestModule10RenderableP_10RenderableP"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(swift.memory.getObject(param0));
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            bjs["make_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModule10RenderableP_10RenderableP = function(param0) {
                    const ret = instance.exports.invoke_swift_closure_TestModule_10TestModule10RenderableP_10RenderableP(boxPtr, swift.memory.retain(param0));
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret1;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModule10RenderableP_10RenderableP);
            }
            bjs["invoke_js_callback_TestModule_10TestModule10RenderableP_SS"] = function(callbackId, param0) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(swift.memory.getObject(param0));
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModule10RenderableP_SS"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModule10RenderableP_SS = function(param0) {
                    instance.exports.invoke_swift_closure_TestModule_10TestModule10RenderableP_SS(boxPtr, swift.memory.retain(param0));
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModule10RenderableP_SS);
            }
            bjs["invoke_js_callback_TestModule_10TestModuleSq10RenderableP_SS"] = function(callbackId, param0IsSome, param0ObjectId) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback(param0IsSome ? swift.memory.getObject(param0ObjectId) : null);
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuleSq10RenderableP_SS"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuleSq10RenderableP_SS = function(param0) {
                    const isSome = param0 != null;
                    let result;
                    if (isSome) {
                        result = swift.memory.retain(param0);
                    } else {
                        result = 0;
                    }
                    instance.exports.invoke_swift_closure_TestModule_10TestModuleSq10RenderableP_SS(boxPtr, +isSome, result);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuleSq10RenderableP_SS);
            }
            bjs["invoke_js_callback_TestModule_10TestModuley_10RenderableP"] = function(callbackId) {
                try {
                    const callback = swift.memory.getObject(callbackId);
                    let ret = callback();
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            bjs["make_swift_closure_TestModule_10TestModuley_10RenderableP"] = function(boxPtr, file, line) {
                const lower_closure_TestModule_10TestModuley_10RenderableP = function() {
                    const ret = instance.exports.invoke_swift_closure_TestModule_10TestModuley_10RenderableP(boxPtr);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return ret1;
                };
                return makeClosure(boxPtr, file, line, lower_closure_TestModule_10TestModuley_10RenderableP);
            }
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Widget_wrap"] = function(pointer) {
                const obj = _exports['Widget'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_Renderable_render"] = function bjs_Renderable_render(self) {
                try {
                    let ret = swift.memory.getObject(self).render();
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
            class Widget extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Widget_deinit, Widget.prototype);
                }

                constructor(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_Widget_init(nameId, nameBytes.length);
                    return Widget.__construct(ret);
                }
                get name() {
                    instance.exports.bjs_Widget_name_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set name(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_Widget_name_set(this.pointer, valueId, valueBytes.length);
                }
            }
            const exports = {
                Widget,
                processRenderable: function bjs_processRenderable(item, transform) {
                    const callbackId = swift.memory.retain(transform);
                    instance.exports.bjs_processRenderable(swift.memory.retain(item), callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                makeRenderableFactory: function bjs_makeRenderableFactory(defaultName) {
                    const defaultNameBytes = textEncoder.encode(defaultName);
                    const defaultNameId = swift.memory.retain(defaultNameBytes);
                    const ret = instance.exports.bjs_makeRenderableFactory(defaultNameId, defaultNameBytes.length);
                    return swift.memory.getObject(ret);
                },
                roundtripRenderable: function bjs_roundtripRenderable(callback) {
                    const callbackId = swift.memory.retain(callback);
                    const ret = instance.exports.bjs_roundtripRenderable(callbackId);
                    return swift.memory.getObject(ret);
                },
                processOptionalRenderable: function bjs_processOptionalRenderable(callback) {
                    const callbackId = swift.memory.retain(callback);
                    instance.exports.bjs_processOptionalRenderable(callbackId);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
            };
            _exports = exports;
            return exports;
        },
    }
}