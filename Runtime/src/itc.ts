// This file defines the interface for the inter-thread communication.
import type { ref, pointer } from "./types.js";
import { Memory } from "./memory.js";

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
export type SwiftRuntimeThreadChannel =
    | {
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
      }
    | {
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
          listenMessageFromWorkerThread: (
              tid: number,
              listener: (message: WorkerToMainMessage) => void
          ) => void;

          /**
           * This function is expected to be set in the main thread and called
           * when the worker thread is terminated.
           * @param tid The thread ID of the worker thread.
           */
          terminateWorkerThread?: (tid: number) => void;
      };


export class ITCInterface {
    constructor(private memory: Memory) {}

    transfer(objectRef: ref, transferring: pointer): { object: any, transferring: pointer, transfer: Transferable[] } {
        const object = this.memory.getObject(objectRef);
        return { object, transferring, transfer: [object] };
    }
}

type AllRequests<Interface extends Record<string, any>> = {
    [K in keyof Interface]: {
        method: K,
        parameters: Parameters<Interface[K]>,
    }
}

type ITCRequest<Interface extends Record<string, any>> = AllRequests<Interface>[keyof AllRequests<Interface>];
type AllResponses<Interface extends Record<string, any>> = {
    [K in keyof Interface]: ReturnType<Interface[K]>
}
type ITCResponse<Interface extends Record<string, any>> = AllResponses<Interface>[keyof AllResponses<Interface>];

export type RequestMessage = {
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
    }
}

type SerializedError = { isError: true; value: Error } | { isError: false; value: unknown }

export type ResponseMessage = {
    type: "response";
    data: {
        /** The TID of the thread that sent the response */
        sourceTid: number;
        /** The context pointer of the request */
        context: pointer;
        /** The response content */
        response: {
            ok: true,
            value: ITCResponse<ITCInterface>;
        } | {
            ok: false,
            error: SerializedError;
        };
    }
}

export type MainToWorkerMessage = {
    type: "wake";
} | RequestMessage | ResponseMessage;

export type WorkerToMainMessage = {
    type: "job";
    data: number;
} | RequestMessage | ResponseMessage;


export class MessageBroker {
    constructor(
        private selfTid: number,
        private threadChannel: SwiftRuntimeThreadChannel,
        private handlers: {
            onRequest: (message: RequestMessage) => void,
            onResponse: (message: ResponseMessage) => void,
        }
    ) {
    }

    request(message: RequestMessage) {
        if (message.data.targetTid == this.selfTid) {
            // The request is for the current thread
            this.handlers.onRequest(message);
        } else if ("postMessageToWorkerThread" in this.threadChannel) {
            // The request is for another worker thread sent from the main thread
            this.threadChannel.postMessageToWorkerThread(message.data.targetTid, message, []);
        } else if ("postMessageToMainThread" in this.threadChannel) {
            // The request is for other worker threads or the main thread sent from a worker thread
            this.threadChannel.postMessageToMainThread(message, []);
        } else {
            throw new Error("unreachable");
        }
    }

    reply(message: ResponseMessage) {
        if (message.data.sourceTid == this.selfTid) {
            // The response is for the current thread
            this.handlers.onResponse(message);
            return;
        }
        const transfer = message.data.response.ok ? message.data.response.value.transfer : [];
        if ("postMessageToWorkerThread" in this.threadChannel) {
            // The response is for another worker thread sent from the main thread
            this.threadChannel.postMessageToWorkerThread(message.data.sourceTid, message, transfer);
        } else if ("postMessageToMainThread" in this.threadChannel) {
            // The response is for other worker threads or the main thread sent from a worker thread
            this.threadChannel.postMessageToMainThread(message, transfer);
        } else {
            throw new Error("unreachable");
        }
    }

    onReceivingRequest(message: RequestMessage) {
        if (message.data.targetTid == this.selfTid) {
            this.handlers.onRequest(message);
        } else if ("postMessageToWorkerThread" in this.threadChannel) {
            // Receive a request from a worker thread to other worker on main thread. 
            // Proxy the request to the target worker thread.
            this.threadChannel.postMessageToWorkerThread(message.data.targetTid, message, []);
        } else if ("postMessageToMainThread" in this.threadChannel) {
            // A worker thread won't receive a request for other worker threads
            throw new Error("unreachable");
        }
    }

    onReceivingResponse(message: ResponseMessage) {
        if (message.data.sourceTid == this.selfTid) {
            this.handlers.onResponse(message);
        } else if ("postMessageToWorkerThread" in this.threadChannel) {
            // Receive a response from a worker thread to other worker on main thread.
            // Proxy the response to the target worker thread.
            const transfer = message.data.response.ok ? message.data.response.value.transfer : [];
            this.threadChannel.postMessageToWorkerThread(message.data.sourceTid, message, transfer);
        } else if ("postMessageToMainThread" in this.threadChannel) {
            // A worker thread won't receive a response for other worker threads
            throw new Error("unreachable");
        }
    }
}

export function serializeError(error: unknown): SerializedError {
    if (error instanceof Error) {
        return { isError: true, value: { message: error.message, name: error.name, stack: error.stack } };
    }
    return { isError: false, value: error };
}

export function deserializeError(error: SerializedError): unknown {
    if (error.isError) {
        return Object.assign(new Error(error.value.message), error.value);
    }
    return error.value;
}
