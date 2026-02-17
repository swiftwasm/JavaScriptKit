// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const MethodValues = {
    Get: 0,
    Post: 1,
    Put: 2,
    Delete: 3,
};

export const LogLevelValues = {
    Debug: "debug",
    Info: "info",
    Warning: "warning",
    Error: "error",
};

export const PortValues = {
    Http: 80,
    Https: 443,
    Development: 3000,
};

export const SupportedMethodValues = {
    Get: 0,
    Post: 1,
};

if (typeof globalThis.Configuration === 'undefined') {
    globalThis.Configuration = {};
}
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
globalThis.Networking.API.MethodValues = MethodValues;
globalThis.Configuration.LogLevelValues = LogLevelValues;
globalThis.Configuration.PortValues = PortValues;
globalThis.Networking.APIV2.Internal.SupportedMethodValues = SupportedMethodValues;
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
                strStack.push(textDecoder.decode(bytes));
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
            if (typeof globalThis.Configuration === 'undefined') {
                globalThis.Configuration = {};
            }
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
            if (typeof globalThis.Services === 'undefined') {
                globalThis.Services = {};
            }
            if (typeof globalThis.Services.Graph === 'undefined') {
                globalThis.Services.Graph = {};
            }
            if (typeof globalThis.Services.Graph.GraphOperations === 'undefined') {
                globalThis.Services.Graph.GraphOperations = {};
            }
            if (typeof globalThis.Utils === 'undefined') {
                globalThis.Utils = {};
            }
            const exports = {
                Configuration: {
                    LogLevel: LogLevelValues,
                    Port: PortValues,
                },
                Networking: {
                    API: {
                        HTTPServer,
                        Method: MethodValues,
                    },
                    APIV2: {
                        Internal: {
                            TestServer,
                            SupportedMethod: SupportedMethodValues,
                        },
                    },
                },
                Services: {
                    Graph: {
                        GraphOperations: {
                            createGraph: function bjs_Services_Graph_GraphOperations_static_createGraph(rootId) {
                                const ret = instance.exports.bjs_Services_Graph_GraphOperations_static_createGraph(rootId);
                                return ret;
                            },
                            nodeCount: function bjs_Services_Graph_GraphOperations_static_nodeCount(graphId) {
                                const ret = instance.exports.bjs_Services_Graph_GraphOperations_static_nodeCount(graphId);
                                return ret;
                            },
                            validate: function bjs_Services_Graph_GraphOperations_static_validate(graphId) {
                                const ret = instance.exports.bjs_Services_Graph_GraphOperations_static_validate(graphId);
                                if (tmpRetException) {
                                    const error = swift.memory.getObject(tmpRetException);
                                    swift.memory.release(tmpRetException);
                                    tmpRetException = undefined;
                                    throw error;
                                }
                                return ret !== 0;
                            },
                        },
                    },
                },
                Utils: {
                    Converter,
                },
            };
            _exports = exports;
            globalThis.Utils.Converter = exports.Utils.Converter;
            globalThis.Networking.API.HTTPServer = exports.Networking.API.HTTPServer;
            globalThis.Networking.APIV2.Internal.TestServer = exports.Networking.APIV2.Internal.TestServer;
            globalThis.Services.Graph.GraphOperations.createGraph = exports.Services.Graph.GraphOperations.createGraph;
            globalThis.Services.Graph.GraphOperations.nodeCount = exports.Services.Graph.GraphOperations.nodeCount;
            globalThis.Services.Graph.GraphOperations.validate = exports.Services.Graph.GraphOperations.validate;
            return exports;
        },
    }
}