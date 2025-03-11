import { instantiate } from "./instantiate.js"
import * as WasmImportsParser from 'https://esm.run/wasm-imports-parser/polyfill.js';

// TODO: Remove this polyfill once the browser supports the WebAssembly Type Reflection JS API
// https://chromestatus.com/feature/5725002447978496
globalThis.WebAssembly = WasmImportsParser.polyfill(globalThis.WebAssembly);

class ThreadRegistry {
  workers = new Map();
  nextTid = 1;

  constructor({ configuration }) {
    this.configuration = configuration;
  }

  spawnThread(worker, module, memory, startArg) {
    const tid = this.nextTid++;
    this.workers.set(tid, worker);
    worker.postMessage({ module, memory, tid, startArg, configuration: this.configuration });
    return tid;
  }

  listenMessageFromWorkerThread(tid, listener) {
    const worker = this.workers.get(tid);
    worker.onmessage = (event) => {
      listener(event.data);
    };
  }

  postMessageToWorkerThread(tid, data, transfer) {
    const worker = this.workers.get(tid);
    worker.postMessage(data, transfer);
  }

  terminateWorkerThread(tid) {
    const worker = this.workers.get(tid);
    worker.terminate();
    this.workers.delete(tid);
  }
}

async function start(configuration = "release") {
  const response = await fetch(`./.build/${configuration}/MyApp.wasm`);
  const module = await WebAssembly.compileStreaming(response);
  const memoryImport = WebAssembly.Module.imports(module).find(i => i.module === "env" && i.name === "memory");
  if (!memoryImport) {
    throw new Error("Memory import not found");
  }
  if (!memoryImport.type) {
    throw new Error("Memory import type not found");
  }
  const memoryType = memoryImport.type;
  const memory = new WebAssembly.Memory({ initial: memoryType.minimum, maximum: memoryType.maximum, shared: true });
  const threads = new ThreadRegistry({ configuration });
  const { instance, swiftRuntime, wasi } = await instantiate({
    module,
    threadChannel: threads,
    addToImports(importObject) {
      importObject["env"] = { memory }
      importObject["wasi"] = {
        "thread-spawn": (startArg) => {
          const worker = new Worker("Sources/JavaScript/worker.js", { type: "module" });
          return threads.spawnThread(worker, module, memory, startArg);
        }
      };
    },
    configuration
  });
  wasi.initialize(instance);

  swiftRuntime.main();
}

start();
