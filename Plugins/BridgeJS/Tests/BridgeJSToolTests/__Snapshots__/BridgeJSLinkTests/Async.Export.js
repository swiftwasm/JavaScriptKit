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
                asyncReturnVoid: function bjs_asyncReturnVoid() {
                    const ret = instance.exports.bjs_asyncReturnVoid();
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripInt: function bjs_asyncRoundTripInt(v) {
                    const ret = instance.exports.bjs_asyncRoundTripInt(v);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripString: function bjs_asyncRoundTripString(v) {
                    const vBytes = textEncoder.encode(v);
                    const vId = swift.memory.retain(vBytes);
                    const ret = instance.exports.bjs_asyncRoundTripString(vId, vBytes.length);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    swift.memory.release(vId);
                    return ret1;
                },
                asyncRoundTripBool: function bjs_asyncRoundTripBool(v) {
                    const ret = instance.exports.bjs_asyncRoundTripBool(v);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripFloat: function bjs_asyncRoundTripFloat(v) {
                    const ret = instance.exports.bjs_asyncRoundTripFloat(v);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripDouble: function bjs_asyncRoundTripDouble(v) {
                    const ret = instance.exports.bjs_asyncRoundTripDouble(v);
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
                asyncRoundTripJSObject: function bjs_asyncRoundTripJSObject(v) {
                    const ret = instance.exports.bjs_asyncRoundTripJSObject(swift.memory.retain(v));
                    const ret1 = swift.memory.getObject(ret);
                    swift.memory.release(ret);
                    return ret1;
                },
            };
        },
    }
}