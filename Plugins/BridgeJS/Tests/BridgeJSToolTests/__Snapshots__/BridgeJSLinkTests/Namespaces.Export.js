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
    return {
        /** @param {WebAssembly.Imports} importObject */
        addImports: (importObject) => {
            const bjs = {};
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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Greeter_wrap"] = function(pointer) {
                const obj = Greeter.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_Converter_wrap"] = function(pointer) {
                const obj = Converter.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_UUID_wrap"] = function(pointer) {
                const obj = UUID.__construct(pointer);
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
            }
            class Converter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Converter_deinit, Converter.prototype);
                }
                
                
                constructor() {
                    const ret = instance.exports.bjs_Converter_init();
                    return Converter.__construct(ret);
                }
                toString(value) {
                    instance.exports.bjs_Converter_toString(this.pointer, value);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
            }
            class UUID extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_UUID_deinit, UUID.prototype);
                }
                
                uuidString() {
                    instance.exports.bjs_UUID_uuidString(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
            }
            const exports = {
                Greeter,
                Converter,
                UUID,
                plainFunction: function bjs_plainFunction() {
                    instance.exports.bjs_plainFunction();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
                namespacedFunction: function bjs_namespacedFunction() {
                    instance.exports.bjs_namespacedFunction();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
            };

            if (typeof globalThis.MyModule === 'undefined') {
                globalThis.MyModule = {};
            }
            if (typeof globalThis.MyModule.Utils === 'undefined') {
                globalThis.MyModule.Utils = {};
            }
            if (typeof globalThis.Utils === 'undefined') {
                globalThis.Utils = {};
            }
            if (typeof globalThis.Utils.Converters === 'undefined') {
                globalThis.Utils.Converters = {};
            }
            if (typeof globalThis.__Swift === 'undefined') {
                globalThis.__Swift = {};
            }
            if (typeof globalThis.__Swift.Foundation === 'undefined') {
                globalThis.__Swift.Foundation = {};
            }
            globalThis.__Swift.Foundation.Greeter = exports.Greeter;
            globalThis.Utils.Converters.Converter = exports.Converter;
            globalThis.__Swift.Foundation.UUID = exports.UUID;
            globalThis.MyModule.Utils.namespacedFunction = exports.namespacedFunction;

            return exports;
        },
    }
}