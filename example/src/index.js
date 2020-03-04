import { SwiftRuntime } from "javascript-kit-swift";
import { WASI } from "@wasmer/wasi";
import { WasmFs } from "@wasmer/wasmfs";


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

const startWasiTask = async () => {
  // Fetch our Wasm File
  const response = await fetch("./assets/JavaScriptKitExample.wasm");
  const responseArrayBuffer = await response.arrayBuffer();

  // Instantiate the WebAssembly file
  const wasm_bytes = new Uint8Array(responseArrayBuffer).buffer;
  let { instance } = await WebAssembly.instantiate(wasm_bytes, {
    wasi_snapshot_preview1: wasi.wasiImport,
    javascript_kit: swift.importObjects(),
  });

  swift.setInsance(instance);
  // Start the WebAssembly WASI instance!
  wasi.start(instance);

  // Output what's inside of /dev/stdout!
  const stdout = await wasmFs.getStdOut();
  console.log(stdout);

  console.log(`Print window.foobar = ${foobar}`);
};
startWasiTask();
