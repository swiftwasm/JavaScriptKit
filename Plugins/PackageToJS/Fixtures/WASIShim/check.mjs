// Usage: node check.mjs <PackageToJS output dir> <node|browser> <app|returns> [atomics|noAtomics|atomicsThrows]
//
// Loads an app linked with JavaScriptWASIShim through the generated package's own setup
// (`defaultNodeSetup` or `defaultBrowserSetup`) and `instantiate()`, then checks its console
// output, how it exits and that the module imports nothing from `wasi_snapshot_preview1`.
//
// The sleep mode decides how `Atomics.wait` behaves: `atomics` keeps it (it must block once per
// sleep), `noAtomics` removes `SharedArrayBuffer` (the shim must busy-wait without calling it),
// `atomicsThrows` makes it throw as on a browser main thread (the shim must try it once).

import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import path from "node:path";
import { pathToFileURL } from "node:url";

const [packageDir, platform, scenario, sleepMode = "atomics"] = process.argv.slice(2);
const packageFile = (name) => pathToFileURL(path.join(path.resolve(packageDir), name)).href;

const expectations = {
    app: {
        stdout: [
            "app: start",
            "ab-joined",
            "",
            "grüße 🌍",
            "bad:�� end",
            "random varies: true",
            "dictionary: count=3 3=9",
            "js pi: true",
            "clock monotonic: true",
            "usleep waited: true",
            "random bulk: true",
            "random block edges: true",
            "random small reads: true",
            "stdout is a character device: true",
            "errors: true",
            "tail",
        ],
        stderr: ["to stderr", "partial stderr"],
        sleeps: 1,
        exitCode: 7,
    },
    returns: {
        stdout: ["returns: start", "returns: end"],
        stderr: [],
        sleeps: 0,
        exitCode: null,
    },
}[scenario];

if (sleepMode === "noAtomics") delete globalThis.SharedArrayBuffer;
const realWait = Atomics.wait;
let atomicsWaits = 0;
Atomics.wait = (...args) => {
    atomicsWaits += 1;
    if (sleepMode === "atomicsThrows") throw new TypeError("Atomics.wait cannot be called in this context");
    return realWait(...args);
};

const output = { stdout: [], stderr: [] };
const realLog = console.log;
console.log = (line) => output.stdout.push(line);
console.error = (line) => output.stderr.push(line);

const { instantiate, MODULE_PATH } = await import(packageFile("instantiate.js"));
const { ProcessExit } = await import(packageFile("runtime.js"));

// Node: `defaultNodeSetup` reports the exit through `onExit` and then calls `process.exit`, so
// the checks run inside `onExit`. Browser: the runtime's default `swjs_proc_exit` throws
// `ProcessExit`, which `instantiate()` passes on.
let options;
if (platform === "node") {
    const { defaultNodeSetup } = await import(packageFile("platforms/node.js"));
    options = await defaultNodeSetup({
        onExit: (code) => finish(code),
    });
} else {
    const { defaultBrowserSetup } = await import(packageFile("platforms/browser.js"));
    const module = await WebAssembly.compile(await readFile(path.join(packageDir, MODULE_PATH)));
    options = await defaultBrowserSetup({ module, getImports: () => ({}) });
}
assert.deepEqual(
    WebAssembly.Module.imports(options.module).filter((entry) => entry.module === "wasi_snapshot_preview1"),
    [],
);

try {
    await instantiate(options);
} catch (error) {
    if (!(error instanceof ProcessExit)) {
        console.log = realLog;
        dump();
        throw error;
    }
    finish(error.code);
}
finish(null);

/** Checks the run that ended with exit code `code`, or without calling `exit` if it's null. */
function finish(code) {
    console.log = realLog;
    dump();
    assert.deepEqual(output.stdout, expectations.stdout);
    assert.deepEqual(output.stderr, expectations.stderr);
    assert.equal(code, expectations.exitCode);
    if (sleepMode === "atomics") {
        assert.ok(atomicsWaits >= expectations.sleeps, `${atomicsWaits} Atomics.wait calls for ${expectations.sleeps} sleeps`);
    } else {
        const expectedWaits = sleepMode === "noAtomics" ? 0 : Math.min(expectations.sleeps, 1);
        assert.equal(atomicsWaits, expectedWaits, `Atomics.wait calls in ${sleepMode} mode`);
    }
    realLog(`${platform} ${scenario} ${sleepMode}: OK`);
    process.exit(0);
}

function dump() {
    for (const line of output.stdout) realLog(`stdout | ${line}`);
    for (const line of output.stderr) realLog(`stderr | ${line}`);
}
