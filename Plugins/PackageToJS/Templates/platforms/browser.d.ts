import type { InstantiateOptions, ModuleSource/* #if HAS_IMPORTS */, Imports/* #endif */ } from "../instantiate.js"

export function defaultBrowserSetup(options?: {
    module: ModuleSource,
/* #if IS_WASI */
    args?: string[],
    onStdoutLine?: (line: string) => void,
    onStderrLine?: (line: string) => void,
/* #endif */
/* #if HAS_IMPORTS */
    getImports: () => Imports,
/* #endif */
/* #if USE_SHARED_MEMORY */
    spawnWorker?: (module: WebAssembly.Module, memory: WebAssembly.Memory, startArg: any) => Worker,
/* #endif */
}): Promise<InstantiateOptions>

export function createDefaultWorkerFactory(preludeScript?: string): (module: WebAssembly.Module, memory: WebAssembly.Memory, startArg: any) => Worker
