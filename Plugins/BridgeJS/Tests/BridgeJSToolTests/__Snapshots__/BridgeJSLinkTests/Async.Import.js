// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export async function createInstantiator(options, swift) {
    let instance;
    let memory;
    const textDecoder = new TextDecoder("utf-8");
    const textEncoder = new TextEncoder("utf-8");

    let tmpRetString;
    let tmpRetBytes;
    let tmpRetException;
    return {
        /** @param {WebAssembly.Imports} importObject */
        addImports: (importObject) => {
            const bjs = {};
            importObject["bjs"] = bjs;
            bjs["return_string"] = function(ptr, len) {
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                tmpRetString = textDecoder.decode(bytes);
            }
            bjs["init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
                const bytes = new Uint8Array(memory.buffer, bytesPtr);
                bytes.set(source);
            }
            bjs["make_jsstring"] = function(ptr, len) {
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                return swift.memory.retain(textDecoder.decode(bytes));
            }
            bjs["init_memory_with_result"] = function(ptr, len) {
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
            const TestModule = importObject["TestModule"] = {};
            TestModule["bjs_asyncReturnVoid"] = function bjs_asyncReturnVoid() {
                let ret = options.imports.asyncReturnVoid();
                return swift.memory.retain(ret);
            }
            TestModule["bjs_asyncRoundTripInt"] = function bjs_asyncRoundTripInt(v) {
                let ret = options.imports.asyncRoundTripInt(v);
                return swift.memory.retain(ret);
            }
            TestModule["bjs_asyncRoundTripString"] = function bjs_asyncRoundTripString(v) {
                const vObject = swift.memory.getObject(v);
                swift.memory.release(v);
                let ret = options.imports.asyncRoundTripString(vObject);
                return swift.memory.retain(ret);
            }
            TestModule["bjs_asyncRoundTripBool"] = function bjs_asyncRoundTripBool(v) {
                let ret = options.imports.asyncRoundTripBool(v);
                return swift.memory.retain(ret);
            }
            TestModule["bjs_asyncRoundTripFloat"] = function bjs_asyncRoundTripFloat(v) {
                let ret = options.imports.asyncRoundTripFloat(v);
                return swift.memory.retain(ret);
            }
            TestModule["bjs_asyncRoundTripDouble"] = function bjs_asyncRoundTripDouble(v) {
                let ret = options.imports.asyncRoundTripDouble(v);
                return swift.memory.retain(ret);
            }
            TestModule["bjs_asyncRoundTripJSObject"] = function bjs_asyncRoundTripJSObject(v) {
                let ret = options.imports.asyncRoundTripJSObject(swift.memory.getObject(v));
                return swift.memory.retain(ret);
            }
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;

            return {

            };
        },
    }
}