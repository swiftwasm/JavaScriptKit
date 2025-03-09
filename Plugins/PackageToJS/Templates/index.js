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
        wasi,
        /* #if USE_SHARED_MEMORY */
        memory: options.memory,
        /* #endif */
    });
    swift.main();

    return {
        instance,
        exports,
    }
}
