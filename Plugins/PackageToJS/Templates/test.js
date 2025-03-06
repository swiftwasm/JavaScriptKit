// @ts-check
import { WASI } from "wasi"
import { instantiate } from "./instantiate.js"
import { MODULE_PATH } from "./index.js"
import { readFile } from "fs/promises"

export class NodeRunner {
    constructor() { }

    async run() {
        const wasi = new WASI({
            version: "preview1",
            args: ["--testing-library", "swift-testing"],
            returnOnExit: false,
        })
        const path = await import("node:path");
        const { fileURLToPath } = await import("node:url");
        const dirname = path.dirname(fileURLToPath(import.meta.url))
        const { swift } = await instantiate(
            await readFile(path.join(dirname, MODULE_PATH)),
            {}, { wasi }
        )
        swift.main()
    }
}

export class BrowserRunner {
    constructor() { }

    async run() {
    }
}
