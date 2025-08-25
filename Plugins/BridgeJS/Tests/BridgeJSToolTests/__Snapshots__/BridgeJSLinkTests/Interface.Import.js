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
    let tmpRetInt;
    let tmpRetF32;
    let tmpRetF64;
    let tmpRetBytes;
    let tmpRetException;
    let tmpRetTag;
    
    let tmpRetStrings = [];
    let tmpRetInts = [];
    let tmpRetF32s = [];
    let tmpRetF64s = [];
    let tmpRetBools = [];

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
                const value = textDecoder.decode(bytes);
                tmpRetString = value;
                tmpRetStrings.push(value);
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
                tmpRetString = undefined;
                tmpRetInt = undefined;
                tmpRetF32 = undefined;
                tmpRetF64 = undefined;
                tmpRetStrings = [];
                tmpRetInts = [];
                tmpRetF32s = [];
                tmpRetF64s = [];
                tmpRetBools = [];
            }
            bjs["swift_js_return_int"] = function(v) {
                const value = v | 0;
                tmpRetInt = value;
                tmpRetInts.push(value);
            }
            bjs["swift_js_return_f32"] = function(v) {
                const value = Math.fround(v);
                tmpRetF32 = value;
                tmpRetF32s.push(value);
            }
            bjs["swift_js_return_f64"] = function(v) {
                tmpRetF64 = v;
                tmpRetF64s.push(v);
            }
            bjs["swift_js_return_bool"] = function(v) {
                const value = v !== 0;
                tmpRetBools.push(value);
            }

            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_returnAnimatable"] = function bjs_returnAnimatable() {
                try {
                    let ret = imports.returnAnimatable();
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_Animatable_animate"] = function bjs_Animatable_animate(self, keyframes, options) {
                try {
                    let ret = swift.memory.getObject(self).animate(swift.memory.getObject(keyframes), swift.memory.getObject(options));
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_Animatable_getAnimations"] = function bjs_Animatable_getAnimations(self, options) {
                try {
                    let ret = swift.memory.getObject(self).getAnimations(swift.memory.getObject(options));
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