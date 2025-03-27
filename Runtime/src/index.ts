import { SwiftClosureDeallocator } from "./closure-heap.js";
import {
    LibraryFeatures,
    ExportedFunctions,
    ref,
    pointer,
    TypedArray,
    MAIN_THREAD_TID,
} from "./types.js";
import * as JSValue from "./js-value.js";
import { Memory } from "./memory.js";
import { deserializeError, MainToWorkerMessage, MessageBroker, ResponseMessage, ITCInterface, serializeError, SwiftRuntimeThreadChannel, WorkerToMainMessage } from "./itc.js";
import { decodeObjectRefs } from "./js-value.js";
export { SwiftRuntimeThreadChannel };

export type SwiftRuntimeOptions = {
    /**
     * If `true`, the memory space of the WebAssembly instance can be shared
     * between the main thread and the worker thread.
     */
    sharedMemory?: boolean;
    /**
     * The thread channel is a set of functions that are used to communicate
     * between the main thread and the worker thread.
     */
    threadChannel?: SwiftRuntimeThreadChannel;
};

export class SwiftRuntime {
    private _instance: WebAssembly.Instance | null;
    private _memory: Memory | null;
    private _closureDeallocator: SwiftClosureDeallocator | null;
    private options: SwiftRuntimeOptions;
    private version: number = 708;

    private textDecoder = new TextDecoder("utf-8");
    private textEncoder = new TextEncoder(); // Only support utf-8
    /** The thread ID of the current thread. */
    private tid: number | null;

    constructor(options?: SwiftRuntimeOptions) {
        this._instance = null;
        this._memory = null;
        this._closureDeallocator = null;
        this.tid = null;
        this.options = options || {};
    }

    setInstance(instance: WebAssembly.Instance) {
        this._instance = instance;
        if (typeof (this.exports as any)._start === "function") {
            throw new Error(
                `JavaScriptKit supports only WASI reactor ABI.
                Please make sure you are building with:
                -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor
                `
            );
        }
        if (this.exports.swjs_library_version() != this.version) {
            throw new Error(
                `The versions of JavaScriptKit are incompatible.
                WebAssembly runtime ${this.exports.swjs_library_version()} != JS runtime ${
                    this.version
                }`
            );
        }
    }

    main() {
        const instance = this.instance;
        try {
            if (typeof instance.exports.main === "function") {
                instance.exports.main();
            } else if (
                typeof instance.exports.__main_argc_argv === "function"
            ) {
                // Swift 6.0 and later use `__main_argc_argv` instead of `main`.
                instance.exports.__main_argc_argv(0, 0);
            }
        } catch (error) {
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
    startThread(tid: number, startArg: number) {
        this.tid = tid;
        const instance = this.instance;
        try {
            if (typeof instance.exports.wasi_thread_start === "function") {
                instance.exports.wasi_thread_start(tid, startArg);
            } else {
                throw new Error(
                    `The WebAssembly module is not built for wasm32-unknown-wasip1-threads target.`
                );
            }
        } catch (error) {
            if (error instanceof UnsafeEventLoopYield) {
                // Ignore the error
                return;
            }
            // Rethrow other errors
            throw error;
        }
    }

    private get instance() {
        if (!this._instance)
            throw new Error("WebAssembly instance is not set yet");
        return this._instance;
    }

    private get exports() {
        return this.instance.exports as any as ExportedFunctions;
    }

    private get memory() {
        if (!this._memory) {
            this._memory = new Memory(this.instance.exports);
        }
        return this._memory;
    }

    private get closureDeallocator(): SwiftClosureDeallocator | null {
        if (this._closureDeallocator) return this._closureDeallocator;

        const features = this.exports.swjs_library_features();
        const librarySupportsWeakRef =
            (features & LibraryFeatures.WeakRefs) != 0;
        if (librarySupportsWeakRef) {
            this._closureDeallocator = new SwiftClosureDeallocator(
                this.exports
            );
        }
        return this._closureDeallocator;
    }

    private callHostFunction(
        host_func_id: number,
        line: number,
        file: string,
        args: any[]
    ) {
        const argc = args.length;
        const argv = this.exports.swjs_prepare_host_function_call(argc);
        const memory = this.memory;
        for (let index = 0; index < args.length; index++) {
            const argument = args[index];
            const base = argv + 16 * index;
            JSValue.write(argument, base, base + 4, base + 8, false, memory);
        }
        let output: any;
        // This ref is released by the swjs_call_host_function implementation
        const callback_func_ref = memory.retain((result: any) => {
            output = result;
        });
        const alreadyReleased = this.exports.swjs_call_host_function(
            host_func_id,
            argv,
            argc,
            callback_func_ref
        );
        if (alreadyReleased) {
            throw new Error(
                `The JSClosure has been already released by Swift side. The closure is created at ${file}:${line}`
            );
        }
        this.exports.swjs_cleanup_host_function_call(argv);
        return output;
    }

    /** @deprecated Use `wasmImports` instead */
    importObjects = () => this.wasmImports;

    get wasmImports(): WebAssembly.ModuleImports {
        let broker: MessageBroker | null = null;
        const getMessageBroker = (threadChannel: SwiftRuntimeThreadChannel) => {
            if (broker) return broker;
            const itcInterface = new ITCInterface(this.memory);
            const newBroker = new MessageBroker(this.tid ?? -1, threadChannel, {
                onRequest: (message) => {
                    let returnValue: ResponseMessage["data"]["response"];
                    try {
                        // @ts-ignore
                        const result = itcInterface[message.data.request.method](...message.data.request.parameters);
                        returnValue = { ok: true, value: result };
                    } catch (error) {
                        returnValue = { ok: false, error: serializeError(error) };
                    }
                    const responseMessage: ResponseMessage = {
                        type: "response",
                        data: {
                            sourceTid: message.data.sourceTid,
                            context: message.data.context,
                            response: returnValue,
                        },
                    }
                    try {
                        newBroker.reply(responseMessage);
                    } catch (error) {
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
                    } else {
                        const error = deserializeError(message.data.response.error);
                        const errorObject = this.memory.retain(error);
                        this.exports.swjs_receive_error(errorObject, message.data.context);
                    }
                }
            })
            broker = newBroker;
            return newBroker;
        }
        return {
            swjs_set_prop: (
                ref: ref,
                name: ref,
                kind: JSValue.Kind,
                payload1: number,
                payload2: number
            ) => {
                const memory = this.memory;
                const obj = memory.getObject(ref);
                const key = memory.getObject(name);
                const value = JSValue.decode(kind, payload1, payload2, memory);
                obj[key] = value;
            },
            swjs_get_prop: (
                ref: ref,
                name: ref,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const memory = this.memory;
                const obj = memory.getObject(ref);
                const key = memory.getObject(name);
                const result = obj[key];
                return JSValue.writeAndReturnKindBits(
                    result,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    memory
                );
            },

            swjs_set_subscript: (
                ref: ref,
                index: number,
                kind: JSValue.Kind,
                payload1: number,
                payload2: number
            ) => {
                const memory = this.memory;
                const obj = memory.getObject(ref);
                const value = JSValue.decode(kind, payload1, payload2, memory);
                obj[index] = value;
            },
            swjs_get_subscript: (
                ref: ref,
                index: number,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const obj = this.memory.getObject(ref);
                const result = obj[index];
                return JSValue.writeAndReturnKindBits(
                    result,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
            },

            swjs_encode_string: (ref: ref, bytes_ptr_result: pointer) => {
                const memory = this.memory;
                const bytes = this.textEncoder.encode(memory.getObject(ref));
                const bytes_ptr = memory.retain(bytes);
                memory.writeUint32(bytes_ptr_result, bytes_ptr);
                return bytes.length;
            },
            swjs_decode_string: (
                // NOTE: TextDecoder can't decode typed arrays backed by SharedArrayBuffer
                this.options.sharedMemory == true
                ? ((bytes_ptr: pointer, length: number) => {
                    const memory = this.memory;
                    const bytes = memory
                        .bytes()
                        .slice(bytes_ptr, bytes_ptr + length);
                    const string = this.textDecoder.decode(bytes);
                    return memory.retain(string);
                })
                : ((bytes_ptr: pointer, length: number) => {
                    const memory = this.memory;
                    const bytes = memory
                        .bytes()
                        .subarray(bytes_ptr, bytes_ptr + length);
                    const string = this.textDecoder.decode(bytes);
                    return memory.retain(string);
                })
            ),
            swjs_load_string: (ref: ref, buffer: pointer) => {
                const memory = this.memory;
                const bytes = memory.getObject(ref);
                memory.writeBytes(buffer, bytes);
            },

            swjs_call_function: (
                ref: ref,
                argv: pointer,
                argc: number,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const memory = this.memory;
                const func = memory.getObject(ref);
                let result = undefined;
                try {
                    const args = JSValue.decodeArray(argv, argc, memory);
                    result = func(...args);
                } catch (error) {
                    return JSValue.writeAndReturnKindBits(
                        error,
                        payload1_ptr,
                        payload2_ptr,
                        true,
                        this.memory
                    );
                }
                return JSValue.writeAndReturnKindBits(
                    result,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
            },
            swjs_call_function_no_catch: (
                ref: ref,
                argv: pointer,
                argc: number,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const memory = this.memory;
                const func = memory.getObject(ref);
                const args = JSValue.decodeArray(argv, argc, memory);
                const result = func(...args);
                return JSValue.writeAndReturnKindBits(
                    result,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
            },

            swjs_call_function_with_this: (
                obj_ref: ref,
                func_ref: ref,
                argv: pointer,
                argc: number,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const memory = this.memory;
                const obj = memory.getObject(obj_ref);
                const func = memory.getObject(func_ref);
                let result: any;
                try {
                    const args = JSValue.decodeArray(argv, argc, memory);
                    result = func.apply(obj, args);
                } catch (error) {
                    return JSValue.writeAndReturnKindBits(
                        error,
                        payload1_ptr,
                        payload2_ptr,
                        true,
                        this.memory
                    );
                }
                return JSValue.writeAndReturnKindBits(
                    result,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
            },
            swjs_call_function_with_this_no_catch: (
                obj_ref: ref,
                func_ref: ref,
                argv: pointer,
                argc: number,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const memory = this.memory;
                const obj = memory.getObject(obj_ref);
                const func = memory.getObject(func_ref);
                let result = undefined;
                const args = JSValue.decodeArray(argv, argc, memory);
                result = func.apply(obj, args);
                return JSValue.writeAndReturnKindBits(
                    result,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
            },

            swjs_call_new: (ref: ref, argv: pointer, argc: number) => {
                const memory = this.memory;
                const constructor = memory.getObject(ref);
                const args = JSValue.decodeArray(argv, argc, memory);
                const instance = new constructor(...args);
                return this.memory.retain(instance);
            },
            swjs_call_throwing_new: (
                ref: ref,
                argv: pointer,
                argc: number,
                exception_kind_ptr: pointer,
                exception_payload1_ptr: pointer,
                exception_payload2_ptr: pointer
            ) => {
                let memory = this.memory;
                const constructor = memory.getObject(ref);
                let result: any;
                try {
                    const args = JSValue.decodeArray(argv, argc, memory);
                    result = new constructor(...args);
                } catch (error) {
                    JSValue.write(
                        error,
                        exception_kind_ptr,
                        exception_payload1_ptr,
                        exception_payload2_ptr,
                        true,
                        this.memory
                    );
                    return -1;
                }
                memory = this.memory;
                JSValue.write(
                    null,
                    exception_kind_ptr,
                    exception_payload1_ptr,
                    exception_payload2_ptr,
                    false,
                    memory
                );
                return memory.retain(result);
            },

            swjs_instanceof: (obj_ref: ref, constructor_ref: ref) => {
                const memory = this.memory;
                const obj = memory.getObject(obj_ref);
                const constructor = memory.getObject(constructor_ref);
                return obj instanceof constructor;
            },

            swjs_value_equals: (lhs_ref: ref, rhs_ref: ref) => {
                const memory = this.memory;
                const lhs = memory.getObject(lhs_ref);
                const rhs = memory.getObject(rhs_ref);
                return lhs == rhs;
            },

            swjs_create_function: (
                host_func_id: number,
                line: number,
                file: ref
            ) => {
                const fileString = this.memory.getObject(file) as string;
                const func = (...args: any[]) =>
                    this.callHostFunction(host_func_id, line, fileString, args);
                const func_ref = this.memory.retain(func);
                this.closureDeallocator?.track(func, func_ref);
                return func_ref;
            },

            swjs_create_typed_array: (
                constructor_ref: ref,
                elementsPtr: pointer,
                length: number
            ) => {
                const ArrayType: TypedArray =
                    this.memory.getObject(constructor_ref);
                if (length == 0) {
                    // The elementsPtr can be unaligned in Swift's Array
                    // implementation when the array is empty. However,
                    // TypedArray requires the pointer to be aligned.
                    // So, we need to create a new empty array without
                    // using the elementsPtr.
                    // See https://github.com/swiftwasm/swift/issues/5599
                    return this.memory.retain(new ArrayType());
                }
                const array = new ArrayType(
                    this.memory.rawMemory.buffer,
                    elementsPtr,
                    length
                );
                // Call `.slice()` to copy the memory
                return this.memory.retain(array.slice());
            },

            swjs_create_object: () => { return this.memory.retain({}); },

            swjs_load_typed_array: (ref: ref, buffer: pointer) => {
                const memory = this.memory;
                const typedArray = memory.getObject(ref);
                const bytes = new Uint8Array(typedArray.buffer);
                memory.writeBytes(buffer, bytes);
            },

            swjs_release: (ref: ref) => {
                this.memory.release(ref);
            },

            swjs_release_remote: (tid: number, ref: ref) => {
                if (!this.options.threadChannel) {
                    throw new Error("threadChannel is not set in options given to SwiftRuntime. Please set it to release objects on remote threads.");
                }
                const broker = getMessageBroker(this.options.threadChannel);
                broker.request({
                    type: "request",
                    data: {
                        sourceTid: this.tid ?? MAIN_THREAD_TID,
                        targetTid: tid,
                        context: 0,
                        request: {
                            method: "release",
                            parameters: [ref],
                        }
                    }
                })
            },

            swjs_i64_to_bigint: (value: bigint, signed: number) => {
                return this.memory.retain(
                    signed ? value : BigInt.asUintN(64, value)
                );
            },
            swjs_bigint_to_i64: (ref: ref, signed: number) => {
                const object = this.memory.getObject(ref);
                if (typeof object !== "bigint") {
                    throw new Error(`Expected a BigInt, but got ${typeof object}`);
                }
                if (signed) {
                    return object;
                } else {
                    if (object < BigInt(0)) {
                        return BigInt(0);
                    }
                    return BigInt.asIntN(64, object);
                }
            },
            swjs_i64_to_bigint_slow: (lower: number, upper: number, signed: number) => {
                const value =
                    BigInt.asUintN(32, BigInt(lower)) +
                    (BigInt.asUintN(32, BigInt(upper)) << BigInt(32));
                return this.memory.retain(
                    signed ? BigInt.asIntN(64, value) : BigInt.asUintN(64, value)
                );
            },
            swjs_unsafe_event_loop_yield: () => {
                throw new UnsafeEventLoopYield();
            },
            swjs_send_job_to_main_thread: (unowned_job: number) => {
                this.postMessageToMainThread({ type: "job", data: unowned_job });
            },
            swjs_listen_message_from_main_thread: () => {
                const threadChannel = this.options.threadChannel;
                if (!(threadChannel && "listenMessageFromMainThread" in threadChannel)) {
                    throw new Error(
                        "listenMessageFromMainThread is not set in options given to SwiftRuntime. Please set it to listen to wake events from the main thread."
                    );
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
                        const unknownMessage: never = message;
                        throw new Error(`Unknown message type: ${unknownMessage}`);
                    }
                });
            },
            swjs_wake_up_worker_thread: (tid: number) => {
                this.postMessageToWorkerThread(tid, { type: "wake" });
            },
            swjs_listen_message_from_worker_thread: (tid: number) => {
                const threadChannel = this.options.threadChannel;
                if (!(threadChannel && "listenMessageFromWorkerThread" in threadChannel)) {
                    throw new Error(
                        "listenMessageFromWorkerThread is not set in options given to SwiftRuntime. Please set it to listen to jobs from worker threads."
                    );
                }
                const broker = getMessageBroker(threadChannel);
                threadChannel.listenMessageFromWorkerThread(
                    tid, (message) => {
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
                            const unknownMessage: never = message;
                            throw new Error(`Unknown message type: ${unknownMessage}`);
                        }
                    },
                );
            },
            swjs_terminate_worker_thread: (tid: number) => {
                const threadChannel = this.options.threadChannel;
                if (threadChannel && "terminateWorkerThread" in threadChannel) {
                    threadChannel.terminateWorkerThread?.(tid);
                } // Otherwise, just ignore the termination request
            },
            swjs_get_worker_thread_id: () => {
                // Main thread's tid is always -1
                return this.tid || -1;
            },
            swjs_request_sending_object: (
                sending_object: ref,
                transferring_objects: pointer,
                transferring_objects_count: number,
                object_source_tid: number,
                sending_context: pointer,
            ) => {
                if (!this.options.threadChannel) {
                    throw new Error("threadChannel is not set in options given to SwiftRuntime. Please set it to request transferring objects.");
                }
                const broker = getMessageBroker(this.options.threadChannel);
                const memory = this.memory;
                const transferringObjects = decodeObjectRefs(transferring_objects, transferring_objects_count, memory);
                broker.request({
                    type: "request",
                    data: {
                        sourceTid: this.tid ?? MAIN_THREAD_TID,
                        targetTid: object_source_tid,
                        context: sending_context,
                        request: {
                            method: "send",
                            parameters: [sending_object, transferringObjects, sending_context],
                        }
                    }
                })
            },
            swjs_request_sending_objects: (
                sending_objects: pointer,
                sending_objects_count: number,
                transferring_objects: pointer,
                transferring_objects_count: number,
                object_source_tid: number,
                sending_context: pointer,
            ) => {
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
                        sourceTid: this.tid ?? MAIN_THREAD_TID,
                        targetTid: object_source_tid,
                        context: sending_context,
                        request: {
                            method: "sendObjects",
                            parameters: [sendingObjects, transferringObjects, sending_context],
                        }
                    }
                })
            },
        };
    }

    private postMessageToMainThread(message: WorkerToMainMessage, transfer: any[] = []) {
        const threadChannel = this.options.threadChannel;
        if (!(threadChannel && "postMessageToMainThread" in threadChannel)) {
            throw new Error(
                "postMessageToMainThread is not set in options given to SwiftRuntime. Please set it to send messages to the main thread."
            );
        }
        threadChannel.postMessageToMainThread(message, transfer);
    }

    private postMessageToWorkerThread(tid: number, message: MainToWorkerMessage, transfer: any[] = []) {
        const threadChannel = this.options.threadChannel;
        if (!(threadChannel && "postMessageToWorkerThread" in threadChannel)) {
            throw new Error(
                "postMessageToWorkerThread is not set in options given to SwiftRuntime. Please set it to send messages to worker threads."
            );
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
class UnsafeEventLoopYield extends Error {}
