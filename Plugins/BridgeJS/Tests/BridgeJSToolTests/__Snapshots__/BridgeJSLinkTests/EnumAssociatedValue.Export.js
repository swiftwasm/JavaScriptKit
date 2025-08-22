// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const APIResult = {
    Tag: {
        Success: 0,
        Failure: 1,
        Flag: 2,
        Rate: 3,
        Precise: 4,
        Info: 5,
    }
};


// Helper factory for APIResult enum
const __bjs_createAPIResultHelpers = () => {
    const f32buf = new ArrayBuffer(4);
    const f32dv = new DataView(f32buf);
    const f64buf = new ArrayBuffer(8);
    const f64dv = new DataView(f64buf);

    const f32ToI32 = (v) => { f32dv.setFloat32(0, Math.fround(v), true); return f32dv.getInt32(0, true); };
    const f64ToI32x2 = (v) => { f64dv.setFloat64(0, v, true); return [f64dv.getInt32(0, true), f64dv.getInt32(4, true)]; };

    return (textEncoder, swift) => ({
        lower: (value) => {
            const t = value.tag;
            switch (t) {
                case APIResult.Tag.Success: {
                    const bytes = textEncoder.encode(value.value);
                    const id = swift.memory.retain(bytes);
                    return { tag: 0, a: id, b: bytes.length, cleanup: () => swift.memory.release(id) };
                }
                case APIResult.Tag.Failure: return { tag: 1, a: (value.value | 0), b: 0 };
                case APIResult.Tag.Flag: return { tag: 2, a: (value.value ? 1 : 0), b: 0 };
                case APIResult.Tag.Rate: return { tag: 3, a: f32ToI32(value.value), b: 0 };
                case APIResult.Tag.Precise: {
                    const [lo, hi] = f64ToI32x2(value.value);
                    return { tag: 4, a: lo, b: hi };
                }
                case APIResult.Tag.Info: return { tag: 5, a: 0, b: 0 };
                default: throw new Error("Unknown APIResult tag: " + String(t));
            }
        },
        raise: (tmpRetTag, tmpRetString, tmpRetInt, tmpRetF32, tmpRetF64) => {
            const tag = tmpRetTag | 0;
            switch (tag) {
                case 0: return { tag: APIResult.Tag.Success, value: tmpRetString };
                case 1: return { tag: APIResult.Tag.Failure, value: tmpRetInt | 0 };
                case 2: return { tag: APIResult.Tag.Flag, value: (tmpRetInt !== 0) };
                    case 3: return { tag: APIResult.Tag.Rate, value: Math.fround(tmpRetF32) };
                case 4: return { tag: APIResult.Tag.Precise, value: tmpRetF64 };
                case 5: return { tag: APIResult.Tag.Info };
                default: throw new Error("Unknown APIResult tag returned from Swift: " + String(tag));
            }
        }
    });
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
    let tmpRetTag;
    let tmpRetInt;
    let tmpRetF32;
    let tmpRetF64;

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
            bjs["swift_js_return_tag"] = function(tag) {
                tmpRetTag = tag | 0;
            }
            bjs["swift_js_return_int"] = function(v) {
                tmpRetInt = v | 0;
            }
            bjs["swift_js_return_f32"] = function(v) {
                tmpRetF32 = Math.fround(v);
            }
            bjs["swift_js_return_f64"] = function(v) {
                tmpRetF64 = v;
            }


        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            // Set up APIResult enum helpers
            const APIResultHelpers = __bjs_createAPIResultHelpers()(textEncoder, swift);
            globalThis.__bjs_lower_APIResult = (value) => APIResultHelpers.lower(value);
            globalThis.__bjs_raise_APIResult = () => APIResultHelpers.raise(tmpRetTag, tmpRetString, tmpRetInt, tmpRetF32, tmpRetF64);
            
            setException = (error) => {
                instance.exports._swift_js_exception.value = swift.memory.retain(error)
            }
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;

            return {
                handle: function bjs_handle(result) {
                    const { tag: resultTag, a: resultA, b: resultB, cleanup: resultCleanup } = globalThis.__bjs_lower_APIResult(result);
                    instance.exports.bjs_handle(resultTag, resultA, resultB);
                    if (resultCleanup) { resultCleanup(); }
                },
                getResult: function bjs_getResult() {
                    instance.exports.bjs_getResult();
                    const ret = globalThis.__bjs_raise_APIResult();
                    return ret;
                },
            };
        },
    }
}