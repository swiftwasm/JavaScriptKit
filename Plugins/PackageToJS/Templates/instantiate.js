// @ts-check
import { SwiftRuntime } from "./runtime.js"

export const MODULE_PATH = "@PACKAGE_TO_JS_MODULE_PATH@";
/* #if USE_SHARED_MEMORY */
export const MEMORY_TYPE = {
    // @ts-ignore
    initial: import.meta.PACKAGE_TO_JS_MEMORY_INITIAL,
    // @ts-ignore
    maximum: import.meta.PACKAGE_TO_JS_MEMORY_MAXIMUM,
    // @ts-ignore
    shared: import.meta.PACKAGE_TO_JS_MEMORY_SHARED,
}
/* #endif */

/**
 * @param {import('./instantiate.d').InstantiateOptions} options
 */
async function createInstantiator(options) {
    return {
        /** @param {WebAssembly.Imports} importObject */
        addImports: (importObject) => {},
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            return {};
        },
    }
}
/** @type {import('./instantiate.d').instantiate} */
export async function instantiate(
    options
) {
    const result = await _instantiate(options);
/* #if IS_WASI */
    options.wasi.initialize(result.instance);
/* #endif */
    result.swift.main();
    return result;
}

/** @type {import('./instantiate.d').instantiateForThread} */
export async function instantiateForThread(
    tid, startArg, options
) {
    const result = await _instantiate(options);
/* #if IS_WASI */
    options.wasi.setInstance(result.instance);
/* #endif */
    result.swift.startThread(tid, startArg)
    return result;
}

/** @type {import('./instantiate.d').instantiate} */
async function _instantiate(
    options
) {
    const moduleSource = options.module;
/* #if IS_WASI */
    const { wasi } = options;
/* #endif */
    const instantiator = await createInstantiator(options);
    const swift = new SwiftRuntime({
/* #if USE_SHARED_MEMORY */
        sharedMemory: true,
        threadChannel: options.threadChannel,
/* #endif */
    });

    /** @type {WebAssembly.Imports} */
    const importObject = {
        javascript_kit: swift.wasmImports,
/* #if IS_WASI */
        wasi_snapshot_preview1: wasi.wasiImport,
/* #if USE_SHARED_MEMORY */
        env: {
            memory: options.memory,
        },
        wasi: {
            "thread-spawn": (startArg) => {
                return options.threadChannel.spawnThread(module, options.memory, startArg);
            }
        }
/* #endif */
/* #endif */
    };
    instantiator.addImports(importObject);
    options.addToCoreImports?.(importObject);

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

    return {
        instance,
        swift,
        exports: instantiator.createExports(instance),
    }
}
