// @ts-check
import { instantiate } from './instantiate.js';
/* #if TARGET_DEFAULT_PLATFORM_NODE */
import { defaultNodeSetup /* #if USE_SHARED_MEMORY */, createDefaultWorkerFactory as createDefaultWorkerFactoryForNode /* #endif */} from './platforms/node.js';
/* #else */
import { defaultBrowserSetup /* #if USE_SHARED_MEMORY */, createDefaultWorkerFactory as createDefaultWorkerFactoryForBrowser /* #endif */} from './platforms/browser.js';
/* #endif */

/* #if TARGET_DEFAULT_PLATFORM_NODE */
/** @type {import('./index.d').init} */
async function initNode(_options) {
    /** @type {import('./platforms/node.d.ts').DefaultNodeSetupOptions} */
    const options = {
        ...(_options || {}),
/* #if USE_SHARED_MEMORY */
        spawnWorker: createDefaultWorkerFactoryForNode(),
/* #endif */
    };
    const instantiateOptions = await defaultNodeSetup(options);
    return await instantiate(instantiateOptions);
}

/* #else */

/** @type {import('./index.d').init} */
async function initBrowser(_options) {
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
        spawnWorker: createDefaultWorkerFactoryForBrowser()
/* #endif */
    })
    return await instantiate(instantiateOptions);
}

/* #endif */

/** @type {import('./index.d').init} */
export async function init(options) {
    /* #if TARGET_DEFAULT_PLATFORM_NODE */
    return initNode(options);
    /* #else */
    return initBrowser(options);
    /* #endif */
}