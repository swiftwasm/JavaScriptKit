import { SwiftRuntime } from "javascript-kit-swift"
import { WASI as NodeWASI } from "wasi"
import { WASI as MicroWASI, useAll } from "uwasi"
import * as fs from "fs/promises"
import path from "path";

const WASI = {
    MicroWASI: ({ args }) => {
        const wasi = new MicroWASI({
            args: args,
            env: {},
            features: [useAll()],
        })

        return {
            wasiImport: wasi.wasiImport,
            setInstance(instance) {
                wasi.instance = instance;
            },
            start(instance, swift) {
                wasi.initialize(instance);
                swift.main();
            }
        }
    },
    Node: ({ args }) => {
        const wasi = new NodeWASI({
            args: args,
            env: {},
            preopens: {
              "/": "./",
            },
            returnOnExit: false,
            version: "preview1",
        })

        return {
            wasiImport: wasi.wasiImport,
            start(instance, swift) {
                wasi.initialize(instance);
                swift.main();
            }
        }
    },
};

const selectWASIBackend = () => {
    const value = process.env["JAVASCRIPTKIT_WASI_BACKEND"]
    if (value) {
        return value;
    }
    return "Node"
};

function constructBaseImportObject(wasi, swift) {
    return {
        wasi_snapshot_preview1: wasi.wasiImport,
        javascript_kit: swift.wasmImports,
        benchmark_helper: {
            noop: () => {},
            noop_with_int: (_) => {},
        },
    }
}

export const startWasiTask = async (wasmPath, wasiConstructorKey = selectWASIBackend()) => {
    // Fetch our Wasm File
    const wasmBinary = await fs.readFile(wasmPath);
    const programName = wasmPath;
    const args = [path.basename(programName)];
    args.push(...process.argv.slice(3));
    const wasi = WASI[wasiConstructorKey]({ args });

    const module = await WebAssembly.compile(wasmBinary);

    const swift = new SwiftRuntime();

    const importObject = constructBaseImportObject(wasi, swift);

    // Instantiate the WebAssembly file
    const instance = await WebAssembly.instantiate(module, importObject);

    swift.setInstance(instance);
    // Start the WebAssembly WASI instance!
    wasi.start(instance, swift);
};
