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
    /* #if IS_WASI */
    const { wasi } = options;
    /* #endif */
    const instantiator = await createInstantiator(imports, options);
    const swift = new SwiftRuntime();

    /** @type {WebAssembly.Imports} */
    const importObject = {
        javascript_kit: swift.wasmImports,
        /* #if IS_WASI */
        wasi_snapshot_preview1: wasi.wasiImport,
        /* #if USE_SHARED_MEMORY */ env: {
            memory: options.memory,
        },
        /* #endif */
        /* #endif */
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
    /* #if IS_WASI */
    wasi.initialize(instance);
    /* #endif */

    return {
        instance,
        swift,
        exports: instantiator.createExports(instance),
    }
}
