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
    let tmpRetOptionalBool;
    let tmpRetOptionalInt;
    let tmpRetOptionalFloat;
    let tmpRetOptionalDouble;
    let tmpRetOptionalHeapObject;
    let tmpRetTag;
    let tmpRetStrings = [];
    let tmpRetInts = [];
    let tmpRetF32s = [];
    let tmpRetF64s = [];
    let tmpParamInts = [];
    let tmpParamF32s = [];
    let tmpParamF64s = [];

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
            bjs["swift_js_push_tag"] = function(tag) {
                tmpRetTag = tag;
            }
            bjs["swift_js_push_int"] = function(v) {
                tmpRetInts.push(v | 0);
            }
            bjs["swift_js_push_f32"] = function(v) {
                tmpRetF32s.push(Math.fround(v));
            }
            bjs["swift_js_push_f64"] = function(v) {
                tmpRetF64s.push(v);
            }
            bjs["swift_js_push_string"] = function(ptr, len) {
                const bytes = new Uint8Array(memory.buffer, ptr, len);
                const value = textDecoder.decode(bytes);
                tmpRetStrings.push(value);
            }
            bjs["swift_js_pop_param_int32"] = function() {
                return tmpParamInts.pop();
            }
            bjs["swift_js_pop_param_f32"] = function() {
                return tmpParamF32s.pop();
            }
            bjs["swift_js_pop_param_f64"] = function() {
                return tmpParamF64s.pop();
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
                    const bytes = new Uint8Array(memory.buffer, ptr, len);
                    tmpRetString = textDecoder.decode(bytes);
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
            const TestModule = importObject["TestModule"] = importObject["TestModule"] || {};
            TestModule["bjs_createDatabaseConnection"] = function bjs_createDatabaseConnection(config) {
                try {
                    let ret = imports.createDatabaseConnection(swift.memory.getObject(config));
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_createLogger"] = function bjs_createLogger(level) {
                try {
                    const levelObject = swift.memory.getObject(level);
                    swift.memory.release(level);
                    let ret = imports.createLogger(levelObject);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_getConfigManager"] = function bjs_getConfigManager() {
                try {
                    let ret = imports.getConfigManager();
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_DatabaseConnection_isConnected_get"] = function bjs_DatabaseConnection_isConnected_get(self) {
                try {
                    let ret = swift.memory.getObject(self).isConnected;
                    return ret ? 1 : 0;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_DatabaseConnection_connectionTimeout_get"] = function bjs_DatabaseConnection_connectionTimeout_get(self) {
                try {
                    let ret = swift.memory.getObject(self).connectionTimeout;
                    return ret;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_DatabaseConnection_connectionTimeout_set"] = function bjs_DatabaseConnection_connectionTimeout_set(self, newValue) {
                try {
                    swift.memory.getObject(self).connectionTimeout = newValue;
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_DatabaseConnection_connect"] = function bjs_DatabaseConnection_connect(self, url) {
                try {
                    const urlObject = swift.memory.getObject(url);
                    swift.memory.release(url);
                    swift.memory.getObject(self).connect(urlObject);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_DatabaseConnection_execute"] = function bjs_DatabaseConnection_execute(self, query) {
                try {
                    const queryObject = swift.memory.getObject(query);
                    swift.memory.release(query);
                    let ret = swift.memory.getObject(self).execute(queryObject);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_Logger_level_get"] = function bjs_Logger_level_get(self) {
                try {
                    let ret = swift.memory.getObject(self).level;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_Logger_log"] = function bjs_Logger_log(self, message) {
                try {
                    const messageObject = swift.memory.getObject(message);
                    swift.memory.release(message);
                    swift.memory.getObject(self).log(messageObject);
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_Logger_error"] = function bjs_Logger_error(self, message, error) {
                try {
                    const messageObject = swift.memory.getObject(message);
                    swift.memory.release(message);
                    swift.memory.getObject(self).error(messageObject, swift.memory.getObject(error));
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_ConfigManager_configPath_get"] = function bjs_ConfigManager_configPath_get(self) {
                try {
                    let ret = swift.memory.getObject(self).configPath;
                    tmpRetBytes = textEncoder.encode(ret);
                    return tmpRetBytes.length;
                } catch (error) {
                    setException(error);
                }
            }
            TestModule["bjs_ConfigManager_get"] = function bjs_ConfigManager_get(self, key) {
                try {
                    const keyObject = swift.memory.getObject(key);
                    swift.memory.release(key);
                    let ret = swift.memory.getObject(self).get(keyObject);
                    return swift.memory.retain(ret);
                } catch (error) {
                    setException(error);
                    return 0
                }
            }
            TestModule["bjs_ConfigManager_set"] = function bjs_ConfigManager_set(self, key, value) {
                try {
                    const keyObject = swift.memory.getObject(key);
                    swift.memory.release(key);
                    swift.memory.getObject(self).set(keyObject, swift.memory.getObject(value));
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