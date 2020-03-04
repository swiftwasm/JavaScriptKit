const SwiftRuntime = require("javascript-kit-swift").SwiftRuntime;
const WASI = require("@wasmer/wasi").WASI;
const WasmFs = require("@wasmer/wasmfs").WasmFs;

const promisify = require("util").promisify;
const fs = require("fs");
const readFile = promisify(fs.readFile);

const swift = new SwiftRuntime();
// Instantiate a new WASI Instance
const wasmFs = new WasmFs();
let wasi = new WASI({
  args: [],
  env: {},
  bindings: {
    ...WASI.defaultBindings,
    fs: wasmFs.fs
  }
});

global.globalObject1 = {
  "prop_1": {
    "nested_prop": 1,
  },
  "prop_2": 2,
  "prop_3": true,
  "prop_4": [
    3, 4, "str_elm_1", 5,
  ],
}

const startWasiTask = async () => {
  // Fetch our Wasm File
  const wasmBinary = await readFile("./dist/JavaScriptKitExec.wasm");

  // Instantiate the WebAssembly file
  let { instance } = await WebAssembly.instantiate(wasmBinary, {
    wasi_snapshot_preview1: wasi.wasiImport,
    javascript_kit: swift.importObjects(),
  });

  swift.setInsance(instance);
  // Start the WebAssembly WASI instance!
  wasi.start(instance);

  // Output what's inside of /dev/stdout!
  const stdout = await wasmFs.getStdOut();
  console.log(stdout);
};
startWasiTask().catch(err => {
  console.log(err)
});
