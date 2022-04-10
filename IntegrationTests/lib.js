const SwiftRuntime = require("javascript-kit-swift").SwiftRuntime;
const WASI = require("@wasmer/wasi").WASI;
const WasmFs = require("@wasmer/wasmfs").WasmFs;

const promisify = require("util").promisify;
const fs = require("fs");
const readFile = promisify(fs.readFile);

const startWasiTask = async (wasmPath) => {
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
    let wasi = new WASI({
        args: [],
        env: {},
        bindings: {
            ...WASI.defaultBindings,
            fs: wasmFs.fs,
        },
    });

    const swift = new SwiftRuntime();
    // Fetch our Wasm File
    const wasmBinary = await readFile(wasmPath);

    // Instantiate the WebAssembly file
    let { instance } = await WebAssembly.instantiate(wasmBinary, {
        wasi_snapshot_preview1: wasi.wasiImport,
        javascript_kit: swift.importObjects(),
    });

    swift.setInstance(instance);
    // Start the WebAssembly WASI instance!
    wasi.start(instance);
    instance.exports._initialize();
    instance.exports.main();
};

module.exports = { startWasiTask };
