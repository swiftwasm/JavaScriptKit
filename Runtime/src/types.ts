import * as JSValue from "./js-value.js";

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

export interface ImportedFunctions {
    swjs_set_prop(
        ref: number,
        name: number,
        kind: JSValue.Kind,
        payload1: number,
        payload2: number
    ): void;
    swjs_get_prop(
        ref: number,
        name: number,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): JavaScriptValueKind;
    swjs_set_subscript(
        ref: number,
        index: number,
        kind: JSValue.Kind,
        payload1: number,
        payload2: number
    ): void;
    swjs_get_subscript(
        ref: number,
        index: number,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): JavaScriptValueKind;
    swjs_encode_string(ref: number, bytes_ptr_result: pointer): number;
    swjs_decode_string(bytes_ptr: pointer, length: number): number;
    swjs_load_string(ref: number, buffer: pointer): void;
    swjs_call_function(
        ref: number,
        argv: pointer,
        argc: number,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): JavaScriptValueKindAndFlags;
    swjs_call_function_no_catch(
        ref: number,
        argv: pointer,
        argc: number,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): JavaScriptValueKindAndFlags;
    swjs_call_function_with_this(
        obj_ref: ref,
        func_ref: ref,
        argv: pointer,
        argc: number,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): JavaScriptValueKindAndFlags;
    swjs_call_function_with_this_no_catch(
        obj_ref: ref,
        func_ref: ref,
        argv: pointer,
        argc: number,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): JavaScriptValueKindAndFlags;
    swjs_call_new(ref: number, argv: pointer, argc: number): number;
    swjs_call_throwing_new(
        ref: number,
        argv: pointer,
        argc: number,
        exception_kind_ptr: pointer,
        exception_payload1_ptr: pointer,
        exception_payload2_ptr: pointer
    ): number;
    swjs_instanceof(obj_ref: ref, constructor_ref: ref): boolean;
    swjs_create_function(host_func_id: number, line: number, file: ref): number;
    swjs_create_typed_array(
        constructor_ref: ref,
        elementsPtr: pointer,
        length: number
    ): number;
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
    swjs_request_transferring_object: (
        object_ref: ref,
        object_source_tid: number,
        transferring: pointer,
    ) => void;
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
