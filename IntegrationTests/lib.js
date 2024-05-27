import { SwiftRuntime } from "javascript-kit-swift"
import { WASI as NodeWASI } from "wasi"
import { WASI as MicroWASI, useAll } from "uwasi"
import * as fs from "fs/promises"
import path from "path";

const WASI = {
    MicroWASI: ({ programName }) => {
        const wasi = new MicroWASI({
            args: [path.basename(programName)],
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
            args: [path.basename(programName)],
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

function isUsingSharedMemory(module) {
    const imports = WebAssembly.Module.imports(module);
    for (const entry of imports) {
        if (entry.module === "env" && entry.name === "memory" && entry.kind == "memory") {
            return true;
        }
    }
    return false;
}

export const startWasiTask = async (wasmPath, wasiConstructor = selectWASIBackend()) => {
    const swift = new SwiftRuntime();
    // Fetch our Wasm File
    const wasmBinary = await fs.readFile(wasmPath);
    const wasi = wasiConstructor({ programName: wasmPath });

    const module = await WebAssembly.compile(wasmBinary);

    const importObject = {
        wasi_snapshot_preview1: wasi.wasiImport,
        javascript_kit: swift.importObjects(),
        benchmark_helper: {
            noop: () => {},
            noop_with_int: (_) => {},
        }
    };

    if (isUsingSharedMemory(module)) {
        importObject["env"] = {
          // We don't have JS API to get memory descriptor of imported memory
          // at this moment, so we assume 256 pages (16MB) memory is enough
          // large for initial memory size.
          memory: new WebAssembly.Memory({ initial: 256, maximum: 16384, shared: true }),
        };
        importObject["wasi"] = {
          "thread-spawn": () => {
            throw new Error("thread-spawn not implemented");
          }
        }
    }

    // Instantiate the WebAssembly file
    const instance = await WebAssembly.instantiate(module, importObject);

    swift.setInstance(instance);
    // Start the WebAssembly WASI instance!
    wasi.start(instance, swift);
};
