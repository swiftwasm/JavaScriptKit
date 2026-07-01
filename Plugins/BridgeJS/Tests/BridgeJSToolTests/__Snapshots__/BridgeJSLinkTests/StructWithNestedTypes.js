// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const KindValues = {
    Circle: "circle",
    Square: "square",
};

export const VariantValues = {
    Button: "button",
    Slider: "slider",
};

export const AlignmentValues = {
    Leading: "leading",
    Trailing: "trailing",
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
    const __bjs_createShapeHelpers = () => ({
        lower: (value) => {
            const bytes = textEncoder.encode(value.label);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
        },
        lift: () => {
            const string = strStack.pop();
            return { label: string };
        }
    });
    const __bjs_createWidgetHelpers = () => ({
        lower: (value) => {
            const bytes = textEncoder.encode(value.name);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
        },
        lift: () => {
            const string = strStack.pop();
            return { name: string };
        }
    });
    const __bjs_createWidget_LayoutHelpers = () => ({
        lower: (value) => {
            i32Stack.push((value.padding | 0));
        },
        lift: () => {
            const int = i32Stack.pop();
            return { padding: int };
        }
    });
    const __bjs_createWidget_BoundsHelpers = () => ({
        lower: (value) => {
            i32Stack.push((value.width | 0));
            i32Stack.push((value.height | 0));
        },
        lift: () => {
            const int = i32Stack.pop();
            const int1 = i32Stack.pop();
            return { width: int1, height: int };
        }
    });

    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            bjs["swift_js_return_string"] = function(ptr, len) {
                tmpRetString = decodeString(ptr, len);
            }
            bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
                swift.memory.release(sourceId);
                const bytes = new Uint8Array(memory.buffer, bytesPtr >>> 0);
                bytes.set(source);
            }
            bjs["swift_js_make_js_string"] = function(ptr, len) {
                return swift.memory.retain(decodeString(ptr, len));
            }
            bjs["swift_js_init_memory_with_result"] = function(ptr, len) {
                const target = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0);
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
            bjs["swift_js_struct_lower_Shape"] = function(objectId) {
                structHelpers.Shape.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Shape"] = function() {
                const value = structHelpers.Shape.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Widget"] = function(objectId) {
                structHelpers.Widget.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Widget"] = function() {
                const value = structHelpers.Widget.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Widget_Layout"] = function(objectId) {
                structHelpers.Widget_Layout.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Widget_Layout"] = function() {
                const value = structHelpers.Widget_Layout.lift();
                return swift.memory.retain(value);
            }
            bjs["swift_js_struct_lower_Widget_Bounds"] = function(objectId) {
                structHelpers.Widget_Bounds.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Widget_Bounds"] = function() {
                const value = structHelpers.Widget_Bounds.lift();
                return swift.memory.retain(value);
            }
            const __bjs_promiseSettlers = Symbol("JavaScriptKit.promiseSettlers");
            bjs["swift_js_make_promise"] = function() {
                let resolve, reject;
                const promise = new Promise((res, rej) => { resolve = res; reject = rej; });
                promise[__bjs_promiseSettlers] = { resolve, reject };
                return swift.memory.retain(promise);
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
            const ShapeHelpers = __bjs_createShapeHelpers();
            structHelpers.Shape = ShapeHelpers;

            const WidgetHelpers = __bjs_createWidgetHelpers();
            structHelpers.Widget = WidgetHelpers;

            const Widget_LayoutHelpers = __bjs_createWidget_LayoutHelpers();
            structHelpers.Widget_Layout = Widget_LayoutHelpers;

            const Widget_BoundsHelpers = __bjs_createWidget_BoundsHelpers();
            structHelpers.Widget_Bounds = Widget_BoundsHelpers;

            const exports = {
                Shape: {
                    init: function(label) {
                        const labelBytes = textEncoder.encode(label);
                        const labelId = swift.memory.retain(labelBytes);
                        instance.exports.bjs_Shape_init(labelId, labelBytes.length);
                        const structValue = structHelpers.Shape.lift();
                        return structValue;
                    },
                    Kind: KindValues,
                },
                Widget: {
                    init: function(name) {
                        const nameBytes = textEncoder.encode(name);
                        const nameId = swift.memory.retain(nameBytes);
                        instance.exports.bjs_Widget_init(nameId, nameBytes.length);
                        const structValue = structHelpers.Widget.lift();
                        return structValue;
                    },
                    Variant: VariantValues,
                    Bounds: {
                        init: function(width, height) {
                            instance.exports.bjs_Widget_Bounds_init(width, height);
                            const structValue = structHelpers.Widget_Bounds.lift();
                            return structValue;
                        },
                        get dimensions() {
                            const ret = instance.exports.bjs_Widget_Bounds_static_dimensions_get();
                            return ret;
                        },
                        zero: function() {
                            instance.exports.bjs_Widget_Bounds_static_zero();
                            const structValue = structHelpers.Widget_Bounds.lift();
                            return structValue;
                        },
                    },
                    Layout: {
                        Alignment: AlignmentValues,
                    },
                },
            };
            _exports = exports;
            return exports;
        },
    }
}