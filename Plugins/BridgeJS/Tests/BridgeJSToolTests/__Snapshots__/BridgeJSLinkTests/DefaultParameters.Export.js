// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const StatusValues = {
    Active: 0,
    Inactive: 1,
    Pending: 2,
};

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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_DefaultGreeter_wrap"] = function(pointer) {
                const obj = DefaultGreeter.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_EmptyGreeter_wrap"] = function(pointer) {
                const obj = EmptyGreeter.__construct(pointer);
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
            class DefaultGreeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_DefaultGreeter_deinit, DefaultGreeter.prototype);
                }
            
                constructor(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_DefaultGreeter_init(nameId, nameBytes.length);
                    swift.memory.release(nameId);
                    return DefaultGreeter.__construct(ret);
                }
                get name() {
                    instance.exports.bjs_DefaultGreeter_name_get(this.pointer);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                set name(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_DefaultGreeter_name_set(this.pointer, valueId, valueBytes.length);
                    swift.memory.release(valueId);
                }
            }
            class EmptyGreeter extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_EmptyGreeter_deinit, EmptyGreeter.prototype);
                }
            
                constructor() {
                    const ret = instance.exports.bjs_EmptyGreeter_init();
                    return EmptyGreeter.__construct(ret);
                }
            }
            return {
                DefaultGreeter,
                EmptyGreeter,
                testStringDefault: function bjs_testStringDefault(message) {
                    if (message === undefined) {
                        message = "Hello World";
                    }
                    const messageBytes = textEncoder.encode(message);
                    const messageId = swift.memory.retain(messageBytes);
                    instance.exports.bjs_testStringDefault(messageId, messageBytes.length);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    swift.memory.release(messageId);
                    return ret;
                },
                testIntDefault: function bjs_testIntDefault(count) {
                    if (count === undefined) {
                        count = 42;
                    }
                    const ret = instance.exports.bjs_testIntDefault(count);
                    return ret;
                },
                testBoolDefault: function bjs_testBoolDefault(flag) {
                    if (flag === undefined) {
                        flag = true;
                    }
                    const ret = instance.exports.bjs_testBoolDefault(flag);
                    return ret !== 0;
                },
                testFloatDefault: function bjs_testFloatDefault(value) {
                    if (value === undefined) {
                        value = 3.14;
                    }
                    const ret = instance.exports.bjs_testFloatDefault(value);
                    return ret;
                },
                testDoubleDefault: function bjs_testDoubleDefault(precision) {
                    if (precision === undefined) {
                        precision = 2.718;
                    }
                    const ret = instance.exports.bjs_testDoubleDefault(precision);
                    return ret;
                },
                testOptionalDefault: function bjs_testOptionalDefault(name) {
                    if (name === undefined) {
                        name = null;
                    }
                    const isSome = name != null;
                    let nameId, nameBytes;
                    if (isSome) {
                        nameBytes = textEncoder.encode(name);
                        nameId = swift.memory.retain(nameBytes);
                    }
                    instance.exports.bjs_testOptionalDefault(+isSome, isSome ? nameId : 0, isSome ? nameBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (nameId != undefined) {
                        swift.memory.release(nameId);
                    }
                    return optResult;
                },
                testOptionalStringDefault: function bjs_testOptionalStringDefault(greeting) {
                    if (greeting === undefined) {
                        greeting = "Hi";
                    }
                    const isSome = greeting != null;
                    let greetingId, greetingBytes;
                    if (isSome) {
                        greetingBytes = textEncoder.encode(greeting);
                        greetingId = swift.memory.retain(greetingBytes);
                    }
                    instance.exports.bjs_testOptionalStringDefault(+isSome, isSome ? greetingId : 0, isSome ? greetingBytes.length : 0);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    if (greetingId != undefined) {
                        swift.memory.release(greetingId);
                    }
                    return optResult;
                },
                testMultipleDefaults: function bjs_testMultipleDefaults(title, count, enabled) {
                    if (title === undefined) {
                        title = "Default Title";
                    }
                    if (count === undefined) {
                        count = 10;
                    }
                    if (enabled === undefined) {
                        enabled = false;
                    }
                    const titleBytes = textEncoder.encode(title);
                    const titleId = swift.memory.retain(titleBytes);
                    instance.exports.bjs_testMultipleDefaults(titleId, titleBytes.length, count, enabled);
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    swift.memory.release(titleId);
                    return ret;
                },
                testEnumDefault: function bjs_testEnumDefault(status) {
                    if (status === undefined) {
                        status = StatusValues.Active;
                    }
                    const ret = instance.exports.bjs_testEnumDefault(status);
                    return ret;
                },
                testComplexInit: function bjs_testComplexInit(greeter) {
                    if (greeter === undefined) {
                        greeter = new DefaultGreeter("DefaultUser");
                    }
                    const ret = instance.exports.bjs_testComplexInit(greeter.pointer);
                    return DefaultGreeter.__construct(ret);
                },
                testEmptyInit: function bjs_testEmptyInit(greeter) {
                    if (greeter === undefined) {
                        greeter = new EmptyGreeter();
                    }
                    const ret = instance.exports.bjs_testEmptyInit(greeter.pointer);
                    return EmptyGreeter.__construct(ret);
                },
                Status: StatusValues,
            };
        },
    }
}