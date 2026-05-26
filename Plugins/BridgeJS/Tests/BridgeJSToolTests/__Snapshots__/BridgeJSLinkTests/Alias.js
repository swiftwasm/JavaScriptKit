// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const InnerTagValues = {
    Tag: {
        Payload: 0,
        Empty: 1,
    },
};
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
    let taStack = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    const __bjs_createInnerTagValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case InnerTagValues.Tag.Payload: {
                    i32Stack.push((value.param0 | 0));
                    return InnerTagValues.Tag.Payload;
                }
                case InnerTagValues.Tag.Empty: {
                    return InnerTagValues.Tag.Empty;
                }
                default: throw new Error("Unknown InnerTagValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case InnerTagValues.Tag.Payload: {
                    const int = i32Stack.pop();
                    return { tag: InnerTagValues.Tag.Payload, param0: int };
                }
                case InnerTagValues.Tag.Empty: return { tag: InnerTagValues.Tag.Empty };
                default: throw new Error("Unknown InnerTagValues tag returned from Swift: " + String(tag));
            }
        }
    });

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
            const taCtors = [Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array];
            bjs["swift_js_push_typed_array"] = function(kind, ptr, count) {
                const Ctor = taCtors[kind];
                const byteLen = count * Ctor.BYTES_PER_ELEMENT;
                const copy = memory.buffer.slice(ptr, ptr + byteLen);
                taStack.push(Array.from(new Ctor(copy)));
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
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_PolygonReference_wrap"] = function(pointer) {
                const obj = _exports['PolygonReference'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            importObject["TestModule"]["bjs_TagReference_wrap"] = function(pointer) {
                const obj = _exports['TagReference'].__construct(pointer);
                return swift.memory.retain(obj);
            };
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_acceptTagged"] = function bjs_acceptTagged(taggedBytes, taggedCount) {
                try {
                    const string = decodeString(taggedBytes, taggedCount);
                    imports.acceptTagged(string);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_acceptOptionalTagged"] = function bjs_acceptOptionalTagged(taggedIsSome, taggedBytes, taggedCount) {
                try {
                    let optResult;
                    if (taggedIsSome) {
                        const string = decodeString(taggedBytes, taggedCount);
                        optResult = string;
                    } else {
                        optResult = null;
                    }
                    imports.acceptOptionalTagged(optResult);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_roundtripTagged"] = function bjs_roundtripTagged(taggedBytes, taggedCount) {
                try {
                    const string = decodeString(taggedBytes, taggedCount);
                    let ret = imports.roundtripTagged(string);
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_produceOptionalCanvas"] = function bjs_produceOptionalCanvas() {
                try {
                    let ret = imports.produceOptionalCanvas();
                    const isSome = ret != null;
                    if (isSome) {
                        const objId = swift.memory.retain(ret);
                        i32Stack.push(objId);
                    }
                    i32Stack.push(isSome ? 1 : 0);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_Surface_init"] = function bjs_Surface_init() {
                try {
                    return swift.memory.retain(new imports.Surface());
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_Surface_label_get"] = function bjs_Surface_label_get(self) {
                try {
                    let ret = swift.memory.getObject(self).label;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_HasOptionalUserId_userId_get"] = function bjs_HasOptionalUserId_userId_get(self) {
                try {
                    let ret = swift.memory.getObject(self).userId;
                    tmpRetOptionalInt = ret;
                } catch (error) {
                    setException(error);
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
            const swiftHeapObjectFinalizationRegistry = (typeof FinalizationRegistry === "undefined") ? { register: () => {}, unregister: () => {} } : new FinalizationRegistry((state) => {
                if (state.hasReleased) {
                    return;
                }
                state.hasReleased = true;
                state.identityMap?.delete(state.pointer);
                state.deinit(state.pointer);
            });

            /// Represents a Swift heap object like a class instance or an actor instance.
            class SwiftHeapObject {
                static __wrap(pointer, deinit, prototype, identityCache) {
                    const makeFresh = (identityMap) => {
                        const obj = Object.create(prototype);
                        const state = { pointer, deinit, hasReleased: false, identityMap };
                        obj.pointer = pointer;
                        obj.__swiftHeapObjectState = state;
                        swiftHeapObjectFinalizationRegistry.register(obj, state, state);
                        if (identityMap) {
                            identityMap.set(pointer, new WeakRef(obj));
                        }
                        return obj;
                    };

                    if (!identityCache) {
                        return makeFresh(null);
                    }

                    const cached = identityCache.get(pointer)?.deref();
                    if (cached && !cached.__swiftHeapObjectState.hasReleased) {
                        deinit(pointer);
                        return cached;
                    }
                    if (identityCache.has(pointer)) {
                        identityCache.delete(pointer);
                    }

                    return makeFresh(identityCache);
                }

                release() {
                    const state = this.__swiftHeapObjectState;
                    if (state.hasReleased) {
                        return;
                    }
                    state.hasReleased = true;
                    swiftHeapObjectFinalizationRegistry.unregister(state);
                    state.identityMap?.delete(state.pointer);
                    state.deinit(state.pointer);
                }
            }
            class PolygonReference extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_PolygonReference_deinit, PolygonReference.prototype, null);
                }

                constructor(underlying) {
                    const ret = instance.exports.bjs_PolygonReference_init(underlying.pointer);
                    return PolygonReference.__construct(ret);
                }
                snapshot() {
                    const ret = instance.exports.bjs_PolygonReference_snapshot(this.pointer);
                    return PolygonReference.__construct(ret);
                }
                merge(other) {
                    const ret = instance.exports.bjs_PolygonReference_merge(this.pointer, other.pointer);
                    return PolygonReference.__construct(ret);
                }
                static origin() {
                    const ret = instance.exports.bjs_PolygonReference_static_origin();
                    return PolygonReference.__construct(ret);
                }
            }
            class TagReference extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_TagReference_deinit, TagReference.prototype, null);
                }

                constructor(underlying) {
                    const ret = instance.exports.bjs_TagReference_init(underlying.pointer);
                    return TagReference.__construct(ret);
                }
            }
            const InnerTagHelpers = __bjs_createInnerTagValuesHelpers();
            enumHelpers.InnerTag = InnerTagHelpers;

            const exports = {
                PolygonReference,
                TagReference,
                roundtripPolygon: function bjs_roundtripPolygon(polygon) {
                    const ret = instance.exports.bjs_roundtripPolygon(polygon.pointer);
                    return PolygonReference.__construct(ret);
                },
                optionalPolygon: function bjs_optionalPolygon(polygon) {
                    const isSome = polygon != null;
                    let result;
                    if (isSome) {
                        result = polygon.pointer;
                    } else {
                        result = 0;
                    }
                    instance.exports.bjs_optionalPolygon(+isSome, result);
                    const pointer = tmpRetOptionalHeapObject;
                    tmpRetOptionalHeapObject = undefined;
                    const optResult = pointer === null ? null : PolygonReference.__construct(pointer);
                    return optResult;
                },
                polygonArray: function bjs_polygonArray(polygons) {
                    for (const elem of polygons) {
                        ptrStack.push(elem.pointer);
                    }
                    i32Stack.push(polygons.length);
                    instance.exports.bjs_polygonArray();
                    const arrayLen = i32Stack.pop();
                    let arrayResult;
                    if (arrayLen === -1) {
                        arrayResult = taStack.pop();
                    } else {
                        arrayResult = [];
                        for (let i = 0; i < arrayLen; i++) {
                            const ptr = ptrStack.pop();
                            const obj = PolygonReference.__construct(ptr);
                            arrayResult.push(obj);
                        }
                        arrayResult.reverse();
                    }
                    return arrayResult;
                },
                validatePolygon: function bjs_validatePolygon(polygon) {
                    const ret = instance.exports.bjs_validatePolygon(polygon.pointer);
                    if (tmpRetException) {
                        const error = swift.memory.getObject(tmpRetException);
                        swift.memory.release(tmpRetException);
                        tmpRetException = undefined;
                        throw error;
                    }
                    return PolygonReference.__construct(ret);
                },
                makeTag: function bjs_makeTag(name) {
                    const nameBytes = textEncoder.encode(name);
                    const nameId = swift.memory.retain(nameBytes);
                    const ret = instance.exports.bjs_makeTag(nameId, nameBytes.length);
                    return TagReference.__construct(ret);
                },
                roundtripTags: function bjs_roundtripTags(xs) {
                    for (const elem of xs) {
                        const isSome = elem != null ? 1 : 0;
                        if (isSome) {
                            const caseId = enumHelpers.InnerTag.lower(elem);
                            i32Stack.push(caseId);
                        } else {
                            i32Stack.push(-1);
                        }
                    }
                    i32Stack.push(xs.length);
                    instance.exports.bjs_roundtripTags();
                    const arrayLen = i32Stack.pop();
                    let arrayResult;
                    if (arrayLen === -1) {
                        arrayResult = taStack.pop();
                    } else {
                        arrayResult = [];
                        for (let i = 0; i < arrayLen; i++) {
                            const caseId1 = i32Stack.pop();
                            let optValue;
                            if (caseId1 === -1) {
                                optValue = null;
                            } else {
                                optValue = enumHelpers.InnerTag.lift(caseId1);
                            }
                            arrayResult.push(optValue);
                        }
                        arrayResult.reverse();
                    }
                    return arrayResult;
                },
                describeUser: function bjs_describeUser(owner) {
                    const ret = instance.exports.bjs_describeUser(swift.memory.retain(owner));
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                InnerTag: InnerTagValues,
            };
            _exports = exports;
            return exports;
        },
    }
}