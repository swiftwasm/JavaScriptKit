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
            const TestModule = importObject["TestModule"] = {};
            TestModule["bjs_Greeter_init"] = function bjs_Greeter_init(name) {
                const nameObject = swift.memory.getObject(name);
                swift.memory.release(name);
                let ret = new options.imports.Greeter(nameObject);
                return swift.memory.retain(ret);
            }
            TestModule["bjs_Greeter_name_get"] = function bjs_Greeter_name_get(self) {
                let ret = swift.memory.getObject(self).name;
                tmpRetBytes = textEncoder.encode(ret);
                return tmpRetBytes.length;
            }
            TestModule["bjs_Greeter_name_set"] = function bjs_Greeter_name_set(self, newValue) {
                const newValueObject = swift.memory.getObject(newValue);
                swift.memory.release(newValue);
                swift.memory.getObject(self).name = newValueObject;
            }
            TestModule["bjs_Greeter_age_get"] = function bjs_Greeter_age_get(self) {
                let ret = swift.memory.getObject(self).age;
                return ret;
            }
            TestModule["bjs_Greeter_greet"] = function bjs_Greeter_greet(self) {
                let ret = swift.memory.getObject(self).greet();
                tmpRetBytes = textEncoder.encode(ret);
                return tmpRetBytes.length;
            }
            TestModule["bjs_Greeter_changeName"] = function bjs_Greeter_changeName(self, name) {
                const nameObject = swift.memory.getObject(name);
                swift.memory.release(name);
                swift.memory.getObject(self).changeName(nameObject);
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