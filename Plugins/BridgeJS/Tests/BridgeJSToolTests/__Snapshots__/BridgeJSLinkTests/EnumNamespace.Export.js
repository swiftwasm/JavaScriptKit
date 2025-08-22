// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const Method = {
    Get: 0,
    Post: 1,
    Put: 2,
    Delete: 3,
};

export const LogLevel = {
    Debug: "debug",
    Info: "info",
    Warning: "warning",
    Error: "error",
};

export const Port = {
    Http: 80,
    Https: 443,
    Development: 3000,
};

export const SupportedMethod = {
    Get: 0,
    Post: 1,
};


if (typeof globalThis.Networking === 'undefined') {
    globalThis.Networking = {};
}
if (typeof globalThis.Networking.API === 'undefined') {
    globalThis.Networking.API = {};
}
if (typeof globalThis.Configuration === 'undefined') {
    globalThis.Configuration = {};
}
if (typeof globalThis.Networking.APIV2 === 'undefined') {
    globalThis.Networking.APIV2 = {};
}
if (typeof globalThis.Networking.APIV2.Internal === 'undefined') {
    globalThis.Networking.APIV2.Internal = {};
}

globalThis.Networking.API.Method = Method;
globalThis.Configuration.LogLevel = LogLevel;
globalThis.Configuration.Port = Port;
globalThis.Networking.APIV2.Internal.SupportedMethod = SupportedMethod;

export async function createInstantiator(options, swift) {
    let instance;
    let memory;
    let setException;
    const textDecoder = new TextDecoder("utf-8");
    const textEncoder = new TextEncoder("utf-8");
    let tmpRetString;
    let tmpRetBytes;
    let tmpRetException;
    let tmpRetTag;
    let tmpRetStrings = [];
    let tmpRetInts = [];
    let tmpRetF32s = [];
    let tmpRetF64s = [];
    let tmpRetBools = [];
    

    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            const bjs = {};
            importObject["bjs"] = bjs;
            const imports = options.getImports(importsContext);
            bjs["swift_js_return_string"] = function(ptr, len) {
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                const value = textDecoder.decode(bytes);
                tmpRetString = value;
                tmpRetStrings.push(value);
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
            bjs["swift_js_return_tag"] = function(tag) {
                tmpRetTag = tag | 0;
                tmpRetString = undefined;
                tmpRetStrings = [];
                tmpRetInts = [];
                tmpRetF32s = [];
                tmpRetF64s = [];
                tmpRetBools = [];
            }
            bjs["swift_js_return_int"] = function(v) {
                const value = v | 0;
                tmpRetInts.push(value);
            }
            bjs["swift_js_return_f32"] = function(v) {
                const value = Math.fround(v);
                tmpRetF32s.push(value);
            }
            bjs["swift_js_return_f64"] = function(v) {
                tmpRetF64s.push(v);
            }
            bjs["swift_js_return_bool"] = function(v) {
                const value = v !== 0;
                tmpRetBools.push(value);
            }
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Converter_wrap"] = function(pointer) {
                const obj = Converter.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_HTTPServer_wrap"] = function(pointer) {
                const obj = HTTPServer.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_TestServer_wrap"] = function(pointer) {
                const obj = TestServer.__construct(pointer);
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
            class HTTPServer extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_HTTPServer_deinit, HTTPServer.prototype);
                }
                
                
                constructor() {
                    const ret = instance.exports.bjs_HTTPServer_init();
                    return HTTPServer.__construct(ret);
                }
                call(method) {
                    instance.exports.bjs_HTTPServer_call(this.pointer, method);
                }
            }
            class TestServer extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_TestServer_deinit, TestServer.prototype);
                }
                
                
                constructor() {
                    const ret = instance.exports.bjs_TestServer_init();
                    return TestServer.__construct(ret);
                }
                call(method) {
                    instance.exports.bjs_TestServer_call(this.pointer, method);
                }
            }
            const exports = {
                Converter,
                HTTPServer,
                TestServer,
            };

            if (typeof globalThis.Networking === 'undefined') {
                globalThis.Networking = {};
            }
            if (typeof globalThis.Networking.API === 'undefined') {
                globalThis.Networking.API = {};
            }
            if (typeof globalThis.Networking.APIV2 === 'undefined') {
                globalThis.Networking.APIV2 = {};
            }
            if (typeof globalThis.Networking.APIV2.Internal === 'undefined') {
                globalThis.Networking.APIV2.Internal = {};
            }
            if (typeof globalThis.Utils === 'undefined') {
                globalThis.Utils = {};
            }
            globalThis.Utils.Converter = exports.Converter;
            globalThis.Networking.API.HTTPServer = exports.HTTPServer;
            globalThis.Networking.APIV2.Internal.TestServer = exports.TestServer;

            return exports;
        },
    }
}