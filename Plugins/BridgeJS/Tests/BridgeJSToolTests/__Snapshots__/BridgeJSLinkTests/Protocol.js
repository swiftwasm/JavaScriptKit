// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const DirectionValues = {
    North: 0,
    South: 1,
    East: 2,
    West: 3,
};

export const ExampleEnumValues = {
    Test: "test",
    Test2: "test2",
};

export const ResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
    },
};
export const PriorityValues = {
    Low: -1,
    Medium: 0,
    High: 1,
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
    let tagStack = [];
    let strStack = [];
    let i32Stack = [];
    let f32Stack = [];
    let f64Stack = [];
    let ptrStack = [];
    let tmpStructCleanups = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    const __bjs_createResultValuesHelpers = () => {
        return () => ({
            lower: (value) => {
                const enumTag = value.tag;
                switch (enumTag) {
                    case ResultValues.Tag.Success: {
                        const bytes = textEncoder.encode(value.param0);
                        const id = swift.memory.retain(bytes);
                        i32Stack.push(bytes.length);
                        i32Stack.push(id);
                        const cleanup = () => {
                            swift.memory.release(id);
                        };
                        return { caseId: ResultValues.Tag.Success, cleanup };
                    }
                    case ResultValues.Tag.Failure: {
                        i32Stack.push((value.param0 | 0));
                        const cleanup = undefined;
                        return { caseId: ResultValues.Tag.Failure, cleanup };
                    }
                    default: throw new Error("Unknown ResultValues tag: " + String(enumTag));
                }
            },
            lift: (tag) => {
                tag = tag | 0;
                switch (tag) {
                    case ResultValues.Tag.Success: {
                        const string = strStack.pop();
                        return { tag: ResultValues.Tag.Success, param0: string };
                    }
                    case ResultValues.Tag.Failure: {
                        const int = i32Stack.pop();
                        return { tag: ResultValues.Tag.Failure, param0: int };
                    }
                    default: throw new Error("Unknown ResultValues tag returned from Swift: " + String(tag));
                }
            }
        });
    };

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
                tagStack.push(tag);
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
                const value = textDecoder.decode(bytes);
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
            bjs["swift_js_struct_cleanup"] = function(cleanupId) {
                if (cleanupId === 0) { return; }
                const index = (cleanupId | 0) - 1;
                const cleanup = tmpStructCleanups[index];
                tmpStructCleanups[index] = null;
                if (cleanup) { cleanup(); }
                while (tmpStructCleanups.length > 0 && tmpStructCleanups[tmpStructCleanups.length - 1] == null) {
                    tmpStructCleanups.pop();
                }
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
            importObject["TestModule"]["bjs_DelegateManager_wrap"] = function(pointer) {
                const obj = DelegateManager.__construct(pointer);
                return swift.memory.retain(obj);
            };
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
                    tmpRetString = ret;
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
            TestModule["bjs_MyViewControllerDelegate_optionalRawEnum_get"] = function bjs_MyViewControllerDelegate_optionalRawEnum_get(self) {
                try {
                    let ret = swift.memory.getObject(self).optionalRawEnum;
                    tmpRetString = ret;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalRawEnum_set"] = function bjs_MyViewControllerDelegate_optionalRawEnum_set(self, valueIsSome, valueWrappedValue) {
                try {
                    let obj;
                    if (valueIsSome) {
                        obj = swift.memory.getObject(valueWrappedValue);
                        swift.memory.release(valueWrappedValue);
                    }
                    swift.memory.getObject(self).optionalRawEnum = valueIsSome ? obj : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_rawStringEnum_get"] = function bjs_MyViewControllerDelegate_rawStringEnum_get(self) {
                try {
                    let ret = swift.memory.getObject(self).rawStringEnum;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_rawStringEnum_set"] = function bjs_MyViewControllerDelegate_rawStringEnum_set(self, value) {
                try {
                    const valueObject = swift.memory.getObject(value);
                    swift.memory.release(value);
                    swift.memory.getObject(self).rawStringEnum = valueObject;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_result_get"] = function bjs_MyViewControllerDelegate_result_get(self) {
                try {
                    let ret = swift.memory.getObject(self).result;
                    const { caseId: caseId, cleanup: cleanup } = enumHelpers.Result.lower(ret);
                    return caseId;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_result_set"] = function bjs_MyViewControllerDelegate_result_set(self, value) {
                try {
                    const enumValue = enumHelpers.Result.lift(value);
                    swift.memory.getObject(self).result = enumValue;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalResult_get"] = function bjs_MyViewControllerDelegate_optionalResult_get(self) {
                try {
                    let ret = swift.memory.getObject(self).optionalResult;
                    const isSome = ret != null;
                    if (isSome) {
                        const { caseId: caseId, cleanup: cleanup } = enumHelpers.Result.lower(ret);
                        return caseId;
                    } else {
                        return -1;
                    }
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_optionalResult_set"] = function bjs_MyViewControllerDelegate_optionalResult_set(self, valueIsSome, valueWrappedValue) {
                try {
                    let enumValue;
                    if (valueIsSome) {
                        enumValue = enumHelpers.Result.lift(valueWrappedValue);
                    }
                    swift.memory.getObject(self).optionalResult = valueIsSome ? enumValue : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_direction_get"] = function bjs_MyViewControllerDelegate_direction_get(self) {
                try {
                    let ret = swift.memory.getObject(self).direction;
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_direction_set"] = function bjs_MyViewControllerDelegate_direction_set(self, value) {
                try {
                    swift.memory.getObject(self).direction = value;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_directionOptional_get"] = function bjs_MyViewControllerDelegate_directionOptional_get(self) {
                try {
                    let ret = swift.memory.getObject(self).directionOptional;
                    const isSome = ret != null;
                    return isSome ? (ret | 0) : -1;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_directionOptional_set"] = function bjs_MyViewControllerDelegate_directionOptional_set(self, valueIsSome, valueWrappedValue) {
                try {
                    swift.memory.getObject(self).directionOptional = valueIsSome ? valueWrappedValue : null;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_priority_get"] = function bjs_MyViewControllerDelegate_priority_get(self) {
                try {
                    let ret = swift.memory.getObject(self).priority;
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_MyViewControllerDelegate_priority_set"] = function bjs_MyViewControllerDelegate_priority_set(self, value) {
                try {
                    swift.memory.getObject(self).priority = value;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_priorityOptional_get"] = function bjs_MyViewControllerDelegate_priorityOptional_get(self) {
                try {
                    let ret = swift.memory.getObject(self).priorityOptional;
                    tmpRetOptionalInt = ret;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_priorityOptional_set"] = function bjs_MyViewControllerDelegate_priorityOptional_set(self, valueIsSome, valueWrappedValue) {
                try {
                    swift.memory.getObject(self).priorityOptional = valueIsSome ? valueWrappedValue : null;
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
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_createEnum"] = function bjs_MyViewControllerDelegate_createEnum(self) {
                try {
                    let ret = swift.memory.getObject(self).createEnum();
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_handleResult"] = function bjs_MyViewControllerDelegate_handleResult(self, result) {
                try {
                    const enumValue = enumHelpers.Result.lift(result);
                    swift.memory.getObject(self).handleResult(enumValue);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_MyViewControllerDelegate_getResult"] = function bjs_MyViewControllerDelegate_getResult(self) {
                try {
                    let ret = swift.memory.getObject(self).getResult();
                    const { caseId: caseId, cleanup: cleanup } = enumHelpers.Result.lower(ret);
                    return caseId;
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
            class DelegateManager extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_DelegateManager_deinit, DelegateManager.prototype);
                }

                constructor(delegates) {
                    const arrayCleanups = [];
                    for (const elem of delegates) {
                        const objId = swift.memory.retain(elem);
                        i32Stack.push(objId);
                    }
                    i32Stack.push(delegates.length);
                    const ret = instance.exports.bjs_DelegateManager_init();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return DelegateManager.__construct(ret);
                }
                notifyAll() {
                    instance.exports.bjs_DelegateManager_notifyAll(this.pointer);
                }
                get delegates() {
                    instance.exports.bjs_DelegateManager_delegates_get(this.pointer);
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const objId = i32Stack.pop();
                        const obj = swift.memory.getObject(objId);
                        swift.memory.release(objId);
                        arrayResult.push(obj);
                    }
                    arrayResult.reverse();
                    return arrayResult;
                }
                set delegates(value) {
                    const arrayCleanups = [];
                    for (const elem of value) {
                        const objId = swift.memory.retain(elem);
                        i32Stack.push(objId);
                    }
                    i32Stack.push(value.length);
                    instance.exports.bjs_DelegateManager_delegates_set(this.pointer);
                    for (const cleanup of arrayCleanups) { cleanup(); }
                }
            }
            const ResultHelpers = __bjs_createResultValuesHelpers()();
            enumHelpers.Result = ResultHelpers;

            const exports = {
                Helper,
                MyViewController,
                DelegateManager,
                processDelegates: function bjs_processDelegates(delegates) {
                    const arrayCleanups = [];
                    for (const elem of delegates) {
                        const objId = swift.memory.retain(elem);
                        i32Stack.push(objId);
                    }
                    i32Stack.push(delegates.length);
                    instance.exports.bjs_processDelegates();
                    const arrayLen = i32Stack.pop();
                    const arrayResult = [];
                    for (let i = 0; i < arrayLen; i++) {
                        const objId1 = i32Stack.pop();
                        const obj = swift.memory.getObject(objId1);
                        swift.memory.release(objId1);
                        arrayResult.push(obj);
                    }
                    arrayResult.reverse();
                    for (const cleanup of arrayCleanups) { cleanup(); }
                    return arrayResult;
                },
                Direction: DirectionValues,
                ExampleEnum: ExampleEnumValues,
                Result: ResultValues,
                Priority: PriorityValues,
            };
            _exports = exports;
            return exports;
        },
    }
}