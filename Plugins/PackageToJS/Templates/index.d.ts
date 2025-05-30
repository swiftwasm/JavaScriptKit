import type { Exports, Imports, ModuleSource } from './instantiate.js'

export type Options = {
    /**
     * The WebAssembly module to instantiate
     *
     * If not provided, the module will be fetched from the default path.
     */
    module?: ModuleSource
/* #if HAS_IMPORTS */
    /**
     * The imports to use for the module
     */
    imports: Imports
/* #endif */
}

/**
 * Instantiate and initialize the module
 *
 * This is a convenience function for browser environments.
 * If you need a more flexible API, see `instantiate`.
 */
export declare function init(options?: Options): Promise<{
    instance: WebAssembly.Instance,
    exports: Exports
}>
