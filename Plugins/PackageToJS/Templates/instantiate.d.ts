import type { /* #if USE_SHARED_MEMORY */SwiftRuntimeThreadChannel, /* #endif */SwiftRuntime } from "./runtime.js";

/* #if HAS_BRIDGE */
export type { Imports, Exports } from "./bridge-js.js";
import type { Imports, Exports } from "./bridge-js.js";
/* #else */
export type Imports = {}
export type Exports = {}
/* #endif */

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
     * The WebAssembly namespace to use for instantiation.
     * Defaults to the globalThis.WebAssembly object.
     */
    WebAssembly?: typeof globalThis.WebAssembly,
    /**
     * The WebAssembly module to instantiate
     */
    module: ModuleSource,
/* #if HAS_IMPORTS */
    /**
     * The imports provided by the embedder
     */
    imports: Imports,
/* #endif */
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
     * @param context - The context object
     */
    addToCoreImports?: (
        imports: WebAssembly.Imports,
        context: {
            getInstance: () => WebAssembly.Instance | null,
            getExports: () => Exports | null,
            _swift: SwiftRuntime,
        }
    ) => void

    /**
     * Instrument the WebAssembly instance
     *
     * @param instance - The instance of the WebAssembly module
     * @param context - The context object
     * @returns The instrumented instance
     */
    instrumentInstance?: (
        instance: WebAssembly.Instance,
        context: {
            _swift: SwiftRuntime
        }
    ) => WebAssembly.Instance
}

/**
 * Instantiate the given WebAssembly module
 */
export declare function instantiate(options: InstantiateOptions): Promise<{
    instance: WebAssembly.Instance,
    swift: SwiftRuntime,
    exports: Exports
}>

/**
 * Instantiate the given WebAssembly module for a thread
 */
export declare function instantiateForThread(tid: number, startArg: number, options: InstantiateOptions): Promise<{
    instance: WebAssembly.Instance,
    swift: SwiftRuntime,
    exports: Exports
}>
