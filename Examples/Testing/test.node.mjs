import { WASI } from "wasi"
import { instantiate } from "./.build/plugins/PackageToJS/outputs/Package/instantiate.js"
import { readFile } from "fs/promises"

const wasi = new WASI({
    version: "preview1",
    args: ["--testing-library", "swift-testing"],
    returnOnExit: false,
})
const { swift } = await instantiate(
    await readFile("./.build/plugins/PackageToJS/outputs/Package/main.wasm"),
    {}, { wasi }
)
swift.main()
