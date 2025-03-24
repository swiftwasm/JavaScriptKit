import type { /* #if USE_SHARED_MEMORY */SwiftRuntimeThreadChannel, /* #endif */SwiftRuntime } from "./runtime.js";

export type Import = {
    // TODO: Generate type from imported .d.ts files
}
export type Export = {
    // TODO: Generate type from .swift files
}

/**
 * The path to the WebAssembly module relative to the root of the package
 */
export declare const MODULE_PATH: string;

/* #if USE_SHARED_MEMORY */
/**
 * The type of the WebAssembly memory imported by the module
 */
export declare const MEMORY_TYPE: {
    initial: number,
    maximum: number,
    shared: boolean
}
/* #endif */
export interface WASI {
    /**
     * The WASI Preview 1 import object
     */
    wasiImport: WebAssembly.ModuleImports
    /**
     * Initialize the WASI reactor instance
     *
     * @param instance - The instance of the WebAssembly module
     */
    initialize(instance: WebAssembly.Instance): void
    /**
     * Set a new instance of the WebAssembly module to the WASI context
     * Typically used when instantiating a WebAssembly module for a thread
     *
     * @param instance - The instance of the WebAssembly module
     */
    setInstance(instance: WebAssembly.Instance): void
    /**
     * Extract a file from the WASI filesystem
     *
     * @param path - The path to the file to extract
     * @returns The data of the file if it was extracted, undefined otherwise
     */
    extractFile?(path: string): Uint8Array | undefined
}

export type ModuleSource = WebAssembly.Module | ArrayBufferView | ArrayBuffer | Response | PromiseLike<Response>

/**
 * The options for instantiating a WebAssembly module
 */
export type InstantiateOptions = {
    /**
     * The WebAssembly module to instantiate
     */
    module: ModuleSource,
    /**
     * The imports provided by the embedder
     */
    imports: Import,
/* #if IS_WASI */
    /**
     * The WASI implementation to use
     */
    wasi: WASI,
/* #endif */
/* #if USE_SHARED_MEMORY */
    /**
     * The WebAssembly memory to use (must be 'shared')
     */
    memory: WebAssembly.Memory
    /**
     * The thread channel is a set of functions that are used to communicate
     * between the main thread and the worker thread.
     */
    threadChannel: SwiftRuntimeThreadChannel & {
        spawnThread: (module: WebAssembly.Module, memory: WebAssembly.Memory, startArg: any) => number;
    }
/* #endif */
    /**
     * Add imports to the WebAssembly import object
     * @param imports - The imports to add
     */
    addToCoreImports?: (imports: WebAssembly.Imports) => void
}

/**
 * Instantiate the given WebAssembly module
 */
export declare function instantiate(options: InstantiateOptions): Promise<{
    instance: WebAssembly.Instance,
    swift: SwiftRuntime,
    exports: Export
}>

/**
 * Instantiate the given WebAssembly module for a thread
 */
export declare function instantiateForThread(tid: number, startArg: number, options: InstantiateOptions): Promise<{
    instance: WebAssembly.Instance,
    swift: SwiftRuntime,
    exports: Export
}>
