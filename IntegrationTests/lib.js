const SwiftRuntime = require("javascript-kit-swift").SwiftRuntime;
const WasmerWASI = require("@wasmer/wasi").WASI;
const WasmFs = require("@wasmer/wasmfs").WasmFs;
const NodeWASI = require("wasi").WASI;
const { WASI: MicroWASI, useAll } = require("uwasi");

const promisify = require("util").promisify;
const fs = require("fs");
const readFile = promisify(fs.readFile);

const WASI = {
    Wasmer: ({ programName }) => {
        // Instantiate a new WASI Instance
        const wasmFs = new WasmFs();
        // Output stdout and stderr to console
        const originalWriteSync = wasmFs.fs.writeSync;
        wasmFs.fs.writeSync = (fd, buffer, offset, length, position) => {
            const text = new TextDecoder("utf-8").decode(buffer);
            switch (fd) {
                case 1:
                    console.log(text);
                    break;
                case 2:
                    console.error(text);
                    break;
            }
            return originalWriteSync(fd, buffer, offset, length, position);
        };
        const wasi = new WasmerWASI({
            args: [programName],
            env: {},
            bindings: {
                ...WasmerWASI.defaultBindings,
                fs: wasmFs.fs,
            },
        });

        return {
            wasiImport: wasi.wasiImport,
            start(instance) {
                wasi.start(instance);
                instance.exports._initialize();
                instance.exports.main();
            }
        }
    },
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
            returnOnExit: true,
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
