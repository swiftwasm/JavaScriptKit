import type { InstantiateOptions } from "../instantiate.js"
import type { Worker } from "node:worker_threads"

export function defaultNodeSetup(options: {
/* #if IS_WASI */
    args?: string[],
/* #endif */
    onExit?: (code: number) => void,
/* #if USE_SHARED_MEMORY */
    spawnWorker: (module: WebAssembly.Module, memory: WebAssembly.Memory, startArg: any) => Worker,
/* #endif */
}): Promise<InstantiateOptions>

export function createDefaultWorkerFactory(preludeScript: string): (module: WebAssembly.Module, memory: WebAssembly.Memory, startArg: any) => Worker
