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
    let tmpRetTag;
    let tmpRetStrings = [];
    let tmpRetInts = [];
    let tmpRetF32s = [];
    let tmpRetF64s = [];
    let tmpParamInts = [];
    let tmpParamF32s = [];
    let tmpParamF64s = [];

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
            bjs["swift_js_push_tag"] = function(tag) {
                tmpRetTag = tag;
            }
            bjs["swift_js_push_int"] = function(v) {
                tmpRetInts.push(v | 0);
            }
            bjs["swift_js_push_f32"] = function(v) {
                tmpRetF32s.push(Math.fround(v));
            }
            bjs["swift_js_push_f64"] = function(v) {
                tmpRetF64s.push(v);
            }
            bjs["swift_js_push_string"] = function(ptr, len) {
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                const value = textDecoder.decode(bytes);
                tmpRetStrings.push(value);
            }
            bjs["swift_js_pop_param_int32"] = function() {
                return tmpParamInts.pop();
            }
            bjs["swift_js_pop_param_f32"] = function() {
                return tmpParamF32s.pop();
            }
            bjs["swift_js_pop_param_f64"] = function() {
                return tmpParamF64s.pop();
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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Greeter_wrap"] = function(pointer) {
                const obj = Greeter.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_PublicGreeter_wrap"] = function(pointer) {
                const obj = PublicGreeter.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_PackageGreeter_wrap"] = function(pointer) {
                const obj = PackageGreeter.__construct(pointer);
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
                changeName(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    instance.exports.bjs_Greeter_changeName(this.pointer, nameId, nameBytes.length);
                    swift.memory.release(nameId);
                }
                get name() {
                    instance.exports.bjs_Greeter_name_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set name(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_Greeter_name_set(this.pointer, valueId, valueBytes.length);
                    swift.memory.release(valueId);
                }
            }
            class PublicGreeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_PublicGreeter_deinit, PublicGreeter.prototype);
                }
            
            }
            class PackageGreeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_PackageGreeter_deinit, PackageGreeter.prototype);
                }
            
            }
            return {
                Greeter,
                PublicGreeter,
                PackageGreeter,
                takeGreeter: function bjs_takeGreeter(greeter) {
                    instance.exports.bjs_takeGreeter(greeter.pointer);
                },
            };
        },
    }
}