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
            TestModule["bjs_createTS2Skeleton"] = function bjs_createTS2Skeleton() {
                try {
                    let ret = imports.createTS2Skeleton();
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_createCodeGenerator"] = function bjs_createCodeGenerator(format) {
                try {
                    const formatObject = swift.memory.getObject(format);
                    swift.memory.release(format);
                    let ret = imports.createCodeGenerator(formatObject);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_TypeScriptProcessor_version_get"] = function bjs_TypeScriptProcessor_version_get(self) {
                try {
                    let ret = swift.memory.getObject(self).version;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_TypeScriptProcessor_convert"] = function bjs_TypeScriptProcessor_convert(self, ts) {
                try {
                    const tsObject = swift.memory.getObject(ts);
                    swift.memory.release(ts);
                    let ret = swift.memory.getObject(self).convert(tsObject);
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_TypeScriptProcessor_validate"] = function bjs_TypeScriptProcessor_validate(self, ts) {
                try {
                    const tsObject = swift.memory.getObject(ts);
                    swift.memory.release(ts);
                    let ret = swift.memory.getObject(self).validate(tsObject);
                    return ret !== 0;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_CodeGenerator_outputFormat_get"] = function bjs_CodeGenerator_outputFormat_get(self) {
                try {
                    let ret = swift.memory.getObject(self).outputFormat;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_CodeGenerator_generate"] = function bjs_CodeGenerator_generate(self, input) {
                try {
                    let ret = swift.memory.getObject(self).generate(swift.memory.getObject(input));
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
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