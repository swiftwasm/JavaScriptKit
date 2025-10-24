// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const PropertyEnumValues = {
    Value1: 0,
    Value2: 1,
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
            importObject["TestModule"]["bjs_PropertyClass_wrap"] = function(pointer) {
                const obj = PropertyClass.__construct(pointer);
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
            class PropertyClass extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_PropertyClass_deinit, PropertyClass.prototype);
                }
            
                constructor() {
                    const ret = instance.exports.bjs_PropertyClass_init();
                    return PropertyClass.__construct(ret);
                }
                static get staticConstant() {
                    instance.exports.bjs_PropertyClass_static_staticConstant_get();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                static get staticVariable() {
                    const ret = instance.exports.bjs_PropertyClass_static_staticVariable_get();
                    return ret;
                }
                static set staticVariable(value) {
                    instance.exports.bjs_PropertyClass_static_staticVariable_set(value);
                }
                static get jsObjectProperty() {
                    const ret = instance.exports.bjs_PropertyClass_static_jsObjectProperty_get();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                }
                static set jsObjectProperty(value) {
                    instance.exports.bjs_PropertyClass_static_jsObjectProperty_set(swift.memory.retain(value));
                }
                static get classVariable() {
                    instance.exports.bjs_PropertyClass_static_classVariable_get();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                static set classVariable(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_PropertyClass_static_classVariable_set(valueId, valueBytes.length);
                    swift.memory.release(valueId);
                }
                static get computedProperty() {
                    instance.exports.bjs_PropertyClass_static_computedProperty_get();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                }
                static set computedProperty(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_PropertyClass_static_computedProperty_set(valueId, valueBytes.length);
                    swift.memory.release(valueId);
                }
                static get readOnlyComputed() {
                    const ret = instance.exports.bjs_PropertyClass_static_readOnlyComputed_get();
                    return ret;
                }
                static get optionalProperty() {
                    instance.exports.bjs_PropertyClass_static_optionalProperty_get();
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                static set optionalProperty(value) {
                    const isSome = value != null;
                    let valueId, valueBytes;
                    if (isSome) {
                        valueBytes = textEncoder.encode(value);
                        valueId = swift.memory.retain(valueBytes);
                    }
                    instance.exports.bjs_PropertyClass_static_optionalProperty_set(+isSome, isSome ? valueId : 0, isSome ? valueBytes.length : 0);
                    if (valueId != undefined) {
                        swift.memory.release(valueId);
                    }
                }
            }
            Object.defineProperty(globalThis.PropertyNamespace, 'namespaceProperty', { get: function() {
                instance.exports.bjs_PropertyNamespace_static_namespaceProperty_get();
                const ret = tmpRetString;
                tmpRetString = undefined;
                return ret;
            }, set: function(value) {
                const valueBytes = textEncoder.encode(value);
                const valueId = swift.memory.retain(valueBytes);
                instance.exports.bjs_PropertyNamespace_static_namespaceProperty_set(valueId, valueBytes.length);
                swift.memory.release(valueId);
            } });
            Object.defineProperty(globalThis.PropertyNamespace, 'namespaceConstant', { get: function() {
                instance.exports.bjs_PropertyNamespace_static_namespaceConstant_get();
                const ret = tmpRetString;
                tmpRetString = undefined;
                return ret;
            } });
            Object.defineProperty(globalThis.PropertyNamespace.Nested, 'nestedProperty', { get: function() {
                const ret = instance.exports.bjs_PropertyNamespace_Nested_static_nestedProperty_get();
                return ret;
            }, set: function(value) {
                instance.exports.bjs_PropertyNamespace_Nested_static_nestedProperty_set(value);
            } });
            Object.defineProperty(globalThis.PropertyNamespace.Nested, 'nestedConstant', { get: function() {
                instance.exports.bjs_PropertyNamespace_Nested_static_nestedConstant_get();
                const ret = tmpRetString;
                tmpRetString = undefined;
                return ret;
            } });
            Object.defineProperty(globalThis.PropertyNamespace.Nested, 'nestedDouble', { get: function() {
                const ret = instance.exports.bjs_PropertyNamespace_Nested_static_nestedDouble_get();
                return ret;
            }, set: function(value) {
                instance.exports.bjs_PropertyNamespace_Nested_static_nestedDouble_set(value);
            } });
            return {
                PropertyClass,
                PropertyEnum: {
                    ...PropertyEnumValues,
                    get enumProperty() {
                        instance.exports.bjs_PropertyEnum_static_enumProperty_get();
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    },
                    set enumProperty(value) {
                        const valueBytes = textEncoder.encode(value);
                        const valueId = swift.memory.retain(valueBytes);
                        instance.exports.bjs_PropertyEnum_static_enumProperty_set(valueId, valueBytes.length);
                        swift.memory.release(valueId);
                    },
                    get enumConstant() {
                        const ret = instance.exports.bjs_PropertyEnum_static_enumConstant_get();
                        return ret;
                    },
                    get computedEnum() {
                        instance.exports.bjs_PropertyEnum_static_computedEnum_get();
                        const ret = tmpRetString;
                        tmpRetString = undefined;
                        return ret;
                    },
                    set computedEnum(value) {
                        const valueBytes = textEncoder.encode(value);
                        const valueId = swift.memory.retain(valueBytes);
                        instance.exports.bjs_PropertyEnum_static_computedEnum_set(valueId, valueBytes.length);
                        swift.memory.release(valueId);
                    }
                },
            };
        },
    }
}