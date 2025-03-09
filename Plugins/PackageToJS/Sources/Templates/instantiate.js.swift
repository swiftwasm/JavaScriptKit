extension TemplateContext {
    var instantiate_d_ts: String {
        return """
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

/**
 * Low-level interface to create an instance of a WebAssembly module
 *
 * This is used to have full control over the instantiation process
 * and to add custom imports.
 */
export interface Instantiator {
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
export declare function createInstantiator(
    imports: Import,
    options: Options | undefined
): Promise<Instantiator>

export interface WASI {
    wasiImport: WebAssembly.ModuleImports
    initialize(instance: WebAssembly.Instance): void
}

/**
 * Instantiate the given WebAssembly module
 *
 * This is a convenience function that creates an instantiator and instantiates the module.
 * @param moduleSource - The WebAssembly module to instantiate
 * @param imports - The imports to add
 * @param options - The options
 */
export declare function instantiate(
    moduleSource: WebAssembly.Module | ArrayBufferView | ArrayBuffer | Response | PromiseLike<Response>,
    imports: Import,
    options: {
        wasi: WASI, \(useSharedMemory ? "memory: WebAssembly.Memory" : "")
    }
): Promise<{
    instance: WebAssembly.Instance,
    swift: any,
    exports: Export
}>
"""
    }

    var instantiate_js: String {
        return """
// @ts-check
// @ts-ignore
import { SwiftRuntime } from "./runtime.js"

export const MODULE_PATH = "@PACKAGE_TO_JS_MODULE_PATH@";

/** @type {import('./instantiate.d').createInstantiator} */
export async function createInstantiator(
    imports,
    options = {}
) {
    return {
        addImports: () => {},
        createExports: () => {
            return {};
        },
    }
}

/** @type {import('./instantiate.d').instantiate} */
export async function instantiate(
    moduleSource,
    imports,
    options
) {
    const { wasi } = options;
    const instantiator = await createInstantiator(imports, options);
    const swift = new SwiftRuntime();

    /** @type {WebAssembly.Imports} */
    const importObject = {
        javascript_kit: swift.wasmImports,
        wasi_snapshot_preview1: wasi.wasiImport, \(useSharedMemory ? """

        env: { memory: options.memory }
""" : "")
    };
    instantiator.addImports(importObject);

    let module;
    let instance;
    if (moduleSource instanceof WebAssembly.Module) {
        module = moduleSource;
        instance = await WebAssembly.instantiate(module, importObject);
    } else if (typeof Response === "function" && (moduleSource instanceof Response || moduleSource instanceof Promise)) {
        if (typeof WebAssembly.instantiateStreaming === "function") {
            const result = await WebAssembly.instantiateStreaming(moduleSource, importObject);
            module = result.module;
            instance = result.instance;
        } else {
            const moduleBytes = await (await moduleSource).arrayBuffer();
            module = await WebAssembly.compile(moduleBytes);
            instance = await WebAssembly.instantiate(module, importObject);
        }
    } else {
        // @ts-expect-error: Type 'Response' is not assignable to type 'BufferSource'
        module = await WebAssembly.compile(moduleSource);
        instance = await WebAssembly.instantiate(module, importObject);
    }

    swift.setInstance(instance);
    wasi.initialize(instance);

    return {
        instance,
        swift,
        exports: instantiator.createExports(instance),
    }
}
"""
    }
}
