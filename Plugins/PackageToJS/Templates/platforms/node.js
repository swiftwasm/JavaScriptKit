// @ts-check
import { fileURLToPath } from "node:url";
import { Worker, parentPort } from "node:worker_threads";
import { MODULE_PATH /* #if USE_SHARED_MEMORY */, MEMORY_TYPE /* #endif */} from "../instantiate.js"
/* #if IS_WASI */
import { WASI, File, OpenFile, ConsoleStdout, PreopenDirectory, Directory, Inode } from '@bjorn3/browser_wasi_shim';
/* #endif */

/* #if USE_SHARED_MEMORY */
export async function defaultNodeThreadSetup() {
    const threadChannel = {
        spawnThread: () => {
            throw new Error("Cannot spawn a new thread from a worker thread")
        },
        postMessageToMainThread: (message, transfer) => {
            // @ts-ignore
            parentPort.postMessage(message, transfer);
        },
        listenMessageFromMainThread: (listener) => {
            // @ts-ignore
            parentPort.on("message", listener)
        }
    }

    const wasi = new WASI(/* args */[MODULE_PATH], /* env */[], /* fd */[
        new OpenFile(new File([])), // stdin
        ConsoleStdout.lineBuffered((stdout) => {
            console.log(stdout);
        }),
        ConsoleStdout.lineBuffered((stderr) => {
            console.error(stderr);
        }),
        new PreopenDirectory("/", new Map()),
    ], { debug: false })

    return {
        wasi: Object.assign(wasi, {
            setInstance(instance) {
                wasi.inst = instance;
            }
        }),
        threadChannel,
    }
}

export function createDefaultWorkerFactory(preludeScript) {
    return (tid, startArg, module, memory) => {
        const selfFilePath = new URL(import.meta.url).pathname;
        const instantiatePath = fileURLToPath(new URL("../instantiate.js", import.meta.url));
        const worker = new Worker(`
            const { parentPort } = require('node:worker_threads');

            Error.stackTraceLimit = 100;
            parentPort.once("message", async (event) => {
                const { instantiatePath, selfFilePath, module, memory, tid, startArg, preludeScript } = event;
                const { defaultNodeThreadSetup } = await import(selfFilePath);
                const { instantiateForThread } = await import(instantiatePath);
                let options = await defaultNodeThreadSetup();
                if (preludeScript) {
                    const prelude = await import(preludeScript);
                    if (prelude.setupOptions) {
                        options = await prelude.setupOptions(options, { isMainThread: false })
                    }
                }
                await instantiateForThread(tid, startArg, {
                    ...options,
                    module, memory,
                    getImports() { return {} },
                })
            })
            `,
            { eval: true }
        )
        worker.on("error", (error) => {
            console.error(`Worker thread ${tid} error:`, error);
            throw error;
        });
        worker.postMessage({ instantiatePath, selfFilePath, module, memory, tid, startArg, preludeScript });
        return worker;
    }
}

class DefaultNodeThreadRegistry {
    workers = new Map();
    nextTid = 1;

    constructor(createWorker) {
        this.createWorker = createWorker;
    }

    spawnThread(module, memory, startArg) {
        const tid = this.nextTid++;
        this.workers.set(tid, this.createWorker(tid, startArg, module, memory));
        return tid;
    }

    listenMessageFromWorkerThread(tid, listener) {
        const worker = this.workers.get(tid);
        worker.on("message", listener);
    }

    postMessageToWorkerThread(tid, message, transfer) {
        const worker = this.workers.get(tid);
        worker.postMessage(message, transfer);
    }

    terminateWorkerThread(tid) {
        const worker = this.workers.get(tid);
        worker.terminate();
        this.workers.delete(tid);
    }
}
/* #endif */

/** @type {import('./node.d.ts').defaultNodeSetup} */
export async function defaultNodeSetup(options = {}) {
    const path = await import("node:path");
    const { fileURLToPath } = await import("node:url");
    const { readFile } = await import("node:fs/promises")

    const args = options.args ?? process.argv.slice(2)
    const rootFs = new Map();
    const wasi = new WASI(/* args */[MODULE_PATH, ...args], /* env */[], /* fd */[
        new OpenFile(new File([])), // stdin
        ConsoleStdout.lineBuffered((stdout) => {
            console.log(stdout);
        }),
        ConsoleStdout.lineBuffered((stderr) => {
            console.error(stderr);
        }),
        new PreopenDirectory("/", rootFs),
    ], { debug: false })
    const pkgDir = path.dirname(path.dirname(fileURLToPath(import.meta.url)))
    const module = await WebAssembly.compile(new Uint8Array(await readFile(path.join(pkgDir, MODULE_PATH))))
/* #if USE_SHARED_MEMORY */
    const memory = new WebAssembly.Memory(MEMORY_TYPE);
    const threadChannel = new DefaultNodeThreadRegistry(options.spawnWorker || createDefaultWorkerFactory())
/* #endif */

    return {
        module,
/* #if HAS_IMPORTS */
        getImports() { return {} },
/* #endif */
/* #if IS_WASI */
        wasi: Object.assign(wasi, {
            setInstance(instance) {
                wasi.inst = instance;
            },
            /**
             * @param {string} path
             * @returns {Uint8Array | undefined}
             */
            extractFile(path) {
                /**
                 * @param {Map<string, Inode>} parent
                 * @param {string[]} components
                 * @param {number} index
                 * @returns {Inode | undefined}
                 */
                const getFile = (parent, components, index) => {
                    const name = components[index];
                    const entry = parent.get(name);
                    if (entry === undefined) {
                        return undefined;
                    }
                    if (index === components.length - 1) {
                        return entry;
                    }
                    if (entry instanceof Directory) {
                        return getFile(entry.contents, components, index + 1);
                    }
                    throw new Error(`Expected directory at ${components.slice(0, index).join("/")}`);
                }

                const components = path.split("/");
                const file = getFile(rootFs, components, 0);
                if (file === undefined) {
                    return undefined;
                }
                if (file instanceof File) {
                    return file.data;
                }
                return undefined;
            }
        }),
        addToCoreImports(importObject) {
            importObject["wasi_snapshot_preview1"]["proc_exit"] = (code) => {
                if (options.onExit) {
                    options.onExit(code);
                }
                process.exit(code);
            }
        },
/* #endif */
/* #if USE_SHARED_MEMORY */
        memory, threadChannel,
/* #endif */
    }
}
