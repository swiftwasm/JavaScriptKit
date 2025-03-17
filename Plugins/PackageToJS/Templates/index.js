// @ts-check
import { instantiate } from './instantiate.js';
import { defaultBrowserSetup /* #if USE_SHARED_MEMORY */, createDefaultWorkerFactory /* #endif */} from './platforms/browser.js';

/** @type {import('./index.d').init} */
export async function init(options = {}) {
    let module = options.module;
    if (!module) {
        module = fetch(new URL("@PACKAGE_TO_JS_MODULE_PATH@", import.meta.url))
    }
    const instantiateOptions = await defaultBrowserSetup({
        module,
/* #if USE_SHARED_MEMORY */
        spawnWorker: createDefaultWorkerFactory()
/* #endif */
    })
    return await instantiate(instantiateOptions);
}
