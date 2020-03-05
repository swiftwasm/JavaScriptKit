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
  "prop_5": {
    "func1": function () { return },
    "func2": function () { return 1 },
    "func3": function (n) { return n * 2},
    "func4": function (a, b, c) { return a + b + c },
    "func5": function (x) { return "Hello, " + x },
    "func6": function (c, a, b) {
      if (c) { return a } else { return b }
    },
  },
  "prop_6": {
    "call_host_1": () => {
      return global.globalObject1.prop_6.host_func_1()
    }
  }
}

global.Animal = function(name, age, isCat) {
  this.name = name
  this.age = age
  this.bark = () => {
    return isCat ? "nyan" : "wan"
  }
  this.isCat = isCat
  this.getIsCat = function() {
    return this.isCat
  }
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
