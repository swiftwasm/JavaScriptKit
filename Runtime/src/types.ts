import * as JSValue from "./js-value";

export type ref = number;
export type pointer = number;

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
    ): void;

    swjs_free_host_function(host_func_id: number): void;
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
        kind_ptr: pointer,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): void;
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
        kind_ptr: pointer,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): void;
    swjs_encode_string(ref: number, bytes_ptr_result: pointer): number;
    swjs_decode_string(bytes_ptr: pointer, length: number): number;
    swjs_load_string(ref: number, buffer: pointer): void;
    swjs_call_function(
        ref: number,
        argv: pointer,
        argc: number,
        kind_ptr: pointer,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): void;
    swjs_call_function_with_this(
        obj_ref: ref,
        func_ref: ref,
        argv: pointer,
        argc: number,
        kind_ptr: pointer,
        payload1_ptr: pointer,
        payload2_ptr: pointer
    ): void;
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
    swjs_create_function(host_func_id: number): number;
    swjs_create_typed_array(
        constructor_ref: ref,
        elementsPtr: pointer,
        length: number
    ): number;
    swjs_release(ref: number): void;
}

export enum LibraryFeatures {
    WeakRefs = 1 << 0,
}

export type TypedArray =
    | Int8ArrayConstructor
    | Uint8ArrayConstructor
    | Int16ArrayConstructor
    | Uint16ArrayConstructor
    | Int32ArrayConstructor
    | Uint32ArrayConstructor
    // | BigInt64ArrayConstructor
    // | BigUint64ArrayConstructor
    | Float32ArrayConstructor
    | Float64ArrayConstructor;
