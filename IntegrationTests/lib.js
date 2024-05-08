const SwiftRuntime = require("javascript-kit-swift").SwiftRuntime;
const NodeWASI = require("wasi").WASI;
const { WASI: MicroWASI, useAll } = require("uwasi");

const promisify = require("util").promisify;
const fs = require("fs");
const readFile = promisify(fs.readFile);

const WASI = {
    MicroWASI: ({ programName }) => {
        const wasi = new MicroWASI({
            args: [programName],
            env: {},
            features: [useAll()],
        })

        return {
            wasiImport: wasi.wasiImport,
            start(instance) {
                wasi.initialize(instance);
                instance.exports.main();
            }
        }
    },
    Node: ({ programName }) => {
        const wasi = new NodeWASI({
            args: [programName],
            env: {},
            returnOnExit: false,
            version: "preview1",
        })

        return {
            wasiImport: wasi.wasiImport,
            start(instance) {
                wasi.initialize(instance);
                instance.exports.main();
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

const startWasiTask = async (wasmPath, wasiConstructor = selectWASIBackend()) => {
    const swift = new SwiftRuntime();
    // Fetch our Wasm File
    const wasmBinary = await readFile(wasmPath);
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
    wasi.start(instance);
};

module.exports = { startWasiTask, WASI };
