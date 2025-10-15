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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_Helper_wrap"] = function(pointer) {
                const obj = Helper.__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_MyViewController_wrap"] = function(pointer) {
                const obj = MyViewController.__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_MyViewControllerDelegate_eventCount_get"] = function bjs_MyViewControllerDelegate_eventCount_get(self) {
                try {
                    let ret = swift.memory.getObject(self).eventCount;
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_eventCount_set"] = function bjs_MyViewControllerDelegate_eventCount_set(self, value) {
                try {
                    swift.memory.getObject(self).eventCount = value;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_delegateName_get"] = function bjs_MyViewControllerDelegate_delegateName_get(self) {
                try {
                    let ret = swift.memory.getObject(self).delegateName;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalName_get"] = function bjs_MyViewControllerDelegate_optionalName_get(self) {
                try {
                    let ret = swift.memory.getObject(self).optionalName;
                    const isSome = ret != null;
                    if (isSome) {
                        const bytes = textEncoder.encode(ret);
                        bjs["swift_js_return_optional_string"](1, bytes, bytes.length);
                        return bytes.length;
                    } else {
                        bjs["swift_js_return_optional_string"](0, 0, 0);
                        return -1;
                    }
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalName_set"] = function bjs_MyViewControllerDelegate_optionalName_set(self, valueIsSome, valueWrappedValue) {
                try {
                    let obj;
                    if (valueIsSome) {
                        obj = swift.memory.getObject(valueWrappedValue);
                        swift.memory.release(valueWrappedValue);
                    }
                    swift.memory.getObject(self).optionalName = valueIsSome ? obj : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onSomethingHappened"] = function bjs_MyViewControllerDelegate_onSomethingHappened(self) {
                try {
                    swift.memory.getObject(self).onSomethingHappened();
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onValueChanged"] = function bjs_MyViewControllerDelegate_onValueChanged(self, value) {
                try {
                    const valueObject = swift.memory.getObject(value);
                    swift.memory.release(value);
                    swift.memory.getObject(self).onValueChanged(valueObject);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onCountUpdated"] = function bjs_MyViewControllerDelegate_onCountUpdated(self, count) {
                try {
                    let ret = swift.memory.getObject(self).onCountUpdated(count);
                    return ret ? 1 : 0;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onLabelUpdated"] = function bjs_MyViewControllerDelegate_onLabelUpdated(self, prefix, suffix) {
                try {
                    const prefixObject = swift.memory.getObject(prefix);
                    swift.memory.release(prefix);
                    const suffixObject = swift.memory.getObject(suffix);
                    swift.memory.release(suffix);
                    swift.memory.getObject(self).onLabelUpdated(prefixObject, suffixObject);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_isCountEven"] = function bjs_MyViewControllerDelegate_isCountEven(self) {
                try {
                    let ret = swift.memory.getObject(self).isCountEven();
                    return ret ? 1 : 0;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onHelperUpdated"] = function bjs_MyViewControllerDelegate_onHelperUpdated(self, helper) {
                try {
                    swift.memory.getObject(self).onHelperUpdated(Helper.__construct(helper));
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_createHelper"] = function bjs_MyViewControllerDelegate_createHelper(self) {
                try {
                    let ret = swift.memory.getObject(self).createHelper();
                    return ret.pointer;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_onOptionalHelperUpdated"] = function bjs_MyViewControllerDelegate_onOptionalHelperUpdated(self, helperIsSome, helperWrappedValue) {
                try {
                    swift.memory.getObject(self).onOptionalHelperUpdated(helperIsSome ? Helper.__construct(helperWrappedValue) : null);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_createOptionalHelper"] = function bjs_MyViewControllerDelegate_createOptionalHelper(self) {
                try {
                    let ret = swift.memory.getObject(self).createOptionalHelper();
                    const isSome = ret != null;
                    return isSome ? ret.pointer : 0;
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
            class Helper extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_Helper_deinit, Helper.prototype);
                }
            
                constructor(value) {
                    const ret = instance.exports.bjs_Helper_init(value);
                    return Helper.__construct(ret);
                }
                increment() {
                    instance.exports.bjs_Helper_increment(this.pointer);
                }
                get value() {
                    const ret = instance.exports.bjs_Helper_value_get(this.pointer);
                    return ret;
                }
                set value(value) {
                    instance.exports.bjs_Helper_value_set(this.pointer, value);
                }
            }
            class MyViewController extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_MyViewController_deinit, MyViewController.prototype);
                }
            
                constructor(delegate) {
                    const ret = instance.exports.bjs_MyViewController_init(swift.memory.retain(delegate));
                    return MyViewController.__construct(ret);
                }
                triggerEvent() {
                    instance.exports.bjs_MyViewController_triggerEvent(this.pointer);
                }
                updateValue(value) {
                    const valueBytes = textEncoder.encode(value);
                    const valueId = swift.memory.retain(valueBytes);
                    instance.exports.bjs_MyViewController_updateValue(this.pointer, valueId, valueBytes.length);
                    swift.memory.release(valueId);
                }
                updateCount(count) {
                    const ret = instance.exports.bjs_MyViewController_updateCount(this.pointer, count);
                    return ret !== 0;
                }
                updateLabel(prefix, suffix) {
                    const prefixBytes = textEncoder.encode(prefix);
                    const prefixId = swift.memory.retain(prefixBytes);
                    const suffixBytes = textEncoder.encode(suffix);
                    const suffixId = swift.memory.retain(suffixBytes);
                    instance.exports.bjs_MyViewController_updateLabel(this.pointer, prefixId, prefixBytes.length, suffixId, suffixBytes.length);
                    swift.memory.release(prefixId);
                    swift.memory.release(suffixId);
                }
                checkEvenCount() {
                    const ret = instance.exports.bjs_MyViewController_checkEvenCount(this.pointer);
                    return ret !== 0;
                }
                sendHelper(helper) {
                    instance.exports.bjs_MyViewController_sendHelper(this.pointer, helper.pointer);
                }
                get delegate() {
                    const ret = instance.exports.bjs_MyViewController_delegate_get(this.pointer);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                }
                set delegate(value) {
                    instance.exports.bjs_MyViewController_delegate_set(this.pointer, swift.memory.retain(value));
                }
                get secondDelegate() {
                    instance.exports.bjs_MyViewController_secondDelegate_get(this.pointer);
                    const optResult = tmpRetString;
                    tmpRetString = undefined;
                    return optResult;
                }
                set secondDelegate(value) {
                    const isSome = value != null;
                    instance.exports.bjs_MyViewController_secondDelegate_set(this.pointer, +isSome, isSome ? swift.memory.retain(value) : 0);
                }
            }
            return {
                Helper,
                MyViewController,
            };
        },
    }
}