// @ts-check
import {  MODULE_PATH, instantiate } from "./instantiate.js"

export class NodeRunner {
    constructor() { }

    async run() {
        try {
            await this._run()
        } catch (error) {
            // Print hint for the user
            if (error instanceof WebAssembly.CompileError) {
                // Old Node.js doesn't support some wasm features.
                // Our minimum supported version is v18.x
                throw new Error(`${error.message}

Hint: Some WebAssembly features might not be supported in your Node.js version.
Please ensure you are using Node.js v18.x or newer.
                `)
            }
            throw error
        }
    }

    async _run() {
        const { WASI } = await import("wasi")
        const path = await import("node:path");
        const { fileURLToPath } = await import("node:url");
        const { readFile } = await import("node:fs/promises")

        const wasi = new WASI({
            version: "preview1",
            args: [MODULE_PATH, ...process.argv.slice(2)],
            preopens: {
                "./": process.cwd(),
            },
            returnOnExit: false,
        })
        const dirname = path.dirname(fileURLToPath(import.meta.url))
        const module = await WebAssembly.compile(await readFile(path.join(dirname, MODULE_PATH)))
        const options = { wasi }
        /* #if USE_SHARED_MEMORY */
        // @ts-ignore
        const memoryType = WebAssembly.Module.imports(module).find(i => i.module === "env" && i.name === "memory")?.type
        const memory = new WebAssembly.Memory({
            initial: memoryType.minimum,
            maximum: memoryType.maximum,
            shared: memoryType.shared,
        })
        options.memory = memory
        /* #endif */
        const { swift } = await instantiate(
            module,
            {},
            // @ts-ignore
            options
        )
        swift.main()
    }
}
