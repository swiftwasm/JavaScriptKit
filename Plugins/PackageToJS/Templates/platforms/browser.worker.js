import { instantiateForThread } from "../instantiate.js"
import { defaultBrowserThreadSetup } from "./browser.js"

self.onmessage = async (event) => {
    const { module, memory, tid, startArg, preludeScript } = event.data;
    let options = await defaultBrowserThreadSetup();
    if (preludeScript) {
        const prelude = await import(preludeScript);
        if (prelude.setupOptions) {
            options = prelude.setupOptions(options, { isMainThread: false })
        }
    }
    await instantiateForThread(tid, startArg, {
        ...options,
        module, memory,
        getImports() { return {} },
    })
}
