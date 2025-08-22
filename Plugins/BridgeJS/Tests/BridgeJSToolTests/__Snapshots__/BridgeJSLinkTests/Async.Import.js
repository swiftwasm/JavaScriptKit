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

            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_asyncReturnVoid"] = function bjs_asyncReturnVoid() {
                try {
                    let ret = imports.asyncReturnVoid();
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_asyncRoundTripInt"] = function bjs_asyncRoundTripInt(v) {
                try {
                    let ret = imports.asyncRoundTripInt(v);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_asyncRoundTripString"] = function bjs_asyncRoundTripString(v) {
                try {
                    const vObject = swift.memory.getObject(v);
                    swift.memory.release(v);
                    let ret = imports.asyncRoundTripString(vObject);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_asyncRoundTripBool"] = function bjs_asyncRoundTripBool(v) {
                try {
                    let ret = imports.asyncRoundTripBool(v);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_asyncRoundTripFloat"] = function bjs_asyncRoundTripFloat(v) {
                try {
                    let ret = imports.asyncRoundTripFloat(v);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_asyncRoundTripDouble"] = function bjs_asyncRoundTripDouble(v) {
                try {
                    let ret = imports.asyncRoundTripDouble(v);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_asyncRoundTripJSObject"] = function bjs_asyncRoundTripJSObject(v) {
                try {
                    let ret = imports.asyncRoundTripJSObject(swift.memory.getObject(v));
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
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

            return {

            };
        },
    }
}