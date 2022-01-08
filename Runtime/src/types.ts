export type ref = number;
export type pointer = number;

export interface SwiftRuntimeExportedFunctions {
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
