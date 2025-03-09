// @ts-check
import { instantiate } from './instantiate.js';
import { defaultBrowserSetup /* #if USE_SHARED_MEMORY */, createDefaultWorkerFactory /* #endif */} from './platforms/browser.js';

/** @type {import('./index.d').init} */
export async function init(_options) {
    /** @type {import('./index.d').Options} */
    const options = _options || {
/* #if HAS_IMPORTS */
        /** @returns {import('./instantiate.d').Imports} */
        get imports() { (() => { throw new Error("No imports provided") })() }
/* #endif */
    };
    let module = options.module;
    if (!module) {
        module = fetch(new URL("@PACKAGE_TO_JS_MODULE_PATH@", import.meta.url))
    }
    const instantiateOptions = await defaultBrowserSetup({
        module,
/* #if HAS_IMPORTS */
        imports: options.imports,
/* #endif */
/* #if USE_SHARED_MEMORY */
        spawnWorker: createDefaultWorkerFactory()
/* #endif */
    })
    return await instantiate(instantiateOptions);
}
