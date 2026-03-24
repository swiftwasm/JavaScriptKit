// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export async function createInstantiator(options, swift) {
    let instance;
    let memory;
    let setException;
    let decodeString;
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
    let i64Stack = [];
    let f32Stack = [];
    let f64Stack = [];
    let ptrStack = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    function bjs_resolvePromiseContinuation(ptr, value) {
        let kind, payload1 = 0, payload2 = 0;
        if (value === null) {
            kind = 4;
        } else if (value === undefined) {
            kind = 5;
        } else {
            const type = typeof value;
            switch (type) {
                case "boolean":
                    kind = 0;
                    payload1 = value ? 1 : 0;
                    break;
                case "number":
                    kind = 2;
                    payload2 = value;
                    break;
                case "string":
                    kind = 1;
                    payload1 = swift.memory.retain(value);
                    break;
                case "symbol":
                    kind = 7;
                    payload1 = swift.memory.retain(value);
                    break;
                case "bigint":
                    kind = 8;
                    payload1 = swift.memory.retain(value);
                    break;
                default:
                    kind = 3;
                    payload1 = swift.memory.retain(value);
                    break;
            }
        }
        instance.exports.bjs_resolve_promise_continuation(ptr, kind, payload1, payload2);
    }
    function bjs_rejectPromiseContinuation(ptr, error) {
        let kind, payload1 = 0, payload2 = 0;
        if (error === null) {
            kind = 4;
        } else if (error === undefined) {
            kind = 5;
        } else {
            const type = typeof error;
            switch (type) {
                case "boolean":
                    kind = 0;
                    payload1 = error ? 1 : 0;
                    break;
                case "number":
                    kind = 2;
                    payload2 = error;
                    break;
                case "string":
                    kind = 1;
                    payload1 = swift.memory.retain(error);
                    break;
                case "symbol":
                    kind = 7;
                    payload1 = swift.memory.retain(error);
                    break;
                case "bigint":
                    kind = 8;
                    payload1 = swift.memory.retain(error);
                    break;
                default:
                    kind = 3;
                    payload1 = swift.memory.retain(error);
                    break;
            }
        }
        instance.exports.bjs_reject_promise_continuation(ptr, kind, payload1, payload2);
    }

    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            const imports = options.getImports(importsContext);
            bjs["swift_js_return_string"] = function(ptr, len) {
                tmpRetString = decodeString(ptr, len);
            }
            bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
                swift.memory.release(sourceId);
                const bytes = new Uint8Array(memory.buffer, bytesPtr);
                bytes.set(source);
            }
            bjs["swift_js_make_js_string"] = function(ptr, len) {
                return swift.memory.retain(decodeString(ptr, len));
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
                const value = decodeString(ptr, len);
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
            bjs["swift_js_push_i64"] = function(v) {
                i64Stack.push(v);
            }
            bjs["swift_js_pop_i64"] = function() {
                return i64Stack.pop();
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
                    tmpRetString = decodeString(ptr, len);
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
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_asyncReturnVoid"] = function bjs_asyncReturnVoid(continuationPtr) {
                try {
                    const promise = imports.asyncReturnVoid();
                    promise.then(
                        (value) => { bjs_resolvePromiseContinuation(continuationPtr, value); },
                        (error) => { bjs_rejectPromiseContinuation(continuationPtr, error); }
                    );
                } catch (error) {
                    bjs_rejectPromiseContinuation(continuationPtr, error);
                }
            }
            TestModule["bjs_asyncRoundTripInt"] = function bjs_asyncRoundTripInt(continuationPtr, v) {
                try {
                    const promise = imports.asyncRoundTripInt(v);
                    promise.then(
                        (value) => { bjs_resolvePromiseContinuation(continuationPtr, value); },
                        (error) => { bjs_rejectPromiseContinuation(continuationPtr, error); }
                    );
                } catch (error) {
                    bjs_rejectPromiseContinuation(continuationPtr, error);
                }
            }
            TestModule["bjs_asyncRoundTripString"] = function bjs_asyncRoundTripString(continuationPtr, vBytes, vCount) {
                try {
                    const string = decodeString(vBytes, vCount);
                    const promise = imports.asyncRoundTripString(string);
                    promise.then(
                        (value) => { bjs_resolvePromiseContinuation(continuationPtr, value); },
                        (error) => { bjs_rejectPromiseContinuation(continuationPtr, error); }
                    );
                } catch (error) {
                    bjs_rejectPromiseContinuation(continuationPtr, error);
                }
            }
            TestModule["bjs_asyncRoundTripBool"] = function bjs_asyncRoundTripBool(continuationPtr, v) {
                try {
                    const promise = imports.asyncRoundTripBool(v !== 0);
                    promise.then(
                        (value) => { bjs_resolvePromiseContinuation(continuationPtr, value); },
                        (error) => { bjs_rejectPromiseContinuation(continuationPtr, error); }
                    );
                } catch (error) {
                    bjs_rejectPromiseContinuation(continuationPtr, error);
                }
            }
            TestModule["bjs_asyncRoundTripDouble"] = function bjs_asyncRoundTripDouble(continuationPtr, v) {
                try {
                    const promise = imports.asyncRoundTripDouble(v);
                    promise.then(
                        (value) => { bjs_resolvePromiseContinuation(continuationPtr, value); },
                        (error) => { bjs_rejectPromiseContinuation(continuationPtr, error); }
                    );
                } catch (error) {
                    bjs_rejectPromiseContinuation(continuationPtr, error);
                }
            }
            TestModule["bjs_asyncRoundTripJSObject"] = function bjs_asyncRoundTripJSObject(continuationPtr, v) {
                try {
                    const promise = imports.asyncRoundTripJSObject(swift.memory.getObject(v));
                    promise.then(
                        (value) => { bjs_resolvePromiseContinuation(continuationPtr, value); },
                        (error) => { bjs_rejectPromiseContinuation(continuationPtr, error); }
                    );
                } catch (error) {
                    bjs_rejectPromiseContinuation(continuationPtr, error);
                }
            }
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            decodeString = (ptr, len) => { const bytes = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0); return textDecoder.decode(bytes); }

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