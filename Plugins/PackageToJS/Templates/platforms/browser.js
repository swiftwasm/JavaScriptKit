// @ts-check
import { MODULE_PATH /* #if USE_SHARED_MEMORY */, MEMORY_TYPE /* #endif */} from "../instantiate.js"
/* #if IS_WASI */
/* #if USE_WASI_CDN */
// @ts-ignore
import { WASI, File, OpenFile, ConsoleStdout, PreopenDirectory } from 'https://cdn.jsdelivr.net/npm/@bjorn3/browser_wasi_shim@0.4.1/+esm';
/* #else */
// @ts-ignore
import { WASI, File, OpenFile, ConsoleStdout, PreopenDirectory } from '@bjorn3/browser_wasi_shim';
/* #endif */
/* #endif */

/* #if USE_SHARED_MEMORY */
export async function defaultBrowserThreadSetup() {
    const threadChannel = {
        spawnThread: () => {
            throw new Error("Cannot spawn a new thread from a worker thread")
        },
        postMessageToMainThread: (message, transfer) => {
            // @ts-ignore
            self.postMessage(message, transfer);
        },
        listenMessageFromMainThread: (listener) => {
            // @ts-ignore
            self.onmessage = (event) => listener(event.data);
        }
    }

/* #if IS_WASI */
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
/* #endif */
    return {
/* #if IS_WASI */
        wasi: Object.assign(wasi, {
            setInstance(instance) {
                wasi.inst = instance;
            }
        }),
/* #endif */
        threadChannel,
    }
}

/** @type {import('./browser.d.ts').createDefaultWorkerFactory} */
export function createDefaultWorkerFactory(preludeScript) {
    return (tid, startArg, module, memory) => {
        const worker = new Worker(new URL("./browser.worker.js", import.meta.url), {
            type: "module",
        });
        worker.addEventListener("messageerror", (error) => {
            console.error(`Worker thread ${tid} error:`, error);
            throw error;
        });
        worker.postMessage({ module, memory, tid, startArg, preludeScript });
        return worker;
    }
}

class DefaultBrowserThreadRegistry {
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
        worker?.addEventListener("message", (event) => {
            listener(event.data);
        });
    }

    postMessageToWorkerThread(tid, message, transfer) {
        const worker = this.workers.get(tid);
        worker?.postMessage(message, transfer);
    }

    terminateWorkerThread(tid) {
        const worker = this.workers.get(tid);
        worker.terminate();
        this.workers.delete(tid);
    }
}
/* #endif */

/** @type {import('./browser.d.ts').defaultBrowserSetup} */
export async function defaultBrowserSetup(options) {
/* #if IS_WASI */
    const args = options.args ?? []
    const onStdoutLine = options.onStdoutLine ?? ((line) => console.log(line))
    const onStderrLine = options.onStderrLine ?? ((line) => console.error(line))
    const wasi = new WASI(/* args */[MODULE_PATH, ...args], /* env */[], /* fd */[
        new OpenFile(new File([])), // stdin
        ConsoleStdout.lineBuffered((stdout) => {
            onStdoutLine(stdout);
        }),
        ConsoleStdout.lineBuffered((stderr) => {
            onStderrLine(stderr);
        }),
        new PreopenDirectory("/", new Map()),
    ], { debug: false })
/* #endif */
/* #if USE_SHARED_MEMORY */
    const memory = new WebAssembly.Memory(MEMORY_TYPE);
    const threadChannel = new DefaultBrowserThreadRegistry(options.spawnWorker)
/* #endif */

    return {
        module: options.module,
        imports: {},
/* #if IS_WASI */
        wasi: Object.assign(wasi, {
            setInstance(instance) {
                wasi.inst = instance;
            }
        }),
/* #endif */
/* #if USE_SHARED_MEMORY */
        memory, threadChannel,
/* #endif */
    }
}
