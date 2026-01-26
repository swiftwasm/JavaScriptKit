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
    let tmpRetPointers = [];
    let tmpParamPointers = [];
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
            bjs["swift_js_push_pointer"] = function(pointer) {
                tmpRetPointers.push(pointer);
            }
            bjs["swift_js_pop_param_pointer"] = function() {
                return tmpParamPointers.pop();
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
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_createArrayBuffer"] = function bjs_createArrayBuffer() {
                try {
                    let ret = imports.createArrayBuffer();
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_createWeirdObject"] = function bjs_createWeirdObject() {
                try {
                    let ret = imports.createWeirdObject();
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_ArrayBufferLike_byteLength_get"] = function bjs_ArrayBufferLike_byteLength_get(self) {
                try {
                    let ret = swift.memory.getObject(self).byteLength;
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_ArrayBufferLike_slice"] = function bjs_ArrayBufferLike_slice(self, begin, end) {
                try {
                    let ret = swift.memory.getObject(self).slice(begin, end);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_WeirdNaming_normalProperty_get"] = function bjs_WeirdNaming_normalProperty_get(self) {
                try {
                    let ret = swift.memory.getObject(self).normalProperty;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_property_with_dashes_get"] = function bjs_WeirdNaming_property_with_dashes_get(self) {
                try {
                    let ret = swift.memory.getObject(self)["property-with-dashes"];
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_WeirdNaming__123invalidStart_get"] = function bjs_WeirdNaming__123invalidStart_get(self) {
                try {
                    let ret = swift.memory.getObject(self)["123invalidStart"];
                    return ret ? 1 : 0;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_WeirdNaming_property_with_spaces_get"] = function bjs_WeirdNaming_property_with_spaces_get(self) {
                try {
                    let ret = swift.memory.getObject(self)["property with spaces"];
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming__specialChar_get"] = function bjs_WeirdNaming__specialChar_get(self) {
                try {
                    let ret = swift.memory.getObject(self)["@specialChar"];
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_WeirdNaming_constructor_get"] = function bjs_WeirdNaming_constructor_get(self) {
                try {
                    let ret = swift.memory.getObject(self).constructor;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_for_get"] = function bjs_WeirdNaming_for_get(self) {
                try {
                    let ret = swift.memory.getObject(self).for;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_Any_get"] = function bjs_WeirdNaming_Any_get(self) {
                try {
                    let ret = swift.memory.getObject(self).Any;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_normalProperty_set"] = function bjs_WeirdNaming_normalProperty_set(self, newValue) {
                try {
                    const newValueObject = swift.memory.getObject(newValue);
                    swift.memory.release(newValue);
                    swift.memory.getObject(self).normalProperty = newValueObject;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_property_with_dashes_set"] = function bjs_WeirdNaming_property_with_dashes_set(self, newValue) {
                try {
                    swift.memory.getObject(self)["property-with-dashes"] = newValue;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming__123invalidStart_set"] = function bjs_WeirdNaming__123invalidStart_set(self, newValue) {
                try {
                    swift.memory.getObject(self)["123invalidStart"] = newValue !== 0;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_property_with_spaces_set"] = function bjs_WeirdNaming_property_with_spaces_set(self, newValue) {
                try {
                    const newValueObject = swift.memory.getObject(newValue);
                    swift.memory.release(newValue);
                    swift.memory.getObject(self)["property with spaces"] = newValueObject;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming__specialChar_set"] = function bjs_WeirdNaming__specialChar_set(self, newValue) {
                try {
                    swift.memory.getObject(self)["@specialChar"] = newValue;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_constructor_set"] = function bjs_WeirdNaming_constructor_set(self, newValue) {
                try {
                    const newValueObject = swift.memory.getObject(newValue);
                    swift.memory.release(newValue);
                    swift.memory.getObject(self).constructor = newValueObject;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_for_set"] = function bjs_WeirdNaming_for_set(self, newValue) {
                try {
                    const newValueObject = swift.memory.getObject(newValue);
                    swift.memory.release(newValue);
                    swift.memory.getObject(self).for = newValueObject;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_any_set"] = function bjs_WeirdNaming_any_set(self, newValue) {
                try {
                    const newValueObject = swift.memory.getObject(newValue);
                    swift.memory.release(newValue);
                    swift.memory.getObject(self).Any = newValueObject;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_WeirdNaming_as"] = function bjs_WeirdNaming_as(self) {
                try {
                    swift.memory.getObject(self).as();
                } catch (error) {
                    setException(error);
                }
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
            const exports = {
            };
            _exports = exports;
            return exports;
        },
    }
}