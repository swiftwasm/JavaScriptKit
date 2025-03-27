export type ref = number;
export type pointer = number;
export type bool = number;
export type JavaScriptValueKind = number;
export type JavaScriptValueKindAndFlags = number;

export interface ExportedFunctions {
    swjs_library_version(): number;
    swjs_library_features(): number;
    swjs_prepare_host_function_call(size: number): pointer;
    swjs_cleanup_host_function_call(argv: pointer): void;
    swjs_call_host_function(
        host_func_id: number,
        argv: pointer,
        argc: number,
        callback_func_ref: ref
    ): bool;

    swjs_free_host_function(host_func_id: number): void;

    swjs_enqueue_main_job_from_worker(unowned_job: number): void;
    swjs_wake_worker_thread(): void;
    swjs_receive_response(object: ref, transferring: pointer): void;
    swjs_receive_error(error: ref, context: number): void;
}

export const enum LibraryFeatures {
    WeakRefs = 1 << 0,
}

export type TypedArray =
    | Int8ArrayConstructor
    | Uint8ArrayConstructor
    | Int16ArrayConstructor
    | Uint16ArrayConstructor
    | Int32ArrayConstructor
    | Uint32ArrayConstructor
    | BigInt64ArrayConstructor
    | BigUint64ArrayConstructor
    | Float32ArrayConstructor
    | Float64ArrayConstructor;

export function assertNever(x: never, message: string) {
    throw new Error(message);
}

export const MAIN_THREAD_TID = -1;
