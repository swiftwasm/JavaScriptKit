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
                constructor(pointer, deinit) {
                    this.pointer = pointer;
                    this.hasReleased = false;
                    this.deinit = deinit;
                    this.registry = new FinalizationRegistry((pointer) => {
                        deinit(pointer);
                    });
                    this.registry.register(this, this.pointer);
                }
            
                release() {
                    this.registry.unregister(this);
                    this.deinit(this.pointer);
                }
            }
            class Greeter extends SwiftHeapObject {
                constructor(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_Greeter_init(nameId, nameBytes.length);
                    swift.memory.release(nameId);
                    super(ret, instance.exports.bjs_Greeter_deinit);
                }
                greet() {
                    instance.exports.bjs_Greeter_greet(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                changeName(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    instance.exports.bjs_Greeter_changeName(this.pointer, nameId, nameBytes.length);
                    swift.memory.release(nameId);
                }
            }
            class Converter extends SwiftHeapObject {
                constructor() {
                    const ret = instance.exports.bjs_Converter_init();
                    super(ret, instance.exports.bjs_Converter_deinit);
                }
                toString(value) {
                    instance.exports.bjs_Converter_toString(this.pointer, value);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
            }
            class UUID extends SwiftHeapObject {
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
            };

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

            return exports;
        },
    }
}