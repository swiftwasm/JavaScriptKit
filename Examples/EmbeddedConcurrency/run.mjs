import { instantiate } from
  "./.build/plugins/PackageToJS/outputs/Package/instantiate.js"
import { defaultNodeSetup } from
  "./.build/plugins/PackageToJS/outputs/Package/platforms/node.js"

const EXPECTED_TESTS = 8;
const TIMEOUT_MS = 30_000;

// Intercept console.log to capture test output
const originalLog = console.log;
let totalLine = null;
let resolveTotal = null;
const totalPromise = new Promise((resolve) => { resolveTotal = resolve; });
console.log = (...args) => {
    const line = args.join(" ");
    originalLog.call(console, ...args);
    if (line.startsWith("TOTAL:")) {
        totalLine = line;
        resolveTotal();
    }
};

const options = await defaultNodeSetup();
await instantiate(options);

// Wait for the async main to complete (tests run via microtasks/setTimeout)
const timeout = new Promise((_, reject) =>
    setTimeout(() => reject(new Error("Timed out waiting for test results")), TIMEOUT_MS)
);
try {
    await Promise.race([totalPromise, timeout]);
} catch (e) {
    originalLog.call(console, `FAIL: ${e.message}`);
    process.exit(1);
}

if (!totalLine) {
    originalLog.call(console, `FAIL: No test summary found — main() likely exited early`);
    process.exit(1);
}
const match = totalLine.match(/TOTAL: (\d+) tests/);
const ran = match ? parseInt(match[1], 10) : 0;
if (ran !== EXPECTED_TESTS) {
    originalLog.call(console,
        `FAIL: Expected ${EXPECTED_TESTS} tests but only ${ran} ran`);
    process.exit(1);
}
