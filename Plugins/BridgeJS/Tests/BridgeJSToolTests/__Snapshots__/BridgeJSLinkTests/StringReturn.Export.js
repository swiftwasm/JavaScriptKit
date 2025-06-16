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

        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;

            return {
                checkString: function bjs_checkString() {
                    instance.exports.bjs_checkString();
                    const ret = tmpRetString;
                    tmpRetString = undefined;
                    return ret;
                },
            };
        },
    }
}