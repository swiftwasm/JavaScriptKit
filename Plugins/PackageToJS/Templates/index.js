// @ts-check
import { WASI, WASIProcExit, File, OpenFile, ConsoleStdout, PreopenDirectory } from '@bjorn3/browser_wasi_shim';
import { instantiate } from './instantiate.js';
export const MODULE_PATH = "@PACKAGE_TO_JS_MODULE_PATH@";

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
        wasi: wasi
    });
    swift.main();

    return {
        instance,
        exports,
    }
}

/** @type {import('./index.d').runTest} */
export async function runTest(
    moduleSource,
    imports,
    options
) {
    try {
        const { instance, exports } = await init(moduleSource, imports, options);
        return { exitCode: 0 };
    } catch (error) {
        if (error instanceof WASIProcExit) {
            return { exitCode: error.code };
        }
        throw error;
    }
}
