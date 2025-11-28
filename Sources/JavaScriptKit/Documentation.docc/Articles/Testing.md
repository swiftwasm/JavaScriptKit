# Testing

Write and run tests for your Swift applications running on JavaScript environment using XCTest or swift-testing.

## Overview

JavaScriptKit supports running tests written with both XCTest and swift-testing. Tests are compiled to WebAssembly and executed in JavaScript environments (Node.js or browser). Unlike standard Swift testing, building and running tests are integrated into a single command that handles the JavaScript runtime setup.

> Note: See the [Testing example](https://github.com/swiftwasm/JavaScriptKit/tree/main/Examples/Testing) for a complete working example.

## Setting Up Tests

### Package Configuration

Your `Package.swift` should have a test target with a dependency on your library target. Here's a simple example:

```swift
// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Example",
    products: [
        .library(name: "Example", targets: ["Example"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Example",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ]
        ),
        .testTarget(
            name: "ExampleTests",
            dependencies: [
                "Example",
                .product(name: "JavaScriptEventLoopTestSupport", package: "JavaScriptKit"),
            ]
        ),
    ]
)
```

> Important: Include `JavaScriptEventLoopTestSupport` in your test target dependencies. This is required to run tests in the JavaScript event loop environment.

### Writing Tests

Create your test files in the `Tests/ExampleTests` directory. JavaScriptKit supports both XCTest and swift-testing. Write your tests using either framework as you would for standard Swift projects.

## Running Tests

### Basic Test Execution

Run your tests using the `js test` subcommand:

```bash
swift package --disable-sandbox --swift-sdk $SWIFT_SDK_ID js test
```

> Important: The `--disable-sandbox` flag is required because the test runner needs to execute npm and Playwright to run tests in JavaScript environments.

This command will:
1. Build your test target as WebAssembly
2. Package the tests with the necessary JavaScript runtime
3. Execute the tests in Node.js by default

The test binary is produced as `PackageTests.wasm` (where `Package` is your package name) and is located in `.build/plugins/PackageToJS/outputs/PackageTests/`.

### Test Environment Options

**Run tests in Node.js (default):**

```bash
swift package --disable-sandbox --swift-sdk $SWIFT_SDK_ID js test --environment node
```

**Run tests in a browser:**

```bash
swift package --disable-sandbox --swift-sdk $SWIFT_SDK_ID js test --environment browser
```

When running tests in the browser, the command will launch a browser instance using Playwright and execute the tests there.

### Other Test Options

**Build tests without running them:**

```bash
swift package --disable-sandbox --swift-sdk $SWIFT_SDK_ID js test --build-only
```

After building, you can run the tests manually:

```bash
node .build/plugins/PackageToJS/outputs/PackageTests/bin/test.js
```

**List available tests:**

```bash
swift package --disable-sandbox --swift-sdk $SWIFT_SDK_ID js test --list-tests
```

**Filter tests by name:**

```bash
swift package --disable-sandbox --swift-sdk $SWIFT_SDK_ID js test --filter "testTrivial"
```

**Enable inspector for browser tests:**

```bash
swift package --disable-sandbox --swift-sdk $SWIFT_SDK_ID js test --environment browser --inspect
```

This starts a local server without automatically running tests. You can manually open `http://localhost:3000/test.browser.html` in your browser to run the tests and use the browser's DevTools for debugging.

## Code Coverage

To generate code coverage reports:

1. **Run tests with code coverage enabled:**

```bash
swift package --disable-sandbox --swift-sdk $SWIFT_SDK_ID js test --enable-code-coverage
```

2. **Generate HTML coverage report:**

```bash
llvm-cov show -instr-profile=.build/plugins/PackageToJS/outputs/PackageTests/default.profdata \
  --format=html .build/plugins/PackageToJS/outputs/PackageTests/main.wasm \
  -o .build/coverage/html Sources
```

3. **View the coverage report:**

```bash
npx serve .build/coverage/html
```

![Code coverage report](coverage-support.png)

## Customizing Test Execution

You can customize the test harness by importing the generated test function and calling it with custom options:

```javascript
// run-tests-custom.mjs
import { testBrowser } from "./.build/plugins/PackageToJS/outputs/PackageTests/test.js";

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
```

Then run your custom test script:

```bash
node run-tests-custom.mjs
```
