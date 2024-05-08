import { SwiftRuntime } from "javascript-kit-swift"
import { WASI as NodeWASI } from "wasi"
import { WASI as MicroWASI, useAll } from "uwasi"
import * as fs from "fs/promises"

const WASI = {
    MicroWASI: ({ programName }) => {
        const wasi = new MicroWASI({
            args: [programName],
            env: {},
            features: [useAll()],
        })

        return {
            wasiImport: wasi.wasiImport,
            start(instance, swift) {
                wasi.initialize(instance);
                swift.main();
            }
        }
    },
    Node: ({ programName }) => {
        const wasi = new NodeWASI({
            args: [programName],
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
        const backend = WASI[value];
        if (backend) {
            return backend;
        }
    }
    return WASI.Node;
};

export const startWasiTask = async (wasmPath, wasiConstructor = selectWASIBackend()) => {
    const swift = new SwiftRuntime();
    // Fetch our Wasm File
    const wasmBinary = await fs.readFile(wasmPath);
    const wasi = wasiConstructor({ programName: wasmPath });

    // Instantiate the WebAssembly file
    let { instance } = await WebAssembly.instantiate(wasmBinary, {
        wasi_snapshot_preview1: wasi.wasiImport,
        javascript_kit: swift.importObjects(),
        benchmark_helper: {
            noop: () => {},
            noop_with_int: (_) => {},
        }
    });

    swift.setInstance(instance);
    // Start the WebAssembly WASI instance!
    wasi.start(instance, swift);
};
