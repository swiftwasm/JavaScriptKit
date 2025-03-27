declare class Memory {
    readonly rawMemory: WebAssembly.Memory;
    private readonly heap;
    constructor(exports: WebAssembly.Exports);
    retain: (value: any) => number;
    getObject: (ref: number) => any;
    release: (ref: number) => void;
    bytes: () => Uint8Array<ArrayBuffer>;
    dataView: () => DataView<ArrayBuffer>;
    writeBytes: (ptr: pointer, bytes: Uint8Array) => void;
    readUint32: (ptr: pointer) => number;
    readUint64: (ptr: pointer) => bigint;
    readInt64: (ptr: pointer) => bigint;
    readFloat64: (ptr: pointer) => number;
    writeUint32: (ptr: pointer, value: number) => void;
    writeUint64: (ptr: pointer, value: bigint) => void;
    writeInt64: (ptr: pointer, value: bigint) => void;
    writeFloat64: (ptr: pointer, value: number) => void;
}

declare const enum Kind {
    Boolean = 0,
    String = 1,
    Number = 2,
    Object = 3,
    Null = 4,
    Undefined = 5,
    Function = 6,
    Symbol = 7,
    BigInt = 8
}

type ref = number;
type pointer = number;
type bool = number;
type JavaScriptValueKind = number;
type JavaScriptValueKindAndFlags = number;
interface ImportedFunctions {
    swjs_set_prop(ref: number, name: number, kind: Kind, payload1: number, payload2: number): void;
    swjs_get_prop(ref: number, name: number, payload1_ptr: pointer, payload2_ptr: pointer): JavaScriptValueKind;
    swjs_set_subscript(ref: number, index: number, kind: Kind, payload1: number, payload2: number): void;
    swjs_get_subscript(ref: number, index: number, payload1_ptr: pointer, payload2_ptr: pointer): JavaScriptValueKind;
    swjs_encode_string(ref: number, bytes_ptr_result: pointer): number;
    swjs_decode_string(bytes_ptr: pointer, length: number): number;
    swjs_load_string(ref: number, buffer: pointer): void;
    swjs_call_function(ref: number, argv: pointer, argc: number, payload1_ptr: pointer, payload2_ptr: pointer): JavaScriptValueKindAndFlags;
    swjs_call_function_no_catch(ref: number, argv: pointer, argc: number, payload1_ptr: pointer, payload2_ptr: pointer): JavaScriptValueKindAndFlags;
    swjs_call_function_with_this(obj_ref: ref, func_ref: ref, argv: pointer, argc: number, payload1_ptr: pointer, payload2_ptr: pointer): JavaScriptValueKindAndFlags;
    swjs_call_function_with_this_no_catch(obj_ref: ref, func_ref: ref, argv: pointer, argc: number, payload1_ptr: pointer, payload2_ptr: pointer): JavaScriptValueKindAndFlags;
    swjs_call_new(ref: number, argv: pointer, argc: number): number;
    swjs_call_throwing_new(ref: number, argv: pointer, argc: number, exception_kind_ptr: pointer, exception_payload1_ptr: pointer, exception_payload2_ptr: pointer): number;
    swjs_instanceof(obj_ref: ref, constructor_ref: ref): boolean;
    swjs_value_equals(lhs_ref: ref, rhs_ref: ref): boolean;
    swjs_create_function(host_func_id: number, line: number, file: ref): number;
    swjs_create_typed_array(constructor_ref: ref, elementsPtr: pointer, length: number): number;
    swjs_create_object(): number;
    swjs_load_typed_array(ref: ref, buffer: pointer): void;
    swjs_release(ref: number): void;
    swjs_release_remote(tid: number, ref: number): void;
    swjs_i64_to_bigint(value: bigint, signed: bool): ref;
    swjs_bigint_to_i64(ref: ref, signed: bool): bigint;
    swjs_i64_to_bigint_slow(lower: number, upper: number, signed: bool): ref;
    swjs_unsafe_event_loop_yield: () => void;
    swjs_send_job_to_main_thread: (unowned_job: number) => void;
    swjs_listen_message_from_main_thread: () => void;
    swjs_wake_up_worker_thread: (tid: number) => void;
    swjs_listen_message_from_worker_thread: (tid: number) => void;
    swjs_terminate_worker_thread: (tid: number) => void;
    swjs_get_worker_thread_id: () => number;
    swjs_request_sending_object: (sending_object: ref, transferring_objects: pointer, transferring_objects_count: number, object_source_tid: number, sending_context: pointer) => void;
    swjs_request_sending_objects: (sending_objects: pointer, sending_objects_count: number, transferring_objects: pointer, transferring_objects_count: number, object_source_tid: number, sending_context: pointer) => void;
}

/**
 * A thread channel is a set of functions that are used to communicate between
 * the main thread and the worker thread. The main thread and the worker thread
 * can send messages to each other using these functions.
 *
 * @example
 * ```javascript
 * // worker.js
 * const runtime = new SwiftRuntime({
 *   threadChannel: {
 *     postMessageToMainThread: postMessage,
 *     listenMessageFromMainThread: (listener) => {
 *       self.onmessage = (event) => {
 *         listener(event.data);
 *       };
 *     }
 *   }
 * });
 *
 * // main.js
 * const worker = new Worker("worker.js");
 * const runtime = new SwiftRuntime({
 *   threadChannel: {
 *     postMessageToWorkerThread: (tid, data) => {
 *       worker.postMessage(data);
 *     },
 *     listenMessageFromWorkerThread: (tid, listener) => {
 *       worker.onmessage = (event) => {
           listener(event.data);
 *       };
 *     }
 *   }
 * });
 * ```
 */
type SwiftRuntimeThreadChannel = {
    /**
     * This function is used to send messages from the worker thread to the main thread.
     * The message submitted by this function is expected to be listened by `listenMessageFromWorkerThread`.
     * @param message The message to be sent to the main thread.
     * @param transfer The array of objects to be transferred to the main thread.
     */
    postMessageToMainThread: (message: WorkerToMainMessage, transfer: any[]) => void;
    /**
     * This function is expected to be set in the worker thread and should listen
     * to messages from the main thread sent by `postMessageToWorkerThread`.
     * @param listener The listener function to be called when a message is received from the main thread.
     */
    listenMessageFromMainThread: (listener: (message: MainToWorkerMessage) => void) => void;
} | {
    /**
     * This function is expected to be set in the main thread.
     * The message submitted by this function is expected to be listened by `listenMessageFromMainThread`.
     * @param tid The thread ID of the worker thread.
     * @param message The message to be sent to the worker thread.
     * @param transfer The array of objects to be transferred to the worker thread.
     */
    postMessageToWorkerThread: (tid: number, message: MainToWorkerMessage, transfer: any[]) => void;
    /**
     * This function is expected to be set in the main thread and should listen
     * to messages sent by `postMessageToMainThread` from the worker thread.
     * @param tid The thread ID of the worker thread.
     * @param listener The listener function to be called when a message is received from the worker thread.
     */
    listenMessageFromWorkerThread: (tid: number, listener: (message: WorkerToMainMessage) => void) => void;
    /**
     * This function is expected to be set in the main thread and called
     * when the worker thread is terminated.
     * @param tid The thread ID of the worker thread.
     */
    terminateWorkerThread?: (tid: number) => void;
};
declare class ITCInterface {
    private memory;
    constructor(memory: Memory);
    send(sendingObject: ref, transferringObjects: ref[], sendingContext: pointer): {
        object: any;
        sendingContext: pointer;
        transfer: Transferable[];
    };
    sendObjects(sendingObjects: ref[], transferringObjects: ref[], sendingContext: pointer): {
        object: any[];
        sendingContext: pointer;
        transfer: Transferable[];
    };
    release(objectRef: ref): {
        object: undefined;
        transfer: Transferable[];
    };
}
type AllRequests<Interface extends Record<string, any>> = {
    [K in keyof Interface]: {
        method: K;
        parameters: Parameters<Interface[K]>;
    };
};
type ITCRequest<Interface extends Record<string, any>> = AllRequests<Interface>[keyof AllRequests<Interface>];
type AllResponses<Interface extends Record<string, any>> = {
    [K in keyof Interface]: ReturnType<Interface[K]>;
};
type ITCResponse<Interface extends Record<string, any>> = AllResponses<Interface>[keyof AllResponses<Interface>];
type RequestMessage = {
    type: "request";
    data: {
        /** The TID of the thread that sent the request */
        sourceTid: number;
        /** The TID of the thread that should respond to the request */
        targetTid: number;
        /** The context pointer of the request */
        context: pointer;
        /** The request content */
        request: ITCRequest<ITCInterface>;
    };
};
type SerializedError = {
    isError: true;
    value: Error;
} | {
    isError: false;
    value: unknown;
};
type ResponseMessage = {
    type: "response";
    data: {
        /** The TID of the thread that sent the response */
        sourceTid: number;
        /** The context pointer of the request */
        context: pointer;
        /** The response content */
        response: {
            ok: true;
            value: ITCResponse<ITCInterface>;
        } | {
            ok: false;
            error: SerializedError;
        };
    };
};
type MainToWorkerMessage = {
    type: "wake";
} | RequestMessage | ResponseMessage;
type WorkerToMainMessage = {
    type: "job";
    data: number;
} | RequestMessage | ResponseMessage;

type SwiftRuntimeOptions = {
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
declare class SwiftRuntime {
    private _instance;
    private _memory;
    private _closureDeallocator;
    private options;
    private version;
    private textDecoder;
    private textEncoder;
    /** The thread ID of the current thread. */
    private tid;
    constructor(options?: SwiftRuntimeOptions);
    setInstance(instance: WebAssembly.Instance): void;
    main(): void;
    /**
     * Start a new thread with the given `tid` and `startArg`, which
     * is forwarded to the `wasi_thread_start` function.
     * This function is expected to be called from the spawned Web Worker thread.
     */
    startThread(tid: number, startArg: number): void;
    private get instance();
    private get exports();
    private get memory();
    private get closureDeallocator();
    private callHostFunction;
    /** @deprecated Use `wasmImports` instead */
    importObjects: () => ImportedFunctions;
    get wasmImports(): ImportedFunctions;
    private postMessageToMainThread;
    private postMessageToWorkerThread;
}

export { SwiftRuntime };
export type { SwiftRuntimeOptions, SwiftRuntimeThreadChannel };
