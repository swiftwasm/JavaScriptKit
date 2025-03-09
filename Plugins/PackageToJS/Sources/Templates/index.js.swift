extension TemplateContext {
    var index_d_ts: String {
        var options: [String] = [
"""
    /**
     * The CLI arguments to pass to the WebAssembly module
     */
    args?: string[]
"""
    ]
    if useSharedMemory {
        options.append("""
    /**
     * The WebAssembly memory to use (must be 'shared')
     */
    memory: WebAssembly.Memory
""")
    }
    return """
import type { Import, Export } from './instantiate.js'

export type Options = {
\(options.joined(separator: "\n"))
}

/**
 * Initialize the given WebAssembly module
 *
 * This is a convenience function that creates an instantiator and instantiates the module.
 * @param moduleSource - The WebAssembly module to instantiate
 * @param imports - The imports to add
 * @param options - The options
 */
export declare function init(
    moduleSource: WebAssembly.Module | ArrayBufferView | ArrayBuffer | Response | PromiseLike<Response>,
    imports: Import,
    options: Options
): Promise<{
    instance: WebAssembly.Instance,
    exports: Export
}>
"""
    }

    var index_js: String {
        return """
// @ts-check
import { WASI, WASIProcExit, File, OpenFile, ConsoleStdout, PreopenDirectory } from '@bjorn3/browser_wasi_shim';
import { instantiate, MODULE_PATH } from './instantiate.js';

/** @type {import('./index.d').init} */
export async function init(
    moduleSource,
    imports,
    options
) {
    const wasi = new WASI(/* args */[MODULE_PATH, ...(options?.args ?? [])], /* env */[], /* fd */[
        new OpenFile(new File([])), // stdin
        ConsoleStdout.lineBuffered((stdout) => {
            console.log(stdout);
        }),
        ConsoleStdout.lineBuffered((stderr) => {
            console.error(stderr);
        }),
        new PreopenDirectory("/", new Map()),
    ], { debug: false })
    const { instance, exports, swift } = await instantiate(moduleSource, imports, {
        wasi: wasi, \(useSharedMemory ? "memory: options?.memory" : "")
    });
    swift.main();

    return {
        instance,
        exports,
    }
}
"""
}
}