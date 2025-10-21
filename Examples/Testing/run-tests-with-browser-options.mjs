// Import the generated test harness function
import { testBrowser } from "./.build/plugins/PackageToJS/outputs/PackageTests/test.js"

// Execute the test with custom browser options
async function runTest(args) {
    const exitCode = await testBrowser({
        args: args,
        playwright: {
            browser: "chromium",
            launchOptions: {
                headless: false,
            }
        }
    });
    if (exitCode !== 0) {
        process.exit(exitCode);
    }
}
// Run XCTest test suites
await runTest([]);
// Run Swift Testing test suites
await runTest(["--testing-library", "swift-testing"]);
process.exit(0);
