import type { Import, Export } from './instantiate.js'

export type Options = {
    /**
     * The CLI arguments to pass to the WebAssembly module
     */
    args?: string[]
/* #if USE_SHARED_MEMORY */
    /**
     * The WebAssembly memory to use (must be 'shared')
     */
    memory: WebAssembly.Memory
/* #endif */
}

/**
 * Initialize the given WebAssembly module
 *
 * This is a convenience function that creates an instantiator and instantiates the module.
 * @param moduleSource - The WebAssembly module to instantiate
 * @param imports - The imports to add
 * @param options - The options
 */
export declare function init(
    moduleSource: WebAssembly.Module | ArrayBufferView | ArrayBuffer | Response | PromiseLike<Response>
): Promise<{
    instance: WebAssembly.Instance,
    exports: Export
}>
