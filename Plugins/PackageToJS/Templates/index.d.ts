/* export */ type Import = {
    // TODO: Generate type from imported .d.ts files
}
/* export */ type Export = {
    // TODO: Generate type from .swift files
}

/**
 * The path to the WebAssembly module relative to the root of the package
 */
export declare const MODULE_PATH: string;

/**
 * Low-level interface to create an instance of a WebAssembly module
 *
 * This is used to have full control over the instantiation process
 * and to add custom imports.
 */
/* export */ interface Instantiator {
    /**
     * Add imports to the WebAssembly module
     * @param imports - The imports to add
     */
    addImports(imports: WebAssembly.Imports): void

    /**
     * Create an interface to access exposed functionalities
     * @param instance - The instance of the WebAssembly module
     * @returns The interface to access the exposed functionalities
     */
    createExports(instance: WebAssembly.Instance): Export
}

/**
 * Create an instantiator for the given imports
 * @param imports - The imports to add
 * @param options - The options
 */
/* export */ declare function createInstantiator(
    imports: Import,
    options: {} | undefined
): Promise<Instantiator>

/**
 * Instantiate the given WebAssembly module
 *
 * This is a convenience function that creates an instantiator and instantiates the module.
 * @param moduleSource - The WebAssembly module to instantiate
 * @param imports - The imports to add
 * @param options - The options
 */
export declare function instantiate(
    moduleSource: WebAssembly.Module | Response | PromiseLike<Response>,
    imports: Import,
    options: {} | undefined
): Promise<{
    instance: WebAssembly.Instance,
    exports: Export
}>
