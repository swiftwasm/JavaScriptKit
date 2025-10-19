import type { Exports, Imports, ModuleSource } from './instantiate.js'
/* #if TARGET_PLATFORM_NODE */
import type { DefaultNodeSetupOptions } from './platforms/node.js'
/* #endif */

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
    getImports: () => Imports
/* #endif */
}

/**
 * Instantiate and initialize the module
 *
/* #if TARGET_PLATFORM_NODE */
 * This is a convenience function for Node.js environments.
/* #else */
 * This is a convenience function for browser environments.
/* #endif */
 * If you need a more flexible API, see `instantiate`.
 */
/* #if TARGET_PLATFORM_NODE */
export declare function init(options?: DefaultNodeSetupOptions): Promise<{
    instance: WebAssembly.Instance,
    exports: Exports
}>
/* #else */
export declare function init(options?: Options): Promise<{
    instance: WebAssembly.Instance,
    exports: Exports
}>
/* #endif */
