export async function createInstantiator(options, swift) {
    let instance;
    let memory;
    let bytesView;
    const textDecoder = new TextDecoder("utf-8");
    const textEncoder = new TextEncoder("utf-8");

    let tmpRetString;
    let s2jRetBytes;
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

            bjs["init_memory_with_result"] = function(ptr, len) {
                new Uint8Array(memory.buffer, ptr, len).set(s2jRetBytes);
            }

            const MyApp = bjs["MyApp"] = {};
            MyApp["returnString"] = function() {
                const ret = options.imports.returnString();
                const bytes = textEncoder.encode(ret);
                s2jRetBytes = bytes;
                return bytes.length;
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
                checkString: function checkString(a) {
                    const aBytes = textEncoder.encode(a);
                    const aId = swift.memory.retain(aBytes);
                    instance.exports.bjs_checkString(aId, aBytes.length);
                    swift.memory.release(aId);
                },
            };
        },
    }
}
