// @ts-check
import { instantiate } from './instantiate.js';
/* #if TARGET_PLATFORM_NODE */
import { defaultNodeSetup /* #if USE_SHARED_MEMORY */, createDefaultWorkerFactory /* #endif */} from './platforms/node.js';
/* #else */
import { defaultBrowserSetup /* #if USE_SHARED_MEMORY */, createDefaultWorkerFactory /* #endif */} from './platforms/browser.js';
/* #endif */

/** @type {import('./index.d').init} */
export async function init(_options) {
/* #if TARGET_PLATFORM_NODE */
    /** @type {import('./platforms/node.d.ts').DefaultNodeSetupOptions} */
    const options = _options || {};
    const instantiateOptions = await defaultNodeSetup({
        args: options.args,
        onExit: options.onExit,
/* #if USE_SHARED_MEMORY */
        spawnWorker: options.spawnWorker || createDefaultWorkerFactory()
/* #endif */
    });
/* #else */
    /** @type {import('./index.d').Options} */
    const options = _options || {
/* #if HAS_IMPORTS */
        /** @returns {import('./instantiate.d').Imports} */
        getImports() { (() => { throw new Error("No imports provided") })() }
/* #endif */
    };
    let module = options.module;
    if (!module) {
        module = fetch(new URL("@PACKAGE_TO_JS_MODULE_PATH@", import.meta.url))
    }
    const instantiateOptions = await defaultBrowserSetup({
        module,
/* #if HAS_IMPORTS */
        getImports: () => options.getImports(),
/* #endif */
/* #if USE_SHARED_MEMORY */
        spawnWorker: createDefaultWorkerFactory()
/* #endif */
    })
/* #endif */
    return await instantiate(instantiateOptions);
}
