import * as nodePlatform from "../platforms/node.js"
import { instantiate } from "../instantiate.js"
import { testBrowser } from "../test.js"
import { parseArgs } from "node:util"
import path from "node:path"
import { writeFileSync } from "node:fs"

function splitArgs(args) {
    // Split arguments into two parts by "--"
    const part1 = []
    const part2 = []
    let index = 0
    while (index < args.length) {
        if (args[index] === "--") {
            index++
            break
        }
        part1.push(args[index])
        index++
    }
    while (index < args.length) {
        part2.push(args[index])
        index++
    }
    return [part1, part2]
}

const [testJsArgs, testFrameworkArgs] = splitArgs(process.argv.slice(2))
const args = parseArgs({
    args: testJsArgs,
    options: {
        prelude: { type: "string" },
        environment: { type: "string" },
        inspect: { type: "boolean" },
        "coverage-file": { type: "string" },
    },
})

const harnesses = {
    node: async ({ preludeScript }) => {
        try {
            let options = await nodePlatform.defaultNodeSetup({
                args: testFrameworkArgs,
                onExit: (code) => {
                    if (code !== 0) { return }
                    // Extract the coverage file from the wasm module
                    const filePath = "default.profraw"
                    const destinationPath = args.values["coverage-file"] ?? filePath
                    const profraw = options.wasi.extractFile?.(filePath)
                    if (profraw) {
                        console.log(`Saved ${filePath} to ${destinationPath}`);
                        writeFileSync(destinationPath, profraw);
                    }
                },
/* #if USE_SHARED_MEMORY */
                spawnWorker: nodePlatform.createDefaultWorkerFactory(preludeScript)
/* #endif */
            })
            if (preludeScript) {
                const prelude = await import(preludeScript)
                if (prelude.setupOptions) {
                    options = prelude.setupOptions(options, { isMainThread: true })
                }
            }
            await instantiate(options)
        } catch (e) {
            if (e instanceof WebAssembly.CompileError) {
                // Check Node.js major version
                const nodeVersion = process.versions.node.split(".")[0]
                const minNodeVersion = 20
                if (nodeVersion < minNodeVersion) {
                    console.error(`Hint: Node.js version ${nodeVersion} is not supported, please use version ${minNodeVersion} or later.`)
                }
            }
            throw e
        }
    },
    browser: async ({ preludeScript }) => {
        process.exit(await testBrowser({ preludeScript, inspect: args.values.inspect, args: testFrameworkArgs }));
    }
}

const harness = harnesses[args.values.environment ?? "node"]
if (!harness) {
    console.error(`Invalid environment: ${args.values.environment}`)
    process.exit(1)
}

const options = {}
if (args.values.prelude) {
    options.preludeScript = path.resolve(process.cwd(), args.values.prelude)
}

await harness(options)
