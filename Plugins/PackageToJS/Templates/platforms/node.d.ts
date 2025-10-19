import type { InstantiateOptions } from "../instantiate.js"
import type { Worker } from "node:worker_threads"

export type DefaultNodeSetupOptions = {
/* #if IS_WASI */
    args?: string[],
/* #endif */
    onExit?: (code: number) => void,
/* #if USE_SHARED_MEMORY */
    spawnWorker: (module: WebAssembly.Module, memory: WebAssembly.Memory, startArg: any) => Worker,
/* #endif */
}

export function defaultNodeSetup(options: DefaultNodeSetupOptions): Promise<InstantiateOptions>

export function createDefaultWorkerFactory(preludeScript: string): (module: WebAssembly.Module, memory: WebAssembly.Memory, startArg: any) => Worker
