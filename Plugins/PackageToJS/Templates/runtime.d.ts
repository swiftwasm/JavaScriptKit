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

type ref = number;
type pointer = number;

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
    importObjects: () => WebAssembly.ModuleImports;
    get wasmImports(): WebAssembly.ModuleImports;
    private postMessageToMainThread;
    private postMessageToWorkerThread;
}

export { SwiftRuntime };
export type { SwiftRuntimeOptions, SwiftRuntimeThreadChannel };
