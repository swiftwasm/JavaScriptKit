/**
 * The path to the WebAssembly module relative to the root of the package
 */
export declare const MODULE_PATH: string;

export type Options = {
    /**
     * The CLI arguments to pass to the WebAssembly module
     */
    args?: string[]
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
    moduleSource: WebAssembly.Module | ArrayBufferView | ArrayBuffer | Response | PromiseLike<Response>,
    imports: Import,
    options: Options | undefined
): Promise<{
    instance: WebAssembly.Instance,
    exports: Export
}>

export declare function runTest(
    moduleSource: WebAssembly.Module | ArrayBufferView | ArrayBuffer | Response | PromiseLike<Response>,
    imports: Import,
    options: Options | undefined
): Promise<{ exitCode: number }>
