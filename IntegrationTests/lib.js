import { SwiftRuntime } from "javascript-kit-swift"
import { WASI as NodeWASI } from "wasi"
import { WASI as MicroWASI, useAll } from "uwasi"
import * as fs from "fs/promises"
import path from "path";
import { Worker, parentPort } from "node:worker_threads";

const WASI = {
    MicroWASI: ({ args }) => {
        const wasi = new MicroWASI({
            args: args,
            env: {},
            features: [useAll()],
        })

        return {
            wasiImport: wasi.wasiImport,
            setInstance(instance) {
                wasi.instance = instance;
            },
            start(instance, swift) {
                wasi.initialize(instance);
                swift.main();
            }
        }
    },
    Node: ({ args }) => {
        const wasi = new NodeWASI({
            args: args,
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
        return value;
    }
    return "Node"
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

function constructBaseImportObject(wasi, swift) {
    return {
        wasi_snapshot_preview1: wasi.wasiImport,
        javascript_kit: swift.wasmImports,
        benchmark_helper: {
            noop: () => {},
            noop_with_int: (_) => {},
        },
    }
}

export async function startWasiChildThread(event) {
    const { module, programName, memory, tid, startArg } = event;
    const swift = new SwiftRuntime({
        sharedMemory: true,
        threadChannel: {
            wakeUpMainThread: parentPort.postMessage.bind(parentPort),
            listenWakeEventFromMainThread: (listener) => {
                parentPort.on("message", listener)
            }
        }
    });
    // Use uwasi for child threads because Node.js WASI cannot be used without calling
    // `WASI.start` or `WASI.initialize`, which is already called in the main thread and
    // will cause an error if called again.
    const wasi = WASI.MicroWASI({ programName });

    const importObject = constructBaseImportObject(wasi, swift);

    importObject["wasi"] = {
        "thread-spawn": () => {
            throw new Error("Cannot spawn a new thread from a worker thread")
        }
    };
    importObject["env"] = { memory };
    importObject["JavaScriptEventLoopTestSupportTests"] = {
        "isMainThread": () => false,
    }

    const instance = await WebAssembly.instantiate(module, importObject);
    swift.setInstance(instance);
    wasi.setInstance(instance);
    swift.startThread(tid, startArg);
}

class ThreadRegistry {
    workers = new Map();
    nextTid = 1;

    spawnThread(module, programName, memory, startArg) {
        const tid = this.nextTid++;
        const selfFilePath = new URL(import.meta.url).pathname;
        const worker = new Worker(`
            const { parentPort } = require('node:worker_threads');

            Error.stackTraceLimit = 100;
            parentPort.once("message", async (event) => {
                const { selfFilePath } = event;
                const { startWasiChildThread } = await import(selfFilePath);
                await startWasiChildThread(event);
            })
        `, { type: "module", eval: true })

        worker.on("error", (error) => {
            console.error(`Worker thread ${tid} error:`, error);
        });
        this.workers.set(tid, worker);
        worker.postMessage({ selfFilePath, module, programName, memory, tid, startArg });
        return tid;
    }

    worker(tid) {
        return this.workers.get(tid);
    }

    wakeUpWorkerThread(tid) {
        const worker = this.workers.get(tid);
        worker.postMessage(null);
    }
}

export const startWasiTask = async (wasmPath, wasiConstructorKey = selectWASIBackend()) => {
    // Fetch our Wasm File
    const wasmBinary = await fs.readFile(wasmPath);
    const programName = wasmPath;
    const args = [path.basename(programName)];
    args.push(...process.argv.slice(3));
    const wasi = WASI[wasiConstructorKey]({ args });

    const module = await WebAssembly.compile(wasmBinary);

    const sharedMemory = isUsingSharedMemory(module);
    const threadRegistry = new ThreadRegistry();
    const swift = new SwiftRuntime({
        sharedMemory,
        threadChannel: {
            wakeUpWorkerThread: threadRegistry.wakeUpWorkerThread.bind(threadRegistry),
            listenMainJobFromWorkerThread: (tid, listener) => {
                const worker = threadRegistry.worker(tid);
                worker.on("message", listener);
            }
        }
    });

    const importObject = constructBaseImportObject(wasi, swift);

    importObject["JavaScriptEventLoopTestSupportTests"] = {
        "isMainThread": () => true,
    }

    if (sharedMemory) {
        // We don't have JS API to get memory descriptor of imported memory
        // at this moment, so we assume 256 pages (16MB) memory is enough
        // large for initial memory size.
        const memory = new WebAssembly.Memory({ initial: 256, maximum: 16384, shared: true })
        importObject["env"] = { memory };
        importObject["wasi"] = {
          "thread-spawn": (startArg) => {
            return threadRegistry.spawnThread(module, programName, memory, startArg);
          }
        }
    }

    // Instantiate the WebAssembly file
    const instance = await WebAssembly.instantiate(module, importObject);

    swift.setInstance(instance);
    // Start the WebAssembly WASI instance!
    wasi.start(instance, swift);
};
