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
        "playwright-expose": { type: "string" },
    },
})

const harnesses = {
    node: async ({ preludeScript }) => {
        try {
            let options = await nodePlatform.defaultNodeSetup({
                args: testFrameworkArgs,
                onExit: (code) => {
                    // swift-testing returns EX_UNAVAILABLE (which is 69 in wasi-libc) for "no tests found"
                    if (code !== 0 && code !== 69) {
                        const stack = new Error().stack
                        console.error(`Test failed with exit code ${code}`)
                        console.error(stack)
                        return
                    }
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
                    options = await prelude.setupOptions(options, { isMainThread: true })
                }
            }
            process.on("beforeExit", () => {
                // NOTE: "beforeExit" is fired when the process exits gracefully without calling `process.exit`
                // Either XCTest or swift-testing should always call `process.exit` through `proc_exit` even
                // if the test succeeds. So exiting gracefully means something went wrong (e.g. withUnsafeContinuation is leaked)
                // Therefore, we exit with code 1 to indicate that the test execution failed.
                console.error(`

=================================================================================================
Detected that the test execution ended without a termination signal from the testing framework.
Hint: This typically means that a continuation leak occurred.
=================================================================================================`)
                process.exit(1)
            })
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
        let onPageLoad = undefined;

        // Load exposed functions from playwright-expose flag
        if (args.values["playwright-expose"]) {
            const exposeScript = path.resolve(process.cwd(), args.values["playwright-expose"]);
            try {
                const exposeModule = await import(exposeScript);
                const exposedFunctions = exposeModule.exposedFunctions;

                if (exposedFunctions) {
                    onPageLoad = async (page) => {
                        // If exposedFunctions is a function, call it with the page object
                        // This allows the functions to capture the page in their closure
                        const functions = typeof exposedFunctions === 'function'
                            ? await exposedFunctions(page)
                            : exposedFunctions;

                        for (const [name, fn] of Object.entries(functions)) {
                            // Bind the page context to each function if needed
                            // The function can optionally use the page from its closure
                            await page.exposeFunction(name, fn);
                        }
                    };
                }
            } catch (e) {
                // If --playwright-expose is specified but file doesn't exist or has no exposedFunctions, that's an error
                if (args.values["playwright-expose"]) {
                    throw e;
                }
            }
        }

        const exitCode = await testBrowser({
            preludeScript,
            inspect: args.values.inspect,
            args: testFrameworkArgs,
            playwright: {
                onPageLoad
            }
        });
        process.exit(exitCode);
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
