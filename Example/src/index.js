import { SwiftRuntime } from "javascript-kit-swift";
import { WASI } from "@wasmer/wasi";
import { WasmFs } from "@wasmer/wasmfs";


const swift = new SwiftRuntime();
// Instantiate a new WASI Instance
const wasmFs = new WasmFs();

// Output stdout and stderr to console
const originalWriteSync = wasmFs.fs.writeSync;
wasmFs.fs.writeSync = (fd, buffer, offset, length, position) => {
  const text = new TextDecoder("utf-8").decode(buffer);
  
  // Filter out standalone "\n" added by every `print`, `console.log`
  // always adds its own "\n" on top.
  if (text !== "\n") {
    switch (fd) {
    case 1:
      console.log(text);
      break;
    case 2:
      console.error(text);
      break;
    }
  }
  return originalWriteSync(fd, buffer, offset, length, position);
};

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
  const response = await fetch("JavaScriptKitExample.wasm");
  const responseArrayBuffer = await response.arrayBuffer();

  // Instantiate the WebAssembly file
  const wasm_bytes = new Uint8Array(responseArrayBuffer).buffer;
  let { instance } = await WebAssembly.instantiate(wasm_bytes, {
    wasi_snapshot_preview1: wasi.wasiImport,
    javascript_kit: swift.importObjects(),
  });

  swift.setInstance(instance);
  // Start the WebAssembly WASI instance!
  wasi.start(instance);
};
startWasiTask();
