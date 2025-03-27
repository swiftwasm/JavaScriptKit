(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
    typeof define === 'function' && define.amd ? define(['exports'], factory) :
    (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.JavaScriptKit = {}));
})(this, (function (exports) { 'use strict';

    /// Memory lifetime of closures in Swift are managed by Swift side
    class SwiftClosureDeallocator {
        constructor(exports) {
            if (typeof FinalizationRegistry === "undefined") {
                throw new Error("The Swift part of JavaScriptKit was configured to require " +
                    "the availability of JavaScript WeakRefs. Please build " +
                    "with `-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS` to " +
                    "disable features that use WeakRefs.");
            }
            this.functionRegistry = new FinalizationRegistry((id) => {
                exports.swjs_free_host_function(id);
            });
        }
        track(func, func_ref) {
            this.functionRegistry.register(func, func_ref);
        }
    }

    function assertNever(x, message) {
        throw new Error(message);
    }
    const MAIN_THREAD_TID = -1;

    const decode = (kind, payload1, payload2, memory) => {
        switch (kind) {
            case 0 /* Kind.Boolean */:
                switch (payload1) {
                    case 0:
                        return false;
                    case 1:
                        return true;
                }
            case 2 /* Kind.Number */:
                return payload2;
            case 1 /* Kind.String */:
            case 3 /* Kind.Object */:
            case 6 /* Kind.Function */:
            case 7 /* Kind.Symbol */:
            case 8 /* Kind.BigInt */:
                return memory.getObject(payload1);
            case 4 /* Kind.Null */:
                return null;
            case 5 /* Kind.Undefined */:
                return undefined;
            default:
                assertNever(kind, `JSValue Type kind "${kind}" is not supported`);
        }
    };
    // Note:
    // `decodeValues` assumes that the size of RawJSValue is 16.
    const decodeArray = (ptr, length, memory) => {
        // fast path for empty array
        if (length === 0) {
            return [];
        }
        let result = [];
        // It's safe to hold DataView here because WebAssembly.Memory.buffer won't
        // change within this function.
        const view = memory.dataView();
        for (let index = 0; index < length; index++) {
            const base = ptr + 16 * index;
            const kind = view.getUint32(base, true);
            const payload1 = view.getUint32(base + 4, true);
            const payload2 = view.getFloat64(base + 8, true);
            result.push(decode(kind, payload1, payload2, memory));
        }
        return result;
    };
    // A helper function to encode a RawJSValue into a pointers.
    // Please prefer to use `writeAndReturnKindBits` to avoid unnecessary
    // memory stores.
    // This function should be used only when kind flag is stored in memory.
    const write = (value, kind_ptr, payload1_ptr, payload2_ptr, is_exception, memory) => {
        const kind = writeAndReturnKindBits(value, payload1_ptr, payload2_ptr, is_exception, memory);
        memory.writeUint32(kind_ptr, kind);
    };
    const writeAndReturnKindBits = (value, payload1_ptr, payload2_ptr, is_exception, memory) => {
        const exceptionBit = (is_exception ? 1 : 0) << 31;
        if (value === null) {
            return exceptionBit | 4 /* Kind.Null */;
        }
        const writeRef = (kind) => {
            memory.writeUint32(payload1_ptr, memory.retain(value));
            return exceptionBit | kind;
        };
        const type = typeof value;
        switch (type) {
            case "boolean": {
                memory.writeUint32(payload1_ptr, value ? 1 : 0);
                return exceptionBit | 0 /* Kind.Boolean */;
            }
            case "number": {
                memory.writeFloat64(payload2_ptr, value);
                return exceptionBit | 2 /* Kind.Number */;
            }
            case "string": {
                return writeRef(1 /* Kind.String */);
            }
            case "undefined": {
                return exceptionBit | 5 /* Kind.Undefined */;
            }
            case "object": {
                return writeRef(3 /* Kind.Object */);
            }
            case "function": {
                return writeRef(6 /* Kind.Function */);
            }
            case "symbol": {
                return writeRef(7 /* Kind.Symbol */);
            }
            case "bigint": {
                return writeRef(8 /* Kind.BigInt */);
            }
            default:
                assertNever(type, `Type "${type}" is not supported yet`);
        }
        throw new Error("Unreachable");
    };
    function decodeObjectRefs(ptr, length, memory) {
        const result = new Array(length);
        for (let i = 0; i < length; i++) {
            result[i] = memory.readUint32(ptr + 4 * i);
        }
        return result;
    }

    let globalVariable;
    if (typeof globalThis !== "undefined") {
        globalVariable = globalThis;
    }
    else if (typeof window !== "undefined") {
        globalVariable = window;
    }
    else if (typeof global !== "undefined") {
        globalVariable = global;
    }
    else if (typeof self !== "undefined") {
        globalVariable = self;
    }

    class SwiftRuntimeHeap {
        constructor() {
            this._heapValueById = new Map();
            this._heapValueById.set(0, globalVariable);
            this._heapEntryByValue = new Map();
            this._heapEntryByValue.set(globalVariable, { id: 0, rc: 1 });
            // Note: 0 is preserved for global
            this._heapNextKey = 1;
        }
        retain(value) {
            const entry = this._heapEntryByValue.get(value);
            if (entry) {
                entry.rc++;
                return entry.id;
            }
            const id = this._heapNextKey++;
            this._heapValueById.set(id, value);
            this._heapEntryByValue.set(value, { id: id, rc: 1 });
            return id;
        }
        release(ref) {
            const value = this._heapValueById.get(ref);
            const entry = this._heapEntryByValue.get(value);
            entry.rc--;
            if (entry.rc != 0)
                return;
            this._heapEntryByValue.delete(value);
            this._heapValueById.delete(ref);
        }
        referenceHeap(ref) {
            const value = this._heapValueById.get(ref);
            if (value === undefined) {
                throw new ReferenceError("Attempted to read invalid reference " + ref);
            }
            return value;
        }
    }

    class Memory {
        constructor(exports) {
            this.heap = new SwiftRuntimeHeap();
            this.retain = (value) => this.heap.retain(value);
            this.getObject = (ref) => this.heap.referenceHeap(ref);
            this.release = (ref) => this.heap.release(ref);
            this.bytes = () => new Uint8Array(this.rawMemory.buffer);
            this.dataView = () => new DataView(this.rawMemory.buffer);
            this.writeBytes = (ptr, bytes) => this.bytes().set(bytes, ptr);
            this.readUint32 = (ptr) => this.dataView().getUint32(ptr, true);
            this.readUint64 = (ptr) => this.dataView().getBigUint64(ptr, true);
            this.readInt64 = (ptr) => this.dataView().getBigInt64(ptr, true);
            this.readFloat64 = (ptr) => this.dataView().getFloat64(ptr, true);
            this.writeUint32 = (ptr, value) => this.dataView().setUint32(ptr, value, true);
            this.writeUint64 = (ptr, value) => this.dataView().setBigUint64(ptr, value, true);
            this.writeInt64 = (ptr, value) => this.dataView().setBigInt64(ptr, value, true);
            this.writeFloat64 = (ptr, value) => this.dataView().setFloat64(ptr, value, true);
            this.rawMemory = exports.memory;
        }
    }

    class ITCInterface {
        constructor(memory) {
            this.memory = memory;
        }
        send(sendingObject, transferringObjects, sendingContext) {
            const object = this.memory.getObject(sendingObject);
            const transfer = transferringObjects.map(ref => this.memory.getObject(ref));
            return { object, sendingContext, transfer };
        }
        sendObjects(sendingObjects, transferringObjects, sendingContext) {
            const objects = sendingObjects.map(ref => this.memory.getObject(ref));
            const transfer = transferringObjects.map(ref => this.memory.getObject(ref));
            return { object: objects, sendingContext, transfer };
        }
        release(objectRef) {
            this.memory.release(objectRef);
            return { object: undefined, transfer: [] };
        }
    }
    class MessageBroker {
        constructor(selfTid, threadChannel, handlers) {
            this.selfTid = selfTid;
            this.threadChannel = threadChannel;
            this.handlers = handlers;
        }
        request(message) {
            if (message.data.targetTid == this.selfTid) {
                // The request is for the current thread
                this.handlers.onRequest(message);
            }
            else if ("postMessageToWorkerThread" in this.threadChannel) {
                // The request is for another worker thread sent from the main thread
                this.threadChannel.postMessageToWorkerThread(message.data.targetTid, message, []);
            }
            else if ("postMessageToMainThread" in this.threadChannel) {
                // The request is for other worker threads or the main thread sent from a worker thread
                this.threadChannel.postMessageToMainThread(message, []);
            }
            else {
                throw new Error("unreachable");
            }
        }
        reply(message) {
            if (message.data.sourceTid == this.selfTid) {
                // The response is for the current thread
                this.handlers.onResponse(message);
                return;
            }
            const transfer = message.data.response.ok ? message.data.response.value.transfer : [];
            if ("postMessageToWorkerThread" in this.threadChannel) {
                // The response is for another worker thread sent from the main thread
                this.threadChannel.postMessageToWorkerThread(message.data.sourceTid, message, transfer);
            }
            else if ("postMessageToMainThread" in this.threadChannel) {
                // The response is for other worker threads or the main thread sent from a worker thread
                this.threadChannel.postMessageToMainThread(message, transfer);
            }
            else {
                throw new Error("unreachable");
            }
        }
        onReceivingRequest(message) {
            if (message.data.targetTid == this.selfTid) {
                this.handlers.onRequest(message);
            }
            else if ("postMessageToWorkerThread" in this.threadChannel) {
                // Receive a request from a worker thread to other worker on main thread. 
                // Proxy the request to the target worker thread.
                this.threadChannel.postMessageToWorkerThread(message.data.targetTid, message, []);
            }
            else if ("postMessageToMainThread" in this.threadChannel) {
                // A worker thread won't receive a request for other worker threads
                throw new Error("unreachable");
            }
        }
        onReceivingResponse(message) {
            if (message.data.sourceTid == this.selfTid) {
                this.handlers.onResponse(message);
            }
            else if ("postMessageToWorkerThread" in this.threadChannel) {
                // Receive a response from a worker thread to other worker on main thread.
                // Proxy the response to the target worker thread.
                const transfer = message.data.response.ok ? message.data.response.value.transfer : [];
                this.threadChannel.postMessageToWorkerThread(message.data.sourceTid, message, transfer);
            }
            else if ("postMessageToMainThread" in this.threadChannel) {
                // A worker thread won't receive a response for other worker threads
                throw new Error("unreachable");
            }
        }
    }
    function serializeError(error) {
        if (error instanceof Error) {
            return { isError: true, value: { message: error.message, name: error.name, stack: error.stack } };
        }
        return { isError: false, value: error };
    }
    function deserializeError(error) {
        if (error.isError) {
            return Object.assign(new Error(error.value.message), error.value);
        }
        return error.value;
    }

    class SwiftRuntime {
        constructor(options) {
            this.version = 708;
            this.textDecoder = new TextDecoder("utf-8");
            this.textEncoder = new TextEncoder(); // Only support utf-8
            /** @deprecated Use `wasmImports` instead */
            this.importObjects = () => this.wasmImports;
            this._instance = null;
            this._memory = null;
            this._closureDeallocator = null;
            this.tid = null;
            this.options = options || {};
        }
        setInstance(instance) {
            this._instance = instance;
            if (typeof this.exports._start === "function") {
                throw new Error(`JavaScriptKit supports only WASI reactor ABI.
                Please make sure you are building with:
                -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor
                `);
            }
            if (this.exports.swjs_library_version() != this.version) {
                throw new Error(`The versions of JavaScriptKit are incompatible.
                WebAssembly runtime ${this.exports.swjs_library_version()} != JS runtime ${this.version}`);
            }
        }
        main() {
            const instance = this.instance;
            try {
                if (typeof instance.exports.main === "function") {
                    instance.exports.main();
                }
                else if (typeof instance.exports.__main_argc_argv === "function") {
                    // Swift 6.0 and later use `__main_argc_argv` instead of `main`.
                    instance.exports.__main_argc_argv(0, 0);
                }
            }
            catch (error) {
                if (error instanceof UnsafeEventLoopYield) {
                    // Ignore the error
                    return;
                }
                // Rethrow other errors
                throw error;
            }
        }
        /**
         * Start a new thread with the given `tid` and `startArg`, which
         * is forwarded to the `wasi_thread_start` function.
         * This function is expected to be called from the spawned Web Worker thread.
         */
        startThread(tid, startArg) {
            this.tid = tid;
            const instance = this.instance;
            try {
                if (typeof instance.exports.wasi_thread_start === "function") {
                    instance.exports.wasi_thread_start(tid, startArg);
                }
                else {
                    throw new Error(`The WebAssembly module is not built for wasm32-unknown-wasip1-threads target.`);
                }
            }
            catch (error) {
                if (error instanceof UnsafeEventLoopYield) {
                    // Ignore the error
                    return;
                }
                // Rethrow other errors
                throw error;
            }
        }
        get instance() {
            if (!this._instance)
                throw new Error("WebAssembly instance is not set yet");
            return this._instance;
        }
        get exports() {
            return this.instance.exports;
        }
        get memory() {
            if (!this._memory) {
                this._memory = new Memory(this.instance.exports);
            }
            return this._memory;
        }
        get closureDeallocator() {
            if (this._closureDeallocator)
                return this._closureDeallocator;
            const features = this.exports.swjs_library_features();
            const librarySupportsWeakRef = (features & 1 /* LibraryFeatures.WeakRefs */) != 0;
            if (librarySupportsWeakRef) {
                this._closureDeallocator = new SwiftClosureDeallocator(this.exports);
            }
            return this._closureDeallocator;
        }
        callHostFunction(host_func_id, line, file, args) {
            const argc = args.length;
            const argv = this.exports.swjs_prepare_host_function_call(argc);
            const memory = this.memory;
            for (let index = 0; index < args.length; index++) {
                const argument = args[index];
                const base = argv + 16 * index;
                write(argument, base, base + 4, base + 8, false, memory);
            }
            let output;
            // This ref is released by the swjs_call_host_function implementation
            const callback_func_ref = memory.retain((result) => {
                output = result;
            });
            const alreadyReleased = this.exports.swjs_call_host_function(host_func_id, argv, argc, callback_func_ref);
            if (alreadyReleased) {
                throw new Error(`The JSClosure has been already released by Swift side. The closure is created at ${file}:${line}`);
            }
            this.exports.swjs_cleanup_host_function_call(argv);
            return output;
        }
        get wasmImports() {
            let broker = null;
            const getMessageBroker = (threadChannel) => {
                var _a;
                if (broker)
                    return broker;
                const itcInterface = new ITCInterface(this.memory);
                const newBroker = new MessageBroker((_a = this.tid) !== null && _a !== void 0 ? _a : -1, threadChannel, {
                    onRequest: (message) => {
                        let returnValue;
                        try {
                            // @ts-ignore
                            const result = itcInterface[message.data.request.method](...message.data.request.parameters);
                            returnValue = { ok: true, value: result };
                        }
                        catch (error) {
                            returnValue = { ok: false, error: serializeError(error) };
                        }
                        const responseMessage = {
                            type: "response",
                            data: {
                                sourceTid: message.data.sourceTid,
                                context: message.data.context,
                                response: returnValue,
                            },
                        };
                        try {
                            newBroker.reply(responseMessage);
                        }
                        catch (error) {
                            responseMessage.data.response = {
                                ok: false,
                                error: serializeError(new TypeError(`Failed to serialize message: ${error}`))
                            };
                            newBroker.reply(responseMessage);
                        }
                    },
                    onResponse: (message) => {
                        if (message.data.response.ok) {
                            const object = this.memory.retain(message.data.response.value.object);
                            this.exports.swjs_receive_response(object, message.data.context);
                        }
                        else {
                            const error = deserializeError(message.data.response.error);
                            const errorObject = this.memory.retain(error);
                            this.exports.swjs_receive_error(errorObject, message.data.context);
                        }
                    }
                });
                broker = newBroker;
                return newBroker;
            };
            return {
                swjs_set_prop: (ref, name, kind, payload1, payload2) => {
                    const memory = this.memory;
                    const obj = memory.getObject(ref);
                    const key = memory.getObject(name);
                    const value = decode(kind, payload1, payload2, memory);
                    obj[key] = value;
                },
                swjs_get_prop: (ref, name, payload1_ptr, payload2_ptr) => {
                    const memory = this.memory;
                    const obj = memory.getObject(ref);
                    const key = memory.getObject(name);
                    const result = obj[key];
                    return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, memory);
                },
                swjs_set_subscript: (ref, index, kind, payload1, payload2) => {
                    const memory = this.memory;
                    const obj = memory.getObject(ref);
                    const value = decode(kind, payload1, payload2, memory);
                    obj[index] = value;
                },
                swjs_get_subscript: (ref, index, payload1_ptr, payload2_ptr) => {
                    const obj = this.memory.getObject(ref);
                    const result = obj[index];
                    return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
                },
                swjs_encode_string: (ref, bytes_ptr_result) => {
                    const memory = this.memory;
                    const bytes = this.textEncoder.encode(memory.getObject(ref));
                    const bytes_ptr = memory.retain(bytes);
                    memory.writeUint32(bytes_ptr_result, bytes_ptr);
                    return bytes.length;
                },
                swjs_decode_string: (
                // NOTE: TextDecoder can't decode typed arrays backed by SharedArrayBuffer
                this.options.sharedMemory == true
                    ? ((bytes_ptr, length) => {
                        const memory = this.memory;
                        const bytes = memory
                            .bytes()
                            .slice(bytes_ptr, bytes_ptr + length);
                        const string = this.textDecoder.decode(bytes);
                        return memory.retain(string);
                    })
                    : ((bytes_ptr, length) => {
                        const memory = this.memory;
                        const bytes = memory
                            .bytes()
                            .subarray(bytes_ptr, bytes_ptr + length);
                        const string = this.textDecoder.decode(bytes);
                        return memory.retain(string);
                    })),
                swjs_load_string: (ref, buffer) => {
                    const memory = this.memory;
                    const bytes = memory.getObject(ref);
                    memory.writeBytes(buffer, bytes);
                },
                swjs_call_function: (ref, argv, argc, payload1_ptr, payload2_ptr) => {
                    const memory = this.memory;
                    const func = memory.getObject(ref);
                    let result = undefined;
                    try {
                        const args = decodeArray(argv, argc, memory);
                        result = func(...args);
                    }
                    catch (error) {
                        return writeAndReturnKindBits(error, payload1_ptr, payload2_ptr, true, this.memory);
                    }
                    return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
                },
                swjs_call_function_no_catch: (ref, argv, argc, payload1_ptr, payload2_ptr) => {
                    const memory = this.memory;
                    const func = memory.getObject(ref);
                    const args = decodeArray(argv, argc, memory);
                    const result = func(...args);
                    return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
                },
                swjs_call_function_with_this: (obj_ref, func_ref, argv, argc, payload1_ptr, payload2_ptr) => {
                    const memory = this.memory;
                    const obj = memory.getObject(obj_ref);
                    const func = memory.getObject(func_ref);
                    let result;
                    try {
                        const args = decodeArray(argv, argc, memory);
                        result = func.apply(obj, args);
                    }
                    catch (error) {
                        return writeAndReturnKindBits(error, payload1_ptr, payload2_ptr, true, this.memory);
                    }
                    return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
                },
                swjs_call_function_with_this_no_catch: (obj_ref, func_ref, argv, argc, payload1_ptr, payload2_ptr) => {
                    const memory = this.memory;
                    const obj = memory.getObject(obj_ref);
                    const func = memory.getObject(func_ref);
                    let result = undefined;
                    const args = decodeArray(argv, argc, memory);
                    result = func.apply(obj, args);
                    return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
                },
                swjs_call_new: (ref, argv, argc) => {
                    const memory = this.memory;
                    const constructor = memory.getObject(ref);
                    const args = decodeArray(argv, argc, memory);
                    const instance = new constructor(...args);
                    return this.memory.retain(instance);
                },
                swjs_call_throwing_new: (ref, argv, argc, exception_kind_ptr, exception_payload1_ptr, exception_payload2_ptr) => {
                    let memory = this.memory;
                    const constructor = memory.getObject(ref);
                    let result;
                    try {
                        const args = decodeArray(argv, argc, memory);
                        result = new constructor(...args);
                    }
                    catch (error) {
                        write(error, exception_kind_ptr, exception_payload1_ptr, exception_payload2_ptr, true, this.memory);
                        return -1;
                    }
                    memory = this.memory;
                    write(null, exception_kind_ptr, exception_payload1_ptr, exception_payload2_ptr, false, memory);
                    return memory.retain(result);
                },
                swjs_instanceof: (obj_ref, constructor_ref) => {
                    const memory = this.memory;
                    const obj = memory.getObject(obj_ref);
                    const constructor = memory.getObject(constructor_ref);
                    return obj instanceof constructor;
                },
                swjs_value_equals: (lhs_ref, rhs_ref) => {
                    const memory = this.memory;
                    const lhs = memory.getObject(lhs_ref);
                    const rhs = memory.getObject(rhs_ref);
                    return lhs == rhs;
                },
                swjs_create_function: (host_func_id, line, file) => {
                    var _a;
                    const fileString = this.memory.getObject(file);
                    const func = (...args) => this.callHostFunction(host_func_id, line, fileString, args);
                    const func_ref = this.memory.retain(func);
                    (_a = this.closureDeallocator) === null || _a === void 0 ? void 0 : _a.track(func, func_ref);
                    return func_ref;
                },
                swjs_create_typed_array: (constructor_ref, elementsPtr, length) => {
                    const ArrayType = this.memory.getObject(constructor_ref);
                    if (length == 0) {
                        // The elementsPtr can be unaligned in Swift's Array
                        // implementation when the array is empty. However,
                        // TypedArray requires the pointer to be aligned.
                        // So, we need to create a new empty array without
                        // using the elementsPtr.
                        // See https://github.com/swiftwasm/swift/issues/5599
                        return this.memory.retain(new ArrayType());
                    }
                    const array = new ArrayType(this.memory.rawMemory.buffer, elementsPtr, length);
                    // Call `.slice()` to copy the memory
                    return this.memory.retain(array.slice());
                },
                swjs_create_object: () => { return this.memory.retain({}); },
                swjs_load_typed_array: (ref, buffer) => {
                    const memory = this.memory;
                    const typedArray = memory.getObject(ref);
                    const bytes = new Uint8Array(typedArray.buffer);
                    memory.writeBytes(buffer, bytes);
                },
                swjs_release: (ref) => {
                    this.memory.release(ref);
                },
                swjs_release_remote: (tid, ref) => {
                    var _a;
                    if (!this.options.threadChannel) {
                        throw new Error("threadChannel is not set in options given to SwiftRuntime. Please set it to release objects on remote threads.");
                    }
                    const broker = getMessageBroker(this.options.threadChannel);
                    broker.request({
                        type: "request",
                        data: {
                            sourceTid: (_a = this.tid) !== null && _a !== void 0 ? _a : MAIN_THREAD_TID,
                            targetTid: tid,
                            context: 0,
                            request: {
                                method: "release",
                                parameters: [ref],
                            }
                        }
                    });
                },
                swjs_i64_to_bigint: (value, signed) => {
                    return this.memory.retain(signed ? value : BigInt.asUintN(64, value));
                },
                swjs_bigint_to_i64: (ref, signed) => {
                    const object = this.memory.getObject(ref);
                    if (typeof object !== "bigint") {
                        throw new Error(`Expected a BigInt, but got ${typeof object}`);
                    }
                    if (signed) {
                        return object;
                    }
                    else {
                        if (object < BigInt(0)) {
                            return BigInt(0);
                        }
                        return BigInt.asIntN(64, object);
                    }
                },
                swjs_i64_to_bigint_slow: (lower, upper, signed) => {
                    const value = BigInt.asUintN(32, BigInt(lower)) +
                        (BigInt.asUintN(32, BigInt(upper)) << BigInt(32));
                    return this.memory.retain(signed ? BigInt.asIntN(64, value) : BigInt.asUintN(64, value));
                },
                swjs_unsafe_event_loop_yield: () => {
                    throw new UnsafeEventLoopYield();
                },
                swjs_send_job_to_main_thread: (unowned_job) => {
                    this.postMessageToMainThread({ type: "job", data: unowned_job });
                },
                swjs_listen_message_from_main_thread: () => {
                    const threadChannel = this.options.threadChannel;
                    if (!(threadChannel && "listenMessageFromMainThread" in threadChannel)) {
                        throw new Error("listenMessageFromMainThread is not set in options given to SwiftRuntime. Please set it to listen to wake events from the main thread.");
                    }
                    const broker = getMessageBroker(threadChannel);
                    threadChannel.listenMessageFromMainThread((message) => {
                        switch (message.type) {
                            case "wake":
                                this.exports.swjs_wake_worker_thread();
                                break;
                            case "request": {
                                broker.onReceivingRequest(message);
                                break;
                            }
                            case "response": {
                                broker.onReceivingResponse(message);
                                break;
                            }
                            default:
                                const unknownMessage = message;
                                throw new Error(`Unknown message type: ${unknownMessage}`);
                        }
                    });
                },
                swjs_wake_up_worker_thread: (tid) => {
                    this.postMessageToWorkerThread(tid, { type: "wake" });
                },
                swjs_listen_message_from_worker_thread: (tid) => {
                    const threadChannel = this.options.threadChannel;
                    if (!(threadChannel && "listenMessageFromWorkerThread" in threadChannel)) {
                        throw new Error("listenMessageFromWorkerThread is not set in options given to SwiftRuntime. Please set it to listen to jobs from worker threads.");
                    }
                    const broker = getMessageBroker(threadChannel);
                    threadChannel.listenMessageFromWorkerThread(tid, (message) => {
                        switch (message.type) {
                            case "job":
                                this.exports.swjs_enqueue_main_job_from_worker(message.data);
                                break;
                            case "request": {
                                broker.onReceivingRequest(message);
                                break;
                            }
                            case "response": {
                                broker.onReceivingResponse(message);
                                break;
                            }
                            default:
                                const unknownMessage = message;
                                throw new Error(`Unknown message type: ${unknownMessage}`);
                        }
                    });
                },
                swjs_terminate_worker_thread: (tid) => {
                    var _a;
                    const threadChannel = this.options.threadChannel;
                    if (threadChannel && "terminateWorkerThread" in threadChannel) {
                        (_a = threadChannel.terminateWorkerThread) === null || _a === void 0 ? void 0 : _a.call(threadChannel, tid);
                    } // Otherwise, just ignore the termination request
                },
                swjs_get_worker_thread_id: () => {
                    // Main thread's tid is always -1
                    return this.tid || -1;
                },
                swjs_request_sending_object: (sending_object, transferring_objects, transferring_objects_count, object_source_tid, sending_context) => {
                    var _a;
                    if (!this.options.threadChannel) {
                        throw new Error("threadChannel is not set in options given to SwiftRuntime. Please set it to request transferring objects.");
                    }
                    const broker = getMessageBroker(this.options.threadChannel);
                    const memory = this.memory;
                    const transferringObjects = decodeObjectRefs(transferring_objects, transferring_objects_count, memory);
                    broker.request({
                        type: "request",
                        data: {
                            sourceTid: (_a = this.tid) !== null && _a !== void 0 ? _a : MAIN_THREAD_TID,
                            targetTid: object_source_tid,
                            context: sending_context,
                            request: {
                                method: "send",
                                parameters: [sending_object, transferringObjects, sending_context],
                            }
                        }
                    });
                },
                swjs_request_sending_objects: (sending_objects, sending_objects_count, transferring_objects, transferring_objects_count, object_source_tid, sending_context) => {
                    var _a;
                    if (!this.options.threadChannel) {
                        throw new Error("threadChannel is not set in options given to SwiftRuntime. Please set it to request transferring objects.");
                    }
                    const broker = getMessageBroker(this.options.threadChannel);
                    const memory = this.memory;
                    const sendingObjects = decodeObjectRefs(sending_objects, sending_objects_count, memory);
                    const transferringObjects = decodeObjectRefs(transferring_objects, transferring_objects_count, memory);
                    broker.request({
                        type: "request",
                        data: {
                            sourceTid: (_a = this.tid) !== null && _a !== void 0 ? _a : MAIN_THREAD_TID,
                            targetTid: object_source_tid,
                            context: sending_context,
                            request: {
                                method: "sendObjects",
                                parameters: [sendingObjects, transferringObjects, sending_context],
                            }
                        }
                    });
                },
            };
        }
        postMessageToMainThread(message, transfer = []) {
            const threadChannel = this.options.threadChannel;
            if (!(threadChannel && "postMessageToMainThread" in threadChannel)) {
                throw new Error("postMessageToMainThread is not set in options given to SwiftRuntime. Please set it to send messages to the main thread.");
            }
            threadChannel.postMessageToMainThread(message, transfer);
        }
        postMessageToWorkerThread(tid, message, transfer = []) {
            const threadChannel = this.options.threadChannel;
            if (!(threadChannel && "postMessageToWorkerThread" in threadChannel)) {
                throw new Error("postMessageToWorkerThread is not set in options given to SwiftRuntime. Please set it to send messages to worker threads.");
            }
            threadChannel.postMessageToWorkerThread(tid, message, transfer);
        }
    }
    /// This error is thrown when yielding event loop control from `swift_task_asyncMainDrainQueue`
    /// to JavaScript. This is usually thrown when:
    /// - The entry point of the Swift program is `func main() async`
    /// - The Swift Concurrency's global executor is hooked by `JavaScriptEventLoop.installGlobalExecutor()`
    /// - Calling exported `main` or `__main_argc_argv` function from JavaScript
    ///
    /// This exception must be caught by the caller of the exported function and the caller should
    /// catch this exception and just ignore it.
    ///
    /// FAQ: Why this error is thrown?
    /// This error is thrown to unwind the call stack of the Swift program and return the control to
    /// the JavaScript side. Otherwise, the `swift_task_asyncMainDrainQueue` ends up with `abort()`
    /// because the event loop expects `exit()` call before the end of the event loop.
    class UnsafeEventLoopYield extends Error {
    }

    exports.SwiftRuntime = SwiftRuntime;

}));
