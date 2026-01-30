/** @type {import('./test.d.ts').testBrowser} */
export async function testBrowser(
    options = {},
) {
    const { fileURLToPath } = await import("node:url");
    const path = await import("node:path");
    const fs = await import("node:fs/promises");
    const os = await import("node:os");
    const { existsSync } = await import("node:fs");
    const selfUrl = fileURLToPath(import.meta.url);
    const webRoot = path.dirname(selfUrl);

    const http = await import("node:http");
    const defaultContentTypes = {
        ".html": "text/html",
        ".js": "text/javascript",
        ".mjs": "text/javascript",
        ".wasm": "application/wasm",
    };
    const preludeScriptPath = "/prelude.js"
    const server = http.createServer(async (req, res) => {
        const url = new URL(req.url, `http://${req.headers.host}`);
        const pathname = url.pathname;
        const filePath = path.join(webRoot, pathname);

        res.setHeader("Cross-Origin-Embedder-Policy", "require-corp");
        res.setHeader("Cross-Origin-Opener-Policy", "same-origin");

        if (existsSync(filePath) && (await fs.stat(filePath)).isFile()) {
            const data = await fs.readFile(filePath);
            const ext = pathname.slice(pathname.lastIndexOf("."));
            const contentType = options.contentTypes?.(pathname) || defaultContentTypes[ext] || "text/plain";
            res.writeHead(200, { "Content-Type": contentType });
            res.end(data);
        } else if (pathname === "/process-info.json") {
            res.writeHead(200, { "Content-Type": "application/json" });
            const info = {
                env: process.env,
                args: options.args,
            };
            if (options.preludeScript) {
                info.preludeScript = preludeScriptPath;
            }
            res.end(JSON.stringify(info));
        } else if (pathname === preludeScriptPath) {
            res.writeHead(200, { "Content-Type": "text/javascript" });
            res.end(await fs.readFile(options.preludeScript, "utf-8"));
        } else {
            res.writeHead(404);
            res.end();
        }
    });

    async function tryListen(port) {
        try {
            await new Promise((resolve) => {
                server.listen({ host: "localhost", port }, () => resolve());
                server.once("error", (error) => {
                    if (error.code === "EADDRINUSE") {
                        resolve(null);
                    } else {
                        throw error;
                    }
                });
            });
            return server.address();
        } catch {
            return null;
        }
    }

    // Try to listen on port 3000, if it's already in use, try a random available port
    let address = await tryListen(3000);
    if (!address) {
        address = await tryListen(0);
    }

    if (options.inspect) {
        console.log("Serving test page at http://localhost:" + address.port + "/test.browser.html");
        console.log("Inspect mode: Press Ctrl+C to exit");
        await new Promise((resolve) => process.on("SIGINT", resolve));
        process.exit(128 + os.constants.signals.SIGINT);
    }

    const playwright = await (async () => {
        try {
            // @ts-ignore
            return await import("playwright")
        } catch {
            // Playwright is not available in the current environment
            console.error(`Playwright is not available in the current environment.
Please run the following command to install it:

      $ npm install playwright && npx playwright install chromium
      `);
            process.exit(1);
        }
    })();
    const browser = await playwright[options.playwright?.browser ?? "chromium"].launch(options.playwright?.launchOptions ?? {});
    const context = await browser.newContext();
    const page = await context.newPage();
    // Allow the user to customize the page before it's loaded, for defining custom export functions
    if (options.playwright?.onPageLoad) {
        await options.playwright.onPageLoad(page);
    }

    // Forward console messages in the page to the Node.js console
    page.on("console", (message) => {
        console.log(message.text());
    });

    let resolveExit = undefined;
    const onExit = new Promise((resolve) => {
        resolveExit = resolve;
    });
    await page.exposeFunction("exitTest", resolveExit);
    await page.goto(`http://localhost:${address.port}/test.browser.html`);
    const exitCode = await onExit;
    await browser.close();
    return exitCode;
}

/** @type {import('./test.d.ts').testBrowserInPage} */
export async function testBrowserInPage(options, processInfo) {
    const exitTest = (code) => {
        const fn = window.exitTest;
        if (fn) { fn(code); }
    }

    const handleError = (error) => {
        console.error(error);
        exitTest(1);
    };

    // There are 6 cases to exit test
    // 1. Successfully finished XCTest with `exit(0)` synchronously
    // 2. Unsuccessfully finished XCTest with `exit(non - zero)` synchronously
    // 3. Successfully finished XCTest with `exit(0)` asynchronously
    // 4. Unsuccessfully finished XCTest with `exit(non - zero)` asynchronously
    // 5. Crash by throwing JS exception synchronously
    // 6. Crash by throwing JS exception asynchronously

    class ExitError extends Error {
        constructor(code) {
            super(`Process exited with code ${code}`);
            this.code = code;
        }
    }
    const handleExitOrError = (error) => {
        if (error instanceof ExitError) {
            exitTest(error.code);
        } else {
            handleError(error) // something wrong happens during test
        }
    }

    // Handle asynchronous exits (case 3, 4, 6)
    window.addEventListener("unhandledrejection", event => {
        event.preventDefault();
        const error = event.reason;
        handleExitOrError(error);
    });

    const { instantiate } = await import("./instantiate.js");
    /** @type {import('./test.d.ts').SetupOptionsFn} */
    let setupOptions = (options, _) => { return options };
    if (processInfo.preludeScript) {
        const prelude = await import(processInfo.preludeScript);
        if (prelude.setupOptions) {
            setupOptions = prelude.setupOptions;
        }
    }

    options = await setupOptions(options, { isMainThread: true });

    try {
        // Instantiate the WebAssembly file
        return await instantiate({
            ...options,
            addToCoreImports: (imports, context) => {
                options.addToCoreImports?.(imports, context);
                imports["wasi_snapshot_preview1"]["proc_exit"] = (code) => {
                    exitTest(code);
                    throw new ExitError(code);
                };
            },
        });
        // When JavaScriptEventLoop executor is still running,
        // reachable here without catch (case 3, 4, 6)
    } catch (error) {
        // Handle synchronous exits (case 1, 2, 5)
        handleExitOrError(error);
    }
}
