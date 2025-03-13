// @ts-check
import { instantiate } from './instantiate.js';
import { defaultBrowserSetup /* #if USE_SHARED_MEMORY */, createDefaultWorkerFactory /* #endif */} from './platforms/browser.js';

/** @type {import('./index.d').init} */
export async function init(moduleSource) {
    const options = await defaultBrowserSetup({
        module: moduleSource,
/* #if USE_SHARED_MEMORY */
        spawnWorker: createDefaultWorkerFactory()
/* #endif */
    })
    return await instantiate(options);
}
