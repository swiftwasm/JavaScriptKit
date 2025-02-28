// @ts-check
import { WASI, File, OpenFile, ConsoleStdout, PreopenDirectory } from '@bjorn3/browser_wasi_shim';
// @ts-ignore
import { SwiftRuntime } from "./runtime.js"
export const MODULE_PATH = "@PACKAGE_TO_JS_MODULE_PATH@";

/** @type {import('./index.d').createInstantiator} */
/* export */ async function createInstantiator(
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

/** @type {import('./index.d').instantiate} */
export async function instantiate(
    moduleSource,
    imports,
    options
) {
    const instantiator = await createInstantiator(imports, options);
    const wasi = new WASI(/* args */[MODULE_PATH], /* env */[], /* fd */[
        new OpenFile(new File([])), // stdin
        ConsoleStdout.lineBuffered((stdout) => {
            console.log(stdout);
        }),
        ConsoleStdout.lineBuffered((stderr) => {
            console.error(stderr);
        }),
        new PreopenDirectory("/", new Map()),
    ])
    const swift = new SwiftRuntime();

    /** @type {WebAssembly.Imports} */
    const importObject = {
        wasi_snapshot_preview1: wasi.wasiImport,
        javascript_kit: swift.wasmImports,
    };
    instantiator.addImports(importObject);

    let module;
    let instance;
    if (moduleSource instanceof WebAssembly.Module) {
        module = moduleSource;
        instance = await WebAssembly.instantiate(module, importObject);
    } else {
        const result = await WebAssembly.instantiateStreaming(moduleSource, importObject);
        module = result.module;
        instance = result.instance;
    }

    swift.setInstance(instance);
    // @ts-ignore: "exports" of the instance is not typed
    wasi.initialize(instance);
    swift.main();

    return {
        instance,
        exports: instantiator.createExports(instance),
    }
}
